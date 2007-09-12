Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbXILHrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbXILHrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761233AbXILHnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:43:51 -0400
Received: from ozlabs.org ([203.10.76.45]:46507 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839AbXILHnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:43:49 -0400
To: <linuxppc-dev@ozlabs.org>
Cc: Jeremy Kerr <jk@ozlabs.org>, <linux-kernel@vger.kernel.org>
Message-Id: <5d0eaf2dbfd1046983f3e6f96ff6b8d967ec3801.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 11/15] Combine spufs_coredump_calls with spufs_calls
Date: Wed, 12 Sep 2007 17:43:48 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Because spufs might be built as a module, we can't have other parts of the
kernel calling directly into it, we need stub routines that check first if the
module is loaded.

Currently we have two structures which hold callbacks for these stubs, the
syscalls are in spufs_calls and the coredump calls are in spufs_coredump_calls.
In both cases the logic for registering/unregistering is essentially the same,
so we can simplify things by combining the two.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/platforms/cell/Makefile         |    2 +-
 arch/powerpc/platforms/cell/spu_coredump.c   |   83 --------------------------
 arch/powerpc/platforms/cell/spu_syscalls.c   |   30 +++++++++
 arch/powerpc/platforms/cell/spufs/coredump.c |   10 +---
 arch/powerpc/platforms/cell/spufs/inode.c    |    6 --
 arch/powerpc/platforms/cell/spufs/spufs.h    |    4 +
 arch/powerpc/platforms/cell/spufs/syscalls.c |    2 +
 include/asm-powerpc/spu.h                    |   12 +---
 8 files changed, 41 insertions(+), 108 deletions(-)

diff --git a/arch/powerpc/platforms/cell/Makefile b/arch/powerpc/platforms/cell/Makefile
index 40f78e9..61d12f1 100644
--- a/arch/powerpc/platforms/cell/Makefile
+++ b/arch/powerpc/platforms/cell/Makefile
@@ -19,7 +19,7 @@ spu-manage-$(CONFIG_PPC_CELLEB)		+= spu_manage.o
 spu-manage-$(CONFIG_PPC_CELL_NATIVE)	+= spu_manage.o
 
 obj-$(CONFIG_SPU_BASE)			+= spu_callbacks.o spu_base.o \
-					   spu_coredump.o spu_syscalls.o \
+					   spu_syscalls.o \
 					   $(spu-priv1-y) \
 					   $(spu-manage-y) \
 					   spufs/
diff --git a/arch/powerpc/platforms/cell/spu_coredump.c b/arch/powerpc/platforms/cell/spu_coredump.c
deleted file mode 100644
index 656a8c5..0000000
--- a/arch/powerpc/platforms/cell/spu_coredump.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * SPU core dump code
- *
- * (C) Copyright 2006 IBM Corp.
- *
- * Author: Dwayne Grant McConnell <decimal@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#include <linux/file.h>
-#include <linux/module.h>
-#include <linux/syscalls.h>
-
-#include <asm/spu.h>
-
-static struct spu_coredump_calls *spu_coredump_calls;
-static DEFINE_MUTEX(spu_coredump_mutex);
-
-int arch_notes_size(void)
-{
-	int ret;
-
-	mutex_lock(&spu_coredump_mutex);
-
-	if (spu_coredump_calls && try_module_get(spu_coredump_calls->owner)) {
-		ret = spu_coredump_calls->arch_notes_size();
-		module_put(spu_coredump_calls->owner);
-	} else {
-		ret = 0;
-	}
-
-	mutex_unlock(&spu_coredump_mutex);
-
-	return ret;
-}
-
-void arch_write_notes(struct file *file)
-{
-	mutex_lock(&spu_coredump_mutex);
-	if (spu_coredump_calls && try_module_get(spu_coredump_calls->owner)) {
-		spu_coredump_calls->arch_write_notes(file);
-		module_put(spu_coredump_calls->owner);
-	}
-	mutex_unlock(&spu_coredump_mutex);
-}
-
-int register_arch_coredump_calls(struct spu_coredump_calls *calls)
-{
-	int ret = 0;
-
-
-	mutex_lock(&spu_coredump_mutex);
-	if (spu_coredump_calls)
-		ret = -EBUSY;
-	else
-		spu_coredump_calls = calls;
-	mutex_unlock(&spu_coredump_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(register_arch_coredump_calls);
-
-void unregister_arch_coredump_calls(struct spu_coredump_calls *calls)
-{
-	BUG_ON(spu_coredump_calls != calls);
-
-	mutex_lock(&spu_coredump_mutex);
-	spu_coredump_calls = NULL;
-	mutex_unlock(&spu_coredump_mutex);
-}
-EXPORT_SYMBOL_GPL(unregister_arch_coredump_calls);
diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
index 76815c5..cf00251 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -2,6 +2,7 @@
  * SPU file system -- system call stubs
  *
  * (C) Copyright IBM Deutschland Entwicklung GmbH 2005
+ * (C) Copyright 2006-2007, IBM Corporation
  *
  * Author: Arnd Bergmann <arndb@de.ibm.com>
  *
@@ -108,6 +109,35 @@ asmlinkage long sys_spu_run(int fd, __u32 __user *unpc, __u32 __user *ustatus)
 	return ret;
 }
 
+int arch_notes_size(void)
+{
+	struct spufs_calls *calls;
+	int ret;
+
+	calls = spufs_calls_get();
+	if (!calls)
+		return 0;
+
+	ret = calls->coredump_extra_notes_size();
+
+	spufs_calls_put(calls);
+
+	return ret;
+}
+
+void arch_write_notes(struct file *file)
+{
+	struct spufs_calls *calls;
+
+	calls = spufs_calls_get();
+	if (!calls)
+		return;
+
+	calls->coredump_extra_notes_write(file);
+
+	spufs_calls_put(calls);
+}
+
 int register_spu_syscalls(struct spufs_calls *calls)
 {
 	int ret = 0;
diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 8348d21..7395350 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -122,7 +122,7 @@ static struct spu_context *coredump_next_context(int *fd)
 	return ctx;
 }
 
-static int spufs_arch_notes_size(void)
+int spufs_coredump_extra_notes_size(void)
 {
 	struct spu_context *ctx;
 	int size = 0, rc, fd;
@@ -185,7 +185,7 @@ out:
 	free_page((unsigned long)buf);
 }
 
-static void spufs_arch_write_notes(struct file *file)
+void spufs_coredump_extra_notes_write(struct file *file)
 {
 	struct spu_context *ctx;
 	int fd, j;
@@ -200,9 +200,3 @@ static void spufs_arch_write_notes(struct file *file)
 		spu_release_saved(ctx);
 	}
 }
-
-struct spu_coredump_calls spufs_coredump_calls = {
-	.arch_notes_size = spufs_arch_notes_size,
-	.arch_write_notes = spufs_arch_write_notes,
-	.owner = THIS_MODULE,
-};
diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index e210a4b..1109874 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -790,16 +790,11 @@ static int __init spufs_init(void)
 	ret = register_spu_syscalls(&spufs_calls);
 	if (ret)
 		goto out_fs;
-	ret = register_arch_coredump_calls(&spufs_coredump_calls);
-	if (ret)
-		goto out_syscalls;
 
 	spufs_init_isolated_loader();
 
 	return 0;
 
-out_syscalls:
-	unregister_spu_syscalls(&spufs_calls);
 out_fs:
 	unregister_filesystem(&spufs_type);
 out_sched:
@@ -815,7 +810,6 @@ static void __exit spufs_exit(void)
 {
 	spu_sched_exit();
 	spufs_exit_isolated_loader();
-	unregister_arch_coredump_calls(&spufs_coredump_calls);
 	unregister_spu_syscalls(&spufs_calls);
 	unregister_filesystem(&spufs_type);
 	kmem_cache_destroy(spufs_inode_cache);
diff --git a/arch/powerpc/platforms/cell/spufs/spufs.h b/arch/powerpc/platforms/cell/spufs/spufs.h
index f869a4b..c7b4e03 100644
--- a/arch/powerpc/platforms/cell/spufs/spufs.h
+++ b/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -204,6 +204,10 @@ extern struct spufs_calls spufs_calls;
 long spufs_run_spu(struct spu_context *ctx, u32 *npc, u32 *status);
 long spufs_create(struct nameidata *nd, unsigned int flags,
 			mode_t mode, struct file *filp);
+/* ELF coredump callbacks for writing SPU ELF notes */
+extern int spufs_coredump_extra_notes_size(void);
+extern void spufs_coredump_extra_notes_write(struct file *file);
+
 extern const struct file_operations spufs_context_fops;
 
 /* gang management */
diff --git a/arch/powerpc/platforms/cell/spufs/syscalls.c b/arch/powerpc/platforms/cell/spufs/syscalls.c
index 22b138d..2c34f71 100644
--- a/arch/powerpc/platforms/cell/spufs/syscalls.c
+++ b/arch/powerpc/platforms/cell/spufs/syscalls.c
@@ -84,5 +84,7 @@ static long do_spu_create(const char __user *pathname, unsigned int flags,
 struct spufs_calls spufs_calls = {
 	.create_thread = do_spu_create,
 	.spu_run = do_spu_run,
+	.coredump_extra_notes_size = spufs_coredump_extra_notes_size,
+	.coredump_extra_notes_write = spufs_coredump_extra_notes_write,
 	.owner = THIS_MODULE,
 };
diff --git a/include/asm-powerpc/spu.h b/include/asm-powerpc/spu.h
index a0f2d28..10c40cd 100644
--- a/include/asm-powerpc/spu.h
+++ b/include/asm-powerpc/spu.h
@@ -244,13 +244,8 @@ struct spufs_calls {
 					struct file *neighbor);
 	long (*spu_run)(struct file *filp, __u32 __user *unpc,
 						__u32 __user *ustatus);
-	struct module *owner;
-};
-
-/* coredump calls implemented in spufs */
-struct spu_coredump_calls {
-	asmlinkage int (*arch_notes_size)(void);
-	asmlinkage void (*arch_write_notes)(struct file *file);
+	int (*coredump_extra_notes_size)(void);
+	void (*coredump_extra_notes_write)(struct file *file);
 	struct module *owner;
 };
 
@@ -277,9 +272,6 @@ struct spu_coredump_calls {
 int register_spu_syscalls(struct spufs_calls *calls);
 void unregister_spu_syscalls(struct spufs_calls *calls);
 
-int register_arch_coredump_calls(struct spu_coredump_calls *calls);
-void unregister_arch_coredump_calls(struct spu_coredump_calls *calls);
-
 int spu_add_sysdev_attr(struct sysdev_attribute *attr);
 void spu_remove_sysdev_attr(struct sysdev_attribute *attr);
 
-- 
1.5.1.3.g7a33b

