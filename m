Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbXHWAZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbXHWAZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXHWAZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:25:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXHWAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:25:04 -0400
Date: Thu, 23 Aug 2007 06:07:50 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Tony Luck <tony.luck@intel.com>
cc: Stephane Eranian <eranian@hpl.hp.com>, Ashok Raj <ashok.raj@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ia64 tree-wide: Misc __cpu{initdata, init, exit}
 annotations
Message-ID: <alpine.LFD.0.999.0708230601560.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* palinfo.c:

palinfo_cpu_notifier is a CPU hotplug notifier_block, and can be
marked __cpuinitdata, and the callback function palinfo_cpu_callback()
itself can be marked __cpuinit. create_palinfo_proc_entries() is only
called from __cpuinit callback or general __init code, therefore a
candidate for __cpuinit itself. remove_palinfo_proc_entries() is only
called from __cpuinit callback or general __exit code, therefore a
candidate for __cpuexit.

* salinfo.c:

The CPU hotplug notifier_block can be __cpuinitdata. The callback
salinfo_cpu_callback() is incorrectly marked __devinit -- it must
be __cpuinit instead.

* topology.c:

cache_sysfs_init() is only called at device_initcall() time so marking
it as __cpuinit is wrong and wasteful. It should be unconditionally
__init. Also cleanup reference to hotplug notifier callback function
from this function and replace with cache_add_dev(), which could also
enable us to use other tricks to replace __cpuinit{data} annotations,
as recently discussed on this list.

cache_shared_cpu_map_setup() is only ever called from __cpuinit-marked
functions hence both its definitions (SMP or !SMP) are candidates for
__cpuinit itself. Also all_cpu_cache_info can be __cpuinitdata because
only referenced from __cpuinit code.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 arch/ia64/kernel/palinfo.c  |    8 ++++----
 arch/ia64/kernel/salinfo.c  |    4 ++--
 arch/ia64/kernel/topology.c |   12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index 85829e2..ce19899 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -907,7 +907,7 @@ palinfo_read_entry(char *page, char **start, off_t off, int count, int *eof, voi
 	return len;
 }
 
-static void
+static void __cpuinit
 create_palinfo_proc_entries(unsigned int cpu)
 {
 #	define CPUSTR	"cpu%d"
@@ -947,7 +947,7 @@ create_palinfo_proc_entries(unsigned int cpu)
 	}
 }
 
-static void
+static void __cpuexit
 remove_palinfo_proc_entries(unsigned int hcpu)
 {
 	int j;
@@ -968,7 +968,7 @@ remove_palinfo_proc_entries(unsigned int hcpu)
 	}
 }
 
-static int palinfo_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit palinfo_cpu_callback(struct notifier_block *nfb,
 					unsigned long action, void *hcpu)
 {
 	unsigned int hotcpu = (unsigned long)hcpu;
@@ -986,7 +986,7 @@ static int palinfo_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block palinfo_cpu_notifier =
+static struct notifier_block palinfo_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = palinfo_cpu_callback,
 	.priority = 0,
diff --git a/arch/ia64/kernel/salinfo.c b/arch/ia64/kernel/salinfo.c
index 25cd75f..779c3cc 100644
--- a/arch/ia64/kernel/salinfo.c
+++ b/arch/ia64/kernel/salinfo.c
@@ -574,7 +574,7 @@ static const struct file_operations salinfo_data_fops = {
 	.write   = salinfo_log_write,
 };
 
-static int __devinit
+static int __cpuinit
 salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	unsigned int i, cpu = (unsigned long)hcpu;
@@ -615,7 +615,7 @@ salinfo_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu
 	return NOTIFY_OK;
 }
 
-static struct notifier_block salinfo_cpu_notifier =
+static struct notifier_block salinfo_cpu_notifier __cpuinitdata =
 {
 	.notifier_call = salinfo_cpu_callback,
 	.priority = 0,
diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index 94ae3c8..14261fe 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -118,11 +118,11 @@ struct cpu_cache_info {
 	struct kobject kobj;
 };
 
-static struct cpu_cache_info	all_cpu_cache_info[NR_CPUS];
+static struct cpu_cache_info	all_cpu_cache_info[NR_CPUS] __cpuinitdata;
 #define LEAF_KOBJECT_PTR(x,y)    (&all_cpu_cache_info[x].cache_leaves[y])
 
 #ifdef CONFIG_SMP
-static void cache_shared_cpu_map_setup( unsigned int cpu,
+static void __cpuinit cache_shared_cpu_map_setup( unsigned int cpu,
 		struct cache_info * this_leaf)
 {
 	pal_cache_shared_info_t	csi;
@@ -157,7 +157,7 @@ static void cache_shared_cpu_map_setup( unsigned int cpu,
 				&csi) == PAL_STATUS_SUCCESS);
 }
 #else
-static void cache_shared_cpu_map_setup(unsigned int cpu,
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu,
 		struct cache_info * this_leaf)
 {
 	cpu_set(cpu, this_leaf->shared_cpu_map);
@@ -428,13 +428,13 @@ static struct notifier_block __cpuinitdata cache_cpu_notifier =
 	.notifier_call = cache_cpu_callback
 };
 
-static int __cpuinit cache_sysfs_init(void)
+static int __init cache_sysfs_init(void)
 {
 	int i;
 
 	for_each_online_cpu(i) {
-		cache_cpu_callback(&cache_cpu_notifier, CPU_ONLINE,
-				(void *)(long)i);
+		struct sys_device *sys_dev = get_cpu_sysdev((unsigned int)i);
+		cache_add_dev(sys_dev);
 	}
 
 	register_hotcpu_notifier(&cache_cpu_notifier);
