Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZFPHg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZFPHg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZFPHgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:36:51 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55082 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbZFPHgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:36:50 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC] new pr_xxx macros for init/devinit functions
Date: Tue, 16 Jun 2009 03:36:40 -0400
Message-Id: <1245137800-5376-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The strings used in init/devinit functions normally stick around forever
even though the rest of the code/data was freed.  So create a new set of
pr_xxx macros which automatically place the strings used into the related
const sections so that when the regions get freed, the strings go as well.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/kernel.h |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 883cd44..988d474 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -377,6 +377,37 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
+/*
+ * Do a printk, but store the format string in a different section from the
+ * default one so that we can free the string memory when we're done with it.
+ */
+#define __pr_init(section, lvl, fmt, ...) do { \
+	static const __##section##const char __fmt[] = KERN_##lvl pr_fmt(fmt); \
+	printk(__fmt, ##__VA_ARGS__); \
+	} while (0)
+
+/* These are pr_xxx() variants that should be used in __init functions */
+#define _pr_init(lvl, fmt, ...)  __pr_init(init, lvl, fmt, ##__VA_ARGS__)
+#define pr_emerg_init(fmt, ...)   _pr_init(EMERG, fmt, ##__VA_ARGS__)
+#define pr_alert_init(fmt, ...)   _pr_init(ALERT, fmt, ##__VA_ARGS__)
+#define pr_crit_init(fmt, ...)    _pr_init(CRIT, fmt, ##__VA_ARGS__)
+#define pr_err_init(fmt, ...)     _pr_init(ERR, fmt, ##__VA_ARGS__)
+#define pr_warning_init(fmt, ...) _pr_init(WARNING, fmt, ##__VA_ARGS__)
+#define pr_notice_init(fmt, ...)  _pr_init(NOTICE, fmt, ##__VA_ARGS__)
+#define pr_info_init(fmt, ...)    _pr_init(INFO, fmt, ##__VA_ARGS__)
+#define pr_cont_init(fmt, ...)    _pr_init(CONT, fmt, ##__VA_ARGS__)
+
+/* These are pr_xxx() variants that should be used in __devinit functions */
+#define _pr_devinit(lvl, fmt, ...)  __pr_init(devinit, lvl, fmt, ##__VA_ARGS__)
+#define pr_emerg_devinit(fmt, ...)   _pr_devinit(EMERG, fmt, ##__VA_ARGS__)
+#define pr_alert_devinit(fmt, ...)   _pr_devinit(ALERT, fmt, ##__VA_ARGS__)
+#define pr_crit_devinit(fmt, ...)    _pr_devinit(CRIT, fmt, ##__VA_ARGS__)
+#define pr_err_devinit(fmt, ...)     _pr_devinit(ERR, fmt, ##__VA_ARGS__)
+#define pr_warning_devinit(fmt, ...) _pr_devinit(WARNING, fmt, ##__VA_ARGS__)
+#define pr_notice_devinit(fmt, ...)  _pr_devinit(NOTICE, fmt, ##__VA_ARGS__)
+#define pr_info_devinit(fmt, ...)    _pr_devinit(INFO, fmt, ##__VA_ARGS__)
+#define pr_cont_devinit(fmt, ...)    _pr_devinit(CONT, fmt, ##__VA_ARGS__)
+
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
 #define pr_devel(fmt, ...) \
-- 
1.6.3.1

