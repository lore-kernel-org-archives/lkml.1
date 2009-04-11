Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZDKBRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZDKBRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZDKBRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:17:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:45457 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbZDKBRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:17:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V6eqvnYfFXnZmx1w+DsV4Nb0EBc2w54akdtIFcFX5pAIafshcfwUdeDGi+5bVMmJBN
         2NHqtj1NocYXqH/TAIwjHqyM3a5WN9BoovtDyFASoZL/kwz4AobSF4Kk5j03rH3Y20Zx
         pURnG9zpqnFEF2bSROi1KnbnXakTADGqq3n2s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2 v2] lockdep: warn about lockdep disabling after kernel taint
Date: Sat, 11 Apr 2009 03:17:17 +0200
Message-Id: <1239412638-6739-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090410134520.GC17878@elte.hu>
References: <20090410134520.GC17878@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

v2: Use a generic helper to disable lockdep instead of an open coded
xchg().

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
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
-- 
1.6.1

