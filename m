Return-Path: <linux-kernel-owner+w=401wt.eu-S932585AbYAYIci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbYAYIci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759599AbYAYIB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:53738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760930AbYAYIAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:00:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jacob Shin <jacob.shin@amd.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 126/196] Kobject: change arch/x86/kernel/cpu/mcheck/mce_amd_64.c to use kobject_create_and_add
Date: Thu, 24 Jan 2008 23:32:35 -0800
Message-Id: <1201246425-5058-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this kobject dynamic and convert it to not use kobject_register,
which is going away.

Cc: Jacob Shin <jacob.shin@amd.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 752fb16..2d65311 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -65,7 +65,7 @@ static struct threshold_block threshold_defaults = {
 };
 
 struct threshold_bank {
-	struct kobject kobj;
+	struct kobject *kobj;
 	struct threshold_block *blocks;
 	cpumask_t cpus;
 };
@@ -433,7 +433,7 @@ static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
 		per_cpu(threshold_banks, cpu)[bank]->blocks = b;
 
 	kobject_set_name(&b->kobj, "misc%i", block);
-	b->kobj.parent = &per_cpu(threshold_banks, cpu)[bank]->kobj;
+	b->kobj.parent = per_cpu(threshold_banks, cpu)[bank]->kobj;
 	b->kobj.ktype = &threshold_ktype;
 	err = kobject_register(&b->kobj);
 	if (err)
@@ -489,7 +489,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 			goto out;
 
 		err = sysfs_create_link(&per_cpu(device_mce, cpu).kobj,
-					&b->kobj, name);
+					b->kobj, name);
 		if (err)
 			goto out;
 
@@ -505,16 +505,15 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		goto out;
 	}
 
-	kobject_set_name(&b->kobj, "threshold_bank%i", bank);
-	b->kobj.parent = &per_cpu(device_mce, cpu).kobj;
+	b->kobj = kobject_create_and_add(name, &per_cpu(device_mce, cpu).kobj);
+	if (!b->kobj)
+		goto out_free;
+
 #ifndef CONFIG_SMP
 	b->cpus = CPU_MASK_ALL;
 #else
 	b->cpus = per_cpu(cpu_core_map, cpu);
 #endif
-	err = kobject_register(&b->kobj);
-	if (err)
-		goto out_free;
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
@@ -531,7 +530,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 			continue;
 
 		err = sysfs_create_link(&per_cpu(device_mce, i).kobj,
-					&b->kobj, name);
+					b->kobj, name);
 		if (err)
 			goto out;
 
@@ -627,7 +626,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 	deallocate_threshold_block(cpu, bank);
 
 free_out:
-	kobject_unregister(&b->kobj);
+	kobject_unregister(b->kobj);
 	kfree(b);
 	per_cpu(threshold_banks, cpu)[bank] = NULL;
 }
-- 
1.5.3.8

