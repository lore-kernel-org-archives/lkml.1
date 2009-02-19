Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZBSLwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZBSLwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 06:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZBSLwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 06:52:00 -0500
Received: from ozlabs.org ([203.10.76.45]:57225 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZBSLv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 06:51:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
Date: Thu, 19 Feb 2009 22:21:51 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jeremy@goop.org, cpw@sgi.com, mingo@elte.hu,
       tony.luck@intel.com
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-10-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192221.52835.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 22:34:35 Tejun Heo wrote:
> Impact: new scalable dynamic percpu allocator which allows dynamic
>         percpu areas to be accessed the same way as static ones
> 
> Implement scalable dynamic percpu allocator which can be used for both
> static and dynamic percpu areas.  This will allow static and dynamic
> areas to share faster direct access methods.  This feature is optional
> and enabled only when CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is defined by
> arch.  Please read comment on top of mm/percpu.c for details.

Hi Tejun,

   One question.  Are you thinking that to be defined by every SMP arch
long-term?  Because there are benefits in having &<percpuvar> == valid
percpuptr, such as passing them around as parameters.  If so, IA64
will want a dedicated per-cpu area for statics (tho it can probably just
map it somehow, but it has to be 64k).

   It'd also be nice to use your generalised module_percpu allocator for the
!CONFIG_HAVE_DYNAMIC_PER_CPU_AREA case, but doesn't really matter if that's
temporary anyway.

Direct comments follow:

> +static int __pcpu_unit_pages_shift = PCPU_MIN_UNIT_PAGES_SHIFT;
> +static int __pcpu_unit_pages;
> +static int __pcpu_unit_shift;
> +static int __pcpu_unit_size;
> +static int __pcpu_chunk_size;
> +static int __pcpu_nr_slots;
> +
> +/* currently everything is power of two, there's no hard dependency on it tho */
> +#define PCPU_UNIT_PAGES_SHIFT	((int)__pcpu_unit_pages_shift)
> +#define PCPU_UNIT_PAGES		((int)__pcpu_unit_pages)
> +#define PCPU_UNIT_SHIFT		((int)__pcpu_unit_shift)
> +#define PCPU_UNIT_SIZE		((int)__pcpu_unit_size)
> +#define PCPU_CHUNK_SIZE		((int)__pcpu_chunk_size)
> +#define PCPU_NR_SLOTS		((int)__pcpu_nr_slots)

These pseudo-constants seem like a really weird thing to do to me.

And AFAICT you have the requirement that PCPU_UNIT_PAGES*PAGE_SIZE >=
sizeof(.data.percpu).  Should probably note that somewhere.

> +static DEFINE_MUTEX(pcpu_mutex);		/* one mutex to rule them all */
> +static struct list_head *pcpu_slot;		/* chunk list slots */
> +static struct rb_root pcpu_addr_root = RB_ROOT;	/* chunks by address */

rbtree might be overkill on first cut.  I'm bearing in mind that Christoph L
had a nice patch to use dynamic percpu allocation in the sl*b allocators;
which would mean this needs to only use get_free_page.

Ah, I see akpm has responded.  I'll stop now and chain onto his comments
in the morning.

Thanks!
Rusty.
