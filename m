Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZCPHu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZCPHu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 03:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZCPHuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 03:50:46 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:14336 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbZCPHuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 03:50:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wSVuuW6uAz71gDjNWFOHTPAv912BZ+OHXsifpbWcfJcsIBPEed/BiivtJCuiBr5HvM
         s9ps0U2vC12N0qRM9mXAwAKsgHDDQlFT4FT+Mom81lNHtyAOlADKD3MUgMBia91edTde
         nbuX+4N3+m1MqofUiS27h0OtX8G7thfHHDkUE=
Date: Mon, 16 Mar 2009 15:51:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090316075113.GD3360@hack>
References: <20090204080248.GB17452@cs.unibo.it> <20090310214450.GD5213@cs.unibo.it> <20090311134103.GC12753@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311134103.GC12753@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 02:41:03PM +0100, Renzo Davoli wrote:
>I am re-submitting the two patches. Now they should be (more)
>consistent with the Coding Style specifications.
>
>This patch adds the new PTRACE_VM_SKIPCALL and PTRACE_VM_SKIPEXIT
>tags for ptrace's addr parameter.
>In this way it is possible to (eventually) get rid of PTRACE_SYSEMU
>PTRACE_SYSEMU_SINGLESTEP, while providing not only the same features
>but a more general support for Virtual Machines.
>Part#1: tracehook based architecture independent support
>
>renzo
>
>Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
>---
>diff -Naur linux-2.6.29-rc7-umluml/include/linux/ptrace.h linux-2.6.29-rc7-vm1/include/linux/ptrace.h
>--- linux-2.6.29-rc7-umluml/include/linux/ptrace.h	2009-03-06 20:26:13.000000000 +0100
>+++ linux-2.6.29-rc7-vm1/include/linux/ptrace.h	2009-03-06 20:31:11.000000000 +0100
>@@ -46,6 +46,11 @@
> #define PTRACE_EVENT_VFORK_DONE	5
> #define PTRACE_EVENT_EXIT	6
> 
>+/* options for new PTRACE_SYSCALL syntax*/
>+#define PTRACE_SYSCALL_SKIPEXIT  0x2
>+#define PTRACE_SYSCALL_SKIPCALL  0x6
>+#define PTRACE_SYSCALL_MASK    0x00000006
>+
> #include <asm/ptrace.h>
> 
> #ifdef __KERNEL__
>@@ -68,6 +73,10 @@
> #define PT_TRACE_VFORK_DONE	0x00000100
> #define PT_TRACE_EXIT	0x00000200
> 
>+#define PT_SYSCALL_SKIPEXIT  0x60000000
>+#define PT_SYSCALL_SKIPCALL  0x40000000
>+#define PT_SYSCALL_MASK      0x60000000
>+
> #define PT_TRACE_MASK	0x000003f4
> 
> /* single stepping state bits (used on ARM and PA-RISC) */
>diff -Naur linux-2.6.29-rc7-umluml/include/linux/tracehook.h linux-2.6.29-rc7-vm1/include/linux/tracehook.h
>--- linux-2.6.29-rc7-umluml/include/linux/tracehook.h	2009-03-06 20:26:13.000000000 +0100
>+++ linux-2.6.29-rc7-vm1/include/linux/tracehook.h	2009-03-06 20:31:11.000000000 +0100
>@@ -112,7 +112,7 @@
> 	struct pt_regs *regs)
> {
> 	ptrace_report_syscall(regs);
>-	return 0;
>+	return (task_ptrace(current) & PT_SYSCALL_SKIPCALL) ? 1 : 0;
> }
> 
> /**
>@@ -134,7 +134,8 @@
>  */
> static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
> {
>-	ptrace_report_syscall(regs);
>+	if (!(task_ptrace(current) & PT_SYSCALL_SKIPEXIT))
>+		ptrace_report_syscall(regs);
> }
> 
> /**
>diff -Naur linux-2.6.29-rc7-umluml/kernel/ptrace.c linux-2.6.29-rc7-vm1/kernel/ptrace.c
>--- linux-2.6.29-rc7-umluml/kernel/ptrace.c	2009-03-06 20:26:15.000000000 +0100
>+++ linux-2.6.29-rc7-vm1/kernel/ptrace.c	2009-03-06 20:31:11.000000000 +0100
>@@ -396,7 +396,7 @@
> #define is_sysemu_singlestep(request)	0
> #endif
> 
>-static int ptrace_resume(struct task_struct *child, long request, long data)
>+static int ptrace_resume(struct task_struct *child, long request, long addr, long data)

This line is longer than 80-characters, please break it into two lines.


> {
> 	if (!valid_signal(data))
> 		return -EIO;
>@@ -425,6 +425,9 @@
> 	else
> 		user_disable_single_step(child);
> 
>+	child->ptrace &= ~PT_SYSCALL_MASK;
>+	child->ptrace |= (addr & PTRACE_SYSCALL_MASK) << 28;


Please don't use magic numbers, use a macro to define it.


>+
> 	child->exit_code = data;
> 	wake_up_process(child);
> 
>@@ -486,12 +489,12 @@
> #endif
> 	case PTRACE_SYSCALL:
> 	case PTRACE_CONT:
>-		return ptrace_resume(child, request, data);
>+		return ptrace_resume(child, request, addr, data);
> 
> 	case PTRACE_KILL:
> 		if (child->exit_state)	/* already dead */
> 			return 0;
>-		return ptrace_resume(child, request, SIGKILL);
>+		return ptrace_resume(child, request, addr, SIGKILL);
> 
> 	default:
> 		break;

-- 
Do what you love, f**k the rest! F**k the regulations!
 
