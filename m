Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZA2QRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZA2QRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZA2QRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:17:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49830 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbZA2QRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:17:41 -0500
Date: Thu, 29 Jan 2009 17:17:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
Message-ID: <20090129161712.GC28984@elte.hu>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <200901290955.38940.rusty@rustcorp.com.au> <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com> <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins> <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com> <1233243212.4495.102.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233243212.4495.102.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-01-29 at 10:08 -0500, Steven Rostedt wrote:
> > The smp_call_function can be passed a wait parameter telling it to
> > wait for all the functions running on other CPUs to complete before
> > returning, or to return without waiting. Unfortunately, this is
> > currently just a suggestion and not manditory. That is, the
> > smp_call_function can decide not to return and wait instead.
> > 
> > The reason for this is because it uses kmalloc to allocate storage
> > to send to the called CPU and that CPU will free it when it is done.
> > But if we fail to allocate the storage, the stack is used instead.
> > This means we must wait for the called CPU to finish before
> > continuing.
> > 
> > Unfortunatly, some callers do no abide by this hint and act as if
> > the non-wait option is mandatory. The MTRR code for instance will
> > deadlock if the smp_call_function is set to wait. This is because
> > the smp_call_function will wait for the other CPUs to finish their
> > called functions, but those functions are waiting on the caller to
> > continue.
> > 
> > This patch changes the generic smp_call_function code to use per cpu
> > variables if the allocation of the data fails for a single CPU call. The
> > smp_call_function_many will fall back to the smp_call_function_single
> > if it fails its alloc. The smp_call_function_single is modified
> > to not force the wait state.
> > 
> > Since we now are using a single data per cpu we must synchronize the
> > callers to prevent a second caller modifying the data before the
> > first called IPI functions complete. To do so, I added a flag to
> > the call_single_data called CSD_FLAG_LOCK. When the single CPU is
> > called (which can be called when a many call fails an alloc), we
> > set the LOCK bit on this per cpu data. When the caller finishes
> > it clears the LOCK bit.
> > 
> > The caller must wait till the LOCK bit is cleared before setting
> > it. When it is cleared, there is no IPI function using it.
> > A spinlock is used to synchronize the setting of the bit between
> > callers. Since only one callee can be called at a time, and it
> > is the only thing to clear it, the IPI does not need to use
> > any locking.
> > 
> >  [
> >    changes for v2:
> > 
> >    -- kept kmalloc and only use per cpu if kmalloc fails.
> >           (Requested by Peter Zijlstra)
> > 
> >    -- added per cpu spinlocks
> >           (Requested by Andrew Morton and Peter Zijlstra)
> >  ]
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> Looks nice, thanks!
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

started testing it in tip/core/urgent, thanks guys!

	Ingo
