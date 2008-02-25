Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYBYSOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYBYSOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYBYSOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:14:24 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:25718 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbYBYSOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KUTPUGW6lF+MlSPhUbj5b+hXi+0Q3t6VzN75Tj6PG+OPCPC2baVYWyl+FjHcfJjX1NIgMrc5rz9gRO+xCVGZ+7gixZ3MJHSUlyW2TPLs/Ejf6bE1zPT9ROlT3bWyNr6JWFjLGKZCHdETHNULMNv+Hocsm+t20pOLNMxFBQ8YztY=
Subject: [PATCH] fbcon: replace mono_col macro with static inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 10:13:57 -0800
Message-Id: <1203963237.5582.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __u32 for max_len to match the declaration of length in the
struct fb_bitfield.

Suppresses sparse shadowed variable warnings from the nested max()
macros:
drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here
drivers/video/console/fbcon.h:130:8: warning: symbol '_x' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here
drivers/video/console/fbcon.h:130:8: warning: symbol '_y' shadows an earlier one
drivers/video/console/fbcon.h:130:8: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/console/fbcon.h |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/video/console/fbcon.h b/drivers/video/console/fbcon.h
index 3706307..51a6bf4 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -104,10 +104,14 @@ struct fbcon_ops {
 #define attr_blink(s) \
 	((s) & 0x8000)
 	
-#define mono_col(info)							\
-	(~(0xfff << (max((info)->var.green.length,			\
-			 max((info)->var.red.length,			\
-			     (info)->var.blue.length)))) & 0xff)
+
+static inline int mono_col(struct fb_info *info)
+{
+	__u32 max_len;
+	max_len = max(info->var.green.length, info->var.red.length);
+	max_len = max(info->var.blue.length, max_len);
+	return ~(0xfff << (max_len & 0xff));
+}
 
 static inline int attr_col_ec(int shift, struct vc_data *vc,
 			      struct fb_info *info, int is_fg)
-- 
1.5.4.3.328.gcaed



