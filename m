Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZEJPKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZEJPKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZEJPJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 11:09:55 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49928 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275AbZEJPJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 11:09:54 -0400
Date: Sun, 10 May 2009 11:09:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Travis <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Message-ID: <20090510150954.GA21561@havoc.gtf.org>
References: <20090508184838.GA11157@havoc.gtf.org> <20090508185015.GA11320@havoc.gtf.org> <20090508190944.GB12130@elte.hu> <200905101819.41765.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905101819.41765.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 06:19:40PM +0930, Rusty Russell wrote:
> On Sat, 9 May 2009 04:39:44 am Ingo Molnar wrote:
> > * Jeff Garzik <jeff@garzik.org> wrote:
> > > The semantics for variable-length arrays __in the middle of structs__
> > > are quite muddy, and a case in sched.c presents an interesting case,
> > > as the preceding code comment indicates:
> > >
> > > 	/*
> > > 	 * The cpus mask in sched_group and sched_domain hangs off
> > > 	 the end.  * FIXME: use cpumask_var_t or dynamic percpu alloc
> > > 	 to avoid * wasting space for nr_cpu_ids < CONFIG_NR_CPUS.  */
> > > 	struct static_sched_group {
> > > 		struct sched_group sg; DECLARE_BITMAP(cpus,
> > > 		CONFIG_NR_CPUS);
> > > 	};
> 
> Yeah, it's kinda nasty.  Generally, sched_group is dynamically allocated,
> so we just allocate sizeof(struct sched_group) + size of nr_cpu_ids bits.
> 
> These ones are static, and it was easier to put this hack in than make them 
> dynamic.  There's nothing wrong with it, until we really want NR_CPUS ==
> bignum, or we want to get rid of NR_CPUS altogether for 
> CONFIG_CPUMASKS_OFFSTACK (which would be very clean, but not clearly 
> worthwhile).

Nothing wrong with it, except

- C99 only defines variable-length automatic arrays
- VLA in the middle of a struct are difficult to optimize
- gcc's VLA handling WILL change, as gcc docs state
- other compilers -- and sparse -- puke all over VLAs, making
  static analysis impossible for all code with this weirdism


> But more importantly, my comment is obviously unclear, since your patch shows 
> you didn't understand the purpose of the field: The cpus bitmap *is* the sg-
> >cpumask[] array.

I guess you missed the
(1) "this patch is only intended to spark discussion",
(2) a reference to the comment, and
(3) "NOT-signed-off-by" portions of my email.

Regards,

	Jeff



