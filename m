Return-Path: <linux-kernel-owner+w=401wt.eu-S1030306AbXBTRFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030306AbXBTRFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030310AbXBTRFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:05:14 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:54981 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030297AbXBTREo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:04:44 -0500
Date: Tue, 20 Feb 2007 11:56:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org
Cc: "Christopher S. Aker" <caker@linode.com>,
       Sapan Bhatia <sapanb@CS.Princeton.EDU>, linux-kernel@vger.kernel.org,
       user-mode-linux@lists.sourceforge.net
Subject: [PATCH 2/3] UML - Host VDSO fix
Message-ID: <20070220165637.GA6250@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a problem seen by a number of people running UML on newer
host kernels.  init would hang with an infinite segfault loop.

It turns out that the host kernel was providing a AT_SYSINFO_EHDR of
0xffffe000, which faked UML into believing that the host VDSO page
could be reused.  However, AT_SYSINFO pointed into the middle of the
address space, and was unmapped as a result.  Because UML was
providing AT_SYSINFO_EHDR and AT_SYSINFO to its own processes, these
would branch to nowhere when trying to use the VDSO.

The fix is to also check the location of AT_SYSINFO when deciding
whether to use the host's VDSO.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/os-Linux/elf_aux.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.17/arch/um/os-Linux/elf_aux.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/elf_aux.c	2006-06-17 21:49:35.000000000 -0400
+++ linux-2.6.17/arch/um/os-Linux/elf_aux.c	2007-02-20 10:57:52.000000000 -0500
@@ -40,6 +40,9 @@ __init void scan_elf_aux( char **envp)
 		switch ( auxv->a_type ) {
 			case AT_SYSINFO:
 				__kernel_vsyscall = auxv->a_un.a_val;
+				/* See if the page is under TASK_SIZE */
+				if (__kernel_vsyscall < (unsigned long) envp)
+					__kernel_vsyscall = 0;
 				break;
 			case AT_SYSINFO_EHDR:
 				vsyscall_ehdr = auxv->a_un.a_val;

-- 
Work email - jdike at linux dot intel dot com
