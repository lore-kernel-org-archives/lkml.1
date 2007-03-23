Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbXCWTlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbXCWTlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934088AbXCWTlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:41:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:58832 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbXCWTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:41:18 -0400
Date: Fri, 23 Mar 2007 15:37:30 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - host VDSO fix
Message-ID: <20070323193730.GA9519@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a problem seen by a number of people running UML on newer host
kernels.  init would hang with an infinite segfault loop.

It turns out that the host kernel was providing a AT_SYSINFO_EHDR of
0xffffe000, which faked UML into believing that the host VDSO page could be
reused.  However, AT_SYSINFO pointed into the middle of the address space, and
was unmapped as a result.  Because UML was providing AT_SYSINFO_EHDR and
AT_SYSINFO to its own processes, these would branch to nowhere when trying to
use the VDSO.

The fix is to also check the location of AT_SYSINFO when deciding whether to
use the host's VDSO.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/elf_aux.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.17/arch/um/os-Linux/elf_aux.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/elf_aux.c	2007-02-23 15:00:51.000000000 -0500
+++ linux-2.6.17/arch/um/os-Linux/elf_aux.c	2007-02-23 15:09:58.000000000 -0500
@@ -39,6 +39,9 @@ __init void scan_elf_aux( char **envp)
 		switch ( auxv->a_type ) {
 			case AT_SYSINFO:
 				__kernel_vsyscall = auxv->a_un.a_val;
+				/* See if the page is under TASK_SIZE */
+				if (__kernel_vsyscall < (unsigned long) envp)
+					__kernel_vsyscall = 0;
 				break;
 			case AT_SYSINFO_EHDR:
 				vsyscall_ehdr = auxv->a_un.a_val;
