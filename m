Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbYFPLHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbYFPLHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYFPLGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:06:53 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYFPLGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:06:52 -0400
Date: Mon, 16 Jun 2008 13:06:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Message-ID: <20080616110649.GJ20851@kernel.dk>
References: <4852B19E.4010202@trash.net> <19f34abd0806131124w32133715o3ef8c27cb0a9f96e@mail.gmail.com> <20080613224711.GA15084@linux-os.sc.intel.com> <20080614062014.GA7340@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614062014.GA7340@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14 2008, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > Somehow (as described below?) TS_USEDFPU is set but the fpu is not 
> > allocated or freed.
> > 
> > Please try the appended patch.
> 
> i've queued up your fix in tip/x86/urgent. (Git access coordinates: 
> http://people.redhat.com/mingo/tip.git/README)
> 
> i'm wondering why this problem was not hit more frequently. Does it need 
> some special FPU use to trigger? Or does it need an exec() with the FPU 
> stack still active? (normally the FPU stack is empty at exec() time)
> 
> 	Ingo
> 
> -------------------->
> commit fade25af0c80b9caed83beb0b961559f4c33a49f
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Fri Jun 13 15:47:12 2008 -0700
> 
>     x86: fix NULL pointer deref in __switch_to
>     
>     Patrick McHardy reported a crash:
>     
>     > > I get this oops once a day, its apparently triggered by something
>     > > run by cron, but the process is a different one each time.
>     > >
>     > > Kernel is -git from yesterday shortly before the -rc6 release
>     > > (last commit is the usb-2.6 merge, the x86 patches are missing),
>     > > .config is attached.
>     > >
>     > > I'll retry with current -git, but the patches that have gone in
>     > > since I last updated don't look related.
>     > >
>     > > [62060.043009] BUG: unable to handle kernel NULL pointer dereference at
>     > > 000001ff
>     > > [62060.043009] IP: [<c0102a9b>] __switch_to+0x2f/0x118
>     > > [62060.043009] *pde = 00000000
>     > > [62060.043009] Oops: 0002 [#1] PREEMPT
>     
>     Vegard Nossum analyzed it:
>     
>     > This decodes to
>     >
>     >    0:   0f ae 00                fxsave (%eax)
>     >
>     > so it's related to the floating-point context. This is the exact
>     > location of the crash:
>     >
>     > $ addr2line -e arch/x86/kernel/process_32.o -i ab0
>     > include/asm/i387.h:232
>     > include/asm/i387.h:262
>     > arch/x86/kernel/process_32.c:595
>     >
>     > ...so it looks like prev_task->thread.xstate->fxsave has become NULL.
>     > Or maybe it never had any other value.
>     
>     Somehow (as described below) TS_USEDFPU is set but the fpu is not
>     allocated or freed.
>     
>     Another possible FPU pre-emption issue with the sleazy FPU optimization
>     which was benign before but not so anymore, with the dynamic FPU allocation
>     patch.
>     
>     New task is getting exec'd and it is prempted at the below point.
>     
>     flush_thread() {
>     	...
>     	/*
>     	* Forget coprocessor state..
>     	*/
>     	clear_fpu(tsk);
>     		<----- Preemption point
>     	clear_used_math();
>     	...
>     }
>     
>     Now when it context switches in again, as the used_math() is still set
>     and fpu_counter can be > 5, we will do a math_state_restore() which sets
>     the task's TS_USEDFPU. After it continues from the above preemption point
>     it does clear_used_math() and much later free_thread_xstate().
>     
>     Now, at the next context switch, it is quite possible that xstate is
>     null, used_math() is not set and TS_USEDFPU is still set. This will
>     trigger unlazy_fpu() causing kernel oops.
>     
>     Fix this  by clearing tsk's fpu_counter before clearing task's fpu.
>     
>     Reported-by: Patrick McHardy <kaber@trash.net>
>     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 6d54833..e2db9ac 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -333,6 +333,7 @@ void flush_thread(void)
>  	/*
>  	 * Forget coprocessor state..
>  	 */
> +	tsk->fpu_counter = 0;
>  	clear_fpu(tsk);
>  	clear_used_math();
>  }
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index ac54ff5..c6eb5c9 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -294,6 +294,7 @@ void flush_thread(void)
>  	/*
>  	 * Forget coprocessor state..
>  	 */
> +	tsk->fpu_counter = 0;
>  	clear_fpu(tsk);
>  	clear_used_math();
>  }

Don't you need an smp_wmb() between that fpu_counter clear and
clear_fpu(), since your fix seems to rely on strict ordering between
the two?

-- 
Jens Axboe

