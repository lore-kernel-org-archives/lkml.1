Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627Ab0AELsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0AELsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395Ab0AELsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:48:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36319 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab0AELsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:48:01 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201001051247.104464547@firstfloor.org>
In-Reply-To: <201001051247.104464547@firstfloor.org>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] [1/12] SYSFS: Pass attribute in sysdev_class attributes show/store
Message-Id: <20100105114758.7773BB17C2@basil.firstfloor.org>
Date: Tue,  5 Jan 2010 12:47:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Passing the attribute to the low level IO functions allows all kinds
of cleanups, by sharing low level IO code without requiring
an own function for every piece of data.

Also drivers can extend the attributes with own data fields
and use that in the low level function.

Similar to sysdev_attributes and normal attributes.

This is a tree-wide sweep, converting everything in one go.

No functional changes in this patch other than passing the new
argument everywhere.

Tested on x86, the non x86 parts are uncompiled.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/mips/txx9/generic/7segled.c |    5 +++
 arch/s390/kernel/smp.c           |    8 ++++--
 arch/s390/kernel/time.c          |   49 +++++++++++++++++++++++++++++----------
 drivers/base/cpu.c               |    9 ++++---
 drivers/base/node.c              |   17 +++++++++----
 drivers/base/sys.c               |    4 +--
 drivers/cpuidle/sysfs.c          |    4 +++
 include/linux/sysdev.h           |    6 +++-
 kernel/perf_event.c              |   13 +++++++---
 kernel/sched.c                   |    4 +++
 10 files changed, 89 insertions(+), 30 deletions(-)

Index: linux-2.6.33-rc2-ak/arch/mips/txx9/generic/7segled.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/arch/mips/txx9/generic/7segled.c
+++ linux-2.6.33-rc2-ak/arch/mips/txx9/generic/7segled.c
@@ -58,13 +58,16 @@ static ssize_t raw_store(struct sys_devi
 static SYSDEV_ATTR(ascii, 0200, NULL, ascii_store);
 static SYSDEV_ATTR(raw, 0200, NULL, raw_store);
 
-static ssize_t map_seg7_show(struct sysdev_class *class, char *buf)
+static ssize_t map_seg7_show(struct sysdev_class *class,
+			     struct sysdev_class_attribute *attr,
+			     char *buf)
 {
 	memcpy(buf, &txx9_seg7map, sizeof(txx9_seg7map));
 	return sizeof(txx9_seg7map);
 }
 
 static ssize_t map_seg7_store(struct sysdev_class *class,
+			      struct sysdev_class_attribute *attr,
 			      const char *buf, size_t size)
 {
 	if (size != sizeof(txx9_seg7map))
Index: linux-2.6.33-rc2-ak/arch/s390/kernel/smp.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/arch/s390/kernel/smp.c
+++ linux-2.6.33-rc2-ak/arch/s390/kernel/smp.c
@@ -995,7 +995,9 @@ out:
 	return rc;
 }
 
-static ssize_t __ref rescan_store(struct sysdev_class *class, const char *buf,
+static ssize_t __ref rescan_store(struct sysdev_class *class,
+				  struct sysdev_class_attribute *attr,
+				  const char *buf,
 				  size_t count)
 {
 	int rc;
@@ -1016,7 +1018,9 @@ static ssize_t dispatching_show(struct s
 	return count;
 }
 
-static ssize_t dispatching_store(struct sysdev_class *dev, const char *buf,
+static ssize_t dispatching_store(struct sysdev_class *dev,
+				 struct sysdev_class_attribute *attr,
+				 const char *buf,
 				 size_t count)
 {
 	int val, rc;
Index: linux-2.6.33-rc2-ak/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/arch/s390/kernel/time.c
+++ linux-2.6.33-rc2-ak/arch/s390/kernel/time.c
@@ -1124,14 +1124,18 @@ static struct sys_device etr_port1_dev =
 /*
  * ETR class attributes
  */
-static ssize_t etr_stepping_port_show(struct sysdev_class *class, char *buf)
+static ssize_t etr_stepping_port_show(struct sysdev_class *class,
+					struct sysdev_class_attribute *attr,
+					char *buf)
 {
 	return sprintf(buf, "%i\n", etr_port0.esw.p);
 }
 
 static SYSDEV_CLASS_ATTR(stepping_port, 0400, etr_stepping_port_show, NULL);
 
-static ssize_t etr_stepping_mode_show(struct sysdev_class *class, char *buf)
+static ssize_t etr_stepping_mode_show(struct sysdev_class *class,
+				      	struct sysdev_class_attribute *attr,
+					char *buf)
 {
 	char *mode_str;
 
@@ -1592,7 +1596,9 @@ static struct sysdev_class stp_sysclass
 	.name	= "stp",
 };
 
-static ssize_t stp_ctn_id_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_ctn_id_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	if (!stp_online)
 		return -ENODATA;
@@ -1602,7 +1608,9 @@ static ssize_t stp_ctn_id_show(struct sy
 
 static SYSDEV_CLASS_ATTR(ctn_id, 0400, stp_ctn_id_show, NULL);
 
-static ssize_t stp_ctn_type_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_ctn_type_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	if (!stp_online)
 		return -ENODATA;
@@ -1611,7 +1619,9 @@ static ssize_t stp_ctn_type_show(struct
 
 static SYSDEV_CLASS_ATTR(ctn_type, 0400, stp_ctn_type_show, NULL);
 
-static ssize_t stp_dst_offset_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_dst_offset_show(struct sysdev_class *class,
+				   struct sysdev_class_attribute *attr,
+				   char *buf)
 {
 	if (!stp_online || !(stp_info.vbits & 0x2000))
 		return -ENODATA;
@@ -1620,7 +1630,9 @@ static ssize_t stp_dst_offset_show(struc
 
 static SYSDEV_CLASS_ATTR(dst_offset, 0400, stp_dst_offset_show, NULL);
 
-static ssize_t stp_leap_seconds_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_leap_seconds_show(struct sysdev_class *class,
+					struct sysdev_class_attribute *attr,
+					char *buf)
 {
 	if (!stp_online || !(stp_info.vbits & 0x8000))
 		return -ENODATA;
@@ -1629,7 +1641,9 @@ static ssize_t stp_leap_seconds_show(str
 
 static SYSDEV_CLASS_ATTR(leap_seconds, 0400, stp_leap_seconds_show, NULL);
 
-static ssize_t stp_stratum_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_stratum_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	if (!stp_online)
 		return -ENODATA;
@@ -1638,7 +1652,9 @@ static ssize_t stp_stratum_show(struct s
 
 static SYSDEV_CLASS_ATTR(stratum, 0400, stp_stratum_show, NULL);
 
-static ssize_t stp_time_offset_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_time_offset_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	if (!stp_online || !(stp_info.vbits & 0x0800))
 		return -ENODATA;
@@ -1647,7 +1663,9 @@ static ssize_t stp_time_offset_show(stru
 
 static SYSDEV_CLASS_ATTR(time_offset, 0400, stp_time_offset_show, NULL);
 
-static ssize_t stp_time_zone_offset_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_time_zone_offset_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	if (!stp_online || !(stp_info.vbits & 0x4000))
 		return -ENODATA;
@@ -1657,7 +1675,9 @@ static ssize_t stp_time_zone_offset_show
 static SYSDEV_CLASS_ATTR(time_zone_offset, 0400,
 			 stp_time_zone_offset_show, NULL);
 
-static ssize_t stp_timing_mode_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_timing_mode_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	if (!stp_online)
 		return -ENODATA;
@@ -1666,7 +1686,9 @@ static ssize_t stp_timing_mode_show(stru
 
 static SYSDEV_CLASS_ATTR(timing_mode, 0400, stp_timing_mode_show, NULL);
 
-static ssize_t stp_timing_state_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_timing_state_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	if (!stp_online)
 		return -ENODATA;
@@ -1675,12 +1697,15 @@ static ssize_t stp_timing_state_show(str
 
 static SYSDEV_CLASS_ATTR(timing_state, 0400, stp_timing_state_show, NULL);
 
-static ssize_t stp_online_show(struct sysdev_class *class, char *buf)
+static ssize_t stp_online_show(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
+				char *buf)
 {
 	return sprintf(buf, "%i\n", stp_online);
 }
 
 static ssize_t stp_online_store(struct sysdev_class *class,
+				struct sysdev_class_attribute *attr,
 				const char *buf, size_t count)
 {
 	unsigned int value;
Index: linux-2.6.33-rc2-ak/drivers/base/cpu.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/cpu.c
+++ linux-2.6.33-rc2-ak/drivers/base/cpu.c
@@ -151,7 +151,8 @@ static ssize_t print_cpus_map(char *buf,
 }
 
 #define	print_cpus_func(type) \
-static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
+static ssize_t print_cpus_##type(struct sysdev_class *class, 		\
+	 		struct sysdev_class_attribute *attr, char *buf)	\
 {									\
 	return print_cpus_map(buf, cpu_##type##_mask);			\
 }									\
@@ -165,7 +166,8 @@ print_cpus_func(present);
 /*
  * Print values for NR_CPUS and offlined cpus
  */
-static ssize_t print_cpus_kernel_max(struct sysdev_class *class, char *buf)
+static ssize_t print_cpus_kernel_max(struct sysdev_class *class,
+				     struct sysdev_class_attribute *attr, char *buf)
 {
 	int n = snprintf(buf, PAGE_SIZE-2, "%d\n", NR_CPUS - 1);
 	return n;
@@ -175,7 +177,8 @@ static SYSDEV_CLASS_ATTR(kernel_max, 044
 /* arch-optional setting to enable display of offline cpus >= nr_cpu_ids */
 unsigned int total_cpus;
 
-static ssize_t print_cpus_offline(struct sysdev_class *class, char *buf)
+static ssize_t print_cpus_offline(struct sysdev_class *class,
+				  struct sysdev_class_attribute *attr, char *buf)
 {
 	int n = 0, len = PAGE_SIZE-2;
 	cpumask_var_t offline;
Index: linux-2.6.33-rc2-ak/drivers/base/node.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/node.c
+++ linux-2.6.33-rc2-ak/drivers/base/node.c
@@ -544,23 +544,29 @@ static ssize_t print_nodes_state(enum no
 	return n;
 }
 
-static ssize_t print_nodes_possible(struct sysdev_class *class, char *buf)
+static ssize_t print_nodes_possible(struct sysdev_class *class,
+				    struct sysdev_class_attribute *attr, char *buf)
 {
 	return print_nodes_state(N_POSSIBLE, buf);
 }
 
-static ssize_t print_nodes_online(struct sysdev_class *class, char *buf)
+static ssize_t print_nodes_online(struct sysdev_class *class,
+				  struct sysdev_class_attribute *attr,
+				  char *buf)
 {
 	return print_nodes_state(N_ONLINE, buf);
 }
 
 static ssize_t print_nodes_has_normal_memory(struct sysdev_class *class,
-						char *buf)
+					     struct sysdev_class_attribute *attr,
+					     char *buf)
 {
 	return print_nodes_state(N_NORMAL_MEMORY, buf);
 }
 
-static ssize_t print_nodes_has_cpu(struct sysdev_class *class, char *buf)
+static ssize_t print_nodes_has_cpu(struct sysdev_class *class,
+				   struct sysdev_class_attribute *attr,
+				   char *buf)
 {
 	return print_nodes_state(N_CPU, buf);
 }
@@ -573,7 +579,8 @@ static SYSDEV_CLASS_ATTR(has_cpu, 0444,
 
 #ifdef CONFIG_HIGHMEM
 static ssize_t print_nodes_has_high_memory(struct sysdev_class *class,
-						 char *buf)
+					   struct sysdev_class_attribute *attr,
+					   char *buf)
 {
 	return print_nodes_state(N_HIGH_MEMORY, buf);
 }
Index: linux-2.6.33-rc2-ak/drivers/base/sys.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/base/sys.c
+++ linux-2.6.33-rc2-ak/drivers/base/sys.c
@@ -89,7 +89,7 @@ static ssize_t sysdev_class_show(struct
 	struct sysdev_class_attribute *class_attr = to_sysdev_class_attr(attr);
 
 	if (class_attr->show)
-		return class_attr->show(class, buffer);
+		return class_attr->show(class, class_attr, buffer);
 	return -EIO;
 }
 
@@ -100,7 +100,7 @@ static ssize_t sysdev_class_store(struct
 	struct sysdev_class_attribute *class_attr = to_sysdev_class_attr(attr);
 
 	if (class_attr->store)
-		return class_attr->store(class, buffer, count);
+		return class_attr->store(class, class_attr, buffer, count);
 	return -EIO;
 }
 
Index: linux-2.6.33-rc2-ak/drivers/cpuidle/sysfs.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/drivers/cpuidle/sysfs.c
+++ linux-2.6.33-rc2-ak/drivers/cpuidle/sysfs.c
@@ -22,6 +22,7 @@ static int __init cpuidle_sysfs_setup(ch
 __setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
 
 static ssize_t show_available_governors(struct sysdev_class *class,
+					struct sysdev_class_attribute *attr,
 					char *buf)
 {
 	ssize_t i = 0;
@@ -41,6 +42,7 @@ out:
 }
 
 static ssize_t show_current_driver(struct sysdev_class *class,
+				   struct sysdev_class_attribute *attr,
 				   char *buf)
 {
 	ssize_t ret;
@@ -56,6 +58,7 @@ static ssize_t show_current_driver(struc
 }
 
 static ssize_t show_current_governor(struct sysdev_class *class,
+				     struct sysdev_class_attribute *attr,
 				     char *buf)
 {
 	ssize_t ret;
@@ -71,6 +74,7 @@ static ssize_t show_current_governor(str
 }
 
 static ssize_t store_current_governor(struct sysdev_class *class,
+				      struct sysdev_class_attribute *attr,
 				      const char *buf, size_t count)
 {
 	char gov_name[CPUIDLE_NAME_LEN];
Index: linux-2.6.33-rc2-ak/include/linux/sysdev.h
===================================================================
--- linux-2.6.33-rc2-ak.orig/include/linux/sysdev.h
+++ linux-2.6.33-rc2-ak/include/linux/sysdev.h
@@ -41,8 +41,10 @@ struct sysdev_class {
 
 struct sysdev_class_attribute {
 	struct attribute attr;
-	ssize_t (*show)(struct sysdev_class *, char *);
-	ssize_t (*store)(struct sysdev_class *, const char *, size_t);
+	ssize_t (*show)(struct sysdev_class *, struct sysdev_class_attribute *,
+			char *);
+	ssize_t (*store)(struct sysdev_class *, struct sysdev_class_attribute *,
+			 const char *, size_t);
 };
 
 #define _SYSDEV_CLASS_ATTR(_name,_mode,_show,_store) 		\
Index: linux-2.6.33-rc2-ak/kernel/perf_event.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/perf_event.c
+++ linux-2.6.33-rc2-ak/kernel/perf_event.c
@@ -5275,13 +5275,16 @@ void __init perf_event_init(void)
 	register_cpu_notifier(&perf_cpu_nb);
 }
 
-static ssize_t perf_show_reserve_percpu(struct sysdev_class *class, char *buf)
+static ssize_t perf_show_reserve_percpu(struct sysdev_class *class,
+					struct sysdev_class_attribute *attr,
+					char *buf)
 {
 	return sprintf(buf, "%d\n", perf_reserved_percpu);
 }
 
 static ssize_t
 perf_set_reserve_percpu(struct sysdev_class *class,
+			struct sysdev_class_attribute *attr,
 			const char *buf,
 			size_t count)
 {
@@ -5310,13 +5313,17 @@ perf_set_reserve_percpu(struct sysdev_cl
 	return count;
 }
 
-static ssize_t perf_show_overcommit(struct sysdev_class *class, char *buf)
+static ssize_t perf_show_overcommit(struct sysdev_class *class,
+				    struct sysdev_class_attribute *attr,
+				    char *buf)
 {
 	return sprintf(buf, "%d\n", perf_overcommit);
 }
 
 static ssize_t
-perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
+perf_set_overcommit(struct sysdev_class *class,
+		    struct sysdev_class_attribute *attr,
+		    const char *buf, size_t count)
 {
 	unsigned long val;
 	int err;
Index: linux-2.6.33-rc2-ak/kernel/sched.c
===================================================================
--- linux-2.6.33-rc2-ak.orig/kernel/sched.c
+++ linux-2.6.33-rc2-ak/kernel/sched.c
@@ -9199,11 +9199,13 @@ static ssize_t sched_power_savings_store
 
 #ifdef CONFIG_SCHED_MC
 static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
+					   struct sysdev_class_attribute *attr,
 					   char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
 static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
+					    struct sysdev_class_attribute *attr,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
@@ -9215,11 +9217,13 @@ static SYSDEV_CLASS_ATTR(sched_mc_power_
 
 #ifdef CONFIG_SCHED_SMT
 static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
+					    struct sysdev_class_attribute *attr,
 					    char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
 static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
+					     struct sysdev_class_attribute *attr,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
