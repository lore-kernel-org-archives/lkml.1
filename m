Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbZCYAw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbZCYAw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbZCYAav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:51 -0400
Received: from kroah.org ([198.145.64.141]:54228 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756941AbZCYAag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Banks <gnb@sgi.com>, Jason Baron <jbaron@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 61/61] Dynamic debug: fix pr_fmt() build error
Date: Tue, 24 Mar 2009 17:27:05 -0700
Message-Id: <1237940825-22904-61-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Banks <gnb@sgi.com>

When CONFIG_DYNAMIC_DEBUG is enabled, allow callers of pr_debug()
to provide their own definition of pr_fmt() even if that definition
uses tricks like

#define pr_fmt(fmt) "%s:" fmt, __func__

Signed-off-by: Greg Banks <gnb@sgi.com>
Cc: Jason Baron <jbaron@redhat.com>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/dynamic_debug.h |    4 ++--
 include/linux/kernel.h        |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 07781aa..baabf33 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -57,7 +57,7 @@ extern int ddebug_remove_module(char *mod_name);
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
 	if (__dynamic_dbg_enabled(descriptor))				\
-		printk(KERN_DEBUG KBUILD_MODNAME ":" fmt,		\
+		printk(KERN_DEBUG KBUILD_MODNAME ":" pr_fmt(fmt),	\
 				##__VA_ARGS__);				\
 	} while (0)
 
@@ -70,7 +70,7 @@ extern int ddebug_remove_module(char *mod_name);
 		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
 	if (__dynamic_dbg_enabled(descriptor))				\
 			dev_printk(KERN_DEBUG, dev,			\
-					KBUILD_MODNAME ": " fmt,	\
+					KBUILD_MODNAME ": " pr_fmt(fmt),\
 					##__VA_ARGS__);			\
 	} while (0)
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index b5496ec..914918a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -359,8 +359,9 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 #define pr_debug(fmt, ...) \
 	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) do { \
-	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
+	dynamic_pr_debug(fmt, ##__VA_ARGS__); \
 	} while (0)
 #else
 #define pr_debug(fmt, ...) \
-- 
1.6.2

