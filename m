Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbYGIMtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbYGIMtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYGIMtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:49:23 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbYGIMtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:49:22 -0400
Message-Id: <20080709082903.559381000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 06/11] remove CONFIG_KMOD from fs
Content-Disposition: inline; filename=008-config-kmod-remove-fs.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just always compile the code when the kernel is modular.
Convert load_nls to use try_then_request_module to tidy
up the code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: fix "unused variable" warning pointed out by Adrian Bunk
    by just using try_then_request_module() for load_nls().

 fs/char_dev.c     |    3 ---
 fs/exec.c         |    9 +++------
 fs/nls/nls_base.c |   23 +++--------------------
 3 files changed, 6 insertions(+), 29 deletions(-)

--- everything.orig/fs/char_dev.c	2008-07-08 22:09:18.000000000 +0200
+++ everything/fs/char_dev.c	2008-07-08 22:10:41.000000000 +0200
@@ -22,9 +22,6 @@
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
 #include "internal.h"
 
 /*
--- everything.orig/fs/exec.c	2008-07-08 22:09:18.000000000 +0200
+++ everything/fs/exec.c	2008-07-08 22:10:41.000000000 +0200
@@ -51,15 +51,12 @@
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/kmod.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
-
 #ifdef __alpha__
 /* for /sbin/loader handling in search_binary_handler() */
 #include <linux/a.out.h>
@@ -1239,8 +1236,8 @@ int search_binary_handler(struct linux_b
 		read_unlock(&binfmt_lock);
 		if (retval != -ENOEXEC || bprm->mm == NULL) {
 			break;
-#ifdef CONFIG_KMOD
-		}else{
+#ifdef CONFIG_MODULES
+		} else {
 #define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 			if (printable(bprm->buf[0]) &&
 			    printable(bprm->buf[1]) &&
--- everything.orig/fs/nls/nls_base.c	2008-07-08 22:09:18.000000000 +0200
+++ everything/fs/nls/nls_base.c	2008-07-08 22:11:57.000000000 +0200
@@ -13,9 +13,7 @@
 #include <linux/nls.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 #include <linux/spinlock.h>
 
 static struct nls_table default_table;
@@ -215,24 +213,9 @@ static struct nls_table *find_nls(char *
 
 struct nls_table *load_nls(char *charset)
 {
-	struct nls_table *nls;
-#ifdef CONFIG_KMOD
-	int ret;
-#endif
-
-	nls = find_nls(charset);
-	if (nls)
-		return nls;
-
-#ifdef CONFIG_KMOD
-	ret = request_module("nls_%s", charset);
-	if (ret != 0) {
-		printk("Unable to load NLS charset %s\n", charset);
-		return NULL;
-	}
-	nls = find_nls(charset);
-#endif
-	return nls;
+	return try_then_request_module(
+			find_nls(charset),
+			"nls_%s", charset);
 }
 
 void unload_nls(struct nls_table *nls)

-- 
