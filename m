Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbXKXUqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbXKXUqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 15:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXKXUqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 15:46:40 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:49836 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbXKXUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 15:46:40 -0500
Date: Sat, 24 Nov 2007 21:44:05 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: samuel@sortiz.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071124203232.6370.65534.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] net/irda/parameters.c: Trivial fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make a single va_start() -> va_end() path + fixing:
  CHECK   /home/kernel/src/net/irda/parameters.c
/home/kernel/src/net/irda/parameters.c:466:2: warning: Using plain integer as NULL pointer
/home/kernel/src/net/irda/parameters.c:520:2: warning: Using plain integer as NULL pointer
/home/kernel/src/net/irda/parameters.c:573:2: warning: Using plain integer as NULL pointer

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on i386 with allyesconfig and allmodconfig.


diff --git a/net/irda/parameters.c b/net/irda/parameters.c
index 2627dad..bf19071 100644
--- a/net/irda/parameters.c
+++ b/net/irda/parameters.c
@@ -368,10 +368,11 @@ int irda_param_pack(__u8 *buf, char *fmt, ...)
 	va_list args;
 	char *p;
 	int n = 0;
+	int retval = 0;
 
 	va_start(args, fmt);
 
-	for (p = fmt; *p != '\0'; p++) {
+	for (p = fmt; *p != '\0' && retval == 0; p++) {
 		switch (*p) {
 		case 'b':  /* 8 bits unsigned byte */
 			buf[n++] = (__u8)va_arg(args, int);
@@ -392,13 +393,12 @@ int irda_param_pack(__u8 *buf, char *fmt, ...)
 			break;
 #endif
 		default:
-			va_end(args);
-			return -1;
+			retval = -1;
 		}
 	}
 	va_end(args);
 
-	return 0;
+	return retval;
 }
 EXPORT_SYMBOL(irda_param_pack);
 
@@ -411,10 +411,11 @@ static int irda_param_unpack(__u8 *buf, char *fmt, ...)
 	va_list args;
 	char *p;
 	int n = 0;
+	int retval = 0;
 
 	va_start(args, fmt);
 
-	for (p = fmt; *p != '\0'; p++) {
+	for (p = fmt; *p != '\0' && retval == 0; p++) {
 		switch (*p) {
 		case 'b':  /* 8 bits byte */
 			arg.ip = va_arg(args, __u32 *);
@@ -436,14 +437,13 @@ static int irda_param_unpack(__u8 *buf, char *fmt, ...)
 			break;
 #endif
 		default:
-			va_end(args);
-			return -1;
+			retval = -1;
 		}
 
 	}
 	va_end(args);
 
-	return 0;
+	return retval;
 }
 
 /*
@@ -463,7 +463,7 @@ int irda_param_insert(void *self, __u8 pi, __u8 *buf, int len,
 	int n = 0;
 
 	IRDA_ASSERT(buf != NULL, return ret;);
-	IRDA_ASSERT(info != 0, return ret;);
+	IRDA_ASSERT(info != NULL, return ret;);
 
 	pi_minor = pi & info->pi_mask;
 	pi_major = pi >> info->pi_major_offset;
@@ -517,7 +517,7 @@ static int irda_param_extract(void *self, __u8 *buf, int len,
 	int n = 0;
 
 	IRDA_ASSERT(buf != NULL, return ret;);
-	IRDA_ASSERT(info != 0, return ret;);
+	IRDA_ASSERT(info != NULL, return ret;);
 
 	pi_minor = buf[n] & info->pi_mask;
 	pi_major = buf[n] >> info->pi_major_offset;
@@ -570,7 +570,7 @@ int irda_param_extract_all(void *self, __u8 *buf, int len,
 	int n = 0;
 
 	IRDA_ASSERT(buf != NULL, return ret;);
-	IRDA_ASSERT(info != 0, return ret;);
+	IRDA_ASSERT(info != NULL, return ret;);
 
 	/*
 	 * Parse all parameters. Each parameter must be at least two bytes
