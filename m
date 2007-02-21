Return-Path: <linux-kernel-owner+w=401wt.eu-S1422752AbXBUSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422752AbXBUSNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422755AbXBUSNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:13:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:54568 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422754AbXBUSNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:13:37 -0500
Subject: [PATCH 1/6] KVM: Add internal filesystem for generating inodes
From: Avi Kivity <avi@qumranet.com>
Date: Wed, 21 Feb 2007 18:13:35 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45DC8B6E.5050205@qumranet.com>
In-Reply-To: <45DC8B6E.5050205@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <20070221181335.9651025016D@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The kvmfs inodes will represent virtual machines and vcpus, as necessary,
reducing cacheline bouncing due to inodes and filps being shared.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 0df0eeb..c01252e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -36,6 +36,8 @@
 #include <asm/desc.h>
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
 
 #include "x86_emulate.h"
 #include "segment_descriptor.h"
@@ -72,6 +74,9 @@ static struct kvm_stats_debugfs_item {
 
 static struct dentry *debugfs_dir;
 
+#define KVMFS_MAGIC 0x19700426
+struct vfsmount *kvmfs_mnt;
+
 #define MAX_IO_MSRS 256
 
 #define CR0_RESEVED_BITS 0xffffffff1ffaffc0ULL
@@ -2252,6 +2257,18 @@ static struct sys_device kvm_sysdev = {
 
 hpa_t bad_page_address;
 
+static int kvmfs_get_sb(struct file_system_type *fs_type, int flags,
+			const char *dev_name, void *data, struct vfsmount *mnt)
+{
+	return get_sb_pseudo(fs_type, "kvm:", NULL, KVMFS_MAGIC, mnt);
+}
+
+static struct file_system_type kvm_fs_type = {
+	.name		= "kvmfs",
+	.get_sb		= kvmfs_get_sb,
+	.kill_sb	= kill_anon_super,
+};
+
 int kvm_init_arch(struct kvm_arch_ops *ops, struct module *module)
 {
 	int r;
@@ -2328,8 +2345,16 @@ void kvm_exit_arch(void)
 static __init int kvm_init(void)
 {
 	static struct page *bad_page;
-	int r = 0;
+	int r;
+
+	r = register_filesystem(&kvm_fs_type);
+	if (r)
+		goto out3;
 
+	kvmfs_mnt = kern_mount(&kvm_fs_type);
+	r = PTR_ERR(kvmfs_mnt);
+	if (IS_ERR(kvmfs_mnt))
+		goto out2;
 	kvm_init_debug();
 
 	kvm_init_msr_list();
@@ -2346,6 +2371,10 @@ static __init int kvm_init(void)
 
 out:
 	kvm_exit_debug();
+	mntput(kvmfs_mnt);
+out2:
+	unregister_filesystem(&kvm_fs_type);
+out3:
 	return r;
 }
 
@@ -2353,6 +2382,8 @@ static __exit void kvm_exit(void)
 {
 	kvm_exit_debug();
 	__free_page(pfn_to_page(bad_page_address >> PAGE_SHIFT));
+	mntput(kvmfs_mnt);
+	unregister_filesystem(&kvm_fs_type);
 }
 
 module_init(kvm_init)
