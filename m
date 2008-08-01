Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYHAP26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYHAP26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYHAP2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:28:16 -0400
Received: from mail.windriver.com ([147.11.1.11]:56472 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYHAP2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:28:13 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/3] kgdb: fix kgdb_validate_break_address to perform a mem write
Date: Fri,  1 Aug 2008 10:27:53 -0500
Message-Id: <1217604474-24239-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1217604474-24239-2-git-send-email-jason.wessel@windriver.com>
References: <1217604474-24239-1-git-send-email-jason.wessel@windriver.com>
 <1217604474-24239-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 01 Aug 2008 15:27:55.0494 (UTC) FILETIME=[2BA1B060:01C8F3EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A regression to the kgdb core was found in the case of using the
CONFIG_DEBUG_RODATA kernel option.  When this option is on, a breakpoint
cannot be written into any readonly memory page.  When an external
debugger requests a breakpoint to get set, the
kgdb_validate_break_address() was only checking to see if the address
to place the breakpoint was readable and lacked a write check.

This patch changes the validate routine to try reading (via the
breakpoint set request) and also to try immediately writing the break
point.  If either fails, an error is correctly returned and the
debugger behaves correctly.  Then an end user can make the
descision to use hardware breakpoints.

Also update the documentation to reflect that using
CONFIG_DEBUG_RODATA will inhibit the use of software breakpoints.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl |   10 ++++++++++
 kernel/kgdb.c                   |   26 +++++++++++++++++++-------
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 54d3b15..372dec2 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -106,6 +106,16 @@
     while debugging the kernel.
     </para>
     <para>
+    If the architecture that you are using supports the kernel option
+    CONFIG_DEBUG_RODATA, you should consider turning it off.  This
+    option will prevent the use of software breakpoints because it
+    marks certain regions of the kernel's memory space as read-only.
+    If kgdb supports it for the architecture you are using, you can
+    use hardware breakpoints if you desire to run with the
+    CONFIG_DEBUG_RODATA option turned on, else you need to turn off
+    this option.
+    </para>
+    <para>
     Next you should choose one of more I/O drivers to interconnect debugging
     host and debugged target.  Early boot debugging requires a KGDB
     I/O driver that supports early debugging and the driver must be
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 3ec23c3..c0d45b2 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -166,13 +166,6 @@ early_param("nokgdbroundup", opt_nokgdbroundup);
  * Weak aliases for breakpoint management,
  * can be overriden by architectures when needed:
  */
-int __weak kgdb_validate_break_address(unsigned long addr)
-{
-	char tmp_variable[BREAK_INSTR_SIZE];
-
-	return probe_kernel_read(tmp_variable, (char *)addr, BREAK_INSTR_SIZE);
-}
-
 int __weak kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
 {
 	int err;
@@ -191,6 +184,25 @@ int __weak kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
 				  (char *)bundle, BREAK_INSTR_SIZE);
 }
 
+int __weak kgdb_validate_break_address(unsigned long addr)
+{
+	char tmp_variable[BREAK_INSTR_SIZE];
+	int err;
+	/* Validate setting the breakpoint and then removing it.  In the
+	 * remove fails, the kernel needs to emit a bad message because we
+	 * are deep trouble not being able to put things back the way we
+	 * found them.
+	 */
+	err = kgdb_arch_set_breakpoint(addr, tmp_variable);
+	if (err)
+		return err;
+	err = kgdb_arch_remove_breakpoint(addr, tmp_variable);
+	if (err)
+		printk(KERN_ERR "KGDB: Critical breakpoint error, kernel "
+		   "memory destroyed at: %lx", addr);
+	return err;
+}
+
 unsigned long __weak kgdb_arch_pc(int exception, struct pt_regs *regs)
 {
 	return instruction_pointer(regs);
-- 
1.5.5.1

