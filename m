Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbXBEOQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbXBEOQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbXBEOQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:16:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932772AbXBEOQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:16:04 -0500
Subject: [DLM] add config entry to enable log_debug [16/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:24:08 +0000
Message-Id: <1170685449.11001.308.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From a10e13fbd217194280b2e125cab087cfe828a09e Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Tue, 9 Jan 2007 09:44:01 -0600
Subject: [PATCH] [DLM] add config entry to enable log_debug

Add a new dlm_config_info field to enable log_debug output and change
log_debug() to use it.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 958021f..7cf2020 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -775,6 +775,7 @@ int dlm_our_addr(struct sockaddr_storage *addr, int num)
 #define DEFAULT_RECOVER_TIMER      5
 #define DEFAULT_TOSS_SECS         10
 #define DEFAULT_SCAN_SECS          5
+#define DEFAULT_LOG_DEBUG          0
 
 struct dlm_config_info dlm_config = {
 	.ci_tcp_port = DEFAULT_TCP_PORT,
@@ -784,6 +785,7 @@ struct dlm_config_info dlm_config = {
 	.ci_dirtbl_size = DEFAULT_DIRTBL_SIZE,
 	.ci_recover_timer = DEFAULT_RECOVER_TIMER,
 	.ci_toss_secs = DEFAULT_TOSS_SECS,
-	.ci_scan_secs = DEFAULT_SCAN_SECS
+	.ci_scan_secs = DEFAULT_SCAN_SECS,
+	.ci_log_debug = DEFAULT_LOG_DEBUG
 };
 
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index ce603e1..1e97861 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -25,6 +25,7 @@ struct dlm_config_info {
 	int ci_recover_timer;
 	int ci_toss_secs;
 	int ci_scan_secs;
+	int ci_log_debug;
 };
 
 extern struct dlm_config_info dlm_config;
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index 7185a13..ee993c5 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -41,6 +41,7 @@
 #include <asm/uaccess.h>
 
 #include <linux/dlm.h>
+#include "config.h"
 
 #define DLM_LOCKSPACE_LEN	64
 
@@ -69,12 +70,12 @@ struct dlm_mhandle;
 #define log_error(ls, fmt, args...) \
 	printk(KERN_ERR "dlm: %s: " fmt "\n", (ls)->ls_name , ##args)
 
-#define DLM_LOG_DEBUG
-#ifdef DLM_LOG_DEBUG
-#define log_debug(ls, fmt, args...) log_error(ls, fmt, ##args)
-#else
-#define log_debug(ls, fmt, args...)
-#endif
+#define log_debug(ls, fmt, args...) \
+do { \
+	if (dlm_config.ci_log_debug) \
+		printk(KERN_DEBUG "dlm: %s: " fmt "\n", \
+		       (ls)->ls_name , ##args); \
+} while (0)
 
 #define DLM_ASSERT(x, do) \
 { \
-- 
1.4.4.2



