Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbZE0AHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbZE0AHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbZE0AHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 20:07:09 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:52002 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZE0AHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 20:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fegTTA7tSo1fVPzFioTlbACFDKO6YV5yetR4xut32ee8E6SHvo2qA67AqFy5Njm2tH
         t8tfM5jr0TD/MIRxG6pMdWfGhfIfJdDyMrK1LEB5ZHRCUvEIXXsI+NJ8MIAX/S/Ehj2l
         6TpyN4+HdvOnai0+3cMLEDakD5i4slYcddZzM=
Date: Wed, 27 May 2009 02:07:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>
Subject: Re: [Patch 08/12] Modify Ptrace routines to access breakpoint
	registers
Message-ID: <20090527000700.GI5969@nowhere>
References: <20090521095613.834622717@prasadkr_t60p.in.ibm.com> <20090521140228.GI13849@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521140228.GI13849@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 07:32:28PM +0530, K.Prasad wrote:
> This patch modifies the ptrace code to use the new wrapper routines around the
> debug/breakpoint registers.
> 
> Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> Signed-off-by: Maneesh Soni <maneesh@linux.vnet.ibm.com>
> Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  arch/x86/kernel/ptrace.c |  230 ++++++++++++++++++++++++++++-------------------
>  1 file changed, 140 insertions(+), 90 deletions(-)
> 
> Index: linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/ptrace.c
> +++ linux-2.6-tip.hbkpt/arch/x86/kernel/ptrace.c
> @@ -34,6 +34,7 @@
>  #include <asm/prctl.h>
>  #include <asm/proto.h>
>  #include <asm/ds.h>
> +#include <asm/hw_breakpoint.h>
>  
>  #include <trace/syscall.h>
>  
> @@ -136,11 +137,6 @@ static int set_segment_reg(struct task_s
>  	return 0;
>  }
>  
> -static unsigned long debugreg_addr_limit(struct task_struct *task)
> -{
> -	return TASK_SIZE - 3;
> -}
> -
>  #else  /* CONFIG_X86_64 */
>  
>  #define FLAG_MASK		(FLAG_MASK_32 | X86_EFLAGS_NT)
> @@ -265,15 +261,6 @@ static int set_segment_reg(struct task_s
>  	return 0;
>  }
>  
> -static unsigned long debugreg_addr_limit(struct task_struct *task)
> -{
> -#ifdef CONFIG_IA32_EMULATION
> -	if (test_tsk_thread_flag(task, TIF_IA32))
> -		return IA32_PAGE_OFFSET - 3;
> -#endif
> -	return TASK_SIZE_MAX - 7;
> -}
> -
>  #endif	/* CONFIG_X86_32 */
>  
>  static unsigned long get_flags(struct task_struct *task)
> @@ -464,95 +451,158 @@ static int genregs_set(struct task_struc
>  }
>  
>  /*
> - * This function is trivial and will be inlined by the compiler.
> - * Having it separates the implementation details of debug
> - * registers from the interface details of ptrace.
> + * Decode the length and type bits for a particular breakpoint as
> + * stored in debug register 7.  Return the "enabled" status.
>   */
> -static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
> +static int decode_dr7(unsigned long dr7, int bpnum, unsigned *len,
> +		unsigned *type)
>  {
> -	switch (n) {
> -	case 0:		return child->thread.debugreg0;
> -	case 1:		return child->thread.debugreg1;
> -	case 2:		return child->thread.debugreg2;
> -	case 3:		return child->thread.debugreg3;
> -	case 6:		return child->thread.debugreg6;
> -	case 7:		return child->thread.debugreg7;
> -	}
> -	return 0;
> +	int temp = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);



temp is usually considered as a poor identifier, even for quick
uses like this.

Why not bp_info?



> +
> +	*len = (temp & 0xc) | 0x40;
> +	*type = (temp & 0x3) | 0x80;
> +	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
>  }
>  
> -static int ptrace_set_debugreg(struct task_struct *child,
> -			       int n, unsigned long data)
> +static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
>  {
> +	struct thread_struct *thread = &(current->thread);
>  	int i;
>  
> -	if (unlikely(n == 4 || n == 5))
> -		return -EIO;
> +	/* Store in the virtual DR6 register the fact that the breakpoint
> +	 * was hit so the thread's debugger will see it.
> +	 */


Please use the common comment convention:

/*
 * Comment
 */


> +	for (i = 0; i < hbp_kernel_pos; i++)
> +		/*
> +		 * We will check bp->info.address against the address stored in
> +		 * thread's hbp structure and not debugreg[i]. This is to ensure
> +		 * that the corresponding bit for 'i' in DR7 register is enabled
> +		 */
> +		if (bp->info.address == thread->hbp[i]->info.address)
> +			break;
>  
> -	if (n < 4 && unlikely(data >= debugreg_addr_limit(child)))
> -		return -EIO;
> +	thread->debugreg6 |= (DR_TRAP0 << i);
> +}
>  
> -	switch (n) {
> -	case 0:		child->thread.debugreg0 = data; break;
> -	case 1:		child->thread.debugreg1 = data; break;
> -	case 2:		child->thread.debugreg2 = data; break;
> -	case 3:		child->thread.debugreg3 = data; break;
> +/*
> + * Handle ptrace writes to debug register 7.
> + */
> +static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
> +{
> +	struct thread_struct *thread = &(tsk->thread);
> +	unsigned long old_dr7 = thread->debugreg7;
> +	int i, orig_ret = 0, rc = 0;
> +	int enabled, second_pass = 0;
> +	unsigned len, type;
> +	struct hw_breakpoint *bp;
>  
> -	case 6:
> -		if ((data & ~0xffffffffUL) != 0)
> -			return -EIO;
> -		child->thread.debugreg6 = data;
> -		break;
> +	data &= ~DR_CONTROL_RESERVED;
> +restore:
> +	/*
> +	 * Loop through all the hardware breakpoints, making the
> +	 * appropriate changes to each.
> +	 */
> +	for (i = 0; i < HBP_NUM; i++) {
> +		enabled = decode_dr7(data, i, &len, &type);
> +		bp = thread->hbp[i];
> +
> +		if (!enabled) {
> +			if (bp) {
> +				/* Don't unregister the breakpoints right-away,
> +				 * unless all register_user_hw_breakpoint()
> +				 * requests have succeeded. This prevents
> +				 * any window of opportunity for debug
> +				 * register grabbing by other users.
> +				 */
> +				if (!second_pass)
> +					continue;
> +				unregister_user_hw_breakpoint(tsk, bp);
> +				kfree(bp);
> +			}
> +			continue;
> +		}
> +		if (!bp) {
> +			rc = -ENOMEM;
> +			bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> +			if (bp) {
> +				bp->info.address = thread->debugreg[i];
> +				bp->triggered = ptrace_triggered;
> +				bp->info.len = len;
> +				bp->info.type = type;
> +				rc = register_user_hw_breakpoint(tsk, bp);
> +				if (rc)
> +					kfree(bp);
> +			}
> +		} else
> +			rc = modify_user_hw_breakpoint(tsk, bp);
> +		if (rc)
> +			break;
> +	}
> +	/*
> +	 * Make a second pass to free the remaining unused breakpoints
> +	 * or to restore the original breakpoints if an error occurred.
> +	 */
> +	if (!second_pass) {
> +		second_pass = 1;
> +		if (rc < 0) {
> +			orig_ret = rc;
> +			data = old_dr7;
> +		}
> +		goto restore;
> +	}
> +	return ((orig_ret < 0) ? orig_ret : rc);
> +}
>  
> -	case 7:
> -		/*
> -		 * Sanity-check data. Take one half-byte at once with
> -		 * check = (val >> (16 + 4*i)) & 0xf. It contains the
> -		 * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
> -		 * 2 and 3 are LENi. Given a list of invalid values,
> -		 * we do mask |= 1 << invalid_value, so that
> -		 * (mask >> check) & 1 is a correct test for invalid
> -		 * values.
> -		 *
> -		 * R/Wi contains the type of the breakpoint /
> -		 * watchpoint, LENi contains the length of the watched
> -		 * data in the watchpoint case.
> -		 *
> -		 * The invalid values are:
> -		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.	[32-bit]
> -		 * - R/Wi == 0x10 (break on I/O reads or writes), so
> -		 *   mask |= 0x4444.
> -		 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
> -		 *   0x1110.
> -		 *
> -		 * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
> -		 *
> -		 * See the Intel Manual "System Programming Guide",
> -		 * 15.2.4
> -		 *
> -		 * Note that LENi == 0x10 is defined on x86_64 in long
> -		 * mode (i.e. even for 32-bit userspace software, but
> -		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
> -		 * See the AMD manual no. 24593 (AMD64 System Programming)
> -		 */
> -#ifdef CONFIG_X86_32
> -#define	DR7_MASK	0x5f54
> -#else
> -#define	DR7_MASK	0x5554
> -#endif
> -		data &= ~DR_CONTROL_RESERVED;
> -		for (i = 0; i < 4; i++)
> -			if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
> -				return -EIO;
> -		child->thread.debugreg7 = data;
> -		if (data)
> -			set_tsk_thread_flag(child, TIF_DEBUG);
> -		else
> -			clear_tsk_thread_flag(child, TIF_DEBUG);
> -		break;
> +/*
> + * Handle PTRACE_PEEKUSR calls for the debug register area.
> + */
> +unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
> +{
> +	struct thread_struct *thread = &(tsk->thread);
> +	unsigned long val = 0;
> +
> +	if (n < HBP_NUM)
> +		val = thread->debugreg[n];
> +	else if (n == 6)
> +		val = thread->debugreg6;
> +	else if (n == 7)
> +		val = thread->debugreg7;
> +	return val;
> +}
> +
> +/*
> + * Handle PTRACE_POKEUSR calls for the debug register area.
> + */
> +int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
> +{
> +	struct thread_struct *thread = &(tsk->thread);
> +	int rc = 0;
> +
> +	/* There are no DR4 or DR5 registers */
> +	if (n == 4 || n == 5)
> +		return -EIO;
> +
> +	if (n == 6) {
> +		tsk->thread.debugreg6 = val;
> +		goto ret_path;
> +	}
> +	if (n < HBP_NUM) {
> +		if (thread->hbp[n]) {
> +			if (arch_check_va_in_userspace(val,
> +					thread->hbp[n]->info.len) == 0) {
> +				rc = -EIO;
> +				goto ret_path;
> +			}
> +			thread->hbp[n]->info.address = val;
> +		}
> +		thread->debugreg[n] = val;
>  	}
> +	/* All that's left is DR7 */
> +	if (n == 7)
> +		rc = ptrace_write_dr7(tsk, val);
>  
> -	return 0;
> +ret_path:
> +	return rc;
>  }
>  
>  /*
> 


I also add the ptrace maintainers in Cc, in case they have
comments about it.

Roland, Oleg, this patch is part of the hardware breakpoint
generic interface integration from Prasad based on an older
work from Alan Stern.

The following patches may help you to better understand
the new API:

(generic headers) [Patch 01/12] Prepare the code for Hardware Breakpoint interfaces
(generic Api) [Patch 02/12] Introducing generic hardware breakpoint handler interfaces
(arch dependent side) [Patch 03/12] x86 architecture implementation of Hardware	Breakpoint interfaces

Thanks.

