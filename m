Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYFBVbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYFBVbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYFBVbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:31:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:12157 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYFBVbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:31:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,579,1204531200"; 
   d="scan'208";a="335140854"
Date: Mon, 2 Jun 2008 14:31:36 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: j.mell@t-online.de, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, ak@suse.de, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, arjan@linux.intel.com
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
Message-ID: <20080602213136.GA25114@linux-os.sc.intel.com>
References: <200806011101.06491.j.mell@t-online.de> <1212340262.5802.8.camel@odie.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212340262.5802.8.camel@odie.local>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 07:11:02PM +0200, Simon Holm Thøgersen wrote:
> søn, 01 06 2008 kl. 11:01 +0200, skrev j.mell@t-online.de:
> [...]
> > 
> > 3. If I revert the patch
> >  
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=acc207616a91a413a50fdd8847a747c4a7324167
> > 
> > in 2.6.20, Einstein does not crash anymore (program was run for more than 
> > 30 hours while system was in normal use with programming, multi-media 
> > etc.). Unfortunately git refuses to revert this patch in 2.6.26-rc4.
> [...]
> 
> I don't think the bisected commit is responsible for anything, but
> triggering a bug elsewhere with your workload. I've been chasing the
> same problem I think, but with other symptoms.

Simon, There seems to be multiple issues here. fpu corruption seems
to be a different problem compared to the issue you have encountered.

> 
> I'm triggering the following by running an lguest guest, but I guess the
> workload just need to have the right scheduler intensity to trigger the
> bug.
> 
> BUG: sleeping function called from invalid context at mm/slab.c:3052
> in_atomic():1, irqs_disabled():0
> Pid: 4771, comm: lguest Not tainted
> 2.6.26-rc4-debug-only-preemptible-00103-g1beee8d #3
>  [<c01146ee>] __might_sleep+0xe4/0xeb
>  [<c01605d9>] kmem_cache_alloc+0x22/0xb4
>  [<c0108479>] init_fpu+0xb0/0x14d
>  [<c0104768>] math_state_restore+0x26/0x5d
>  [<c01045ab>] device_not_available+0x43/0x48
>  [<c011007b>] ? handle_vm86_fault+0x213/0x6b8
>  [<c01029ad>] ? __switch_to+0x23/0x113
>  [<c02d6c9f>] schedule+0x221/0x2a4

Simon, Can you please try the appended patch and see if it fixes this
issue? Thanks.
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
 }
