Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbXGKVDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbXGKVDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933281AbXGKVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:02:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933950AbXGKVCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:02:03 -0400
Date: Wed, 11 Jul 2007 22:01:20 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.23 PATCH 12/18] dm: add ratelimit logging macros
Message-ID: <20070711210120.GD24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Jonathan Brassow <jbrassow@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Brassow <jbrassow@redhat.com>

Add ratelimit extension to dm logging macros.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm.h |   40 ++++++++++++++++++++++++++++++++++++----
 1 files changed, 36 insertions(+), 4 deletions(-)

Index: linux/drivers/md/dm.h
===================================================================
--- linux.orig/drivers/md/dm.h	2007-07-11 21:37:31.000000000 +0100
+++ linux/drivers/md/dm.h	2007-07-11 21:37:49.000000000 +0100
@@ -18,13 +18,45 @@
 
 #define DM_NAME "device-mapper"
 
-#define DMERR(f, arg...) printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-#define DMWARN(f, arg...) printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
-#define DMINFO(f, arg...) printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMERR(f, arg...) \
+	printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMERR_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " \
+			       f "\n", ## arg); \
+	} while (0)
+
+#define DMWARN(f, arg...) \
+	printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMWARN_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_WARNING DM_NAME ": " DM_MSG_PREFIX ": " \
+			       f "\n", ## arg); \
+	} while (0)
+
+#define DMINFO(f, arg...) \
+	printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
+#define DMINFO_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_INFO DM_NAME ": " DM_MSG_PREFIX ": " f \
+			       "\n", ## arg); \
+	} while (0)
+
 #ifdef CONFIG_DM_DEBUG
-#  define DMDEBUG(f, arg...) printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
+#  define DMDEBUG(f, arg...) \
+	printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX " DEBUG: " f "\n", ## arg)
+#  define DMDEBUG_LIMIT(f, arg...) \
+	do { \
+		if (printk_ratelimit())	\
+			printk(KERN_DEBUG DM_NAME ": " DM_MSG_PREFIX ": " f \
+			       "\n", ## arg); \
+	} while (0)
 #else
 #  define DMDEBUG(f, arg...) do {} while (0)
+#  define DMDEBUG_LIMIT(f, arg...) do {} while (0)
 #endif
 
 #define DMEMIT(x...) sz += ((sz >= maxlen) ? \
