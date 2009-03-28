Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZC1NYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZC1NYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 09:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZC1NXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 09:23:43 -0400
Received: from ozlabs.org ([203.10.76.45]:52789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZC1NXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 09:23:42 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 28 Mar 2009 23:53:38 +1030
Subject: [PATCH 2/5] module_param: split perm field into flags and perm
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903282353.38428.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Rather than hack KPARAM_KMALLOCED into the perm field, separate it out.
Since the perm field was 32 bits and only needs 16, we don't add bloat.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h |    8 ++++++--
 kernel/params.c             |    9 +++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -36,9 +36,13 @@ typedef int (*param_set_fn)(const char *
 /* Returns length written or -errno.  Buffer is 4k (ie. be short!) */
 typedef int (*param_get_fn)(char *buffer, struct kernel_param *kp);
 
+/* Flag bits for kernel_param.flags */
+#define KPARAM_KMALLOCED	1
+
 struct kernel_param {
 	const char *name;
-	unsigned int perm;
+	u16 perm;
+	u16 flags;
 	param_set_fn set;
 	param_get_fn get;
 	union {
@@ -88,7 +92,7 @@ struct kparam_array
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, perm, set, get, { arg } }
+	= { __param_str_##name, perm, 0, set, get, { arg } }
 
 #define module_param_call(name, set, get, arg, perm)			      \
 	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -23,9 +23,6 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
-
-/* We abuse the high bits of "perm" to record whether we kmalloc'ed. */
-#define KPARAM_KMALLOCED	0x80000000
 
 #if 0
 #define DEBUGP printk
@@ -220,13 +217,13 @@ int param_set_charp(const char *val, str
 		return -ENOSPC;
 	}
 
-	if (kp->perm & KPARAM_KMALLOCED)
+	if (kp->flags & KPARAM_KMALLOCED)
 		kfree(*(char **)kp->arg);
 
 	/* This is a hack.  We can't need to strdup in early boot, and we
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
-		kp->perm |= KPARAM_KMALLOCED;
+		kp->flags |= KPARAM_KMALLOCED;
 		*(char **)kp->arg = kstrdup(val, GFP_KERNEL);
 		if (!kp->arg)
 			return -ENOMEM;
@@ -591,7 +588,7 @@ void destroy_params(const struct kernel_
 	unsigned int i;
 
 	for (i = 0; i < num; i++)
-		if (params[i].perm & KPARAM_KMALLOCED)
+		if (params[i].flags & KPARAM_KMALLOCED)
 			kfree(*(char **)params[i].arg);
 }
 

