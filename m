Return-Path: <linux-kernel-owner+w=401wt.eu-S1767302AbXDEU35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767302AbXDEU35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767300AbXDEU3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:29:45 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:54288 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbXDEU31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:29:27 -0400
Date: Thu, 5 Apr 2007 16:24:53 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/4] UML - Dump registers on ptrace or wait failure
Message-ID: <20070405202453.GA8934@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a register dump if handle_trap fails.
Abstract out ptrace_dump_regs since it now has two callers.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/skas/process.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

Index: linux-2.6.21-mm/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/skas/process.c	2007-04-05 12:38:43.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/skas/process.c	2007-04-05 12:39:12.000000000 -0400
@@ -44,6 +44,22 @@ int is_skas_winch(int pid, int fd, void 
 	return(1);
 }
 
+static int ptrace_dump_regs(int pid)
+{
+        unsigned long regs[MAX_REG_NR];
+        int i;
+
+        if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+                return -errno;
+        else {
+                printk("Stub registers -\n");
+                for(i = 0; i < ARRAY_SIZE(regs); i++)
+                        printk("\t%d - %lx\n", i, regs[i]);
+        }
+
+        return 0;
+}
+
 void wait_stub_done(int pid, int sig, char * fname)
 {
 	int n, status, err;
@@ -67,18 +83,10 @@ void wait_stub_done(int pid, int sig, ch
 
 	if((n < 0) || !WIFSTOPPED(status) ||
 	   (WSTOPSIG(status) != SIGUSR1 && WSTOPSIG(status) != SIGTRAP)){
-		unsigned long regs[MAX_REG_NR];
-
-		if(ptrace(PTRACE_GETREGS, pid, 0, regs) < 0)
+		err = ptrace_dump_regs(pid);
+		if(err)
 			printk("Failed to get registers from stub, "
-			       "errno = %d\n", errno);
-		else {
-			int i;
-
-			printk("Stub registers -\n");
-			for(i = 0; i < ARRAY_SIZE(regs); i++)
-				printk("\t%d - %lx\n", i, regs[i]);
-		}
+			       "errno = %d\n", -err);
 		panic("%s : failed to wait for SIGUSR1/SIGTRAP, "
 		      "pid = %d, n = %d, errno = %d, status = 0x%x\n",
 		      fname, pid, n, errno, status);
@@ -142,9 +150,14 @@ static void handle_trap(int pid, union u
 
 		CATCH_EINTR(err = waitpid(pid, &status, WUNTRACED));
 		if((err < 0) || !WIFSTOPPED(status) ||
-		   (WSTOPSIG(status) != SIGTRAP + 0x80))
+		   (WSTOPSIG(status) != SIGTRAP + 0x80)){
+                        err = ptrace_dump_regs(pid);
+                        if(err)
+                                printk("Failed to get registers from process, "
+                                       "errno = %d\n", -err);
 			panic("handle_trap - failed to wait at end of syscall, "
 			      "errno = %d, status = %d\n", errno, status);
+                }
 	}
 
 	handle_syscall(regs);
