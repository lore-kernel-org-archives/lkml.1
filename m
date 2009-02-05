Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZBEWsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZBEWsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZBEWr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:47:57 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34997 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbZBEWr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:47:56 -0500
From: ericvh@gmail.com
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] 9p: fix endian issues [attempt 3]
Date: Thu,  5 Feb 2009 16:47:53 -0600
Message-Id: <1233874073-9755-1-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Van Hensbergen <ericvh@gmail.com>

When the changes were done to the protocol last release, some endian
bugs crept in.  This patch fixes those endian problems and has been
verified to run on 32/64 bit and x86/ppc architectures.

This version of the patch incorporates the correct annotations
for endian variables.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 net/9p/protocol.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index dcd7666..fc70147 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -29,6 +29,7 @@
 #include <linux/errno.h>
 #include <linux/uaccess.h>
 #include <linux/sched.h>
+#include <linux/types.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include "protocol.h"
@@ -160,29 +161,32 @@ p9pdu_vreadf(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
 			break;
 		case 'w':{
 				int16_t *val = va_arg(ap, int16_t *);
-				if (pdu_read(pdu, val, sizeof(*val))) {
+				__le16 le_val;
+				if (pdu_read(pdu, &le_val, sizeof(le_val))) {
 					errcode = -EFAULT;
 					break;
 				}
-				*val = cpu_to_le16(*val);
+				*val = le16_to_cpu(le_val);
 			}
 			break;
 		case 'd':{
 				int32_t *val = va_arg(ap, int32_t *);
-				if (pdu_read(pdu, val, sizeof(*val))) {
+				__le32 le_val;
+				if (pdu_read(pdu, &le_val, sizeof(le_val))) {
 					errcode = -EFAULT;
 					break;
 				}
-				*val = cpu_to_le32(*val);
+				*val = le32_to_cpu(le_val);
 			}
 			break;
 		case 'q':{
 				int64_t *val = va_arg(ap, int64_t *);
-				if (pdu_read(pdu, val, sizeof(*val))) {
+				__le64 le_val;
+				if (pdu_read(pdu, &le_val, sizeof(le_val))) {
 					errcode = -EFAULT;
 					break;
 				}
-				*val = cpu_to_le64(*val);
+				*val = le64_to_cpu(le_val);
 			}
 			break;
 		case 's':{
@@ -362,19 +366,19 @@ p9pdu_vwritef(struct p9_fcall *pdu, int optional, const char *fmt, va_list ap)
 			}
 			break;
 		case 'w':{
-				int16_t val = va_arg(ap, int);
+				__le16 val = cpu_to_le16(va_arg(ap, int));
 				if (pdu_write(pdu, &val, sizeof(val)))
 					errcode = -EFAULT;
 			}
 			break;
 		case 'd':{
-				int32_t val = va_arg(ap, int32_t);
+				__le32 val = cpu_to_le32(va_arg(ap, int32_t));
 				if (pdu_write(pdu, &val, sizeof(val)))
 					errcode = -EFAULT;
 			}
 			break;
 		case 'q':{
-				int64_t val = va_arg(ap, int64_t);
+				__le64 val = cpu_to_le64(va_arg(ap, int64_t));
 				if (pdu_write(pdu, &val, sizeof(val)))
 					errcode = -EFAULT;
 			}
-- 
1.5.6.3

