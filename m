Return-Path: <linux-kernel-owner+w=401wt.eu-S1030868AbXAZQ4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030868AbXAZQ4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030887AbXAZQ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:56:09 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25728 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030868AbXAZQ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:56:02 -0500
Date: Fri, 26 Jan 2007 17:55:58 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: holzheu@de.ibm.com
Subject: [S390] Hypervisor filesystem (s390_hypfs) for z/VM
Message-ID: <20070126165558.GA11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

[S390] Hypervisor filesystem (s390_hypfs) for z/VM

This is an extension of the already existing hypfs for LPAR (DIAG 204).
Data returned by DIAG 2fc is exported using the s390_hypfs when Linux
is running under z/VM. Information about cpus and memory is provided.
Data is put into different virtual files which can be accessed from user
space. All values are represented as ASCII strings

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/hypfs/Makefile     |    2 
 arch/s390/hypfs/hypfs.h      |    9 +
 arch/s390/hypfs/hypfs_diag.h |   16 --
 arch/s390/hypfs/hypfs_vm.c   |  231 +++++++++++++++++++++++++++++++++++++++++++
 arch/s390/hypfs/inode.c      |   31 +++--
 5 files changed, 262 insertions(+), 27 deletions(-)

diff -urpN linux-2.6/arch/s390/hypfs/hypfs_diag.h linux-2.6-patched/arch/s390/hypfs/hypfs_diag.h
--- linux-2.6/arch/s390/hypfs/hypfs_diag.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/hypfs/hypfs_diag.h	1970-01-01 01:00:00.000000000 +0100
@@ -1,16 +0,0 @@
-/*
- *  arch/s390/hypfs_diag.h
- *    Hypervisor filesystem for Linux on s390.
- *
- *    Copyright (C) IBM Corp. 2006
- *    Author(s): Michael Holzheu <holzheu@de.ibm.com>
- */
-
-#ifndef _HYPFS_DIAG_H_
-#define _HYPFS_DIAG_H_
-
-extern int hypfs_diag_init(void);
-extern void hypfs_diag_exit(void);
-extern int hypfs_diag_create_files(struct super_block *sb, struct dentry *root);
-
-#endif /* _HYPFS_DIAG_H_ */
diff -urpN linux-2.6/arch/s390/hypfs/hypfs.h linux-2.6-patched/arch/s390/hypfs/hypfs.h
--- linux-2.6/arch/s390/hypfs/hypfs.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/hypfs/hypfs.h	2007-01-26 17:29:36.000000000 +0100
@@ -27,4 +27,13 @@ extern struct dentry *hypfs_create_str(s
 				       struct dentry *dir, const char *name,
 				       char *string);
 
+/* LPAR Hypervisor */
+extern int hypfs_diag_init(void);
+extern void hypfs_diag_exit(void);
+extern int hypfs_diag_create_files(struct super_block *sb, struct dentry *root);
+
+/* VM Hypervisor */
+extern int hypfs_vm_init(void);
+extern int hypfs_vm_create_files(struct super_block *sb, struct dentry *root);
+
 #endif /* _HYPFS_H_ */
diff -urpN linux-2.6/arch/s390/hypfs/hypfs_vm.c linux-2.6-patched/arch/s390/hypfs/hypfs_vm.c
--- linux-2.6/arch/s390/hypfs/hypfs_vm.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/hypfs/hypfs_vm.c	2007-01-26 17:29:36.000000000 +0100
@@ -0,0 +1,231 @@
+/*
+ *    Hypervisor filesystem for Linux on s390. z/VM implementation.
+ *
+ *    Copyright (C) IBM Corp. 2006
+ *    Author(s): Michael Holzheu <holzheu@de.ibm.com>
+ */
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/vmalloc.h>
+#include <asm/ebcdic.h>
+#include "hypfs.h"
+
+#define NAME_LEN 8
+
+static char local_guest[] = "        ";
+static char all_guests[] = "*       ";
+static char *guest_query;
+
+struct diag2fc_data {
+	__u32 version;
+	__u32 flags;
+	__u64 used_cpu;
+	__u64 el_time;
+	__u64 mem_min_kb;
+	__u64 mem_max_kb;
+	__u64 mem_share_kb;
+	__u64 mem_used_kb;
+	__u32 pcpus;
+	__u32 lcpus;
+	__u32 vcpus;
+	__u32 cpu_min;
+	__u32 cpu_max;
+	__u32 cpu_shares;
+	__u32 cpu_use_samp;
+	__u32 cpu_delay_samp;
+	__u32 page_wait_samp;
+	__u32 idle_samp;
+	__u32 other_samp;
+	__u32 total_samp;
+	char  guest_name[NAME_LEN];
+};
+
+struct diag2fc_parm_list {
+	char userid[NAME_LEN];
+	char aci_grp[NAME_LEN];
+	__u64 addr;
+	__u32 size;
+	__u32 fmt;
+};
+
+static int diag2fc(int size, char* query, void *addr)
+{
+	unsigned long residual_cnt;
+	unsigned long rc;
+	struct diag2fc_parm_list parm_list;
+
+	memcpy(parm_list.userid, query, NAME_LEN);
+	ASCEBC(parm_list.userid, NAME_LEN);
+	parm_list.addr = (unsigned long) addr ;
+	parm_list.size = size;
+	parm_list.fmt = 0x02;
+	memset(parm_list.aci_grp, 0x40, NAME_LEN);
+	rc = -1;
+
+	asm volatile(
+		"	diag    %0,%1,0x2fc\n"
+		"0:\n"
+		EX_TABLE(0b,0b)
+		: "=d" (residual_cnt), "+d" (rc) : "0" (&parm_list) : "memory");
+
+	if ((rc != 0 ) && (rc != -2))
+		return rc;
+	else
+		return -residual_cnt;
+}
+
+static struct diag2fc_data *diag2fc_store(char *query, int *count)
+{
+	int size;
+	struct diag2fc_data *data;
+
+	do {
+		size = diag2fc(0, query, NULL);
+		if (size < 0)
+			return ERR_PTR(-EACCES);
+		data = vmalloc(size);
+		if (!data)
+			return ERR_PTR(-ENOMEM);
+		if (diag2fc(size, query, data) == 0)
+			break;
+		vfree(data);
+	} while (1);
+	*count = (size / sizeof(*data));
+
+	return data;
+}
+
+static void diag2fc_free(void *data)
+{
+	vfree(data);
+}
+
+#define ATTRIBUTE(sb, dir, name, member) \
+do { \
+	void *rc; \
+	rc = hypfs_create_u64(sb, dir, name, member); \
+	if (IS_ERR(rc)) \
+		return PTR_ERR(rc); \
+} while(0)
+
+static int hpyfs_vm_create_guest(struct super_block *sb,
+				 struct dentry *systems_dir,
+				 struct diag2fc_data *data)
+{
+	char guest_name[NAME_LEN + 1] = {};
+	struct dentry *guest_dir, *cpus_dir, *samples_dir, *mem_dir;
+	int dedicated_flag, capped_value;
+
+	capped_value = (data->flags & 0x00000006) >> 1;
+	dedicated_flag = (data->flags & 0x00000008) >> 3;
+
+	/* guest dir */
+	memcpy(guest_name, data->guest_name, NAME_LEN);
+	EBCASC(guest_name, NAME_LEN);
+	strstrip(guest_name);
+	guest_dir = hypfs_mkdir(sb, systems_dir, guest_name);
+	if (IS_ERR(guest_dir))
+		return PTR_ERR(guest_dir);
+	ATTRIBUTE(sb, guest_dir, "onlinetime_us", data->el_time);
+
+	/* logical cpu information */
+	cpus_dir = hypfs_mkdir(sb, guest_dir, "cpus");
+	if (IS_ERR(cpus_dir))
+		return PTR_ERR(cpus_dir);
+	ATTRIBUTE(sb, cpus_dir, "cputime_us", data->used_cpu);
+	ATTRIBUTE(sb, cpus_dir, "capped", capped_value);
+	ATTRIBUTE(sb, cpus_dir, "dedicated", dedicated_flag);
+	ATTRIBUTE(sb, cpus_dir, "count", data->vcpus);
+	ATTRIBUTE(sb, cpus_dir, "weight_min", data->cpu_min);
+	ATTRIBUTE(sb, cpus_dir, "weight_max", data->cpu_max);
+	ATTRIBUTE(sb, cpus_dir, "weight_cur", data->cpu_shares);
+
+	/* memory information */
+	mem_dir = hypfs_mkdir(sb, guest_dir, "mem");
+	if (IS_ERR(mem_dir))
+		return PTR_ERR(mem_dir);
+	ATTRIBUTE(sb, mem_dir, "min_KiB", data->mem_min_kb);
+	ATTRIBUTE(sb, mem_dir, "max_KiB", data->mem_max_kb);
+	ATTRIBUTE(sb, mem_dir, "used_KiB", data->mem_used_kb);
+	ATTRIBUTE(sb, mem_dir, "share_KiB", data->mem_share_kb);
+
+	/* samples */
+	samples_dir = hypfs_mkdir(sb, guest_dir, "samples");
+	if (IS_ERR(samples_dir))
+		return PTR_ERR(samples_dir);
+	ATTRIBUTE(sb, samples_dir, "cpu_using", data->cpu_use_samp);
+	ATTRIBUTE(sb, samples_dir, "cpu_delay", data->cpu_delay_samp);
+	ATTRIBUTE(sb, samples_dir, "mem_delay", data->page_wait_samp);
+	ATTRIBUTE(sb, samples_dir, "idle", data->idle_samp);
+	ATTRIBUTE(sb, samples_dir, "other", data->other_samp);
+	ATTRIBUTE(sb, samples_dir, "total", data->total_samp);
+	return 0;
+}
+
+int hypfs_vm_create_files(struct super_block *sb, struct dentry *root)
+{
+	struct dentry *dir, *file;
+	struct diag2fc_data *data;
+	int rc, i, count = 0;
+
+	data = diag2fc_store(guest_query, &count);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	/* Hpervisor Info */
+	dir = hypfs_mkdir(sb, root, "hyp");
+	if (IS_ERR(dir)) {
+		rc = PTR_ERR(dir);
+		goto failed;
+	}
+	file = hypfs_create_str(sb, dir, "type", "z/VM Hypervisor");
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		goto failed;
+	}
+
+	/* physical cpus */
+	dir = hypfs_mkdir(sb, root, "cpus");
+	if (IS_ERR(dir)) {
+		rc = PTR_ERR(dir);
+		goto failed;
+	}
+	file = hypfs_create_u64(sb, dir, "count", data->lcpus);
+	if (IS_ERR(file)) {
+		rc = PTR_ERR(file);
+		goto failed;
+	}
+
+	/* guests */
+	dir = hypfs_mkdir(sb, root, "systems");
+	if (IS_ERR(dir)) {
+		rc = PTR_ERR(dir);
+		goto failed;
+	}
+
+	for (i = 0; i < count; i++) {
+		rc = hpyfs_vm_create_guest(sb, dir, &(data[i]));
+		if (rc)
+			goto failed;
+	}
+	diag2fc_free(data);
+	return 0;
+
+failed:
+	diag2fc_free(data);
+	return rc;
+}
+
+int hypfs_vm_init(void)
+{
+	if (diag2fc(0, all_guests, NULL) > 0)
+		guest_query = all_guests;
+	else if (diag2fc(0, local_guest, NULL) > 0)
+		guest_query = local_guest;
+	else
+		return -EACCES;
+
+	return 0;
+}
diff -urpN linux-2.6/arch/s390/hypfs/inode.c linux-2.6-patched/arch/s390/hypfs/inode.c
--- linux-2.6/arch/s390/hypfs/inode.c	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/hypfs/inode.c	2007-01-26 17:29:36.000000000 +0100
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <asm/ebcdic.h>
 #include "hypfs.h"
-#include "hypfs_diag.h"
 
 #define HYPFS_MAGIC 0x687970	/* ASCII 'hyp' */
 #define TMP_SIZE 64		/* size of temporary buffers */
@@ -192,7 +191,10 @@ static ssize_t hypfs_aio_write(struct ki
 		goto out;
 	}
 	hypfs_delete_tree(sb->s_root);
-	rc = hypfs_diag_create_files(sb, sb->s_root);
+	if (MACHINE_IS_VM)
+		rc = hypfs_vm_create_files(sb, sb->s_root);
+	else
+		rc = hypfs_diag_create_files(sb, sb->s_root);
 	if (rc) {
 		printk(KERN_ERR "hypfs: Update failed\n");
 		hypfs_delete_tree(sb->s_root);
@@ -289,7 +291,10 @@ static int hypfs_fill_super(struct super
 		rc = -ENOMEM;
 		goto err_alloc;
 	}
-	rc = hypfs_diag_create_files(sb, root_dentry);
+	if (MACHINE_IS_VM)
+		rc = hypfs_vm_create_files(sb, root_dentry);
+	else
+		rc = hypfs_diag_create_files(sb, root_dentry);
 	if (rc)
 		goto err_tree;
 	sbi->update_file = hypfs_create_update_file(sb, root_dentry);
@@ -462,11 +467,15 @@ static int __init hypfs_init(void)
 {
 	int rc;
 
-	if (MACHINE_IS_VM)
-		return -ENODATA;
-	if (hypfs_diag_init()) {
-		rc = -ENODATA;
-		goto fail_diag;
+	if (MACHINE_IS_VM) {
+		if (hypfs_vm_init())
+			/* no diag 2fc, just exit */
+			return -ENODATA;
+	} else {
+		if (hypfs_diag_init()) {
+			rc = -ENODATA;
+			goto fail_diag;
+		}
 	}
 	kset_set_kset_s(&s390_subsys, hypervisor_subsys);
 	rc = subsystem_register(&s390_subsys);
@@ -480,7 +489,8 @@ static int __init hypfs_init(void)
 fail_filesystem:
 	subsystem_unregister(&s390_subsys);
 fail_sysfs:
-	hypfs_diag_exit();
+	if (!MACHINE_IS_VM)
+		hypfs_diag_exit();
 fail_diag:
 	printk(KERN_ERR "hypfs: Initialization failed with rc = %i.\n", rc);
 	return rc;
@@ -488,7 +498,8 @@ fail_diag:
 
 static void __exit hypfs_exit(void)
 {
-	hypfs_diag_exit();
+	if (!MACHINE_IS_VM)
+		hypfs_diag_exit();
 	unregister_filesystem(&hypfs_type);
 	subsystem_unregister(&s390_subsys);
 }
diff -urpN linux-2.6/arch/s390/hypfs/Makefile linux-2.6-patched/arch/s390/hypfs/Makefile
--- linux-2.6/arch/s390/hypfs/Makefile	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/hypfs/Makefile	2007-01-26 17:29:36.000000000 +0100
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_S390_HYPFS_FS) += s390_hypfs.o
 
-s390_hypfs-objs := inode.o hypfs_diag.o
+s390_hypfs-objs := inode.o hypfs_diag.o hypfs_vm.o
