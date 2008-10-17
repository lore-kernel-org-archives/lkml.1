Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYJPLMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYJPLMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbYJPLMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:12:15 -0400
Received: from ozlabs.org ([203.10.76.45]:46637 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYJPLMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:12:15 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu Oct 16 22:10:38 EST 2008
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] remove CONFIG_KMOD from fs
Cc: Johannes Berg <johannes@sipsolutions.net>
Message-Id: <20081016111213.57575DDFA2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

Just always compile the code when the kernel is modular.
Convert load_nls to use try_then_request_module to tidy
up the code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 fs/char_dev.c     |    3 ---
 fs/exec.c         |    9 +++------
 fs/nls/nls_base.c |   21 +--------------------
 3 files changed, 4 insertions(+), 29 deletions(-)

diff -r 544fa53943a0 fs/char_dev.c
--- a/fs/char_dev.c	Mon Aug 25 14:27:33 2008 +1000
+++ b/fs/char_dev.c	Mon Aug 25 14:27:58 2008 +1000
@@ -22,9 +22,6 @@
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
 
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
 #include "internal.h"
 
 /*
diff -r 544fa53943a0 fs/exec.c
--- a/fs/exec.c	Mon Aug 25 14:27:33 2008 +1000
+++ b/fs/exec.c	Mon Aug 25 14:27:58 2008 +1000
@@ -50,14 +50,11 @@
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
 #include <linux/tracehook.h>
+#include <linux/kmod.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
-
-#ifdef CONFIG_KMOD
-#include <linux/kmod.h>
-#endif
 
 #ifdef __alpha__
 /* for /sbin/loader handling in search_binary_handler() */
@@ -1247,8 +1244,8 @@ int search_binary_handler(struct linux_b
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
diff -r 544fa53943a0 fs/nls/nls_base.c
--- a/fs/nls/nls_base.c	Mon Aug 25 14:27:33 2008 +1000
+++ b/fs/nls/nls_base.c	Mon Aug 25 14:27:58 2008 +1000
@@ -13,9 +13,7 @@
 #include <linux/nls.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#ifdef CONFIG_KMOD
 #include <linux/kmod.h>
-#endif
 #include <linux/spinlock.h>
 
 static struct nls_table default_table;
@@ -215,24 +213,7 @@ static struct nls_table *find_nls(char *
 
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
+	return try_then_request_module(find_nls(charset), "nls_%s", charset);
 }
 
 void unload_nls(struct nls_table *nls)

