Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZBBNmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZBBNmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 08:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZBBNmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 08:42:46 -0500
Received: from leb.cs.unibo.it ([130.136.1.102]:40075 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZBBNmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 08:42:45 -0500
X-Greylist: delayed 1228 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 08:42:45 EST
Date: Mon, 2 Feb 2009 14:22:16 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH] UML on UML breaks when testing SYSEMU
Message-ID: <20090202132215.GH28208@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is currently impossible to run a user-mode linux machine inside another user-mode 
linux (UML on UML).

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

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
diff -Naur linux-2.6.28.2/arch/um/kernel/ptrace.c linux-2.6.28.2-umluml/arch/um/kernel/ptrace.c
--- linux-2.6.28.2/arch/um/kernel/ptrace.c	2009-01-25 01:42:07.000000000 +0100
+++ linux-2.6.28.2-umluml/arch/um/kernel/ptrace.c	2009-02-02 14:01:52.000000000 +0100
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
