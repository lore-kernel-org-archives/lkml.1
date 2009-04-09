Return-Path: <linux-kernel-owner+w=401wt.eu-S1764829AbZDIV23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764829AbZDIV23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760325AbZDIV1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:27:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:59036 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759482AbZDIV1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iZHgkNe2vZmt2k+q7um3OpNfJo3iba9aDgqW29YVM/twkAvAGFSsJIXkyr+p2AJObm
         l4enQswpEdRAvvV0oIpLTFkDa4tjqnRO3/xBgAUIiUC29y28oCx1eu64H9NGxUeT0k8J
         llPIMVzFqJ5mExXH73wza5aO7MrvpOmgHooYE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LTP <ltp-list@lists.sourceforge.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] lockdep: choose to continue lock debugging despite taint
Date: Thu,  9 Apr 2009 23:27:40 +0200
Message-Id: <1239312460-13396-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1239312460-13396-1-git-send-email-fweisbec@gmail.com>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep is disabled after any kernel taints. This might be convenient
to ignore bad locking issues which sources come from outside the kernel
tree. Nevertheless, it might be a frustrating experience for the
staging developers or anyone who might develop a kernel that happens
to be tainted.

Just provide an option to let one choose to continue lock-debugging
after any taint.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/kernel/panic.c b/kernel/panic.c
index 9e7420a..eadc0b5 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -213,6 +213,7 @@ unsigned long get_taint(void)
 
 void add_taint(unsigned flag)
 {
+#ifndef CONFIG_LOCKDEP_IGNORE_TAINT
 	/*
 	 * Can't trust the integrity of the kernel anymore.
 	 * We don't call directly debug_locks_off() because the issue
@@ -220,6 +221,7 @@ void add_taint(unsigned flag)
 	 */
 	if (xchg(&debug_locks, 0))
 		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
+#endif
 
 	set_bit(flag, &tainted_mask);
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c6e854f..599888b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -436,6 +436,20 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
+config LOCKDEP_IGNORE_TAINT
+	bool "Lock debugging: continue despite taints"
+	depends on LOCKDEP
+	default n
+	help
+	  If your kernel becomes tainted because of a warning,
+	  a staging or proprietary module loaded, etc... lockdep
+	  will be disabled by default. Select this option if you
+	  want lockdep to continue running despite a taint. If
+	  you are working on a staging driver, experiencing
+	  warnings but focusing on something else, or whatever
+	  reason that makes you developing on a kernel that is
+	  tainted, you might want to say Y here.
+
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
-- 
1.6.1

