Return-Path: <linux-kernel-owner+w=401wt.eu-S939004AbXFHHvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939004AbXFHHvo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937939AbXFHHZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55329 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967005AbXFHHZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:00 -0400
Message-Id: <20070608072217.582992000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:59 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 32/54] UML - Improve host PTRACE_SYSEMU check
Content-Disposition: inline; filename=uml-improve-host-ptrace_sysemu-check.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jeff Dike <jdike@addtoit.com>

Make the PTRACE_SYSEMU checking more robust.  It will make sure that
system call numbers are reported correctly.  If there is a problem, it
will disable PTRACE_SYSEMU use and use PTRACE_SYSCALL instead.

This fixes a hang on boot on FC6 hosts with a broken PTRACE_SYSEMU.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
--
 arch/um/os-Linux/start_up.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- linux-2.6.21.4.orig/arch/um/os-Linux/start_up.c
+++ linux-2.6.21.4/arch/um/os-Linux/start_up.c
@@ -144,9 +144,7 @@ static int stop_ptraced_child(int pid, v
 		int exit_with = WEXITSTATUS(status);
 		if (exit_with == 2)
 			non_fatal("check_ptrace : child exited with status 2. "
-				  "Serious trouble happening! Try updating "
-				  "your host skas patch!\nDisabling SYSEMU "
-				  "support.");
+				  "\nDisabling SYSEMU support.\n");
 		non_fatal("check_ptrace : child exited with exitcode %d, while "
 			  "expecting %d; status 0x%x\n", exit_with,
 			  exitcode, status);
@@ -209,6 +207,7 @@ __uml_setup("nosysemu", nosysemu_cmd_par
 static void __init check_sysemu(void)
 {
 	void *stack;
+	unsigned long regs[MAX_REG_NR];
 	int pid, n, status, count=0;
 
 	non_fatal("Checking syscall emulation patch for ptrace...");
@@ -225,11 +224,20 @@ static void __init check_sysemu(void)
 		fatal("check_sysemu : expected SIGTRAP, got status = %d",
 		      status);
 
-	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET,
-		   os_getpid());
-	if(n < 0)
-		fatal_perror("check_sysemu : failed to modify system call "
-			     "return");
+	if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+		fatal_perror("check_sysemu : PTRACE_GETREGS failed");
+	if(PT_SYSCALL_NR(regs) != __NR_getpid){
+		non_fatal("check_sysemu got system call number %d, "
+			  "expected %d...", PT_SYSCALL_NR(regs), __NR_getpid);
+		goto fail;
+	}
+
+	n = ptrace(PTRACE_POKEUSR, pid, PT_SYSCALL_RET_OFFSET, os_getpid());
+	if(n < 0){
+		non_fatal("check_sysemu : failed to modify system call "
+			  "return");
+		goto fail;
+	}
 
 	if (stop_ptraced_child(pid, stack, 0, 0) < 0)
 		goto fail_stopped;

-- 
