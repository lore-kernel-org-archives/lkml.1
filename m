Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbZAFWTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbZAFWTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZAFWNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:35 -0500
Received: from kroah.org ([198.145.64.141]:51214 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752918AbZAFWNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/60] Make DEBUG take precedence over DYNAMIC_PRINTK_DEBUG
Date: Tue,  6 Jan 2009 14:11:36 -0800
Message-Id: <1231279939-32728-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Statically defined DEBUG should take precedence over
dynamically enabled debugging; otherwise adding DEBUG
(like, for example, via CONFIG_DEBUG_KOBJECT) does not
have the expected result of printing pr_debug() and dev_dbg()
messages unconditionally.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    8 ++++----
 include/linux/kernel.h |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index e21b5d6..b97a0cf 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -553,13 +553,13 @@ extern const char *dev_driver_string(const struct device *dev);
 #define dev_info(dev, format, arg...)		\
 	dev_printk(KERN_INFO , dev , format , ## arg)
 
-#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#if defined(DEBUG)
+#define dev_dbg(dev, format, arg...)		\
+	dev_printk(KERN_DEBUG , dev , format , ## arg)
+#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 #define dev_dbg(dev, format, ...) do { \
 	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
 	} while (0)
-#elif defined(DEBUG)
-#define dev_dbg(dev, format, arg...)		\
-	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
 #define dev_dbg(dev, format, arg...)		\
 	({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ca9ff64..d242fe1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -349,13 +349,13 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
+#if defined(DEBUG)
+#define pr_debug(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 #define pr_debug(fmt, ...) do { \
 	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
 	} while (0)
-#elif defined(DEBUG)
-#define pr_debug(fmt, ...) \
-	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
 #define pr_debug(fmt, ...) \
 	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
-- 
1.6.0.4

