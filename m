Return-Path: <linux-kernel-owner+w=401wt.eu-S935210AbZFPFjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210AbZFPFjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933639AbZFPFiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:38:52 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42708 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765394AbZFPFiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:38:51 -0400
Subject: [RFD PATCH 2/4] cpu: sysfs interface for hotplugging bunch of CPUs.
To: linux-kernel@vger.kernel.org
From: Gautham R Shenoy <ego@in.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       Rusty Russel <rusty@rustcorp.com.au>,
       Paul E McKenney <paulmck@us.ibm.com>, Nathan Lynch <ntl@pobox.com>,
       Ingo Molnar <mingo@elte.hu>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Shoahua Li <shaohua.li@linux.com>
Date: Tue, 16 Jun 2009 11:08:49 +0530
Message-ID: <20090616053849.30891.17453.stgit@sofia.in.ibm.com>
In-Reply-To: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
References: <20090616053431.30891.18682.stgit@sofia.in.ibm.com>
User-Agent: StGit/0.14.3.384.g9ab0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user can currently view the online and offline CPUs in the system through
the sysfs files named "online" and "offline" respectively which
are present in the directory /sys/devices/system/cpu/. These files currently
have 0444 permissions.

For the purpose of evacuation of a bunch of CPUs, we propose to extend this
same interface and make it 0644, by which the user can use the same interface
to bring a bunch of CPUs online or take a bunch of CPUs offline.

To do this, the user is required to echo the cpu-list which is expected to be
hotplugged.

Eg:

echo 2,3 > /sys/devices/system/cpu/offline #Offlines CPUs 2 and 3
echo 4 > /sys/devices/sytem/cpu/offline    #Offlines CPU 4
echo 2-4 > /sys/devices/system/cpu/online  #Onlines CPU 2,3,4

This patch changes the permissions of these sysfs files from 0444 to 0644.
It provides a dummy store function, which currently parses the input
provided by the user and copies them to another debug cpumask structure,
which can be accessed using the sysfs interfaces:
	/sys/devices/system/cpu/debug_offline
and
	/sys/devices/system/cpu/debug_online

Thus on performing a
	echo 2,3 > /sys/devices/system/cpu/offline
the operation
	cat /sys/devices/system/cpu/debug_offline
should yield
	2-3
as the result.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 drivers/base/cpu.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e62a4cc..7a15e7b 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -116,18 +116,54 @@ static ssize_t print_cpus_map(char *buf, const struct cpumask *map)
 	return n;
 }
 
-#define	print_cpus_func(type) \
+#define show_cpus_func(type)						\
 static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
 {									\
 	return print_cpus_map(buf, cpu_##type##_mask);			\
-}									\
-static struct sysdev_class_attribute attr_##type##_map = 		\
+}
+
+#define print_cpus_func(type)						\
+show_cpus_func(type);							\
+static struct sysdev_class_attribute attr_##type##_map =		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
 
-print_cpus_func(online);
 print_cpus_func(possible);
 print_cpus_func(present);
 
+static struct cpumask debug_offline_mask_data;
+static struct cpumask debug_online_mask_data;
+static struct cpumask *cpu_debug_offline_mask = &debug_offline_mask_data;
+static struct cpumask *cpu_debug_online_mask = &debug_online_mask_data;
+print_cpus_func(debug_offline);
+print_cpus_func(debug_online);
+
+show_cpus_func(online);
+static ssize_t store_cpus_online(struct sysdev_class *dev_class,
+					const char *buf, size_t count)
+{
+	ssize_t ret = count;
+	cpumask_var_t store_cpus_online_mask;
+
+	if (!alloc_cpumask_var(&store_cpus_online_mask, GFP_KERNEL))
+		return count;
+
+	ret = cpulist_parse(buf, store_cpus_online_mask);
+
+	if (ret < 0)
+		goto out;
+
+	cpumask_copy(cpu_debug_online_mask, store_cpus_online_mask);
+
+out:
+	free_cpumask_var(store_cpus_online_mask);
+	if (ret >= 0)
+		ret = count;
+	return ret;
+}
+static struct sysdev_class_attribute attr_online_map =
+	_SYSDEV_CLASS_ATTR(online, 0644, print_cpus_online,
+						store_cpus_online);
+
 /*
  * Print values for NR_CPUS and offlined cpus
  */
@@ -168,7 +204,31 @@ static ssize_t print_cpus_offline(struct sysdev_class *class, char *buf)
 	n += snprintf(&buf[n], len - n, "\n");
 	return n;
 }
-static SYSDEV_CLASS_ATTR(offline, 0444, print_cpus_offline, NULL);
+
+static ssize_t store_cpus_offline(struct sysdev_class *dev_class,
+					const char *buf, size_t count)
+{
+	ssize_t ret = count;
+	cpumask_var_t store_cpus_offline_mask;
+
+	if (!alloc_cpumask_var(&store_cpus_offline_mask, GFP_KERNEL))
+		return count;
+
+	ret = cpulist_parse(buf, store_cpus_offline_mask);
+
+	if (ret < 0)
+		goto out;
+
+	cpumask_copy(cpu_debug_offline_mask, store_cpus_offline_mask);
+
+out:
+	free_cpumask_var(store_cpus_offline_mask);
+	if (ret >= 0)
+		ret = count;
+	return ret;
+}
+static SYSDEV_CLASS_ATTR(offline, 0644, print_cpus_offline,
+						store_cpus_offline);
 
 static struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_online_map,
@@ -176,6 +236,8 @@ static struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_present_map,
 	&attr_kernel_max,
 	&attr_offline,
+	&attr_debug_online_map,
+	&attr_debug_offline_map,
 };
 
 static int cpu_states_init(void)

