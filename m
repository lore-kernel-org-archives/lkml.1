Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZEJIuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZEJIuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 04:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZEJIty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 04:49:54 -0400
Received: from ozlabs.org ([203.10.76.45]:57365 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbZEJItw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 04:49:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Date: Sun, 10 May 2009 18:19:40 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Jeff Garzik <jeff@garzik.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Travis <travis@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       roland@redhat.com
References: <20090508184838.GA11157@havoc.gtf.org> <20090508185015.GA11320@havoc.gtf.org> <20090508190944.GB12130@elte.hu>
In-Reply-To: <20090508190944.GB12130@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101819.41765.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 04:39:44 am Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> > The semantics for variable-length arrays __in the middle of structs__
> > are quite muddy, and a case in sched.c presents an interesting case,
> > as the preceding code comment indicates:
> >
> > 	/*
> > 	 * The cpus mask in sched_group and sched_domain hangs off
> > 	 the end.  * FIXME: use cpumask_var_t or dynamic percpu alloc
> > 	 to avoid * wasting space for nr_cpu_ids < CONFIG_NR_CPUS.  */
> > 	struct static_sched_group {
> > 		struct sched_group sg; DECLARE_BITMAP(cpus,
> > 		CONFIG_NR_CPUS);
> > 	};

Yeah, it's kinda nasty.  Generally, sched_group is dynamically allocated,
so we just allocate sizeof(struct sched_group) + size of nr_cpu_ids bits.

These ones are static, and it was easier to put this hack in than make them 
dynamic.  There's nothing wrong with it, until we really want NR_CPUS ==
bignum, or we want to get rid of NR_CPUS altogether for 
CONFIG_CPUMASKS_OFFSTACK (which would be very clean, but not clearly 
worthwhile).

But more importantly, my comment is obviously unclear, since your patch shows 
you didn't understand the purpose of the field: The cpus bitmap *is* the sg-
>cpumask[] array.

> > Maybe a C expert can say whether cpumask[0] is better than cpumask[],
> > or have other comments?

[0] is a gcc extension, but it should be equivalent.

> That cpumask[] should probably be cpumask[0], to document the
> aliasing to ->span and ->cpus properly.

If the comment wasn't sufficient documentation, I don't think that would help :(

Rusty.
