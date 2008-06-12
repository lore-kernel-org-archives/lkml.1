Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYFLQ3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYFLQ3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYFLQ3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:29:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52298 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbYFLQ3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:29:13 -0400
Date: Thu, 12 Jun 2008 12:28:42 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/2] UML - Work around broken host PTRACE_SYSEMU
Message-ID: <20080612162842.GA8406@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora broke PTRACE_SYSEMU again, and UML crashes as a result when it
doesn't need to.  This patch makes the PTRACE_SYSEMU check fail
gracefully and makes UML fall back to PTRACE_SYSCALL.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/start_up.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6.22/arch/um/os-Linux/start_up.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/start_up.c	2008-06-10 11:42:06.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/start_up.c	2008-06-10 12:16:57.000000000 -0400
@@ -121,8 +121,10 @@ static int stop_ptraced_child(int pid, i
 {
 	int status, n, ret = 0;
 
-	if (ptrace(PTRACE_CONT, pid, 0, 0) < 0)
-		fatal_perror("stop_ptraced_child : ptrace failed");
+	if (ptrace(PTRACE_CONT, pid, 0, 0) < 0) {
+		perror("stop_ptraced_child : ptrace failed");
+		return -1;
+	}
 	CATCH_EINTR(n = waitpid(pid, &status, 0));
 	if (!WIFEXITED(status) || (WEXITSTATUS(status) != exitcode)) {
 		int exit_with = WEXITSTATUS(status);
@@ -212,7 +214,7 @@ static void __init check_sysemu(void)
 	if (n < 0)
 		fatal_perror("check_sysemu : wait failed");
 	if (!WIFSTOPPED(status) || (WSTOPSIG(status) != SIGTRAP))
-		fatal("check_sysemu : expected SIGTRAP, got status = %d",
+		fatal("check_sysemu : expected SIGTRAP, got status = %d\n",
 		      status);
 
 	if (ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
@@ -254,9 +256,11 @@ static void __init check_sysemu(void)
 
 		if (WIFSTOPPED(status) &&
 		    (WSTOPSIG(status) == (SIGTRAP|0x80))) {
-			if (!count)
-				fatal("check_ptrace : SYSEMU_SINGLESTEP "
-				      "doesn't singlestep");
+			if (!count) {
+				non_fatal("check_ptrace : SYSEMU_SINGLESTEP "
+					  "doesn't singlestep");
+				goto fail;
+			}
 			n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
 				   os_getpid());
 			if (n < 0)
@@ -266,9 +270,12 @@ static void __init check_sysemu(void)
 		}
 		else if (WIFSTOPPED(status) && (WSTOPSIG(status) == SIGTRAP))
 			count++;
-		else
-			fatal("check_ptrace : expected SIGTRAP or "
-			      "(SIGTRAP | 0x80), got status = %d", status);
+		else {
+			non_fatal("check_ptrace : expected SIGTRAP or "
+				  "(SIGTRAP | 0x80), got status = %d\n",
+				  status);
+			goto fail;
+		}
 	}
 	if (stop_ptraced_child(pid, 0, 0) < 0)
 		goto fail_stopped;
