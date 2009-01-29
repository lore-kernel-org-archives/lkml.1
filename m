Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZA2R4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZA2R4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZA2R4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 12:56:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:51368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZA2R4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 12:56:05 -0500
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
In-Reply-To: <1233251222.4495.110.camel@laptop>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	 <200901290955.38940.rusty@rustcorp.com.au>
	 <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>
	 <20090128173039.cbc29e81.akpm@linux-foundation.org>
	 <1233218954.7835.11.camel@twins>
	 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
	 <1233251222.4495.110.camel@laptop>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 18:55:41 +0100
Message-Id: <1233251741.4495.111.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 18:47 +0100, Peter Zijlstra wrote:
> On Thu, 2009-01-29 at 09:21 -0800, Linus Torvalds wrote:
> > On Thu, 29 Jan 2009, Steven Rostedt wrote:
> > > 
> > > The caller must wait till the LOCK bit is cleared before setting
> > > it. When it is cleared, there is no IPI function using it.
> > > A spinlock is used to synchronize the setting of the bit between
> > > callers. Since only one callee can be called at a time, and it
> > > is the only thing to clear it, the IPI does not need to use
> > > any locking.
> > 
> > That spinlock cannot be right. It is provably wrong for so many reasons..
> > 
> > Think about it. We're talking about a per-CPU lock, which already makes no 
> > sense: we're only locking against our own CPU, and we've already disabled 
> > preemption for totally unrelated reasons.
> > 
> > And the only way locking can make sense against our own CPU is if we lock 
> > against interrupts - but the lock isn't actually irq-safe, so if you are 
> > trying to lock against interrupts, you are (a) doing it wrong (you should 
> > disable interrupts, not use a spinlock) and (b) causing a deadlock if it 
> > ever happens.
> 
> 
> > +                       else {
> > +                               data = &per_cpu(csd_data, cpu);
> > +                               spin_lock(&per_cpu(csd_data_lock, cpu));
> > +                               while (data->flags & CSD_FLAG_LOCK)
> > +                                       cpu_relax();
> > +                               data->flags = CSD_FLAG_LOCK;
> > +                               spin_unlock(&per_cpu(csd_data_lock, cpu));
> > +                       }
> 
> I think your argument would hold if he did:
> 
>   data = &__get_cpu_var(csd_data);
> 
> But now he's actually grabbing the remote cpu's csd, and thus needs
> atomicy around that remote csd -- which two cpus could contend for.

So the below should do

---
 kernel/smp.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 9bce851..9eead6c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -201,8 +201,6 @@ void generic_smp_call_function_single_interrupt(void)
 }
 
 static DEFINE_PER_CPU(struct call_single_data, csd_data);
-static DEFINE_PER_CPU(spinlock_t, csd_data_lock) =
-	__SPIN_LOCK_UNLOCKED(csd_lock);
 
 /*
  * smp_call_function_single - Run a function on a specific CPU
@@ -259,12 +257,10 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			if (data)
 				data->flags = CSD_FLAG_ALLOC;
 			else {
-				data = &per_cpu(csd_data, cpu);
-				spin_lock(&per_cpu(csd_data_lock, cpu));
+				data = &per_cpu(csd_data, me);
 				while (data->flags & CSD_FLAG_LOCK)
 					cpu_relax();
 				data->flags = CSD_FLAG_LOCK;
-				spin_unlock(&per_cpu(csd_data_lock, cpu));
 			}
 		} else {
 			data = &d;


