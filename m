Return-Path: <linux-kernel-owner+w=401wt.eu-S1765487AbYAYIO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765487AbYAYIO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761815AbYAYIAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:37 -0500
Received: from ns2.suse.de ([195.135.220.15]:53650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763980AbYAYH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 171/196] Kobject: convert arch/* from kobject_unregister() to kobject_put()
Date: Thu, 24 Jan 2008 23:33:20 -0800
Message-Id: <1201246425-5058-92-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for kobject_unregister() anymore, thanks to Kay's
kobject cleanup changes, so replace all instances of it with
kobject_put().


Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/ia64/kernel/topology.c             |    9 ++++-----
 arch/s390/hypfs/inode.c                 |    4 ++--
 arch/sh/kernel/cpu/sh4/sq.c             |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c   |    9 ++++-----
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    6 +++---
 5 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index c4311e3..a2484fc 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -366,10 +366,9 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++) {
-				kobject_unregister(
-					&(LEAF_KOBJECT_PTR(cpu,j)->kobj));
+				kobject_put(&(LEAF_KOBJECT_PTR(cpu,j)->kobj));
 			}
-			kobject_unregister(&all_cpu_cache_info[cpu].kobj);
+			kobject_put(&all_cpu_cache_info[cpu].kobj);
 			cpu_cache_sysfs_exit(cpu);
 			break;
 		}
@@ -386,10 +385,10 @@ static int __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 	unsigned long i;
 
 	for (i = 0; i < all_cpu_cache_info[cpu].num_cache_leaves; i++)
-		kobject_unregister(&(LEAF_KOBJECT_PTR(cpu,i)->kobj));
+		kobject_put(&(LEAF_KOBJECT_PTR(cpu,i)->kobj));
 
 	if (all_cpu_cache_info[cpu].kobj.parent) {
-		kobject_unregister(&all_cpu_cache_info[cpu].kobj);
+		kobject_put(&all_cpu_cache_info[cpu].kobj);
 		memset(&all_cpu_cache_info[cpu].kobj,
 			0,
 			sizeof(struct kobject));
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 631a610..4b010ff 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -517,7 +517,7 @@ static int __init hypfs_init(void)
 	return 0;
 
 fail_filesystem:
-	kobject_unregister(s390_kobj);
+	kobject_put(s390_kobj);
 fail_sysfs:
 	if (!MACHINE_IS_VM)
 		hypfs_diag_exit();
@@ -531,7 +531,7 @@ static void __exit hypfs_exit(void)
 	if (!MACHINE_IS_VM)
 		hypfs_diag_exit();
 	unregister_filesystem(&hypfs_type);
-	kobject_unregister(s390_kobj);
+	kobject_put(s390_kobj);
 }
 
 module_init(hypfs_init)
diff --git a/arch/sh/kernel/cpu/sh4/sq.c b/arch/sh/kernel/cpu/sh4/sq.c
index 97fd9b9..3008c00 100644
--- a/arch/sh/kernel/cpu/sh4/sq.c
+++ b/arch/sh/kernel/cpu/sh4/sq.c
@@ -360,7 +360,7 @@ static int __devexit sq_sysdev_remove(struct sys_device *sysdev)
 	unsigned int cpu = sysdev->id;
 	struct kobject *kobj = sq_kobject[cpu];
 
-	kobject_unregister(kobj);
+	kobject_put(kobj);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 3509542..8b4507b 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -749,10 +749,9 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++) {
-				kobject_unregister(
-					&(INDEX_KOBJECT_PTR(cpu,j)->kobj));
+				kobject_put(&(INDEX_KOBJECT_PTR(cpu,j)->kobj));
 			}
-			kobject_unregister(cache_kobject[cpu]);
+			kobject_put(cache_kobject[cpu]);
 			cpuid4_cache_sysfs_exit(cpu);
 			break;
 		}
@@ -777,8 +776,8 @@ static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 	cpu_clear(cpu, cache_dev_map);
 
 	for (i = 0; i < num_cache_leaves; i++)
-		kobject_unregister(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
-	kobject_unregister(cache_kobject[cpu]);
+		kobject_put(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
+	kobject_put(cache_kobject[cpu]);
 	cpuid4_cache_sysfs_exit(cpu);
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index ef15f35..7535887 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -456,7 +456,7 @@ recurse:
 
 out_free:
 	if (b) {
-		kobject_unregister(&b->kobj);
+		kobject_put(&b->kobj);
 		kfree(b);
 	}
 	return err;
@@ -581,7 +581,7 @@ static void deallocate_threshold_block(unsigned int cpu,
 		return;
 
 	list_for_each_entry_safe(pos, tmp, &head->blocks->miscj, miscj) {
-		kobject_unregister(&pos->kobj);
+		kobject_put(&pos->kobj);
 		list_del(&pos->miscj);
 		kfree(pos);
 	}
@@ -627,7 +627,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
-	kobject_unregister(b->kobj);
+	kobject_put(b->kobj);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
 }
-- 
1.5.3.8

