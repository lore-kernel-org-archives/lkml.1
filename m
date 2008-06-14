Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYFNGUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYFNGUw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 02:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYFNGUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 02:20:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56022 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYFNGUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 02:20:39 -0400
Date: Sat, 14 Jun 2008 08:20:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Message-ID: <20080614062014.GA7340@elte.hu>
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com> <20080613224711.GA15084@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613224711.GA15084@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Somehow (as described below?) TS_USEDFPU is set but the fpu is not 
> allocated or freed.
> 
> Please try the appended patch.

i've queued up your fix in tip/x86/urgent. (Git access coordinates: 
http://people.redhat.com/mingo/tip.git/README)

i'm wondering why this problem was not hit more frequently. Does it need 
some special FPU use to trigger? Or does it need an exec() with the FPU 
stack still active? (normally the FPU stack is empty at exec() time)

	Ingo

-------------------->
commit fade25af0c80b9caed83beb0b961559f4c33a49f
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Fri Jun 13 15:47:12 2008 -0700

    x86: fix NULL pointer deref in __switch_to
    
    Patrick McHardy reported a crash:
    
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
    > > [62060.043009] BUG: unable to handle kernel NULL pointer dereference at
    > > 000001ff
    > > [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
    > > [62060.043009] *pde = 00000000
    > > [62060.043009] Oops: 0002 [#1] PREEMPT
    
    Vegard Nossum analyzed it:
    
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
    
    Somehow (as described below) TS_USEDFPU is set but the fpu is not
    allocated or freed.
    
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
    
    Reported-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

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
