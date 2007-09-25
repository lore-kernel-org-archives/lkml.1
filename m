Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbXIYAdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbXIYAdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756202AbXIYAdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:33:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:32804 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbXIYAdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:33:41 -0400
Subject: Re: [PATCH 1/2] powerpc: ptrace CHECK_FULL_REGS
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       David Woodhouse <dwmw2@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070924235052.5AFC24D04B7@magilla.localdomain>
References: <20070924235052.5AFC24D04B7@magilla.localdomain>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 10:33:26 +1000
Message-Id: <1190680406.12382.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 16:50 -0700, Roland McGrath wrote:
> This restores the CHECK_FULL_REGS sanity check to every place that can
> access the nonvolatile GPRs for ptrace.  This is already done for
> native-bitwidth PTRACE_PEEKUSR, but was omitted for many other cases
> (32-bit ptrace, PTRACE_GETREGS, etc.); I think there may have been more
> uniform checks before that were lost in the recent cleanup of GETREGS et al.

Yup, I think I ditched most of them.. for some reason I decided it
couldn't happen, but maybe I'm wrong ?

Cheers,
Ben.

> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/powerpc/kernel/ptrace.c   |    4 ++++
>  arch/powerpc/kernel/ptrace32.c |    8 ++++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 8a177bd..40d34b3 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -331,6 +331,7 @@ static long arch_ptrace_old(struct task_struct *child, long request, long addr,
>  		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
>  		unsigned long __user *tmp = (unsigned long __user *)addr;
>  
> +		CHECK_FULL_REGS(child->thread.regs);
>  		for (i = 0; i < 32; i++) {
>  			ret = put_user(*reg, tmp);
>  			if (ret)
> @@ -346,6 +347,7 @@ static long arch_ptrace_old(struct task_struct *child, long request, long addr,
>  		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
>  		unsigned long __user *tmp = (unsigned long __user *)addr;
>  
> +		CHECK_FULL_REGS(child->thread.regs);
>  		for (i = 0; i < 32; i++) {
>  			ret = get_user(*reg, tmp);
>  			if (ret)
> @@ -517,6 +519,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
>  			ret = -EIO;
>  			break;
>  		}
> +		CHECK_FULL_REGS(child->thread.regs);
>  		ret = 0;
>  		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
>  			ret |= __put_user(ptrace_get_reg(child, ui),
> @@ -537,6 +540,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
>  			ret = -EIO;
>  			break;
>  		}
> +		CHECK_FULL_REGS(child->thread.regs);
>  		ret = 0;
>  		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
>  			ret = __get_user(tmp, (unsigned long __user *) data);
> diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
> index 9e6baea..6b86960 100644
> --- a/arch/powerpc/kernel/ptrace32.c
> +++ b/arch/powerpc/kernel/ptrace32.c
> @@ -53,6 +53,7 @@ static long compat_ptrace_old(struct task_struct *child, long request,
>  		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
>  		unsigned int __user *tmp = (unsigned int __user *)addr;
>  
> +		CHECK_FULL_REGS(child->thread.regs);
>  		for (i = 0; i < 32; i++) {
>  			ret = put_user(*reg, tmp);
>  			if (ret)
> @@ -68,6 +69,7 @@ static long compat_ptrace_old(struct task_struct *child, long request,
>  		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
>  		unsigned int __user *tmp = (unsigned int __user *)addr;
>  
> +		CHECK_FULL_REGS(child->thread.regs);
>  		for (i = 0; i < 32; i++) {
>  			ret = get_user(*reg, tmp);
>  			if (ret)
> @@ -164,6 +166,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
>  		if ((addr & 3) || (index > PT_FPSCR32))
>  			break;
>  
> +		CHECK_FULL_REGS(child->thread.regs);
>  		if (index < PT_FPR0) {
>  			tmp = ptrace_get_reg(child, index);
>  		} else {
> @@ -210,6 +213,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
>  		if ((addr & 3) || numReg > PT_FPSCR)
>  			break;
>  
> +		CHECK_FULL_REGS(child->thread.regs);
>  		if (numReg >= PT_FPR0) {
>  			flush_fp_to_thread(child);
>  			tmp = ((unsigned long int *)child->thread.fpr)[numReg - PT_FPR0];
> @@ -270,6 +274,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
>  		if ((addr & 3) || (index > PT_FPSCR32))
>  			break;
>  
> +		CHECK_FULL_REGS(child->thread.regs);
>  		if (index < PT_FPR0) {
>  			ret = ptrace_put_reg(child, index, data);
>  		} else {
> @@ -307,6 +312,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
>  		 */
>  		if ((addr & 3) || (numReg > PT_FPSCR))
>  			break;
> +		CHECK_FULL_REGS(child->thread.regs);
>  		if (numReg < PT_FPR0) {
>  			unsigned long freg = ptrace_get_reg(child, numReg);
>  			if (index % 2)
> @@ -342,6 +348,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
>  			ret = -EIO;
>  			break;
>  		}
> +		CHECK_FULL_REGS(child->thread.regs);
>  		ret = 0;
>  		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
>  			ret |= __put_user(ptrace_get_reg(child, ui),
> @@ -359,6 +366,7 @@ long compat_sys_ptrace(int request, int pid, unsigned long addr,
>  			ret = -EIO;
>  			break;
>  		}
> +		CHECK_FULL_REGS(child->thread.regs);
>  		ret = 0;
>  		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
>  			ret = __get_user(tmp, (unsigned int __user *) data);
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

