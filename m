Return-Path: <linux-kernel-owner+w=401wt.eu-S1759396AbYAKIho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbYAKIho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYAKIhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:37:37 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30337
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493AbYAKIhe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:37:34 -0500
Message-Id: <478738F3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:37:55 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <davem@davemloft.net>, <schwidefsky@de.ibm.com>, <mingo@elte.hu>,
       <tony.luck@intel.com>, <paulus@samba.org>, <gregkh@suse.de>
Subject: [PATCH 1/3] constify struct attribute_group uses
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. as all consumers of it don't require it to be modifiable.

Unfortunately, due to the two-level constifications, this required
touching quite many files, not all of which I am able to test - please
bare with eventual mistakes or oversights.

The patch doesn't change all instances where 'const' could have been
added as a result of the base structure changes, only where either the
change has a real effect (the module loader doesn't enforce read-only
section attributes at present, so only built-in files matter) or where
compiler warnings would result otherwise.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kernel/err_inject.c             |    4 +--
 arch/powerpc/kernel/sysfs.c               |    4 +--
 arch/powerpc/platforms/cell/cbe_thermal.c |    8 +++---
 arch/powerpc/platforms/cell/spu_base.c    |    4 +--
 arch/powerpc/platforms/pseries/power.c    |    4 +--
 arch/s390/kernel/ipl.c                    |   36 +++++++++++++++---------------
 arch/s390/kernel/smp.c                    |    4 +--
 arch/sparc64/kernel/sysfs.c               |    4 +--
 arch/x86/kernel/cpu/mcheck/therm_throt.c  |    4 +--
 arch/x86/kernel/microcode.c               |    4 +--
 drivers/base/core.c                       |    4 +--
 drivers/base/power/sysfs.c                |    4 +--
 drivers/base/topology.c                   |    4 +--
 drivers/cpuidle/sysfs.c                   |    4 +--
 drivers/firewire/fw-device.h              |    2 -
 drivers/firmware/dmi-id.c                 |    4 +--
 drivers/hwmon/dme1737.c                   |    2 -
 drivers/infiniband/core/sysfs.c           |    8 +++---
 drivers/input/input.c                     |   14 +++++------
 drivers/input/keyboard/atkbd.c            |    4 +--
 drivers/input/mouse/psmouse-base.c        |    4 +--
 drivers/input/serio/serio.c               |    4 +--
 drivers/misc/thinkpad_acpi.c              |    6 ++---
 drivers/s390/cio/css.h                    |    2 -
 drivers/s390/cio/device.c                 |   12 +++++-----
 drivers/scsi/scsi_sysfs.c                 |    6 ++---
 include/asm-powerpc/spu.h                 |    4 +--
 include/linux/cpu.h                       |    4 +--
 include/linux/device.h                    |    6 ++---
 include/linux/netdevice.h                 |    2 -
 include/linux/sysfs.h                     |    2 -
 include/linux/transport_class.h           |    2 -
 kernel/ksysfs.c                           |    4 +--
 kernel/module.c                           |    3 --
 kernel/params.c                           |    3 --
 kernel/power/disk.c                       |    4 +--
 kernel/power/main.c                       |    6 ++---
 mm/slub.c                                 |    4 +--
 net/core/net-sysfs.c                      |   10 ++++----
 39 files changed, 106 insertions(+), 108 deletions(-)

--- 2.6.24-rc7-const.orig/arch/ia64/kernel/err_inject.c
+++ 2.6.24-rc7-const/arch/ia64/kernel/err_inject.c
@@ -200,7 +200,7 @@ define_one_ro(status);
 define_one_ro(capabilities);
 define_one_ro(resources);
 
-static struct attribute *default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	&attr_call_start.attr,
 	&attr_virtual_to_phys.attr,
 	&attr_err_type_info.attr,
@@ -212,7 +212,7 @@ static struct attribute *default_attrs[]
 	NULL
 };
 
-static struct attribute_group err_inject_attr_group = {
+static const struct attribute_group err_inject_attr_group = {
 	.attrs = default_attrs,
 	.name = "err_inject"
 };
--- 2.6.24-rc7-const.orig/arch/powerpc/kernel/sysfs.c
+++ 2.6.24-rc7-const/arch/powerpc/kernel/sysfs.c
@@ -436,7 +436,7 @@ int cpu_add_sysdev_attr(struct sysdev_at
 }
 EXPORT_SYMBOL_GPL(cpu_add_sysdev_attr);
 
-int cpu_add_sysdev_attr_group(struct attribute_group *attrs)
+int cpu_add_sysdev_attr_group(const struct attribute_group *attrs)
 {
 	int cpu;
 	struct sys_device *sysdev;
@@ -470,7 +470,7 @@ void cpu_remove_sysdev_attr(struct sysde
 }
 EXPORT_SYMBOL_GPL(cpu_remove_sysdev_attr);
 
-void cpu_remove_sysdev_attr_group(struct attribute_group *attrs)
+void cpu_remove_sysdev_attr_group(const struct attribute_group *attrs)
 {
 	int cpu;
 	struct sys_device *sysdev;
--- 2.6.24-rc7-const.orig/arch/powerpc/platforms/cell/cbe_thermal.c
+++ 2.6.24-rc7-const/arch/powerpc/platforms/cell/cbe_thermal.c
@@ -244,7 +244,7 @@ static SYSDEV_PREFIX_ATTR(spu, throttle_
 static SYSDEV_PREFIX_ATTR(spu, throttle_full_stop, 0600);
 
 
-static struct attribute *spu_attributes[] = {
+static struct attribute *const spu_attributes[] = {
 	&attr_spu_temperature.attr,
 	&attr_spu_throttle_end.attr,
 	&attr_spu_throttle_begin.attr,
@@ -252,7 +252,7 @@ static struct attribute *spu_attributes[
 	NULL,
 };
 
-static struct attribute_group spu_attribute_group = {
+static const struct attribute_group spu_attribute_group = {
 	.name	= "thermal",
 	.attrs	= spu_attributes,
 };
@@ -271,7 +271,7 @@ static SYSDEV_PREFIX_ATTR(ppe, throttle_
 static SYSDEV_PREFIX_ATTR(ppe, throttle_begin, 0600);
 static SYSDEV_PREFIX_ATTR(ppe, throttle_full_stop, 0600);
 
-static struct attribute *ppe_attributes[] = {
+static struct attribute *const ppe_attributes[] = {
 	&attr_ppe_temperature0.attr,
 	&attr_ppe_temperature1.attr,
 	&attr_ppe_throttle_end.attr,
@@ -280,7 +280,7 @@ static struct attribute *ppe_attributes[
 	NULL,
 };
 
-static struct attribute_group ppe_attribute_group = {
+static const struct attribute_group ppe_attribute_group = {
 	.name	= "thermal",
 	.attrs	= ppe_attributes,
 };
--- 2.6.24-rc7-const.orig/arch/powerpc/platforms/cell/spu_base.c
+++ 2.6.24-rc7-const/arch/powerpc/platforms/cell/spu_base.c
@@ -476,7 +476,7 @@ int spu_add_sysdev_attr(struct sysdev_at
 }
 EXPORT_SYMBOL_GPL(spu_add_sysdev_attr);
 
-int spu_add_sysdev_attr_group(struct attribute_group *attrs)
+int spu_add_sysdev_attr_group(const struct attribute_group *attrs)
 {
 	struct spu *spu;
 
@@ -501,7 +501,7 @@ void spu_remove_sysdev_attr(struct sysde
 }
 EXPORT_SYMBOL_GPL(spu_remove_sysdev_attr);
 
-void spu_remove_sysdev_attr_group(struct attribute_group *attrs)
+void spu_remove_sysdev_attr_group(const struct attribute_group *attrs)
 {
 	struct spu *spu;
 
--- 2.6.24-rc7-const.orig/arch/powerpc/platforms/pseries/power.c
+++ 2.6.24-rc7-const/arch/powerpc/platforms/pseries/power.c
@@ -59,12 +59,12 @@ static struct subsys_attribute auto_powe
 #ifndef CONFIG_PM
 decl_subsys(power,NULL,NULL);
 
-static struct attribute *g[] = {
+static struct attribute *const g[] = {
         &auto_poweron_attr.attr,
         NULL,
 };
 
-static struct attribute_group attr_group = {
+static const struct attribute_group attr_group = {
         .attrs = g,
 };
 
--- 2.6.24-rc7-const.orig/arch/s390/kernel/ipl.c
+++ 2.6.24-rc7-const/arch/s390/kernel/ipl.c
@@ -351,7 +351,7 @@ DEFINE_IPL_ATTR_RO(ipl_fcp, bootprog, "%
 DEFINE_IPL_ATTR_RO(ipl_fcp, br_lba, "%lld\n", (unsigned long long)
 		   IPL_PARMBLOCK_START->ipl_info.fcp.br_lba);
 
-static struct attribute *ipl_fcp_attrs[] = {
+static struct attribute *const ipl_fcp_attrs[] = {
 	&sys_ipl_type_attr.attr,
 	&sys_ipl_device_attr.attr,
 	&sys_ipl_fcp_wwpn_attr.attr,
@@ -361,7 +361,7 @@ static struct attribute *ipl_fcp_attrs[]
 	NULL,
 };
 
-static struct attribute_group ipl_fcp_attr_group = {
+static const struct attribute_group ipl_fcp_attr_group = {
 	.attrs = ipl_fcp_attrs,
 };
 
@@ -382,14 +382,14 @@ static ssize_t ipl_ccw_loadparm_show(str
 static struct subsys_attribute sys_ipl_ccw_loadparm_attr =
 	__ATTR(loadparm, 0444, ipl_ccw_loadparm_show, NULL);
 
-static struct attribute *ipl_ccw_attrs[] = {
+static struct attribute *const ipl_ccw_attrs[] = {
 	&sys_ipl_type_attr.attr,
 	&sys_ipl_device_attr.attr,
 	&sys_ipl_ccw_loadparm_attr.attr,
 	NULL,
 };
 
-static struct attribute_group ipl_ccw_attr_group = {
+static const struct attribute_group ipl_ccw_attr_group = {
 	.attrs = ipl_ccw_attrs,
 };
 
@@ -397,24 +397,24 @@ static struct attribute_group ipl_ccw_at
 
 DEFINE_IPL_ATTR_RO(ipl_nss, name, "%s\n", kernel_nss_name);
 
-static struct attribute *ipl_nss_attrs[] = {
+static struct attribute *const ipl_nss_attrs[] = {
 	&sys_ipl_type_attr.attr,
 	&sys_ipl_nss_name_attr.attr,
 	NULL,
 };
 
-static struct attribute_group ipl_nss_attr_group = {
+static const struct attribute_group ipl_nss_attr_group = {
 	.attrs = ipl_nss_attrs,
 };
 
 /* UNKNOWN ipl device attributes */
 
-static struct attribute *ipl_unknown_attrs[] = {
+static struct attribute *const ipl_unknown_attrs[] = {
 	&sys_ipl_type_attr.attr,
 	NULL,
 };
 
-static struct attribute_group ipl_unknown_attr_group = {
+static const struct attribute_group ipl_unknown_attr_group = {
 	.attrs = ipl_unknown_attrs,
 };
 
@@ -437,7 +437,7 @@ DEFINE_IPL_ATTR_RW(reipl_fcp, br_lba, "%
 DEFINE_IPL_ATTR_RW(reipl_fcp, device, "0.0.%04llx\n", "0.0.%llx\n",
 		   reipl_block_fcp->ipl_info.fcp.devno);
 
-static struct attribute *reipl_fcp_attrs[] = {
+static struct attribute *const reipl_fcp_attrs[] = {
 	&sys_reipl_fcp_device_attr.attr,
 	&sys_reipl_fcp_wwpn_attr.attr,
 	&sys_reipl_fcp_lun_attr.attr,
@@ -446,7 +446,7 @@ static struct attribute *reipl_fcp_attrs
 	NULL,
 };
 
-static struct attribute_group reipl_fcp_attr_group = {
+static const struct attribute_group reipl_fcp_attr_group = {
 	.name  = IPL_FCP_STR,
 	.attrs = reipl_fcp_attrs,
 };
@@ -504,13 +504,13 @@ static struct subsys_attribute sys_reipl
 	__ATTR(loadparm, 0644, reipl_ccw_loadparm_show,
 	       reipl_ccw_loadparm_store);
 
-static struct attribute *reipl_ccw_attrs[] = {
+static struct attribute *const reipl_ccw_attrs[] = {
 	&sys_reipl_ccw_device_attr.attr,
 	&sys_reipl_ccw_loadparm_attr.attr,
 	NULL,
 };
 
-static struct attribute_group reipl_ccw_attr_group = {
+static const struct attribute_group reipl_ccw_attr_group = {
 	.name  = IPL_CCW_STR,
 	.attrs = reipl_ccw_attrs,
 };
@@ -520,12 +520,12 @@ static struct attribute_group reipl_ccw_
 
 DEFINE_IPL_ATTR_STR_RW(reipl_nss, name, "%s\n", "%s\n", reipl_nss_name);
 
-static struct attribute *reipl_nss_attrs[] = {
+static struct attribute *const reipl_nss_attrs[] = {
 	&sys_reipl_nss_name_attr.attr,
 	NULL,
 };
 
-static struct attribute_group reipl_nss_attr_group = {
+static const struct attribute_group reipl_nss_attr_group = {
 	.name  = IPL_NSS_STR,
 	.attrs = reipl_nss_attrs,
 };
@@ -609,7 +609,7 @@ DEFINE_IPL_ATTR_RW(dump_fcp, br_lba, "%l
 DEFINE_IPL_ATTR_RW(dump_fcp, device, "0.0.%04llx\n", "0.0.%llx\n",
 		   dump_block_fcp->ipl_info.fcp.devno);
 
-static struct attribute *dump_fcp_attrs[] = {
+static struct attribute *const dump_fcp_attrs[] = {
 	&sys_dump_fcp_device_attr.attr,
 	&sys_dump_fcp_wwpn_attr.attr,
 	&sys_dump_fcp_lun_attr.attr,
@@ -618,7 +618,7 @@ static struct attribute *dump_fcp_attrs[
 	NULL,
 };
 
-static struct attribute_group dump_fcp_attr_group = {
+static const struct attribute_group dump_fcp_attr_group = {
 	.name  = IPL_FCP_STR,
 	.attrs = dump_fcp_attrs,
 };
@@ -628,12 +628,12 @@ static struct attribute_group dump_fcp_a
 DEFINE_IPL_ATTR_RW(dump_ccw, device, "0.0.%04llx\n", "0.0.%llx\n",
 		   dump_block_ccw->ipl_info.ccw.devno);
 
-static struct attribute *dump_ccw_attrs[] = {
+static struct attribute *const dump_ccw_attrs[] = {
 	&sys_dump_ccw_device_attr.attr,
 	NULL,
 };
 
-static struct attribute_group dump_ccw_attr_group = {
+static const struct attribute_group dump_ccw_attr_group = {
 	.name  = IPL_CCW_STR,
 	.attrs = dump_ccw_attrs,
 };
--- 2.6.24-rc7-const.orig/arch/s390/kernel/smp.c
+++ 2.6.24-rc7-const/arch/s390/kernel/smp.c
@@ -750,14 +750,14 @@ static ssize_t show_idle_time(struct sys
 }
 static SYSDEV_ATTR(idle_time_us, 0444, show_idle_time, NULL);
 
-static struct attribute *cpu_attrs[] = {
+static struct attribute *const cpu_attrs[] = {
 	&attr_capability.attr,
 	&attr_idle_count.attr,
 	&attr_idle_time_us.attr,
 	NULL,
 };
 
-static struct attribute_group cpu_attr_group = {
+static const struct attribute_group cpu_attr_group = {
 	.attrs = cpu_attrs,
 };
 
--- 2.6.24-rc7-const.orig/arch/sparc64/kernel/sysfs.c
+++ 2.6.24-rc7-const/arch/sparc64/kernel/sysfs.c
@@ -54,7 +54,7 @@ SHOW_MMUSTAT_ULONG(dmmu_tsb_ticks_ctxnon
 SHOW_MMUSTAT_ULONG(dmmu_tsb_hits_ctxnon0_256mb_tte);
 SHOW_MMUSTAT_ULONG(dmmu_tsb_ticks_ctxnon0_256mb_tte);
 
-static struct attribute *mmu_stat_attrs[] = {
+static struct attribute *const mmu_stat_attrs[] = {
 	&attr_immu_tsb_hits_ctx0_8k_tte.attr,
 	&attr_immu_tsb_ticks_ctx0_8k_tte.attr,
 	&attr_immu_tsb_hits_ctx0_64k_tte.attr,
@@ -90,7 +90,7 @@ static struct attribute *mmu_stat_attrs[
 	NULL,
 };
 
-static struct attribute_group mmu_stat_group = {
+static const struct attribute_group mmu_stat_group = {
 	.attrs = mmu_stat_attrs,
 	.name = "mmu_stats",
 };
--- 2.6.24-rc7-const.orig/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ 2.6.24-rc7-const/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -55,12 +55,12 @@ static ssize_t therm_throt_sysdev_show_#
 define_therm_throt_sysdev_show_func(count);
 define_therm_throt_sysdev_one_ro(count);
 
-static struct attribute *thermal_throttle_attrs[] = {
+static struct attribute *const thermal_throttle_attrs[] = {
 	&attr_count.attr,
 	NULL
 };
 
-static struct attribute_group thermal_throttle_attr_group = {
+static const struct attribute_group thermal_throttle_attr_group = {
 	.attrs = thermal_throttle_attrs,
 	.name = "thermal_throttle"
 };
--- 2.6.24-rc7-const.orig/arch/x86/kernel/microcode.c
+++ 2.6.24-rc7-const/arch/x86/kernel/microcode.c
@@ -691,14 +691,14 @@ static SYSDEV_ATTR(reload, 0200, NULL, r
 static SYSDEV_ATTR(version, 0400, version_show, NULL);
 static SYSDEV_ATTR(processor_flags, 0400, pf_show, NULL);
 
-static struct attribute *mc_default_attrs[] = {
+static struct attribute *const mc_default_attrs[] = {
 	&attr_reload.attr,
 	&attr_version.attr,
 	&attr_processor_flags.attr,
 	NULL
 };
 
-static struct attribute_group mc_attr_group = {
+static const struct attribute_group mc_attr_group = {
 	.attrs = mc_default_attrs,
 	.name = "microcode",
 };
--- 2.6.24-rc7-const.orig/drivers/base/core.c
+++ 2.6.24-rc7-const/drivers/base/core.c
@@ -315,7 +315,7 @@ static void device_remove_attributes(str
 }
 
 static int device_add_groups(struct device *dev,
-			     struct attribute_group **groups)
+			     const struct attribute_group *const *groups)
 {
 	int error = 0;
 	int i;
@@ -334,7 +334,7 @@ static int device_add_groups(struct devi
 }
 
 static void device_remove_groups(struct device *dev,
-				 struct attribute_group **groups)
+				 const struct attribute_group *const *groups)
 {
 	int i;
 
--- 2.6.24-rc7-const.orig/drivers/base/power/sysfs.c
+++ 2.6.24-rc7-const/drivers/base/power/sysfs.c
@@ -79,11 +79,11 @@ wake_store(struct device * dev, struct d
 static DEVICE_ATTR(wakeup, 0644, wake_show, wake_store);
 
 
-static struct attribute * power_attrs[] = {
+static struct attribute *const power_attrs[] = {
 	&dev_attr_wakeup.attr,
 	NULL,
 };
-static struct attribute_group pm_attr_group = {
+static const struct attribute_group pm_attr_group = {
 	.name	= "power",
 	.attrs	= power_attrs,
 };
--- 2.6.24-rc7-const.orig/drivers/base/topology.c
+++ 2.6.24-rc7-const/drivers/base/topology.c
@@ -81,7 +81,7 @@ define_one_ro(core_siblings);
 #define ref_core_siblings_attr
 #endif
 
-static struct attribute *default_attrs[] = {
+static struct attribute *const default_attrs[] = {
 	ref_physical_package_id_attr
 	ref_core_id_attr
 	ref_thread_siblings_attr
@@ -89,7 +89,7 @@ static struct attribute *default_attrs[]
 	NULL
 };
 
-static struct attribute_group topology_attr_group = {
+static const struct attribute_group topology_attr_group = {
 	.attrs = default_attrs,
 	.name = "topology"
 };
--- 2.6.24-rc7-const.orig/drivers/cpuidle/sysfs.c
+++ 2.6.24-rc7-const/drivers/cpuidle/sysfs.c
@@ -103,7 +103,7 @@ static ssize_t store_current_governor(st
 static SYSDEV_ATTR(current_driver, 0444, show_current_driver, NULL);
 static SYSDEV_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
 
-static struct attribute *cpuclass_default_attrs[] = {
+static struct attribute *const cpuclass_default_attrs[] = {
 	&attr_current_driver.attr,
 	&attr_current_governor_ro.attr,
 	NULL
@@ -113,7 +113,7 @@ static SYSDEV_ATTR(available_governors, 
 static SYSDEV_ATTR(current_governor, 0644, show_current_governor,
 	store_current_governor);
 
-static struct attribute *cpuclass_switch_attrs[] = {
+static struct attribute *const cpuclass_switch_attrs[] = {
 	&attr_available_governors.attr,
 	&attr_current_driver.attr,
 	&attr_current_governor.attr,
--- 2.6.24-rc7-const.orig/drivers/firewire/fw-device.h
+++ 2.6.24-rc7-const/drivers/firewire/fw-device.h
@@ -30,7 +30,7 @@ enum fw_device_state {
 };
 
 struct fw_attribute_group {
-	struct attribute_group *groups[2];
+	const struct attribute_group *groups[2];
 	struct attribute_group group;
 	struct attribute *attrs[11];
 };
--- 2.6.24-rc7-const.orig/drivers/firmware/dmi-id.c
+++ 2.6.24-rc7-const/drivers/firmware/dmi-id.c
@@ -136,11 +136,11 @@ static struct device_attribute sys_dmi_m
 
 static struct attribute *sys_dmi_attributes[DMI_STRING_MAX+2];
 
-static struct attribute_group sys_dmi_attribute_group = {
+static const struct attribute_group sys_dmi_attribute_group = {
 	.attrs = sys_dmi_attributes,
 };
 
-static struct attribute_group* sys_dmi_attribute_groups[] = {
+static const struct attribute_group *const sys_dmi_attribute_groups[] = {
 	&sys_dmi_attribute_group,
 	NULL
 };
--- 2.6.24-rc7-const.orig/drivers/hwmon/dme1737.c
+++ 2.6.24-rc7-const/drivers/hwmon/dme1737.c
@@ -1775,7 +1775,7 @@ static void dme1737_chmod_group(struct d
 				const struct attribute_group *group,
 				mode_t mode)
 {
-	struct attribute **attr;
+	struct attribute *const *attr;
 
 	for (attr = group->attrs; *attr; attr++) {
 		dme1737_chmod_file(dev, *attr, mode);
--- 2.6.24-rc7-const.orig/drivers/infiniband/core/sysfs.c
+++ 2.6.24-rc7-const/drivers/infiniband/core/sysfs.c
@@ -411,12 +411,12 @@ static void ib_port_release(struct kobje
 	for (i = 0; (a = p->gid_group.attrs[i]); ++i)
 		kfree(a);
 
-	kfree(p->gid_group.attrs);
+	kfree((void *)p->gid_group.attrs);
 
 	for (i = 0; (a = p->pkey_group.attrs[i]); ++i)
 		kfree(a);
 
-	kfree(p->pkey_group.attrs);
+	kfree((void *)p->pkey_group.attrs);
 
 	kfree(p);
 }
@@ -555,7 +555,7 @@ err_free_pkey:
 	for (i = 0; i < attr.pkey_tbl_len; ++i)
 		kfree(p->pkey_group.attrs[i]);
 
-	kfree(p->pkey_group.attrs);
+	kfree((void *)p->pkey_group.attrs);
 
 err_remove_gid:
 	sysfs_remove_group(&p->kobj, &p->gid_group);
@@ -564,7 +564,7 @@ err_free_gid:
 	for (i = 0; i < attr.gid_tbl_len; ++i)
 		kfree(p->gid_group.attrs[i]);
 
-	kfree(p->gid_group.attrs);
+	kfree((void *)p->gid_group.attrs);
 
 err_remove_pma:
 	sysfs_remove_group(&p->kobj, &pma_group);
--- 2.6.24-rc7-const.orig/drivers/input/input.c
+++ 2.6.24-rc7-const/drivers/input/input.c
@@ -945,7 +945,7 @@ static ssize_t input_dev_show_modalias(s
 }
 static DEVICE_ATTR(modalias, S_IRUGO, input_dev_show_modalias, NULL);
 
-static struct attribute *input_dev_attrs[] = {
+static struct attribute *const input_dev_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_phys.attr,
 	&dev_attr_uniq.attr,
@@ -953,7 +953,7 @@ static struct attribute *input_dev_attrs
 	NULL
 };
 
-static struct attribute_group input_dev_attr_group = {
+static const struct attribute_group input_dev_attr_group = {
 	.attrs	= input_dev_attrs,
 };
 
@@ -972,7 +972,7 @@ INPUT_DEV_ID_ATTR(vendor);
 INPUT_DEV_ID_ATTR(product);
 INPUT_DEV_ID_ATTR(version);
 
-static struct attribute *input_dev_id_attrs[] = {
+static struct attribute *const input_dev_id_attrs[] = {
 	&dev_attr_bustype.attr,
 	&dev_attr_vendor.attr,
 	&dev_attr_product.attr,
@@ -980,7 +980,7 @@ static struct attribute *input_dev_id_at
 	NULL
 };
 
-static struct attribute_group input_dev_id_attr_group = {
+static const struct attribute_group input_dev_id_attr_group = {
 	.name	= "id",
 	.attrs	= input_dev_id_attrs,
 };
@@ -1027,7 +1027,7 @@ INPUT_DEV_CAP_ATTR(SND, snd);
 INPUT_DEV_CAP_ATTR(FF, ff);
 INPUT_DEV_CAP_ATTR(SW, sw);
 
-static struct attribute *input_dev_caps_attrs[] = {
+static struct attribute *const input_dev_caps_attrs[] = {
 	&dev_attr_ev.attr,
 	&dev_attr_key.attr,
 	&dev_attr_rel.attr,
@@ -1040,12 +1040,12 @@ static struct attribute *input_dev_caps_
 	NULL
 };
 
-static struct attribute_group input_dev_caps_attr_group = {
+static const struct attribute_group input_dev_caps_attr_group = {
 	.name	= "capabilities",
 	.attrs	= input_dev_caps_attrs,
 };
 
-static struct attribute_group *input_dev_attr_groups[] = {
+static const struct attribute_group *const input_dev_attr_groups[] = {
 	&input_dev_attr_group,
 	&input_dev_id_attr_group,
 	&input_dev_caps_attr_group,
--- 2.6.24-rc7-const.orig/drivers/input/keyboard/atkbd.c
+++ 2.6.24-rc7-const/drivers/input/keyboard/atkbd.c
@@ -263,7 +263,7 @@ static struct device_attribute atkbd_att
 
 ATKBD_DEFINE_RO_ATTR(err_count);
 
-static struct attribute *atkbd_attributes[] = {
+static struct attribute *const atkbd_attributes[] = {
 	&atkbd_attr_extra.attr,
 	&atkbd_attr_scroll.attr,
 	&atkbd_attr_set.attr,
@@ -273,7 +273,7 @@ static struct attribute *atkbd_attribute
 	NULL
 };
 
-static struct attribute_group atkbd_attribute_group = {
+static const struct attribute_group atkbd_attribute_group = {
 	.attrs	= atkbd_attributes,
 };
 
--- 2.6.24-rc7-const.orig/drivers/input/mouse/psmouse-base.c
+++ 2.6.24-rc7-const/drivers/input/mouse/psmouse-base.c
@@ -81,7 +81,7 @@ PSMOUSE_DEFINE_ATTR(resync_time, S_IWUSR
 			(void *) offsetof(struct psmouse, resync_time),
 			psmouse_show_int_attr, psmouse_set_int_attr);
 
-static struct attribute *psmouse_attributes[] = {
+static struct attribute *const psmouse_attributes[] = {
 	&psmouse_attr_protocol.dattr.attr,
 	&psmouse_attr_rate.dattr.attr,
 	&psmouse_attr_resolution.dattr.attr,
@@ -90,7 +90,7 @@ static struct attribute *psmouse_attribu
 	NULL
 };
 
-static struct attribute_group psmouse_attribute_group = {
+static const struct attribute_group psmouse_attribute_group = {
 	.attrs	= psmouse_attributes,
 };
 
--- 2.6.24-rc7-const.orig/drivers/input/serio/serio.c
+++ 2.6.24-rc7-const/drivers/input/serio/serio.c
@@ -443,7 +443,7 @@ static DEVICE_ATTR(proto, S_IRUGO, serio
 static DEVICE_ATTR(id, S_IRUGO, serio_show_id_id, NULL);
 static DEVICE_ATTR(extra, S_IRUGO, serio_show_id_extra, NULL);
 
-static struct attribute *serio_device_id_attrs[] = {
+static struct attribute *const serio_device_id_attrs[] = {
 	&dev_attr_type.attr,
 	&dev_attr_proto.attr,
 	&dev_attr_id.attr,
@@ -451,7 +451,7 @@ static struct attribute *serio_device_id
 	NULL
 };
 
-static struct attribute_group serio_id_attr_group = {
+static const struct attribute_group serio_id_attr_group = {
 	.name	= "id",
 	.attrs	= serio_device_id_attrs,
 };
--- 2.6.24-rc7-const.orig/drivers/misc/thinkpad_acpi.c
+++ 2.6.24-rc7-const/drivers/misc/thinkpad_acpi.c
@@ -644,7 +644,7 @@ static void tpacpi_remove_driver_attribu
 
 struct attribute_set_obj {
 	struct attribute_set s;
-	struct attribute *a;
+	struct attribute *a[1];
 } __attribute__((packed));
 
 static struct attribute_set *create_attr_set(unsigned int max_members,
@@ -662,7 +662,7 @@ static struct attribute_set *create_attr
 	if (!sobj)
 		return NULL;
 	sobj->s.max_members = max_members;
-	sobj->s.group.attrs = &sobj->a;
+	sobj->s.group.attrs = sobj->a;
 	sobj->s.group.name = name;
 
 	return &sobj->s;
@@ -677,7 +677,7 @@ static int add_to_attr_set(struct attrib
 	if (s->members >= s->max_members)
 		return -ENOMEM;
 
-	s->group.attrs[s->members] = attr;
+	container_of(s, struct attribute_set_obj, s)->a[s->members] = attr;
 	s->members++;
 
 	return 0;
--- 2.6.24-rc7-const.orig/drivers/s390/cio/css.h
+++ 2.6.24-rc7-const/drivers/s390/cio/css.h
@@ -191,5 +191,5 @@ int sch_is_pseudo_sch(struct subchannel 
 
 extern struct workqueue_struct *slow_path_wq;
 
-extern struct attribute_group *subch_attr_groups[];
+extern const struct attribute_group *const subch_attr_groups[];
 #endif
--- 2.6.24-rc7-const.orig/drivers/s390/cio/device.c
+++ 2.6.24-rc7-const/drivers/s390/cio/device.c
@@ -570,22 +570,22 @@ static DEVICE_ATTR(online, 0644, online_
 extern struct device_attribute dev_attr_cmb_enable;
 static DEVICE_ATTR(availability, 0444, available_show, NULL);
 
-static struct attribute * subch_attrs[] = {
+static struct attribute *const subch_attrs[] = {
 	&dev_attr_chpids.attr,
 	&dev_attr_pimpampom.attr,
 	NULL,
 };
 
-static struct attribute_group subch_attr_group = {
+static const struct attribute_group subch_attr_group = {
 	.attrs = subch_attrs,
 };
 
-struct attribute_group *subch_attr_groups[] = {
+const struct attribute_group *const subch_attr_groups[] = {
 	&subch_attr_group,
 	NULL,
 };
 
-static struct attribute * ccwdev_attrs[] = {
+static struct attribute *const ccwdev_attrs[] = {
 	&dev_attr_devtype.attr,
 	&dev_attr_cutype.attr,
 	&dev_attr_modalias.attr,
@@ -595,11 +595,11 @@ static struct attribute * ccwdev_attrs[]
 	NULL,
 };
 
-static struct attribute_group ccwdev_attr_group = {
+static const struct attribute_group ccwdev_attr_group = {
 	.attrs = ccwdev_attrs,
 };
 
-static struct attribute_group *ccwdev_attr_groups[] = {
+static const struct attribute_group *const ccwdev_attr_groups[] = {
 	&ccwdev_attr_group,
 	NULL,
 };
--- 2.6.24-rc7-const.orig/drivers/scsi/scsi_sysfs.c
+++ 2.6.24-rc7-const/drivers/scsi/scsi_sysfs.c
@@ -678,7 +678,7 @@ sdev_store_evt_##name(struct device *dev
 DECLARE_EVT(media_change, MEDIA_CHANGE)
 
 /* Default template for device attributes.  May NOT be modified */
-static struct attribute *scsi_sdev_attrs[] = {
+static struct attribute *const scsi_sdev_attrs[] = {
 	&dev_attr_device_blocked.attr,
 	&dev_attr_type.attr,
 	&dev_attr_scsi_level.attr,
@@ -698,11 +698,11 @@ static struct attribute *scsi_sdev_attrs
 	NULL
 };
 
-static struct attribute_group scsi_sdev_attr_group = {
+static const struct attribute_group scsi_sdev_attr_group = {
 	.attrs =	scsi_sdev_attrs,
 };
 
-static struct attribute_group *scsi_sdev_attr_groups[] = {
+static const struct attribute_group *const scsi_sdev_attr_groups[] = {
 	&scsi_sdev_attr_group,
 	NULL
 };
--- 2.6.24-rc7-const.orig/include/asm-powerpc/spu.h
+++ 2.6.24-rc7-const/include/asm-powerpc/spu.h
@@ -276,8 +276,8 @@ void unregister_spu_syscalls(struct spuf
 int spu_add_sysdev_attr(struct sysdev_attribute *attr);
 void spu_remove_sysdev_attr(struct sysdev_attribute *attr);
 
-int spu_add_sysdev_attr_group(struct attribute_group *attrs);
-void spu_remove_sysdev_attr_group(struct attribute_group *attrs);
+int spu_add_sysdev_attr_group(const struct attribute_group *attrs);
+void spu_remove_sysdev_attr_group(const struct attribute_group *attrs);
 
 
 /*
--- 2.6.24-rc7-const.orig/include/linux/cpu.h
+++ 2.6.24-rc7-const/include/linux/cpu.h
@@ -38,8 +38,8 @@ extern struct sys_device *get_cpu_sysdev
 extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
 extern void cpu_remove_sysdev_attr(struct sysdev_attribute *attr);
 
-extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
-extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
+extern int cpu_add_sysdev_attr_group(const struct attribute_group *attrs);
+extern void cpu_remove_sysdev_attr_group(const struct attribute_group *attrs);
 
 extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls);
 
--- 2.6.24-rc7-const.orig/include/linux/device.h
+++ 2.6.24-rc7-const/include/linux/device.h
@@ -260,7 +260,7 @@ struct class_device {
 	struct device		* dev;		/* not necessary, but nice to have */
 	void			* class_data;	/* class-specific data */
 	struct class_device	*parent;	/* parent of this child device, if there is one */
-	struct attribute_group  ** groups;	/* optional groups */
+	const struct attribute_group *const *groups; /* optional groups */
 
 	void	(*release)(struct class_device *dev);
 	int	(*uevent)(struct class_device *dev, struct kobj_uevent_env *env);
@@ -330,7 +330,7 @@ extern void class_device_destroy(struct 
  */
 struct device_type {
 	const char *name;
-	struct attribute_group **groups;
+	const struct attribute_group *const *groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	void (*release)(struct device *dev);
 	int (*suspend)(struct device * dev, pm_message_t state);
@@ -446,7 +446,7 @@ struct device {
 	struct list_head	node;
 	struct class		*class;
 	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
-	struct attribute_group	**groups;	/* optional groups */
+	const struct attribute_group *const *groups; /* optional groups */
 
 	void	(*release)(struct device * dev);
 };
--- 2.6.24-rc7-const.orig/include/linux/netdevice.h
+++ 2.6.24-rc7-const/include/linux/netdevice.h
@@ -709,7 +709,7 @@ struct net_device
 	/* class/net/name entry */
 	struct device		dev;
 	/* space for optional statistics and wireless sysfs groups */
-	struct attribute_group  *sysfs_groups[3];
+	const struct attribute_group  *sysfs_groups[3];
 
 	/* rtnetlink link ops */
 	const struct rtnl_link_ops *rtnl_link_ops;
--- 2.6.24-rc7-const.orig/include/linux/sysfs.h
+++ 2.6.24-rc7-const/include/linux/sysfs.h
@@ -32,7 +32,7 @@ struct attribute {
 
 struct attribute_group {
 	const char		*name;
-	struct attribute	**attrs;
+	struct attribute	*const *attrs;
 };
 
 
--- 2.6.24-rc7-const.orig/include/linux/transport_class.h
+++ 2.6.24-rc7-const/include/linux/transport_class.h
@@ -55,7 +55,7 @@ struct anon_transport_class cls = {				\
 
 struct transport_container {
 	struct attribute_container ac;
-	struct attribute_group *statistics;
+	const struct attribute_group *statistics;
 };
 
 #define attribute_container_to_transport_container(x) \
--- 2.6.24-rc7-const.orig/kernel/ksysfs.c
+++ 2.6.24-rc7-const/kernel/ksysfs.c
@@ -97,7 +97,7 @@ static struct bin_attribute notes_attr =
 decl_subsys(kernel, NULL, NULL);
 EXPORT_SYMBOL_GPL(kernel_subsys);
 
-static struct attribute * kernel_attrs[] = {
+static struct attribute *const kernel_attrs[] = {
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
 	&uevent_seqnum_attr.attr,
 	&uevent_helper_attr.attr,
@@ -110,7 +110,7 @@ static struct attribute * kernel_attrs[]
 	NULL
 };
 
-static struct attribute_group kernel_attr_group = {
+static const struct attribute_group kernel_attr_group = {
 	.attrs = kernel_attrs,
 };
 
--- 2.6.24-rc7-const.orig/kernel/module.c
+++ 2.6.24-rc7-const/kernel/module.c
@@ -1007,11 +1007,10 @@ static void add_sect_attrs(struct module
 
 	/* Setup section attributes. */
 	sect_attrs->grp.name = "sections";
-	sect_attrs->grp.attrs = (void *)sect_attrs + size[0];
+	sect_attrs->grp.attrs = gattr = (void *)sect_attrs + size[0];
 
 	sect_attrs->nsections = 0;
 	sattr = &sect_attrs->attrs[0];
-	gattr = &sect_attrs->grp.attrs[0];
 	for (i = 0; i < nsect; i++) {
 		if (! (sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
--- 2.6.24-rc7-const.orig/kernel/params.c
+++ 2.6.24-rc7-const/kernel/params.c
@@ -477,10 +477,9 @@ param_sysfs_setup(struct module_kobject 
 		return ERR_PTR(-ENOMEM);
 
 	mp->grp.name = "parameters";
-	mp->grp.attrs = (void *)mp + size[0];
+	mp->grp.attrs = gattr = (void *)mp + size[0];
 
 	pattr = &mp->attrs[0];
-	gattr = &mp->grp.attrs[0];
 	for (i = 0; i < num_params; i++) {
 		struct kernel_param *kp = &kparam[i];
 		if (kp->perm) {
--- 2.6.24-rc7-const.orig/kernel/power/disk.c
+++ 2.6.24-rc7-const/kernel/power/disk.c
@@ -693,7 +693,7 @@ static ssize_t image_size_store(struct k
 
 power_attr(image_size);
 
-static struct attribute * g[] = {
+static struct attribute *const g[] = {
 	&disk_attr.attr,
 	&resume_attr.attr,
 	&image_size_attr.attr,
@@ -701,7 +701,7 @@ static struct attribute * g[] = {
 };
 
 
-static struct attribute_group attr_group = {
+static const struct attribute_group attr_group = {
 	.attrs = g,
 };
 
--- 2.6.24-rc7-const.orig/kernel/power/main.c
+++ 2.6.24-rc7-const/kernel/power/main.c
@@ -364,19 +364,19 @@ pm_trace_store(struct kset *kset, const 
 
 power_attr(pm_trace);
 
-static struct attribute * g[] = {
+static struct attribute *const g[] = {
 	&state_attr.attr,
 	&pm_trace_attr.attr,
 	NULL,
 };
 #else
-static struct attribute * g[] = {
+static struct attribute *const g[] = {
 	&state_attr.attr,
 	NULL,
 };
 #endif /* CONFIG_PM_TRACE */
 
-static struct attribute_group attr_group = {
+static const struct attribute_group attr_group = {
 	.attrs = g,
 };
 
--- 2.6.24-rc7-const.orig/mm/slub.c
+++ 2.6.24-rc7-const/mm/slub.c
@@ -3865,7 +3865,7 @@ static ssize_t defrag_ratio_store(struct
 SLAB_ATTR(defrag_ratio);
 #endif
 
-static struct attribute * slab_attrs[] = {
+static struct attribute *const slab_attrs[] = {
 	&slab_size_attr.attr,
 	&object_size_attr.attr,
 	&objs_per_slab_attr.attr,
@@ -3898,7 +3898,7 @@ static struct attribute * slab_attrs[] =
 	NULL
 };
 
-static struct attribute_group slab_attr_group = {
+static const struct attribute_group slab_attr_group = {
 	.attrs = slab_attrs,
 };
 
--- 2.6.24-rc7-const.orig/net/core/net-sysfs.c
+++ 2.6.24-rc7-const/net/core/net-sysfs.c
@@ -295,7 +295,7 @@ NETSTAT_ENTRY(tx_window_errors);
 NETSTAT_ENTRY(rx_compressed);
 NETSTAT_ENTRY(tx_compressed);
 
-static struct attribute *netstat_attrs[] = {
+static struct attribute *const netstat_attrs[] = {
 	&dev_attr_rx_packets.attr,
 	&dev_attr_tx_packets.attr,
 	&dev_attr_rx_bytes.attr,
@@ -323,7 +323,7 @@ static struct attribute *netstat_attrs[]
 };
 
 
-static struct attribute_group netstat_group = {
+static const struct attribute_group netstat_group = {
 	.name  = "statistics",
 	.attrs  = netstat_attrs,
 };
@@ -375,7 +375,7 @@ WIRELESS_SHOW(misc, discard.misc, fmt_de
 WIRELESS_SHOW(retries, discard.retries, fmt_dec);
 WIRELESS_SHOW(beacon, miss.beacon, fmt_dec);
 
-static struct attribute *wireless_attrs[] = {
+static struct attribute *const wireless_attrs[] = {
 	&dev_attr_status.attr,
 	&dev_attr_link.attr,
 	&dev_attr_level.attr,
@@ -389,7 +389,7 @@ static struct attribute *wireless_attrs[
 	NULL
 };
 
-static struct attribute_group wireless_group = {
+static const struct attribute_group wireless_group = {
 	.name = "wireless",
 	.attrs = wireless_attrs,
 };
@@ -457,7 +457,7 @@ void netdev_unregister_kobject(struct ne
 int netdev_register_kobject(struct net_device *net)
 {
 	struct device *dev = &(net->dev);
-	struct attribute_group **groups = net->sysfs_groups;
+	const struct attribute_group **groups = net->sysfs_groups;
 
 	device_initialize(dev);
 	dev->class = &net_class;


