Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbYHCP4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbYHCP4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbYHCP4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:56:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:46578 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240AbYHCP4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vWhSdHMVO9WuaSeljP+9G9YD2r18OxJH6Wlrniq/D3wNAf+WYpr9qgz1vD7296o15x
         93674iimg6nyV+s9NR5yyWCAxdN+Aw2KxTMmt32UfIxpO0v0AcnPU0lfCO7wGn20/mU5
         +cC6vAU9PGDlvTYAlaID3XakUEBKjTmCi8Jf4=
Subject: [rfc-patch, bugfix 1/2] x86-microcode: generic updates
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Oruba <peter.oruba@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Max Krasnyansky <maxk@qualcomm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 17:56:29 +0200
Message-Id: <1217778989.4912.53.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dmitry Adamushko <dmitry.adamushko@gmail.com>

(1) Introduce microcode_update_cpu() which is a generic routine to do ucode-updates (for both bootup-path
and system-resume-path);

(2) Adapt the logic of cpu-hotplug handlers;

(3) Fix a race with sched_setaffinity() in reload_store()

We introduce another mechanism to run ucode-updates on a target cpu
to replace set_cpus_allowed_ptr() being called from cpu-hotplug events

(which causes a bug#11197: http://www.ussg.iu.edu/hypermail/linux/kernel/0807.3/3791.html)

microcode_update_cpu() can be run either from start_secondary()
(perhaps via a function pointer) or scheduled via keventd (implemented by the following patch).

all in all, we remove more lines than we add (84/79)

(Almost)-Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---

--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -126,16 +126,16 @@ static DEFINE_MUTEX(microcode_mutex);
 
 static struct ucode_cpu_info {
 	int valid;
+	int resume;
 	unsigned int sig;
 	unsigned int pf;
 	unsigned int rev;
 	microcode_t *mc;
 } ucode_cpu_info[NR_CPUS];
 
-static void collect_cpu_info(int cpu_num)
+static void collect_cpu_info(int cpu_num, struct ucode_cpu_info *uci)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 	unsigned int val[2];
 
 	/* We should bind the task to the CPU */
@@ -569,79 +569,85 @@ static int cpu_request_microcode(int cpu)
 	return error;
 }
 
-static int apply_microcode_check_cpu(int cpu)
+static void microcode_fini_cpu(int cpu)
 {
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	cpumask_t old;
-	unsigned int val[2];
-	int err = 0;
 
-	/* Check if the microcode is available */
-	if (!uci->mc)
-		return 0;
+	mutex_lock(&microcode_mutex);
+	uci->valid = 0;
+	uci->resume = 0;
+	vfree(uci->mc);
+	uci->mc = NULL;
+	mutex_unlock(&microcode_mutex);
+}
 
-	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+static void microcode_set_cpu_frozen(int cpu)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	/* Check if the microcode we have in memory matches the CPU */
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64) || uci->sig != cpuid_eax(0x00000001))
-		err = -EINVAL;
+	mutex_lock(&microcode_mutex);
+	if (uci->valid)
+		uci->resume = 1;
+	mutex_unlock(&microcode_mutex);
+}
 
-	if (!err && ((c->x86_model >= 5) || (c->x86 > 6))) {
-		/* get processor flags from MSR 0x17 */
-		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
-		if (uci->pf != (1 << ((val[1] >> 18) & 7)))
-			err = -EINVAL;
-	}
+static int microcode_resume_cpu(int cpu, struct ucode_cpu_info *new_uci)
+{
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
-	if (!err) {
-		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-		/* see notes above for revision 1.07.  Apparent chip bug */
-		sync_core();
-		/* get the current revision from MSR 0x8B */
-		rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
-		if (uci->rev != val[1])
-			err = -EINVAL;
-	}
+	if (!uci->resume)
+		return 0;
+
+	uci->resume = 0;
 
-	if (!err)
+	/* Check if the 'cached' microcode is ok: */
+	if (!uci->mc)
+		return 1;
+
+	if (new_uci->sig == uci->sig &&
+	    new_uci->pf  == uci->pf &&
+	    new_uci->rev == uci->rev) {
 		apply_microcode(cpu);
-	else
-		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
-			" sig=0x%x, pf=0x%x, rev=0x%x\n",
-			cpu, uci->sig, uci->pf, uci->rev);
+	} else {
+		microcode_fini_cpu(cpu);
+		*uci = *new_uci;
+	}
 
-	set_cpus_allowed_ptr(current, &old);
-	return err;
+	return 1;
 }
 
-static void microcode_init_cpu(int cpu, int resume)
+void microcode_update_cpu(int cpu)
 {
-	cpumask_t old;
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu, 
+			      new_uci;
 
-	old = current->cpus_allowed;
+	memset(&new_uci, 0, sizeof(new_uci));
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
 	mutex_lock(&microcode_mutex);
-	collect_cpu_info(cpu);
-	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
-		cpu_request_microcode(cpu);
+	collect_cpu_info(cpu, &new_uci);
+
+	if (new_uci.valid) {
+		/*
+		 * Check if the system resume is in progress,
+		 * otherwise just request a firmware:
+		 */
+		if (!microcode_resume_cpu(cpu, &new_uci)) {
+			*uci = new_uci;
+
+			if (system_state == SYSTEM_RUNNING)
+				cpu_request_microcode(cpu);
+		}
+	}
 	mutex_unlock(&microcode_mutex);
-	set_cpus_allowed_ptr(current, &old);
 }
 
-static void microcode_fini_cpu(int cpu)
+static void microcode_init_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	cpumask_t old = current->cpus_allowed;
 
-	mutex_lock(&microcode_mutex);
-	uci->valid = 0;
-	vfree(uci->mc);
-	uci->mc = NULL;
-	mutex_unlock(&microcode_mutex);
+	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	microcode_update_cpu(cpu);
+	set_cpus_allowed_ptr(current, &old);
 }
 
 static ssize_t reload_store(struct sys_device *dev,
@@ -660,14 +666,15 @@ static ssize_t reload_store(struct sys_device *dev,
 		cpumask_t old = current->cpus_allowed;
 
 		get_online_cpus();
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-
-		mutex_lock(&microcode_mutex);
-		if (uci->valid)
-			err = cpu_request_microcode(cpu);
-		mutex_unlock(&microcode_mutex);
+		if (cpu_online(cpu)) {
+			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+			mutex_lock(&microcode_mutex);
+			if (uci->valid)
+				err = cpu_request_microcode(cpu);
+			mutex_unlock(&microcode_mutex);
+			set_cpus_allowed_ptr(current, &old);
+		}
 		put_online_cpus();
-		set_cpus_allowed_ptr(current, &old);
 	}
 	if (err)
 		return err;
@@ -706,7 +713,7 @@ static struct attribute_group mc_attr_group = {
 	.name = "microcode",
 };
 
-static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
+static int mc_sysdev_add(struct sys_device *sys_dev)
 {
 	int err, cpu = sys_dev->id;
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
@@ -721,16 +728,11 @@ static int __mc_sysdev_add(struct sys_device *sys_dev, int resume)
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu, resume);
+	microcode_init_cpu(cpu);
 
 	return 0;
 }
 
-static int mc_sysdev_add(struct sys_device *sys_dev)
-{
-	return __mc_sysdev_add(sys_dev, 0);
-}
-
 static int mc_sysdev_remove(struct sys_device *sys_dev)
 {
 	int cpu = sys_dev->id;
@@ -770,34 +772,27 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 
 	sys_dev = get_cpu_sysdev(cpu);
 	switch (action) {
-	case CPU_UP_CANCELED_FROZEN:
-		/* The CPU refused to come up during a system resume */
-		microcode_fini_cpu(cpu);
-		break;
 	case CPU_ONLINE:
-	case CPU_DOWN_FAILED:
-		mc_sysdev_add(sys_dev);
-		break;
 	case CPU_ONLINE_FROZEN:
-		/* System-wide resume is in progress, try to apply microcode */
-		if (apply_microcode_check_cpu(cpu)) {
-			/* The application of microcode failed */
-			microcode_fini_cpu(cpu);
-			__mc_sysdev_add(sys_dev, 1);
-			break;
-		}
+	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		if (sysfs_create_group(&sys_dev->kobj, &mc_attr_group))
 			printk(KERN_ERR "microcode: Failed to create the sysfs "
 				"group for CPU%d\n", cpu);
 		break;
 	case CPU_DOWN_PREPARE:
-		mc_sysdev_remove(sys_dev);
-		break;
 	case CPU_DOWN_PREPARE_FROZEN:
 		/* Suspend is in progress, only remove the interface */
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 		break;
+	case CPU_DEAD:
+	case CPU_UP_CANCELED_FROZEN:
+                /* The CPU refused to come up during a system resume */
+		microcode_fini_cpu(cpu);
+		break;
+	case CPU_DEAD_FROZEN:
+		microcode_set_cpu_frozen(cpu);
+		break;
 	}
 	return NOTIFY_OK;
 }


