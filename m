Return-Path: <linux-kernel-owner+w=401wt.eu-S1754147AbYLVLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbYLVLqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYLVLpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:45:34 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57745 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYLVLpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:45:32 -0500
Message-Id: <20081222114530.063420431@de.ibm.com>
References: <20081222113629.080104676@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 22 Dec 2008 12:36:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 2/2] module: convert to stop_machine_create/destroy.
Content-Disposition: inline; filename=002_module.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The module code relies on a non-failing stop_machine call. So we create
the kstop threads in advance and with that make sure the call won't fail.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/module.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c
+++ linux-2.6/kernel/module.c
@@ -757,8 +757,16 @@ sys_delete_module(const char __user *nam
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	if (mutex_lock_interruptible(&module_mutex) != 0)
-		return -EINTR;
+	/* Create stop_machine threads since free_module relies on
+	 * a non-failing stop_machine call. */
+	ret = stop_machine_create();
+	if (ret)
+		return ret;
+
+	if (mutex_lock_interruptible(&module_mutex) != 0) {
+		ret = -EINTR;
+		goto out_stop;
+	}
 
 	mod = find_module(name);
 	if (!mod) {
@@ -817,6 +825,8 @@ sys_delete_module(const char __user *nam
 
  out:
 	mutex_unlock(&module_mutex);
+out_stop:
+	stop_machine_destroy();
 	return ret;
 }
 
@@ -1865,6 +1875,13 @@ static noinline struct module *load_modu
 	/* vmalloc barfs on "unusual" numbers.  Check here */
 	if (len > 64 * 1024 * 1024 || (hdr = vmalloc(len)) == NULL)
 		return ERR_PTR(-ENOMEM);
+
+	/* Create stop_machine threads since the error path relies on
+	 * a non-failing stop_machine call. */
+	err = stop_machine_create();
+	if (err)
+		goto free_hdr;
+
 	if (copy_from_user(hdr, umod, len) != 0) {
 		err = -EFAULT;
 		goto free_hdr;
@@ -2257,6 +2274,7 @@ static noinline struct module *load_modu
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
+	stop_machine_destroy();
 	/* Done! */
 	return mod;
 
@@ -2279,6 +2297,7 @@ static noinline struct module *load_modu
 	kfree(args);
  free_hdr:
 	vfree(hdr);
+	stop_machine_destroy();
 	return ERR_PTR(err);
 
  truncated:

-- 
