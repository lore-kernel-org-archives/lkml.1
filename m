Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZE0IqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZE0IqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZE0IqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:46:05 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37915 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbZE0IqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:46:02 -0400
Date: Wed, 27 May 2009 14:15:38 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>
Subject: Re: [Patch 08/12] Modify Ptrace routines to access breakpoint
	registers
Message-ID: <20090527084538.GB6020@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090521095613.834622717@prasadkr_t60p.in.ibm.com> <20090521140228.GI13849@in.ibm.com> <20090527000700.GI5969@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527000700.GI5969@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 02:07:04AM +0200, Frederic Weisbecker wrote:
> On Thu, May 21, 2009 at 07:32:28PM +0530, K.Prasad wrote:
> > This patch modifies the ptrace code to use the new wrapper routines around the
> > debug/breakpoint registers.
> > 
> > Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > Signed-off-by: Maneesh Soni <maneesh@linux.vnet.ibm.com>
> > Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> > ---
> > -static unsigned long ptrace_get_debugreg(struct task_struct *child, int n)
> > +static int decode_dr7(unsigned long dr7, int bpnum, unsigned *len,
> > +		unsigned *type)
> >  {
> > -	switch (n) {
> > -	case 0:		return child->thread.debugreg0;
> > -	case 1:		return child->thread.debugreg1;
> > -	case 2:		return child->thread.debugreg2;
> > -	case 3:		return child->thread.debugreg3;
> > -	case 6:		return child->thread.debugreg6;
> > -	case 7:		return child->thread.debugreg7;
> > -	}
> > -	return 0;
> > +	int temp = dr7 >> (DR_CONTROL_SHIFT + bpnum * DR_CONTROL_SIZE);
> 
> 
> 
> temp is usually considered as a poor identifier, even for quick
> uses like this.
> 
> Why not bp_info?
> 
>

Okay.
 
> > +
> > +	*len = (temp & 0xc) | 0x40;
> > +	*type = (temp & 0x3) | 0x80;
> > +	return (dr7 >> (bpnum * DR_ENABLE_SIZE)) & 0x3;
> >  }
> >  
> > -static int ptrace_set_debugreg(struct task_struct *child,
> > -			       int n, unsigned long data)
> > +static void ptrace_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
> >  {
> > +	struct thread_struct *thread = &(current->thread);
> >  	int i;
> >  
> > -	if (unlikely(n == 4 || n == 5))
> > -		return -EIO;
> > +	/* Store in the virtual DR6 register the fact that the breakpoint
> > +	 * was hit so the thread's debugger will see it.
> > +	 */
> 
> 
> Please use the common comment convention:
> 
> /*
>  * Comment
>  */
> 
> 

I missed it. Will correct. Thanks.

> > +	for (i = 0; i < hbp_kernel_pos; i++)
> > +		/*
> > +		 * We will check bp->info.address against the address stored in
> > +		 * thread's hbp structure and not debugreg[i]. This is to ensure
> > +		 * that the corresponding bit for 'i' in DR7 register is enabled
> > +		 */
> > +		if (bp->info.address == thread->hbp[i]->info.address)
> > +			break;
> >  
> > -	if (n < 4 && unlikely(data >= debugreg_addr_limit(child)))
> > -		return -EIO;
> > +	thread->debugreg6 |= (DR_TRAP0 << i);
> > +}
> >  
> > -	switch (n) {
> > -	case 0:		child->thread.debugreg0 = data; break;
> > -	case 1:		child->thread.debugreg1 = data; break;
> > -	case 2:		child->thread.debugreg2 = data; break;
> > -	case 3:		child->thread.debugreg3 = data; break;
> > +/*
> > + * Handle ptrace writes to debug register 7.
> > + */
> > +static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	unsigned long old_dr7 = thread->debugreg7;
> > +	int i, orig_ret = 0, rc = 0;
> > +	int enabled, second_pass = 0;
> > +	unsigned len, type;
> > +	struct hw_breakpoint *bp;
> >  
> > -	case 6:
> > -		if ((data & ~0xffffffffUL) != 0)
> > -			return -EIO;
> > -		child->thread.debugreg6 = data;
> > -		break;
> > +	data &= ~DR_CONTROL_RESERVED;
> > +restore:
> > +	/*
> > +	 * Loop through all the hardware breakpoints, making the
> > +	 * appropriate changes to each.
> > +	 */
> > +	for (i = 0; i < HBP_NUM; i++) {
> > +		enabled = decode_dr7(data, i, &len, &type);
> > +		bp = thread->hbp[i];
> > +
> > +		if (!enabled) {
> > +			if (bp) {
> > +				/* Don't unregister the breakpoints right-away,
> > +				 * unless all register_user_hw_breakpoint()
> > +				 * requests have succeeded. This prevents
> > +				 * any window of opportunity for debug
> > +				 * register grabbing by other users.
> > +				 */
> > +				if (!second_pass)
> > +					continue;
> > +				unregister_user_hw_breakpoint(tsk, bp);
> > +				kfree(bp);
> > +			}
> > +			continue;
> > +		}
> > +		if (!bp) {
> > +			rc = -ENOMEM;
> > +			bp = kzalloc(sizeof(struct hw_breakpoint), GFP_KERNEL);
> > +			if (bp) {
> > +				bp->info.address = thread->debugreg[i];
> > +				bp->triggered = ptrace_triggered;
> > +				bp->info.len = len;
> > +				bp->info.type = type;
> > +				rc = register_user_hw_breakpoint(tsk, bp);
> > +				if (rc)
> > +					kfree(bp);
> > +			}
> > +		} else
> > +			rc = modify_user_hw_breakpoint(tsk, bp);
> > +		if (rc)
> > +			break;
> > +	}
> > +	/*
> > +	 * Make a second pass to free the remaining unused breakpoints
> > +	 * or to restore the original breakpoints if an error occurred.
> > +	 */
> > +	if (!second_pass) {
> > +		second_pass = 1;
> > +		if (rc < 0) {
> > +			orig_ret = rc;
> > +			data = old_dr7;
> > +		}
> > +		goto restore;
> > +	}
> > +	return ((orig_ret < 0) ? orig_ret : rc);
> > +}
> >  
> > -	case 7:
> > -		/*
> > -		 * Sanity-check data. Take one half-byte at once with
> > -		 * check = (val >> (16 + 4*i)) & 0xf. It contains the
> > -		 * R/Wi and LENi bits; bits 0 and 1 are R/Wi, and bits
> > -		 * 2 and 3 are LENi. Given a list of invalid values,
> > -		 * we do mask |= 1 << invalid_value, so that
> > -		 * (mask >> check) & 1 is a correct test for invalid
> > -		 * values.
> > -		 *
> > -		 * R/Wi contains the type of the breakpoint /
> > -		 * watchpoint, LENi contains the length of the watched
> > -		 * data in the watchpoint case.
> > -		 *
> > -		 * The invalid values are:
> > -		 * - LENi == 0x10 (undefined), so mask |= 0x0f00.	[32-bit]
> > -		 * - R/Wi == 0x10 (break on I/O reads or writes), so
> > -		 *   mask |= 0x4444.
> > -		 * - R/Wi == 0x00 && LENi != 0x00, so we have mask |=
> > -		 *   0x1110.
> > -		 *
> > -		 * Finally, mask = 0x0f00 | 0x4444 | 0x1110 == 0x5f54.
> > -		 *
> > -		 * See the Intel Manual "System Programming Guide",
> > -		 * 15.2.4
> > -		 *
> > -		 * Note that LENi == 0x10 is defined on x86_64 in long
> > -		 * mode (i.e. even for 32-bit userspace software, but
> > -		 * 64-bit kernel), so the x86_64 mask value is 0x5454.
> > -		 * See the AMD manual no. 24593 (AMD64 System Programming)
> > -		 */
> > -#ifdef CONFIG_X86_32
> > -#define	DR7_MASK	0x5f54
> > -#else
> > -#define	DR7_MASK	0x5554
> > -#endif
> > -		data &= ~DR_CONTROL_RESERVED;
> > -		for (i = 0; i < 4; i++)
> > -			if ((DR7_MASK >> ((data >> (16 + 4*i)) & 0xf)) & 1)
> > -				return -EIO;
> > -		child->thread.debugreg7 = data;
> > -		if (data)
> > -			set_tsk_thread_flag(child, TIF_DEBUG);
> > -		else
> > -			clear_tsk_thread_flag(child, TIF_DEBUG);
> > -		break;
> > +/*
> > + * Handle PTRACE_PEEKUSR calls for the debug register area.
> > + */
> > +unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	unsigned long val = 0;
> > +
> > +	if (n < HBP_NUM)
> > +		val = thread->debugreg[n];
> > +	else if (n == 6)
> > +		val = thread->debugreg6;
> > +	else if (n == 7)
> > +		val = thread->debugreg7;
> > +	return val;
> > +}
> > +
> > +/*
> > + * Handle PTRACE_POKEUSR calls for the debug register area.
> > + */
> > +int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
> > +{
> > +	struct thread_struct *thread = &(tsk->thread);
> > +	int rc = 0;
> > +
> > +	/* There are no DR4 or DR5 registers */
> > +	if (n == 4 || n == 5)
> > +		return -EIO;
> > +
> > +	if (n == 6) {
> > +		tsk->thread.debugreg6 = val;
> > +		goto ret_path;
> > +	}
> > +	if (n < HBP_NUM) {
> > +		if (thread->hbp[n]) {
> > +			if (arch_check_va_in_userspace(val,
> > +					thread->hbp[n]->info.len) == 0) {
> > +				rc = -EIO;
> > +				goto ret_path;
> > +			}
> > +			thread->hbp[n]->info.address = val;
> > +		}
> > +		thread->debugreg[n] = val;
> >  	}
> > +	/* All that's left is DR7 */
> > +	if (n == 7)
> > +		rc = ptrace_write_dr7(tsk, val);
> >  
> > -	return 0;
> > +ret_path:
> > +	return rc;
> >  }
> >  
> >  /*
> > 
> 
> 
> I also add the ptrace maintainers in Cc, in case they have
> comments about it.
> 
> Roland, Oleg, this patch is part of the hardware breakpoint
> generic interface integration from Prasad based on an older
> work from Alan Stern.
> 
> The following patches may help you to better understand
> the new API:
> 
> (generic headers) [Patch 01/12] Prepare the code for Hardware Breakpoint interfaces
> (generic Api) [Patch 02/12] Introducing generic hardware breakpoint handler interfaces
> (arch dependent side) [Patch 03/12] x86 architecture implementation of Hardware	Breakpoint interfaces
> 
> Thanks.
> 

Hi Roland/Oleg,
	Adding to what Frederic has stated, the ptrace patches do not
modify the behaviour as seen by the end-user. The ptrace_set_debugreg()
behaviour on registers DR0 - DR3 is the same as the existing one. For
DR7, a new function ptrace_write_dr7() is in place and most error returns
are confined to this function (there are a few new ones like -ENOMEM).

If a ptrace write operation on DR7 fails, any partially written values
on the register is restored to a state that existed before the ptrace
call along with an error return. This enables the user-space application
to safely recover from the error.

Hope that the changes on ptrace_<set><get>_debugreg() look acceptable to
you.

Thanks,
K.Prasad

