Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYBKTwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYBKTwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbYBKTwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:52:09 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:25641 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587AbYBKTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=kVFxYuaSJWRlo7x0ehEWfXG1TPzhddMWoq2oNm2szsSyMnnFutzhcNm9HRv5eH3xuMMqDax38LVUzdFDnLRMieMWmXwzRCEGZeCleLCSGm+nLo8BRk3vfS/hfkUrU7bibPuM2HbRlwCtBLJa/BE4aGeDNbyS02h/6acwedjWcR4=
Date: Tue, 12 Feb 2008 03:52:22 +0800
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: [PATCH 1/1] Taint kernel after WARN_ON(condition)
Message-ID: <20080211195222.GA5809@gandalf.middleearth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Nur Hussein <nurhussein@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will taint the kernel with a new flag, 'W', whenever a
warning is issued with WARN_ON(condition). Whenever a warning occurs, it
is helpful to record this within the kernel state as a taint. When a BUG
happens, it'd be useful to know if it was also preceded by a WARN.

This patch applies to Linus's git tree.

Signed-off-by: Nur Hussein (nurhussein@gmail.com)
---

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 2632328..0633e96 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -42,8 +42,10 @@ extern void warn_on_slowpath(const char *file, const int line);
 #ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
+	if (unlikely(__ret_warn_on)) {					\
 		__WARN();						\
+		add_taint(TAINT_WARN);					\
+	}								\
 	unlikely(__ret_warn_on);					\
 })
 #endif
@@ -60,6 +62,8 @@ extern void warn_on_slowpath(const char *file, const int line);
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on)) 					\
+		add_taint(TAINT_WARN);					\
 	unlikely(__ret_warn_on);					\
 })
 #endif
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2df44e7..d90c1a4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -255,6 +255,7 @@ extern enum system_states {
 #define TAINT_USER			(1<<6)
 #define TAINT_DIE			(1<<7)
 #define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
+#define TAINT_WARN			(1<<9)
 
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 24af9f8..e113a85 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -153,6 +153,8 @@ EXPORT_SYMBOL(panic);
  *  'M' - System experienced a machine check exception.
  *  'B' - System has hit bad_page.
  *  'U' - Userspace-defined naughtiness.
+ *  'A' - ACPI table overridden.
+ *  'W' - Taint on warning.
  *
  *	The string is overwritten by the next call to print_taint().
  */
@@ -161,7 +163,7 @@ const char *print_tainted(void)
 {
 	static char buf[20];
 	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c",
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
@@ -170,7 +172,8 @@ const char *print_tainted(void)
 			tainted & TAINT_BAD_PAGE ? 'B' : ' ',
 			tainted & TAINT_USER ? 'U' : ' ',
 			tainted & TAINT_DIE ? 'D' : ' ',
-			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ');
+			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
+			tainted & TAINT_WARN ? 'W' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");
