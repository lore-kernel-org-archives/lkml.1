Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZDLOqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZDLOqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZDLOqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:46:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZDLOqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:46:14 -0400
Date: Sun, 12 Apr 2009 14:45:35 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239412638-6739-1-git-send-email-fweisbec@gmail.com>
References: <1239412638-6739-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:core/urgent] lockdep: warn about lockdep disabling after kernel taint
Message-ID: <tip-9eeba6138cefc0435695463ddadb0d95e0a6bcd2@git.kernel.org>
Git-Commit-ID: 9eeba6138cefc0435695463ddadb0d95e0a6bcd2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 14:45:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9eeba6138cefc0435695463ddadb0d95e0a6bcd2
Gitweb:     http://git.kernel.org/tip/9eeba6138cefc0435695463ddadb0d95e0a6bcd2
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 11 Apr 2009 03:17:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 16:10:51 +0200

lockdep: warn about lockdep disabling after kernel taint

Impact: provide useful missing info for developers

Kernel taint can occur in several situations such as warnings,
load of prorietary or staging modules, bad page, etc...

But when such taint happens, a developer might still be working on
the kernel, expecting that lockdep is still enabled. But a taint
disables lockdep without ever warning about it.
Such a kernel behaviour doesn't really help for kernel development.

This patch adds this missing warning.

Since the taint is done most of the time after the main message that
explain the real source issue, it seems safe to warn about it inside
add_taint() so that it appears at last, without hurting the main
information.

v2: Use a generic helper to disable lockdep instead of an
    open coded xchg().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1239412638-6739-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/debug_locks.h |    7 +++++++
 kernel/panic.c              |   10 ++++++++--
 lib/debug_locks.c           |    2 +-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 096476f..493dedb 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -2,12 +2,19 @@
 #define __LINUX_DEBUG_LOCKING_H
 
 #include <linux/kernel.h>
+#include <asm/atomic.h>
 
 struct task_struct;
 
 extern int debug_locks;
 extern int debug_locks_silent;
 
+
+static inline int __debug_locks_off(void)
+{
+	return xchg(&debug_locks, 0);
+}
+
 /*
  * Generic 'turn off all lock debugging' function:
  */
diff --git a/kernel/panic.c b/kernel/panic.c
index 3fd8c5b..940ca14 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -213,8 +213,14 @@ unsigned long get_taint(void)
 
 void add_taint(unsigned flag)
 {
-	/* can't trust the integrity of the kernel anymore: */
-	debug_locks = 0;
+	/*
+	 * Can't trust the integrity of the kernel anymore.
+	 * We don't call directly debug_locks_off() because the issue
+	 * is not necessarily serious enough to set oops_in_progress to 1
+	 */
+	if (__debug_locks_off())
+		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
+
 	set_bit(flag, &tainted_mask);
 }
 EXPORT_SYMBOL(add_taint);
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index 0218b46..bc3b117 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -36,7 +36,7 @@ int debug_locks_silent;
  */
 int debug_locks_off(void)
 {
-	if (xchg(&debug_locks, 0)) {
+	if (__debug_locks_off()) {
 		if (!debug_locks_silent) {
 			oops_in_progress = 1;
 			console_verbose();
