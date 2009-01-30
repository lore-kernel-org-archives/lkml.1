Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZA3M5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZA3M5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZA3M5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:57:31 -0500
Received: from brick.kernel.dk ([93.163.65.50]:18343 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZA3M5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:57:30 -0500
Date: Fri, 30 Jan 2009 13:55:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -v3] use per cpu data for single cpu ipi calls
Message-ID: <20090130125540.GS30821@kernel.dk>
References: <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain> <1233253380.4495.123.camel@laptop> <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain> <1233254680.4495.126.camel@laptop> <20090130112310.GI30821@kernel.dk> <1233318733.4495.174.camel@laptop> <20090130123858.GQ30821@kernel.dk> <1233319731.4495.177.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233319731.4495.177.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30 2009, Peter Zijlstra wrote:
> On Fri, 2009-01-30 at 13:38 +0100, Jens Axboe wrote:
> 
> > >  		if (!wait) {
> > > +			/*
> > > +			 * We are calling a function on a single CPU
> > > +			 * and we are not going to wait for it to finish.
> > > +			 * We first try to allocate the data, but if we
> > > +			 * fail, we fall back to use a per cpu data to pass
> > > +			 * the information to that CPU. Since all callers
> > > +			 * of this code will use the same data, we must
> > > +			 * synchronize the callers to prevent a new caller
> > > +			 * from corrupting the data before the callee
> > > +			 * can access it.
> > > +			 *
> > > +			 * The CSD_FLAG_LOCK is used to let us know when
> > > +			 * the IPI handler is done with the data.
> > > +			 * The first caller will set it, and the callee
> > > +			 * will clear it. The next caller must wait for
> > > +			 * it to clear before we set it again. This
> > > +			 * will make sure the callee is done with the
> > > +			 * data before a new caller will use it.
> > > +			 * We use spinlocks to manage the callers.
> > > +			 */
> > 
> > That last sentence appears stale now, since there's no locking involved
> > for the per-cpu csd.
> 
> Gah, I edited that, and generated the patch using
> 
> # git diff --stat -p 4f4b6c1a94a8735bbdc030a2911cf395495645b6.. kernel/smp.c | xclip
> 
> on Ingo's tip/master. However it seems such a diff does not include
> non-commited changes, even though a regular git diff does:
> 
> # git diff kernel/smp.c
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 9eead6c..bbedbb7 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -251,7 +251,6 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
>                          * it to clear before we set it again. This
>                          * will make sure the callee is done with the
>                          * data before a new caller will use it.
> -                        * We use spinlocks to manage the callers.
>                          */
>                         data = kmalloc(sizeof(*data), GFP_ATOMIC);
>                         if (data)
> 
> What is the recommended way to do such a diff?

Drop the .. and it should work. Don't ask me why :-)

-- 
Jens Axboe

