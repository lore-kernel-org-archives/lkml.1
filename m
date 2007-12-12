Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbXLLUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbXLLUs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbXLLUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:48:49 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:40745 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXLLUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:48:48 -0500
Date: Wed, 12 Dec 2007 15:47:59 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/6] UML - Don't allow processes to call into stub
Message-ID: <20071212204759.GA9134@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill a process that tries to branch into a stub and execute a system
call.  There are no security implications here - a system call in a
stub is treated the same as a system call anywhere else.  But if a
process is trying to branch into a stub, either it is trying something
nasty or it has gone haywire, so it's a good idea to get rid of it in
either case.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/skas/process.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2007-12-05 12:51:53.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2007-12-05 16:34:55.000000000 -0500
@@ -146,6 +146,9 @@ static void handle_trap(int pid, struct 
 {
 	int err, status;
 
+	if ((UPT_IP(regs) >= STUB_START) && (UPT_IP(regs) < STUB_END))
+		fatal_sigsegv();
+
 	/* Mark this as a syscall */
 	UPT_SYSCALL_NR(regs) = PT_SYSCALL_NR(regs->gp);
 
