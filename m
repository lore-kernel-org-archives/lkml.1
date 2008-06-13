Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbYFMWrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbYFMWrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 18:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbYFMWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 18:47:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:16525 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbYFMWrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 18:47:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,642,1204531200"; 
   d="scan'208";a="259534949"
Date: Fri, 13 Jun 2008 15:47:12 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Message-ID: <20080613224711.GA15084@linux-os.sc.intel.com>
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 11:24:01AM -0700, Vegard Nossum wrote:
> On Fri, Jun 13, 2008 at 7:42 PM, Patrick McHardy <kaber@trash.net> wrote:
> > I get this oops once a day, its apparently triggered by something
> > run by cron, but the process is a different one each time.
> >
> > Kernel is -git from yesterday shortly before the -rc6 release
> > (last commit is the usb-2.6 merge, the x86 patches are missing),
> > .config is attached.
> >
> > I'll retry with current -git, but the patches that have gone in
> > since I last updated don't look related.
> >
> 
> Thanks for the report.
> 
> >
> > [62060.043009] BUG: unable to handle kernel NULL pointer dereference at
> > 000001ff
> > [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
> > [62060.043009] *pde = 00000000
> > [62060.043009] Oops: 0002 [#1] PREEMPT

Patrick, Do you see any other error messages before this BUG stmt? Can you
please provide the complete kernel log till the point of failure?

I have a theory for your problem and have appended a patch to test it. Can
you please check if the appended patch fixes your problem.

> This decodes to
> 
>    0:   0f ae 00                fxsave (%eax)
> 
> so it's related to the floating-point context. This is the exact
> location of the crash:
> 
> $ addr2line -e arch/x86/kernel/process_32.o -i ab0
> include/asm/i387.h:232
> include/asm/i387.h:262
> arch/x86/kernel/process_32.c:595
> 
> ...so it looks like prev_task->thread.xstate->fxsave has become NULL.
> Or maybe it never had any other value.

Somehow (as described below?) TS_USEDFPU is set but the fpu is not
allocated or freed.

Please try the appended patch.

---
Another possible FPU pre-emption issue with the sleazy FPU optimization
which was benign before but not so anymore, with the dynamic FPU allocation
patch.

New task is getting exec'd and it is prempted at the below point.

flush_thread() {
	...
	/*
	* Forget coprocessor state..
	*/
	clear_fpu(tsk);
		<----- Preemption point
	clear_used_math();
	...
}

Now when it context switches in again, as the used_math() is still set
and fpu_counter can be > 5, we will do a math_state_restore() which sets
the task's TS_USEDFPU. After it continues from the above preemption point
it does clear_used_math() and much later free_thread_xstate().

Now, at the next context switch, it is quite possible that xstate is
null, used_math() is not set and TS_USEDFPU is still set. This will
trigger unlazy_fpu() causing kernel oops.

Fix this  by clearing tsk's fpu_counter before clearing task's fpu.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 6d54833..e2db9ac 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -333,6 +333,7 @@ void flush_thread(void)
 	/*
 	 * Forget coprocessor state..
 	 */
+	tsk->fpu_counter = 0;
 	clear_fpu(tsk);
 	clear_used_math();
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ac54ff5..c6eb5c9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -294,6 +294,7 @@ void flush_thread(void)
 	/*
 	 * Forget coprocessor state..
 	 */
+	tsk->fpu_counter = 0;
 	clear_fpu(tsk);
 	clear_used_math();
 }
