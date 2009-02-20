Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZBTIiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZBTIiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbZBTIiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:38:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbZBTIiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:38:14 -0500
Date: Fri, 20 Feb 2009 00:37:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH UPDATED 09/10] percpu: implement new dynamic percpu
 allocator
Message-Id: <20090220003743.d787107b.akpm@linux-foundation.org>
In-Reply-To: <499E5BF9.1060806@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
	<1234958676-27618-10-git-send-email-tj@kernel.org>
	<499E5BF9.1060806@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 16:30:01 +0900 Tejun Heo <tj@kernel.org> wrote:

> Impact: new scalable dynamic percpu allocator which allows dynamic
>         percpu areas to be accessed the same way as static ones
> 
> Implement scalable dynamic percpu allocator which can be used for both
> static and dynamic percpu areas.  This will allow static and dynamic
> areas to share faster direct access methods.  This feature is optional
> and enabled only when CONFIG_HAVE_DYNAMIC_PER_CPU_AREA is defined by
> arch.  Please read comment on top of mm/percpu.c for details.
> 
> ...
>
> +static int pcpu_unit_pages_shift;
> +static int pcpu_unit_pages;
> +static int pcpu_unit_shift;
> +static int pcpu_unit_size;
> +static int pcpu_chunk_size;
> +static int pcpu_nr_slots;
> +static size_t pcpu_chunk_struct_size;
> +
> +/* the address of the first chunk which starts with the kernel static area */
> +void *pcpu_base_addr;
> +EXPORT_SYMBOL_GPL(pcpu_base_addr);
> +
> +/* the size of kernel static area */
> +static int pcpu_static_size;

It would be nice to document the units of the `size' variables.  Bytes?
Pages?

Or, better: s/size/bytes/g.  

> +static int pcpu_size_to_slot(int size)
> +{
> +	int highbit = fls(size);
> +	return max(highbit - PCPU_SLOT_BASE_SHIFT + 2, 1);
> +}

See,

static int pcpu_bytes_to_slot(int bytes)
{
	int highbit = fls(bytes);
	return max(highbit - PCPU_SLOT_BASE_SHIFT + 2, 1);
}

is clearer.
