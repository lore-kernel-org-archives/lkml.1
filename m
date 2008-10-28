Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYJ1IbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYJ1IbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYJ1IbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:31:13 -0400
Received: from mga05.intel.com ([192.55.52.89]:19961 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752562AbYJ1IbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:31:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,498,1220252400"; 
   d="scan'208";a="632356470"
Subject: Re: cpu2000(both float and int) 13% regression with 2.6.28-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Roland McGrath <roland@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20081028080327.GB15734@elte.hu>
References: <1225175522.1685.57.camel@ymzhang>
	 <20081028080327.GB15734@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Oct 2008 16:31:18 +0800
Message-Id: <1225182678.1685.68.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-10-28 at 09:03 +0100, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Comparing with 2.6.27, cpu2000 (both float and int) has about 13% regression
> > with 2.6.28-rc1 ﻿on my new-model x86-64 machine.
> > 
> > I bisected down to below patch.
> > 
> > commit 0afe2db21394820d32646a695eccf3fbfe6ab5c7
> > Merge: d847059... 43603c8...
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Sat Oct 11 20:23:20 2008 +0200
> > 
> >     Merge branch 'x86/unify-cpu-detect' into x86-v28-for-linus-phase4-D
> >     
> >     Conflicts:
> >         arch/x86/kernel/cpu/common.c
> >         arch/x86/kernel/signal_64.c
> >         include/asm-x86/cpufeature.h
> > 
> > 
> > When I tried to revert it against 2.6.28-rc2, there are many conflictions.
> 
> My guess right now is that it's the merge commit's doing, see the diff 
> below. Could you undo just the restore_sigcontext() chunk of it, in 
> arch/x86/kernel/signal_64.c:
I failed to apply the patch. When I tried to manually copy the source codes
from 2.6.27 to 2.6.28-rc2, I found there are many dependence on xsave, such like
TS_XSAVE, so restore might not match with save.

> 
> @@@ -157,20 -96,9 +94,9 @@@ restore_sigcontext(struct pt_regs *regs
> 
> I've attached it as a patch below, apply it with "patch -p1 -R"
> 
> (I've also attached the full merge commit further below - just in case 
> it's in another portion of it.)
> 
> 	Ingo
> 
> ---------------->
> 
> diff --cc arch/x86/kernel/signal_64.c
> index 694aa88,4665b59..823a55b
> --- a/arch/x86/kernel/signal_64.c
> +++ b/arch/x86/kernel/signal_64.c
> @@@ -157,20 -96,9 +94,9 @@@ restore_sigcontext(struct pt_regs *regs
>   	}
>   
>   	{
>  -		struct _fpstate __user * buf;
>  +		struct _fpstate __user *buf;
>   		err |= __get_user(buf, &sc->fpstate);
> - 
> - 		if (buf) {
> - 			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
> - 				goto badframe;
> - 			err |= restore_i387(buf);
> - 		} else {
> - 			struct task_struct *me = current;
> - 			if (used_math()) {
> - 				clear_fpu(me);
> - 				clear_used_math();
> - 			}
> - 		}
> + 		err |= restore_i387_xstate(buf);
>   	}
>   
>   	err |= __get_user(*pax, &sc->ax);
> 
> ------------------->
> commit 0afe2db21394820d32646a695eccf3fbfe6ab5c7
> Merge: d847059... 43603c8...
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sat Oct 11 20:23:20 2008 +0200
> 
>     Merge branch 'x86/unify-cpu-detect' into x86-v28-for-linus-phase4-D
>     
>     Conflicts:
>     	arch/x86/kernel/cpu/common.c
>     	arch/x86/kernel/signal_64.c
>     	include/asm-x86/cpufeature.h
> 
> diff --cc arch/x86/kernel/sigframe.h
> index 8b4956e,6dd7e2b..cc673aa
> --- a/arch/x86/kernel/sigframe.h
> +++ b/arch/x86/kernel/sigframe.h
> @@@ -23,10 -32,6 +32,11 @@@ struct rt_sigframe 
>   	char __user *pretcode;
>   	struct ucontext uc;
>   	struct siginfo info;
> + 	/* fp state follows here */
>   };
>  +
>  +int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  +		sigset_t *set, struct pt_regs *regs);
>  +int ia32_setup_frame(int sig, struct k_sigaction *ka,
>  +		sigset_t *set, struct pt_regs *regs);
>   #endif
> diff --cc arch/x86/kernel/signal_64.c
> index 694aa88,4665b59..823a55b
> --- a/arch/x86/kernel/signal_64.c
> +++ b/arch/x86/kernel/signal_64.c
> @@@ -157,20 -96,9 +94,9 @@@ restore_sigcontext(struct pt_regs *regs
>   	}
>   
>   	{
>  -		struct _fpstate __user * buf;
>  +		struct _fpstate __user *buf;
>   		err |= __get_user(buf, &sc->fpstate);
> - 
> - 		if (buf) {
> - 			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
> - 				goto badframe;
> - 			err |= restore_i387(buf);
> - 		} else {
> - 			struct task_struct *me = current;
> - 			if (used_math()) {
> - 				clear_fpu(me);
> - 				clear_used_math();
> - 			}
> - 		}
> + 		err |= restore_i387_xstate(buf);
>   	}
>   
>   	err |= __get_user(*pax, &sc->ax);
> @@@ -273,10 -197,10 +196,10 @@@ get_stack(struct k_sigaction *ka, struc
>   }
>   
>   static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
>  -			   sigset_t *set, struct pt_regs * regs)
>  +			   sigset_t *set, struct pt_regs *regs)
>   {
>   	struct rt_sigframe __user *frame;
> - 	struct _fpstate __user *fp = NULL;
> + 	void __user *fp = NULL;
>   	int err = 0;
>   	struct task_struct *me = current;
>   
> @@@ -285,11 -209,8 +208,8 @@@
>   		frame = (void __user *)round_down(
>   			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
>   
> - 		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
> - 			goto give_sigsegv;
> - 
> - 		if (save_i387(fp) < 0)
> + 		if (save_i387_xstate(fp) < 0)
>  -			err |= -1; 
>  +			err |= -1;
>   	} else
>   		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;
>   
> @@@ -301,9 -222,12 +221,12 @@@
>   		if (err)
>   			goto give_sigsegv;
>   	}
>  -		
>  +
>   	/* Create the ucontext.  */
> - 	err |= __put_user(0, &frame->uc.uc_flags);
> + 	if (cpu_has_xsave)
> + 		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
> + 	else
> + 		err |= __put_user(0, &frame->uc.uc_flags);
>   	err |= __put_user(0, &frame->uc.uc_link);
>   	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
>   	err |= __put_user(sas_ss_flags(regs->sp),
> diff --cc include/asm-x86/cpufeature.h
> index 065c6a8,8d45690..adfeae6
> --- a/include/asm-x86/cpufeature.h
> +++ b/include/asm-x86/cpufeature.h
> @@@ -64,49 -72,61 +72,63 @@@
>   #define X86_FEATURE_CYRIX_ARR	(3*32+ 2) /* Cyrix ARRs (= MTRRs) */
>   #define X86_FEATURE_CENTAUR_MCR	(3*32+ 3) /* Centaur MCRs (= MTRRs) */
>   /* cpu types for specific tunings: */
> - #define X86_FEATURE_K8		(3*32+ 4) /* Opteron, Athlon64 */
> - #define X86_FEATURE_K7		(3*32+ 5) /* Athlon */
> - #define X86_FEATURE_P3		(3*32+ 6) /* P3 */
> - #define X86_FEATURE_P4		(3*32+ 7) /* P4 */
> + #define X86_FEATURE_K8		(3*32+ 4) /* "" Opteron, Athlon64 */
> + #define X86_FEATURE_K7		(3*32+ 5) /* "" Athlon */
> + #define X86_FEATURE_P3		(3*32+ 6) /* "" P3 */
> + #define X86_FEATURE_P4		(3*32+ 7) /* "" P4 */
>   #define X86_FEATURE_CONSTANT_TSC (3*32+ 8) /* TSC ticks at a constant rate */
>   #define X86_FEATURE_UP		(3*32+ 9) /* smp kernel running on up */
> - #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* FXSAVE leaks FOP/FIP/FOP */
> + #define X86_FEATURE_FXSAVE_LEAK (3*32+10) /* "" FXSAVE leaks FOP/FIP/FOP */
>   #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
> ++#define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
>   #define X86_FEATURE_PEBS	(3*32+12) /* Precise-Event Based Sampling */
>   #define X86_FEATURE_BTS		(3*32+13) /* Branch Trace Store */
> - #define X86_FEATURE_SYSCALL32	(3*32+14) /* syscall in ia32 userspace */
> - #define X86_FEATURE_SYSENTER32	(3*32+15) /* sysenter in ia32 userspace */
> - #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
> - #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
> - #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
> - #define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
> + #define X86_FEATURE_SYSCALL32	(3*32+14) /* "" syscall in ia32 userspace */
> + #define X86_FEATURE_SYSENTER32	(3*32+15) /* "" sysenter in ia32 userspace */
> + #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well */
> + #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* "" Mfence synchronizes RDTSC */
> + #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
> + #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
>   #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
>  +#define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
> + #define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
>   
>   /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
> - #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
> - #define X86_FEATURE_MWAIT	(4*32+ 3) /* Monitor/Mwait support */
> - #define X86_FEATURE_DSCPL	(4*32+ 4) /* CPL Qualified Debug Store */
> + #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
> + #define X86_FEATURE_PCLMULQDQ	(4*32+ 1) /* PCLMULQDQ instruction */
> + #define X86_FEATURE_DTES64	(4*32+ 2) /* 64-bit Debug Store */
> + #define X86_FEATURE_MWAIT	(4*32+ 3) /* "monitor" Monitor/Mwait support */
> + #define X86_FEATURE_DSCPL	(4*32+ 4) /* "ds_cpl" CPL Qual. Debug Store */
> + #define X86_FEATURE_VMX		(4*32+ 5) /* Hardware virtualization */
> + #define X86_FEATURE_SMX		(4*32+ 6) /* Safer mode */
>   #define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
>   #define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
> + #define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
>   #define X86_FEATURE_CID		(4*32+10) /* Context ID */
> + #define X86_FEATURE_FMA		(4*32+12) /* Fused multiply-add */
>   #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
>   #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
> + #define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
>   #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
> + #define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
> + #define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
>   #define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
> - #define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2 */
> + #define X86_FEATURE_AES		(4*32+25) /* AES instructions */
> + #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
> + #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
> + #define X86_FEATURE_AVX		(4*32+28) /* Advanced Vector Extensions */
>   
>   /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word 5 */
> - #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore insn) */
> - #define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* on-CPU RNG enabled */
> - #define X86_FEATURE_XCRYPT	(5*32+ 6) /* on-CPU crypto (xcrypt insn) */
> - #define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* on-CPU crypto enabled */
> + #define X86_FEATURE_XSTORE	(5*32+ 2) /* "rng" RNG present (xstore) */
> + #define X86_FEATURE_XSTORE_EN	(5*32+ 3) /* "rng_en" RNG enabled */
> + #define X86_FEATURE_XCRYPT	(5*32+ 6) /* "ace" on-CPU crypto (xcrypt) */
> + #define X86_FEATURE_XCRYPT_EN	(5*32+ 7) /* "ace_en" on-CPU crypto enabled */
>   #define X86_FEATURE_ACE2	(5*32+ 8) /* Advanced Cryptography Engine v2 */
>   #define X86_FEATURE_ACE2_EN	(5*32+ 9) /* ACE v2 enabled */
> - #define X86_FEATURE_PHE		(5*32+ 10) /* PadLock Hash Engine */
> - #define X86_FEATURE_PHE_EN	(5*32+ 11) /* PHE enabled */
> - #define X86_FEATURE_PMM		(5*32+ 12) /* PadLock Montgomery Multiplier */
> - #define X86_FEATURE_PMM_EN	(5*32+ 13) /* PMM enabled */
> + #define X86_FEATURE_PHE		(5*32+10) /* PadLock Hash Engine */
> + #define X86_FEATURE_PHE_EN	(5*32+11) /* PHE enabled */
> + #define X86_FEATURE_PMM		(5*32+12) /* PadLock Montgomery Multiplier */
> + #define X86_FEATURE_PMM_EN	(5*32+13) /* PMM enabled */
>   
>   /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
>   #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */

