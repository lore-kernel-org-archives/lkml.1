Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYFBW5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYFBW5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYFBW5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:57:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:37797 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbYFBW53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:57:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,579,1204531200"; 
   d="scan'208";a="256055315"
Date: Mon, 2 Jun 2008 15:57:27 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: j.mell@t-online.de
Cc: =?iso-8859-1?Q?J=FCrgen?= Mell <j.mell@t-online.de>,
       Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Message-ID: <20080602225727.GC25114@linux-os.sc.intel.com>
References: <200806011101.06491.j.mell@t-online.de> <87wsl9fkno.fsf@basil.nowhere.org> <200806011847.29744.j.mell@t-online.de> <20080602213756.GB25114@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080602213756.GB25114@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2008 at 02:37:56PM -0700, Suresh Siddha wrote:
> On Sun, Jun 01, 2008 at 06:47:29PM +0200, Jürgen Mell wrote:
> > On Sonntag, 1. Juni 2008, Andi Kleen wrote:
> > > j.mell@t-online.de writes:
> > > > or it is restored more than
> > > > once. Please keep in mind, that I am always running two Einstein
> > > > processes simultaneously on my two cores!
> > > > I am willing to do further testing of this problem if someone can give
> > > > me a hint how to continue.
> > >
> > > My bet would have been actually on
> > > aa283f49276e7d840a40fb01eee6de97eaa7e012 because it does some nasty
> > > things (enable interrupts in the middle of __switch_to).
> > >
> > > I looked through the old patchkit and couldn't find any specific
> > > PREEMPT problems. All code it changes should run with preempt_off
> > >
> > > You could verify with sticking WARN_ON_ONCE(preemptible()) into
> > > all the places acc207616a91a413a50fdd8847a747c4a7324167
> > > changes (__unlazy_fpu, math_state_restore) and see if that triggers
> > > anywhere.
> > 
> > No, that did not trigger. I put the WARN_ON_ONCE into process.c, traps.c 
> > and also into the __unlazy_fpu macro in i387.h but I got no messages 
> > anywhere (dmesg, /var/log/messages, /var/log/warn) when the trap #8 
> > occurred. 
> > Meanwhile I am also running the tests on another machine to make sure it is 
> > not a hardware-related problem.
> > 
> > Any new ideas are welcome!
> > 
> > Meanwhile I will go back to 2.6.20 and revert
> > aa283f49276e7d840a40fb01eee6de97eaa7e012. Maybe I got on a wrong track...
> 
> 2.6.20 doesn't have the commit 'aa283f49276e7d840a40fb01eee6de97eaa7e012'
> 
> As you are seeing this corruption problem starting from 2.6.20,
> atleast recent(in 2.6.26 series) fpu changes don't play a role in this.
> 
> I will try to reproduce your issue.

Jürgen, I think I found the reason for your issue aswell.

As you observed, it is probably coming from the commit
acc207616a91a413a50fdd8847a747c4a7324167, i386: add sleazy FPU optimization

It's a side affect though. This is the failing scenario:

process 'A' in save_i387_ia32() just after clear_used_math()

Got an interrupt and pre-empted out.

At the next context switch to process 'A' again, kernel tries to restore
the math state proactively and sees a fpu_counter > 0 and !tsk_used_math()

This results in init_fpu() during the __switch_to()'s math_state_restore()

And resulting in fpu corruption which will be saved/restored 
(save_i387_fxsave and restore_i387_fxsave) during the remaining
part of the signal handling after the context switch.

So in short, yes the problem shows up for preempt enabled kernels and the
same patch I sent out 30 mins back (appended again) should fix your issue
aswell. Can you please test this and check if my theory is indeed correct.
If it fixes your issue aswell, then I will re-post the patch with
a new changelog and updated comments in the patch.

thanks,
suresh
---

[patch] x86: fix blocking call (math_state_restore()) condition in __switch_to

Add tsk_used_math() checks to prevent calling math_state_restore()
which can sleep in the case of !tsk_used_math(). This prevents
making a blocking call in __switch_to().

Apparently "fpu_counter > 5" check is not enough, as in some signal handling
and fork/exec scenarios, fpu_counter > 5 and !tsk_used_math() is possible.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f8476df..6d54833 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -649,8 +649,11 @@ struct task_struct * __switch_to(struct task_struct *prev_p, struct task_struct
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * tsk_used_math() checks prevent calling math_state_restore(),
+	 * which can sleep in the case of !tsk_used_math()
 	 */
-	if (next_p->fpu_counter > 5)
+	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
 
 	/*
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index e2319f3..ac54ff5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -658,8 +658,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	/* If the task has used fpu the last 5 timeslices, just do a full
 	 * restore of the math state immediately to avoid the trap; the
 	 * chances of needing FPU soon are obviously high now
+	 *
+	 * tsk_used_math() checks prevent calling math_state_restore(),
+	 * which can sleep in the case of !tsk_used_math()
 	 */
-	if (next_p->fpu_counter>5)
+	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
 		math_state_restore();
 	return prev_p;
