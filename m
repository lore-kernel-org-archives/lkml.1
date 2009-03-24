Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZCXJ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZCXJ7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbZCXJ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:59:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:55703 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbZCXJ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:59:26 -0400
Subject: [PATCH 2/2] fs: don't include <linux/gfp.h> to fix
	headers-export-check
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 11:59:23 +0200
Message-Id: <1237888763.25315.70.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix build

This patch fixes a headers-export-check failure:

  /home/mingo/tip/usr/include/linux/bsg.h:11: found __[us]{8,16,32,64} type without #include <linux/types.h>
  /home/mingo/tip/usr/include/linux/fs.h:11: included file 'linux/gfp.h' is not exported
  make[3]: *** [/home/mingo/tip/usr/include/linux/.check] Error 1
  make[2]: *** [linux] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/fs.h |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index add95da..11fdc57 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -8,7 +8,6 @@
 
 #include <linux/limits.h>
 #include <linux/ioctl.h>
-#include <linux/gfp.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
@@ -2233,15 +2232,12 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 
 
 #ifdef CONFIG_SECURITY
-static inline char *alloc_secdata(void)
-{
-	return (char *)get_zeroed_page(GFP_KERNEL);
-}
-
-static inline void free_secdata(void *secdata)
-{
-	free_page((unsigned long)secdata);
-}
+/*
+ * These need to be macros because we cannot include <linux/gfp.h> in this
+ * header file.
+ */
+#define alloc_secdata()       (char *)get_zeroed_page(GFP_KERNEL)
+#define free_secdata(secdata) free_page((unsigned long) secdata)
 #else
 static inline char *alloc_secdata(void)
 {
-- 
1.5.4.3



