Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYBMPyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYBMPyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYBMPyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:54:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48606 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349AbYBMPya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:54:30 -0500
Date: Wed, 13 Feb 2008 07:53:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
cc: Sam Ravnborg <sam@ravnborg.org>, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vmsplice exploits, stack protector and Makefiles
In-Reply-To: <47B30F05.29637.9A21F9B@pageexec.freemail.hu>
Message-ID: <alpine.LFD.1.00.0802130749210.2920@woody.linux-foundation.org>
References: <20080212090001.3fcc4ca0@laptopd505.fenrus.org> <47B30F05.29637.9A21F9B@pageexec.freemail.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, 
 if you're merging this, please do the independent parts really 
independenrly. For example, the above is a patch in its own right, and 
probably worth doing regardless of anything else.

(Same goes for the ACPI parts, I'll bounce that part to Len,

			Linus

On Wed, 13 Feb 2008, pageexec@freemail.hu wrote:
>
> diff -u linux-2.6.24.2-pax/arch/x86/kernel/entry_64.S linux-2.6.24.2-pax/arch/x86/kernel/entry_64.S
> --- linux-2.6.24.2-pax/arch/x86/kernel/entry_64.S	2008-01-25 15:34:25.000000000 +0100
> +++ linux-2.6.24.2-pax/arch/x86/kernel/entry_64.S	2008-02-13 11:12:26.000000000 +0100
> @@ -440,6 +440,7 @@
>  	CFI_REGISTER rip, r11
>  	SAVE_REST
>  	FIXUP_TOP_OF_STACK %r11
> +	movq %rsp, %rcx
>  	call sys_execve
>  	RESTORE_TOP_OF_STACK %r11
>  	movq %rax,RAX(%rsp)
> @@ -1004,15 +1005,16 @@
>   *	rdi: name, rsi: argv, rdx: envp
>   *
>   * We want to fallback into:
> - *	extern long sys_execve(char *name, char **argv,char **envp, struct pt_regs regs)
> + *	extern long sys_execve(char *name, char **argv,char **envp, struct pt_regs *regs)
>   *
>   * do_sys_execve asm fallback arguments:
> - *	rdi: name, rsi: argv, rdx: envp, fake frame on the stack
> + *	rdi: name, rsi: argv, rdx: envp, rcx: fake frame on the stack
>   */
>  ENTRY(kernel_execve)
>  	CFI_STARTPROC
>  	FAKE_STACK_FRAME $0
>  	SAVE_ALL	
> +	movq %rsp,%rcx
>  	call sys_execve
>  	movq %rax, RAX(%rsp)	
>  	RESTORE_REST
> diff -u linux-2.6.24.2-pax/arch/x86/kernel/process_64.c linux-2.6.24.2-pax/arch/x86/kernel/process_64.c
> --- linux-2.6.24.2-pax/arch/x86/kernel/process_64.c	2008-01-25 15:34:25.000000000 +0100
> +++ linux-2.6.24.2-pax/arch/x86/kernel/process_64.c	2008-02-13 11:13:14.000000000 +0100
> @@ -702,7 +701,7 @@
>   */
>  asmlinkage 
>  long sys_execve(char __user *name, char __user * __user *argv,
> -		char __user * __user *envp, struct pt_regs regs)
> +		char __user * __user *envp, struct pt_regs *regs)
>  {
>  	long error;
>  	char * filename;
> @@ -711,7 +710,7 @@
>  	error = PTR_ERR(filename);
>  	if (IS_ERR(filename)) 
>  		return error;
> -	error = do_execve(filename, argv, envp, &regs); 
> +	error = do_execve(filename, argv, envp, regs);
>  	if (error == 0) {
>  		task_lock(current);
>  		current->ptrace &= ~PT_DTRACE;
