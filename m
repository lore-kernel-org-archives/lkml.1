Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYDHL0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYDHL0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYDHLTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:35 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:1406 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbYDHLTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:33 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 20/29] ia64: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:27 +0400
Message-Id: <1207653576-12640-20-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Tony Luck <tony.luck@intel.com>
CC: linux-ia64@vger.kernel.org
---
 arch/ia64/hp/common/sba_iommu.c      |    6 ++----
 arch/ia64/kernel/perfmon.c           |    6 +-----
 arch/ia64/kernel/salinfo.c           |   10 ++++------
 arch/ia64/sn/kernel/sn2/sn2_smp.c    |    5 +++--
 arch/ia64/sn/kernel/sn2/sn_proc_fs.c |   29 ++++++++++-------------------
 5 files changed, 20 insertions(+), 36 deletions(-)

diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 6ce729f..34421ae 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -1932,15 +1932,13 @@ static const struct file_operations ioc_fops = {
 static void __init
 ioc_proc_init(void)
 {
-	struct proc_dir_entry *dir, *entry;
+	struct proc_dir_entry *dir;
 
 	dir = proc_mkdir("bus/mckinley", NULL);
 	if (!dir)
 		return;
 
-	entry = create_proc_entry(ioc_list->name, 0, dir);
-	if (entry)
-		entry->proc_fops = &ioc_fops;
+	proc_create(ioc_list->name, 0, dir, &ioc_fops);
 }
 #endif
 
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index a2aabfd..c66c588 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -6695,16 +6695,12 @@ pfm_init(void)
 	/*
 	 * create /proc/perfmon (mostly for debugging purposes)
 	 */
- 	perfmon_dir = create_proc_entry("perfmon", S_IRUGO, NULL);
+	perfmon_dir = proc_create("perfmon", S_IRUGO, NULL, &pfm_proc_fops);
 	if (perfmon_dir == NULL) {
 		printk(KERN_ERR "perfmon: cannot create /proc entry, perfmon disabled\n");
 		pmu_conf = NULL;
 		return -1;
 	}
-  	/*
- 	 * install customized file operations for /proc/perfmon entry
- 	 */
- 	perfmon_dir->proc_fops = &pfm_proc_fops;
 
 	/*
 	 * create /proc/sys/kernel/perfmon (for debugging purposes)
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index 779c3cc..012551f 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -648,18 +648,16 @@ salinfo_init(void)
 		if (!dir)
 			continue;
 
-		entry = create_proc_entry("event", S_IRUSR, dir);
+		entry = proc_create_data("event", S_IRUSR, dir,
+					 &salinfo_event_fops, data);
 		if (!entry)
 			continue;
-		entry->data = data;
-		entry->proc_fops = &salinfo_event_fops;
 		*sdir++ = entry;
 
-		entry = create_proc_entry("data", S_IRUSR | S_IWUSR, dir);
+		entry = proc_create_data("data", S_IRUSR | S_IWUSR, dir,
+					 &salinfo_data_fops, data);
 		if (!entry)
 			continue;
-		entry->data = data;
-		entry->proc_fops = &salinfo_data_fops;
 		*sdir++ = entry;
 
 		/* we missed any events before now */
diff --git a/arch/ia64/sn/kernel/sn2/sn2_smp.c b/arch/ia64/sn/kernel/sn2/sn2_smp.c
index dfc6bf1..49d3120 100644
--- a/arch/ia64/sn/kernel/sn2/sn2_smp.c
+++ b/arch/ia64/sn/kernel/sn2/sn2_smp.c
@@ -550,11 +550,12 @@ static int __init sn2_ptc_init(void)
 	if (!ia64_platform_is("sn2"))
 		return 0;
 
-	if (!(proc_sn2_ptc = create_proc_entry(PTC_BASENAME, 0444, NULL))) {
+	proc_sn2_ptc = proc_create(PTC_BASENAME, 0444,
+				   NULL, &proc_sn2_ptc_operations);
+	if (!&proc_sn2_ptc_operations) {
 		printk(KERN_ERR "unable to create %s proc entry", PTC_BASENAME);
 		return -EINVAL;
 	}
-	proc_sn2_ptc->proc_fops = &proc_sn2_ptc_operations;
 	spin_lock_init(&sn2_global_ptc_lock);
 	return 0;
 }
diff --git a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c b/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
index 62b3e9a..2526e5c 100644
--- a/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
+++ b/arch/ia64/sn/kernel/sn2/sn_proc_fs.c
@@ -139,30 +139,21 @@ static const struct file_operations proc_sn_topo_fops = {
 void register_sn_procfs(void)
 {
 	static struct proc_dir_entry *sgi_proc_dir = NULL;
-	struct proc_dir_entry *pde;
 
 	BUG_ON(sgi_proc_dir != NULL);
 	if (!(sgi_proc_dir = proc_mkdir("sgi_sn", NULL)))
 		return;
 
-	pde = create_proc_entry("partition_id", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_partition_id_fops;
-	pde = create_proc_entry("system_serial_number", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_system_sn_fops;
-	pde = create_proc_entry("licenseID", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_license_id_fops;
-	pde = create_proc_entry("sn_force_interrupt", 0644, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_sn_force_intr_fops;
-	pde = create_proc_entry("coherence_id", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_coherence_id_fops;
-	pde = create_proc_entry("sn_topology", 0444, sgi_proc_dir);
-	if (pde)
-		pde->proc_fops = &proc_sn_topo_fops;
+	proc_create("partition_id", 0444, sgi_proc_dir,
+		    &proc_partition_id_fops);
+	proc_create("system_serial_number", 0444, sgi_proc_dir,
+		    &proc_system_sn_fops);
+	proc_create("licenseID", 0444, sgi_proc_dir, &proc_license_id_fops);
+	proc_create("sn_force_interrupt", 0644, sgi_proc_dir,
+		    &proc_sn_force_intr_fops);
+	proc_create("coherence_id", 0444, sgi_proc_dir,
+		    &proc_coherence_id_fops);
+	proc_create("sn_topology", 0444, sgi_proc_dir, &proc_sn_topo_fops);
 }
 
 #endif /* CONFIG_PROC_FS */
-- 
1.5.3.rc5

