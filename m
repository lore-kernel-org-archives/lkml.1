Return-Path: <linux-kernel-owner+w=401wt.eu-S964969AbXBLQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969AbXBLQum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964973AbXBLQum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:50:42 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:52572 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964969AbXBLQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:50:41 -0500
Date: Mon, 12 Feb 2007 11:42:47 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [patches] [PATCH 2.6.21 review I] [4/25] x86: kernel-mode faults pollute current->thead
Message-ID: <20070212164247.GA5381@ccure.user-mode-linux.org>
References: <200702101250.142420000@suse.de> <20070210115016.652C913DCE@wotan.suse.de> <45D0422A.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D0422A.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 09:32:10AM +0000, Jan Beulich wrote:
> This breaks consumers of notify_die() relying on the proper trap number being
> passed, as the call to notify_die() from die() currently reads
> current->thread.trap_no.

Rats, good point.

> Also, you seem to leave other places where trap_no gets set untouched -
> is this intentional (do_debug - probably correct here, kernel_math_error -
> probably incorrect here)?

I did check the other trap handlers.  kernel_math_error calls die,
which calls do_exit(SIGSEGV).  This doesn't seem to allow the process
the opportunity to trap the SIGSEGV and examine the fault information.

> >I looked at i386, and there is a similar situation.  In this case, there is
> >duplicate code setting task->thread.error_code and trapno.  I deleted one,
> >leaving the copy that runs in the case of a userspace fault.
> 
> Likewise.

Yup.  How does this patch look to you?  We set error_code and trap_no
for userspace faults and kernel faults which call die().  We don't set
them for kernelspace faults which are fixed up.

Index: linux-2.6/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/traps.c
+++ linux-2.6/arch/i386/kernel/traps.c
@@ -619,6 +619,8 @@ gp_in_vm86:
 
 gp_in_kernel:
 	if (!fixup_exception(regs)) {
+		current->thread.error_code = error_code;
+		current->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 				error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;
Index: linux-2.6/arch/x86_64/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/traps.c
+++ linux-2.6/arch/x86_64/kernel/traps.c
@@ -605,8 +605,11 @@ static void __kprobes do_trap(int trapnr
 		fixup = search_exception_tables(regs->rip);
 		if (fixup)
 			regs->rip = fixup->fixup;
-		else	
+		else {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
+		}
 		return;
 	}
 }


-- 
Work email - jdike at linux dot intel dot com

