Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYJGPk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYJGPk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYJGPkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:40:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47760 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753472AbYJGPkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:40:47 -0400
Date: Tue, 7 Oct 2008 11:40:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 6/9] Use virtual debug registers in process/thread
 handling code
In-Reply-To: <20081007114451.GA25875@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0810071137550.2591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, K.Prasad wrote:

> This patch enables the use of abstract/virtual debug registers in
> process-handling routines.

...
> --- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/process_32.c
> +++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/process_32.c
> @@ -56,6 +56,8 @@
>  #include <asm/cpu.h>
>  #include <asm/kdebug.h>
>  #include <asm/idle.h>
> +#include <asm/debugreg.h>
> +#include <asm/hw_breakpoint.h>
>  
>  asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
>  
> @@ -158,9 +160,11 @@ void cpu_idle(void)
>  void __show_registers(struct pt_regs *regs, int all)
>  {
>  	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
> -	unsigned long d0, d1, d2, d3, d6, d7;
> +	unsigned long u_debugreg[8];
>  	unsigned long sp;
>  	unsigned short ss, gs;
> +	struct thread_hw_breakpoint *thbi = current->thread.hw_breakpoint_info;
> +	int i;
>  
>  	if (user_mode_vm(regs)) {
>  		sp = regs->sp;
> @@ -201,17 +205,18 @@ void __show_registers(struct pt_regs *re
>  	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
>  			cr0, cr2, cr3, cr4);
>  
> -	get_debugreg(d0, 0);
> -	get_debugreg(d1, 1);
> -	get_debugreg(d2, 2);
> -	get_debugreg(d3, 3);
> +	if (thbi) {
> +		for (i = 0; i < HB_NUM; ++i)
> +			u_debugreg[i] = thbi->vdr_bps[i].info.address;
> +		u_debugreg[7] = thbi->vdr7;
> +	}
> +	u_debugreg[6] = current->thread.vdr6;
> +
>  	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
> -			d0, d1, d2, d3);
> +					u_debugreg[0], u_debugreg[1],
> +						u_debugreg[2], u_debugreg[3]);
>  
> -	get_debugreg(d6, 6);
> -	get_debugreg(d7, 7);
> -	printk("DR6: %08lx DR7: %08lx\n",
> -			d6, d7);
> +	printk("DR6: %08lx DR7: %08lx\n", u_debugreg[6], u_debugreg[7]);

I don't like this at all.  show_registers() should display the physical
register contents, not the virtualized values.  Ditto for the 64-byte
version of this routine.

Alan Stern

