Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbYA3I45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbYA3I45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbYA3Ix4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:53:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:56345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758840AbYA3Ixy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:53:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,276,1199692800"; 
   d="scan'208";a="294287536"
Subject: [RFC PATCH 2.6.24] x86: add sysfs interface for cpuid module, try 2
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: tglx@linutronix.de
Cc: hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
Content-Type: text/plain
Organization: Intel
Date: Wed, 30 Jan 2008 07:41:20 +0800
Message-Id: <1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is try 2, it should cover VIA/Cyrix and Transmeta Crusoe, please
help to test it if anybody has VIA/Cyrix and Transmeta Crusoe. This patch just
makes users get cpuid raw data more conveniently by
/sys/devices/syste/cpu/cpu*/cpuid/* without using any userspace application.

Current cpuid module will create a char device for every logical cpu,
when a user cats /dev/cpu/*/cpuid, he/she will enter a limitless loop,
the root cause is that cpuid module doesn't decide wether a cpuid level
is valid, it just uses an offset to denote cpuid level and take it to
cpuid instruction, cpuid instruction will ignore it and return some data
specific to cpu model, cpuid doesn't an error return value because it is
void type. So cpuid module will execute cpuid continuously and return
data although most of data make no sense.

This patch tries to add a sysfs interface for cpuid, users can see all the
available cpuid levels, specify a specific level and get cpuid corresponding
to this cpuid level.

For every logical cpu, this patch will create a cpuid directory under
/sys/devices/system/cpu/cpu*/, there are three entries under cpuid:

avail_levels	cur_level	cur_cpuid

A user can get all the available cpuid levels from avail_levels, he/she can
set one available cpuid level to cur_level, then he/she can get cpuid from
cur_cpuid, cur_cpuid corresponds to cur_level.

Here are some example output:
[root@yangyi-dev /]# ls /sys/devices/system/cpu/cpu0/cpuid
avail_levels  cur_cpuid  cur_level
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpuid/avail_levels
0x00000000
0x00000001
0x00000002
0x00000003
0x00000004
0x00000005
0x00000006
0x00000007
0x00000008
0x00000009
0x0000000a
0x80000000
0x80000001
0x80000002
0x80000003
0x80000004
0x80000005
0x80000006
0x80000007
0x80000008
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpuid/cur_level
0x00000000
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpuid/cur_cpuid
0x0000000a 0x756e6547 0x6c65746e 0x49656e69
[root@yangyi-dev /]# echo 0x80000007 > /sys/devices/system/cpu/cpu0/cpuid/cur_level
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpuid/cur_cpuid
0x00000000 0x00000000 0x00000000 0x00000000
[root@yangyi-dev /]# echo 0x80000001 > /sys/devices/system/cpu/cpu0/cpuid/cur_level
[root@yangyi-dev /]# cat /sys/devices/system/cpu/cpu0/cpuid/cur_cpuid
0x00000000 0x00000000 0x00000001 0x20100000
[root@yangyi-dev /]# ls /sys/devices/system/cpu/cpu1/cpuid
avail_levels  cur_cpuid  cur_level
[root@yangyi-dev /]#

Signed-off-by: Yi Yang <yi.y.yang@intel.com>
---
 cpuid.c |  255 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 254 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpuid.c	2008-01-28 01:28:48.000000000 +0800
+++ b/arch/x86/kernel/cpuid.c	2008-01-30 07:31:40.000000000 +0800
@@ -175,6 +175,250 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpuid_class_cpu_callback,
 };
 
+struct cpuid_info {
+	int cpu;
+	unsigned int cur_level;
+	unsigned int min_level;
+	unsigned int max_level;
+	unsigned int min_ext_level;
+	unsigned int max_ext_level;
+	struct kobject kobj;
+};
+
+struct cpuid_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct cpuid_info *, char *);
+	ssize_t (*store)(struct cpuid_info *, const char *, size_t count);
+};
+
+static struct cpuid_info cpuid_infos[NR_CPUS];
+
+static cpumask_t cpu_map = CPU_MASK_NONE;
+
+#define A32(a, b, c, d) (((d) << 24) + ((c) << 16) + ((b) << 8) + (a))
+
+static int is_centaur(u32 *data)
+{
+	return data[1] == A32('C', 'e', 'n', 't') &&
+	       data[3] == A32('a', 'u', 'r', 'H') &&
+	       data[2] == A32('a', 'u', 'l', 's');
+}
+
+static int is_transmeta(u32 *data)
+{
+	return data[1] == A32('G', 'e', 'n', 'u') &&
+	       data[3] == A32('i', 'n', 'e', 'T') &&
+	       data[2] == A32('M', 'x', '8', '6');
+}
+
+static ssize_t show_cur_level(struct cpuid_info *cpuid_info_p, char *buf)
+{
+	return sprintf(buf, "0x%08x\n", cpuid_info_p->cur_level);
+}
+
+static ssize_t store_cur_level(struct cpuid_info *cpuid_info_p,
+				const char *buf, size_t count)
+{
+	char *p;
+	unsigned int val;
+	size_t len = 13;
+	char tmpbuf[16];
+
+	if ((count > len) || (count <= 0))
+		return -EINVAL;
+
+	len = count;
+	if (buf[count-1] == '\n')
+		 len--;
+
+	memcpy(tmpbuf, buf, len);
+	tmpbuf[len] = '\0';
+	val = simple_strtoul(tmpbuf, &p, 0);
+
+	if (*p != '\0')
+		return -EINVAL;
+	if (((val >= cpuid_info_p->min_level)
+		&& (val <= cpuid_info_p->max_level))
+		|| ((val >= cpuid_info_p->min_ext_level)
+		&& (val <= cpuid_info_p->max_ext_level))) {
+		cpuid_info_p->cur_level = val;
+		return count;
+	} else
+		return -EINVAL;
+}
+
+static ssize_t show_avail_levels(struct cpuid_info *cpuid_info_p, char *buf)
+{
+	unsigned int level;
+	ssize_t len = 0;
+
+	level = cpuid_info_p->min_level;
+	while (level <= cpuid_info_p->max_level) {
+		len += sprintf(buf + len, "0x%08x\n", level);
+		level++;
+	}
+
+	level = cpuid_info_p->min_ext_level;
+	while (level <= cpuid_info_p->max_ext_level) {
+		len += sprintf(buf + len, "0x%08x\n", level);
+		level++;
+	}
+	return len;
+}
+
+static ssize_t show_cur_cpuid(struct cpuid_info *cpuid_info_p, char *buf)
+{
+	u32 data[4];
+
+	do_cpuid(cpuid_info_p->cpu, cpuid_info_p->cur_level, data);
+	return sprintf(buf, "0x%08x 0x%08x 0x%08x 0x%08x\n",
+			data[0], data[1], data[2], data[3]);
+}
+
+static struct cpuid_attr cur_level =
+	__ATTR(cur_level, 0600, show_cur_level, store_cur_level);
+static struct cpuid_attr avail_levels =
+	__ATTR(avail_levels, 0400, show_avail_levels, NULL);
+static struct cpuid_attr cur_cpuid =
+	__ATTR(cur_cpuid, 0400, show_cur_cpuid, NULL);
+
+static struct attribute *default_attrs[] = {
+	&cur_level.attr,
+	&avail_levels.attr,
+	&cur_cpuid.attr,
+	NULL
+};
+#define to_cpuid_info(k) container_of(k, struct cpuid_info, kobj)
+#define to_cpuid_attr(a) container_of(a, struct cpuid_attr, attr)
+
+static ssize_t check_cpu(struct cpuid_info *cpuid_info_p)
+{
+	int cpu = cpuid_info_p->cpu;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+
+	if (cpu >= NR_CPUS || !cpu_online(cpu))
+		return -ENXIO;	/* No such CPU */
+	if (c->cpuid_level < 0)
+		return -EIO;	/* CPUID not supported */
+
+	return 0;
+}
+
+static ssize_t cpuid_show(struct kobject *kobj, struct attribute *attr,
+				char *buf)
+{
+	ssize_t ret;
+	struct cpuid_attr *fattr = to_cpuid_attr(attr);
+	struct cpuid_info *cpuid_info_p = to_cpuid_info(kobj);
+
+	ret = check_cpu(cpuid_info_p);
+	if (ret != 0)
+		return ret;
+
+	return fattr->show(cpuid_info_p, buf);
+}
+
+static ssize_t cpuid_store(struct kobject *kobj, struct attribute *attr,
+				const char *buf, size_t count)
+{
+	struct cpuid_attr *fattr = to_cpuid_attr(attr);
+	struct cpuid_info *cpuid_info_p = to_cpuid_info(kobj);
+	ssize_t ret;
+
+	ret = check_cpu(cpuid_info_p);
+	if (ret != 0)
+		return ret;
+
+	ret = fattr->store ? fattr->store(cpuid_info_p, buf, count) : 0;
+	return ret;
+}
+
+static void cpuid_sysfs_release(struct kobject *kobj)
+{
+}
+
+static struct sysfs_ops cpuid_sysfs_ops = {
+	.show   = cpuid_show,
+	.store  = cpuid_store,
+};
+
+static struct kobj_type ktype_cpuid = {
+	.sysfs_ops      = &cpuid_sysfs_ops,
+	.default_attrs  = default_attrs,
+	.release        = cpuid_sysfs_release,
+};
+
+static __init_refok int create_cpuid_sysfs(int cpu)
+{
+	struct sys_device *cpu_sys_dev = NULL;
+	u32 data[4];
+	int retval;
+	u32 ext_level = 0x80000000;
+
+	cpu_sys_dev = get_cpu_sysdev(cpu);
+	if (cpu_sys_dev == NULL)
+		return -1;
+
+	cpuid_infos[cpu].kobj.parent = &cpu_sys_dev->kobj;
+	kobject_set_name(&(cpuid_infos[cpu].kobj), "%s", "cpuid");
+	cpuid_infos[cpu].kobj.ktype = &ktype_cpuid;
+
+	do_cpuid(cpu, 0, data);
+	cpuid_infos[cpu].cpu = cpu;
+	cpuid_infos[cpu].cur_level = 0;
+	cpuid_infos[cpu].min_level = 0;
+	cpuid_infos[cpu].max_level = data[0];
+
+	if (is_centaur(data))
+		ext_level = 0xc0000000;
+	else if (is_transmeta(data))
+		ext_level = 0x80860000;
+
+	do_cpuid(cpu, ext_level, data);
+	cpuid_infos[cpu].min_ext_level = ext_level;
+	cpuid_infos[cpu].max_ext_level = data[0];
+
+	retval = kobject_register(&(cpuid_infos[cpu].kobj));
+	if (retval < 0) {
+		cpu_clear(cpu, cpu_map);
+		return retval;
+	}
+	cpu_set(cpu, cpu_map);
+	return 0;
+}
+
+static void remove_cpuid_sysfs(int cpu)
+{
+	if (cpu_isset(cpu, cpu_map)) {
+		cpu_clear(cpu, cpu_map);
+		kobject_unregister(&(cpuid_infos[cpu].kobj));
+		memset(&cpuid_infos[cpu], 0, sizeof(struct cpuid_info));
+	}
+}
+
+static int __init_refok cpuid_sysfs_cpu_callback(struct notifier_block *nfb,
+					      unsigned long action,
+					      void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		create_cpuid_sysfs(cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		remove_cpuid_sysfs(cpu);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __initdata_refok cpuid_sysfs_cpu_notifier = {
+	.notifier_call = cpuid_sysfs_cpu_callback,
+};
+
 static int __init cpuid_init(void)
 {
 	int i, err = 0;
@@ -195,8 +439,13 @@ static int __init cpuid_init(void)
 		err = cpuid_device_create(i);
 		if (err != 0) 
 			goto out_class;
+
+		err = create_cpuid_sysfs(i);
+		if (err != 0)
+			goto out_class;
 	}
 	register_hotcpu_notifier(&cpuid_class_cpu_notifier);
+	register_hotcpu_notifier(&cpuid_sysfs_cpu_notifier);
 
 	err = 0;
 	goto out;
@@ -205,6 +454,7 @@ out_class:
 	i = 0;
 	for_each_online_cpu(i) {
 		cpuid_device_destroy(i);
+		remove_cpuid_sysfs(i);
 	}
 	class_destroy(cpuid_class);
 out_chrdev:
@@ -217,11 +467,14 @@ static void __exit cpuid_exit(void)
 {
 	int cpu = 0;
 
-	for_each_online_cpu(cpu)
+	for_each_online_cpu(cpu) {
 		cpuid_device_destroy(cpu);
+		remove_cpuid_sysfs(cpu);
+	}
 	class_destroy(cpuid_class);
 	unregister_chrdev(CPUID_MAJOR, "cpu/cpuid");
 	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
+	unregister_hotcpu_notifier(&cpuid_sysfs_cpu_notifier);
 }
 
 module_init(cpuid_init);


