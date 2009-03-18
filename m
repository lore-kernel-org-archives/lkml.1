Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZCRM7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZCRM7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758036AbZCRM7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:59:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:58521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040AbZCRM7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:59:00 -0400
Date: Wed, 18 Mar 2009 12:57:36 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peter.oruba@amd.com, rusty@rustcorp.com.au, akpm@linux-foundation.org,
       dmitry.adamushko@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peter.oruba@amd.com, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       dmitry.adamushko@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200903111632.37279.rusty@rustcorp.com.au>
References: <200903111632.37279.rusty@rustcorp.com.au>
Subject: [tip:cpus4096] x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c
Message-ID: <tip-af5c820a3169e81af869c113e18ec7588836cd50@git.kernel.org>
Git-Commit-ID: af5c820a3169e81af869c113e18ec7588836cd50
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 12:57:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af5c820a3169e81af869c113e18ec7588836cd50
Gitweb:     http://git.kernel.org/tip/af5c820a3169e81af869c113e18ec7588836cd50
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Wed, 11 Mar 2009 16:32:36 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 13:50:47 +0100

x86: cpumask: use work_on_cpu in arch/x86/kernel/microcode_core.c

Impact: don't play with current's cpumask

Straightforward indirection through work_on_cpu().  One change is
that the error code from microcode_update_cpu() is now actually
plumbed back to microcode_init_cpu(), so now we printk if it fails
on cpu hotplug.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Oruba <peter.oruba@amd.com>
LKML-Reference: <200903111632.37279.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/microcode_core.c |  106 ++++++++++++++++++++++----------------
 1 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index c9b721b..9a8dbc0 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -108,29 +108,40 @@ struct ucode_cpu_info ucode_cpu_info[NR_CPUS];
 EXPORT_SYMBOL_GPL(ucode_cpu_info);
 
 #ifdef CONFIG_MICROCODE_OLD_INTERFACE
+struct update_for_cpu {
+	const void __user *buf;
+	size_t size;
+};
+
+static long update_for_cpu(void *_ufc)
+{
+	struct update_for_cpu *ufc = _ufc;
+	int error;
+
+	error = microcode_ops->request_microcode_user(smp_processor_id(),
+						      ufc->buf, ufc->size);
+	if (error < 0)
+		return error;
+	if (!error)
+		microcode_ops->apply_microcode(smp_processor_id());
+	return error;
+}
+
 static int do_microcode_update(const void __user *buf, size_t size)
 {
-	cpumask_t old;
 	int error = 0;
 	int cpu;
-
-	old = current->cpus_allowed;
+	struct update_for_cpu ufc = { .buf = buf, .size = size };
 
 	for_each_online_cpu(cpu) {
 		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 		if (!uci->valid)
 			continue;
-
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-		error = microcode_ops->request_microcode_user(cpu, buf, size);
+		error = work_on_cpu(cpu, update_for_cpu, &ufc);
 		if (error < 0)
-			goto out;
-		if (!error)
-			microcode_ops->apply_microcode(cpu);
+			break;
 	}
-out:
-	set_cpus_allowed_ptr(current, &old);
 	return error;
 }
 
@@ -205,11 +216,26 @@ MODULE_ALIAS_MISCDEV(MICROCODE_MINOR);
 /* fake device for request_firmware */
 static struct platform_device *microcode_pdev;
 
+static long reload_for_cpu(void *unused)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
+	int err = 0;
+
+	mutex_lock(&microcode_mutex);
+	if (uci->valid) {
+		err = microcode_ops->request_microcode_fw(smp_processor_id(),
+							  &microcode_pdev->dev);
+		if (!err)
+			microcode_ops->apply_microcode(smp_processor_id());
+	}
+	mutex_unlock(&microcode_mutex);
+	return err;
+}
+
 static ssize_t reload_store(struct sys_device *dev,
 			    struct sysdev_attribute *attr,
 			    const char *buf, size_t sz)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + dev->id;
 	char *end;
 	unsigned long val = simple_strtoul(buf, &end, 0);
 	int err = 0;
@@ -218,21 +244,9 @@ static ssize_t reload_store(struct sys_device *dev,
 	if (end == buf)
 		return -EINVAL;
 	if (val == 1) {
-		cpumask_t old = current->cpus_allowed;
-
 		get_online_cpus();
-		if (cpu_online(cpu)) {
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-			mutex_lock(&microcode_mutex);
-			if (uci->valid) {
-				err = microcode_ops->request_microcode_fw(cpu,
-						&microcode_pdev->dev);
-				if (!err)
-					microcode_ops->apply_microcode(cpu);
-			}
-			mutex_unlock(&microcode_mutex);
-			set_cpus_allowed_ptr(current, &old);
-		}
+		if (cpu_online(cpu))
+			err = work_on_cpu(cpu, reload_for_cpu, NULL);
 		put_online_cpus();
 	}
 	if (err)
@@ -328,9 +342,9 @@ static int microcode_resume_cpu(int cpu)
 	return 0;
 }
 
-static void microcode_update_cpu(int cpu)
+static long microcode_update_cpu(void *unused)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_cpu_info *uci = ucode_cpu_info + smp_processor_id();
 	int err = 0;
 
 	/*
@@ -338,30 +352,27 @@ static void microcode_update_cpu(int cpu)
 	 * otherwise just request a firmware:
 	 */
 	if (uci->valid) {
-		err = microcode_resume_cpu(cpu);
+		err = microcode_resume_cpu(smp_processor_id());
 	} else {	
-		collect_cpu_info(cpu);
+		collect_cpu_info(smp_processor_id());
 		if (uci->valid && system_state == SYSTEM_RUNNING)
-			err = microcode_ops->request_microcode_fw(cpu,
+			err = microcode_ops->request_microcode_fw(
+					smp_processor_id(),
 					&microcode_pdev->dev);
 	}
 	if (!err)
-		microcode_ops->apply_microcode(cpu);
+		microcode_ops->apply_microcode(smp_processor_id());
+	return err;
 }
 
-static void microcode_init_cpu(int cpu)
+static int microcode_init_cpu(int cpu)
 {
-	cpumask_t old = current->cpus_allowed;
-
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	/* We should bind the task to the CPU */
-	BUG_ON(raw_smp_processor_id() != cpu);
-
+	int err;
 	mutex_lock(&microcode_mutex);
-	microcode_update_cpu(cpu);
+	err = work_on_cpu(cpu, microcode_update_cpu, NULL);
 	mutex_unlock(&microcode_mutex);
 
-	set_cpus_allowed_ptr(current, &old);
+	return err;
 }
 
 static int mc_sysdev_add(struct sys_device *sys_dev)
@@ -379,8 +390,11 @@ static int mc_sysdev_add(struct sys_device *sys_dev)
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu);
-	return 0;
+	err = microcode_init_cpu(cpu);
+	if (err)
+		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
+
+	return err;
 }
 
 static int mc_sysdev_remove(struct sys_device *sys_dev)
@@ -404,7 +418,7 @@ static int mc_sysdev_resume(struct sys_device *dev)
 		return 0;
 
 	/* only CPU 0 will apply ucode here */
-	microcode_update_cpu(0);
+	microcode_update_cpu(NULL);
 	return 0;
 }
 
@@ -424,7 +438,9 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		microcode_init_cpu(cpu);
+		if (microcode_init_cpu(cpu))
+			printk(KERN_ERR "microcode: failed to init CPU%d\n",
+			       cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("microcode: CPU%d added\n", cpu);
