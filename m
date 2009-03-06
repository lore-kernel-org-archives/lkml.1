Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZCFTte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZCFTte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZCFTt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:49:26 -0500
Received: from leb.cs.unibo.it ([130.136.1.102]:35904 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZCFTt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:49:26 -0500
Date: Fri, 6 Mar 2009 20:49:22 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>
Subject: [PATCH] UML on UML fixed: it did not start
Message-ID: <20090306194921.GA2881@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is currently impossible to run a user-mode linux machine inside another user-mode 
linux (UML on UML). It breaks after a few instructions. When it tries to check
whether SYSEMU is installed (the inner) UML receives an inconsistent result 
(from the outer UML).

This is the output of a broken attempt:
$ ./linux mem=256m ubd0=cow
Locating the bottom of the address space ... 0x0
Locating the top of the address space ... 0xc0000000
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking ptrace new tags for syscall emulation...unsupported
Checking syscall emulation patch for ptrace...check_sysemu : expected SIGTRAP, got status = 256
$

The problem is the following:
PTRACE_SYSCALL/SINGLESTEP is currently managed inside arch_ptrace for ARCH=um.

PTRACE_SYSEMU/SUSEMU_SINGLESTEP is not captured in arch_ptrace's switch, therefore
it is erroneously passed back to ptrace_request (in kernel/ptrace).

This simple patch simply forces ptrace to return an error on PTRACE_SYSEMU/SUSEMU_SINGLESTEP
as it is unsupported on ARCH=um, and fixes the problem.

I posted the same patch one month ago. I just tested it again against the latest kernel.

	renzo

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
diff -Naur linux-2.6.29-rc7/arch/um/kernel/ptrace.c linux-2.6.29-rc7-umluml/arch/um/kernel/ptrace.c
--- linux-2.6.29-rc7/arch/um/kernel/ptrace.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.29-rc7-umluml/arch/um/kernel/ptrace.c	2009-03-06 20:27:51.000000000 +0100
@@ -64,6 +64,11 @@
 		ret = poke_user(child, addr, data);
 		break;
 
+	case PTRACE_SYSEMU:
+	case PTRACE_SYSEMU_SINGLESTEP:
+		ret=-EIO;
+		break;
+
 	/* continue and stop at next (return from) syscall */
 	case PTRACE_SYSCALL:
 	/* restart after signal. */
