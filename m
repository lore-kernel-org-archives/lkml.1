Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbZLWVV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbZLWVV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZLWVVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:45311 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401AbZLWVVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 20/37] arm,kgdb: Add hook to catch an oops with debugger
Date: Wed, 23 Dec 2009 15:19:33 -0600
Message-Id: <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:20.0458 (UTC) FILETIME=[BB45E4A0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in a low level hook to catch calls to die() in the debugger.

After the debugger is done, the standard system rules will be in play
for the original exception.

The kdb debugger wants a chance to catch these sorts of exceptions for
analysis.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/arm/include/asm/kgdb.h |    2 ++
 arch/arm/kernel/kgdb.c      |    8 ++++++++
 arch/arm/kernel/traps.c     |    5 +++++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 67af4b8..5a2e60e 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -95,6 +95,8 @@ extern int kgdb_fault_expected;
 #define _PC			15
 #define _CPSR			(GDB_MAX_REGS - 1)
 
+int kgdb_die_hook(int cmd, const char *str, struct pt_regs *regs, int err);
+
 /*
  * So that we can denote the end of a frame for tracing,
  * in the simple case:
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index bb17e9b..3c0e5e5 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -10,6 +10,7 @@
  *           Deepak Saxena <dsaxena@plexity.net>
  */
 #include <linux/kgdb.h>
+#include <linux/notifier.h>
 #include <asm/traps.h>
 
 /* Make a local copy of the registers passed into the handler (bletch) */
@@ -189,6 +190,13 @@ void kgdb_arch_exit(void)
 	unregister_undef_hook(&kgdb_compiled_brkpt_hook);
 }
 
+int kgdb_die_hook(int cmd, const char *str, struct pt_regs *regs, int err)
+{
+	if (kgdb_handle_exception(1, err, cmd, regs))
+		return NOTIFY_DONE;
+	return NOTIFY_STOP;
+}
+
 /*
  * Register our undef instruction hooks with ARM undef core.
  * We regsiter a hook specifically looking for the KGB break inst
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 3f361a7..707e824 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -21,6 +21,9 @@
 #include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
+#include <linux/kgdb.h>
+#include <linux/kdebug.h>
+#include <linux/notifier.h>
 
 #include <asm/atomic.h>
 #include <asm/cacheflush.h>
@@ -254,6 +257,8 @@ NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct thread_info *thread = current_thread_info();
 
+	kgdb_die_hook(DIE_OOPS, str, regs, err);
+
 	oops_enter();
 
 	spin_lock_irq(&die_lock);
-- 
1.6.4.rc1

