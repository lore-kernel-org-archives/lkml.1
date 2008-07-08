Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbYGHRH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbYGHRH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYGHRHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:07:50 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYGHRHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:07:49 -0400
Message-Id: <20080708170045.990097000@sipsolutions.net>
References: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC 06/11] remove CONFIG_KMOD from fs
Content-Disposition: inline; filename=config-kmod-remove-fs.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just always compile the code when the kernel is modular.
load_nls could be converted to try_then_request_module
but would lose the printk in that case.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 fs/char_dev.c     |    3 ---
 fs/exec.c         |    9 +++------
 fs/nls/nls_base.c |    6 +-----
 3 files changed, 4 insertions(+), 14 deletions(-)

--- everything.orig/fs/char_dev.c	2008-07-08 18:32:40.000000000 +0200
+++ everything/fs/char_dev.c	2008-07-08 18:33:54.000000000 +0200
@@ -22,9 +22,6 @@
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
 #include "internal.h"
 
 /*
--- everything.orig/fs/exec.c	2008-07-08 18:32:40.000000000 +0200
+++ everything/fs/exec.c	2008-07-08 18:33:54.000000000 +0200
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
--- everything.orig/fs/nls/nls_base.c	2008-07-08 18:32:40.000000000 +0200
+++ everything/fs/nls/nls_base.c	2008-07-08 18:34:44.000000000 +0200
@@ -13,9 +13,7 @@
 #include <linux/nls.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 #include <linux/spinlock.h>
 
 static struct nls_table default_table;
@@ -216,15 +214,13 @@ static struct nls_table *find_nls(char *
 struct nls_table *load_nls(char *charset)
 {
 	struct nls_table *nls;
-#ifdef CONFIG_KMOD
 	int ret;
-#endif
 
 	nls = find_nls(charset);
 	if (nls)
 		return nls;
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	ret = request_module("nls_%s", charset);
 	if (ret != 0) {
 		printk("Unable to load NLS charset %s\n", charset);

-- 

