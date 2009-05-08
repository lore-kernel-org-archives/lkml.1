Return-Path: <linux-kernel-owner+w=401wt.eu-S1764415AbZEHV0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764415AbZEHV0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761780AbZEHVXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:23:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:44762 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbZEHVXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:23:35 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 08/13] RFC ONLY - arm,kgdb: Add hook to catch an oops with debugger
Date: Fri,  8 May 2009 16:23:15 -0500
Message-Id: <1241817800-9320-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1241817800-9320-8-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-2-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-3-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-4-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-5-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-6-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-7-git-send-email-jason.wessel@windriver.com>
 <1241817800-9320-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 08 May 2009 21:23:30.0216 (UTC) FILETIME=[3BC7EA80:01C9D023]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a RFC patch.  The work to possibly merge kdb and kgdb is being
evaluated and this patch is considered only a proof of concept or
prototype.

Add in a low level hook to catch calls to die() in the debugger.

After the debugger is done, the standard system rules will be in play
for the original exception.

The kdb debugger wanted a chance to catch these sorts of exceptions
for analysis.

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
index 57eb0f6..e649019 100644
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
@@ -248,6 +251,8 @@ NORET_TYPE void die(const char *str, struct pt_regs *regs, int err)
 {
 	struct thread_info *thread = current_thread_info();
 
+	kgdb_die_hook(DIE_OOPS, str, regs, err);
+
 	oops_enter();
 
 	console_verbose();
-- 
1.6.3.rc0.1.gf800

