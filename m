Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbXCYMKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbXCYMKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXCYMKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:10:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45601 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbXCYMKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:10:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim <maximlevitsky@gmail.com>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Sun, 25 Mar 2007 14:13:07 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
References: <200703211840.53242.maximlevitsky@gmail.com> <200703231542.45459.rjw@sisk.pl> <200703250240.39457.maximlevitsky@gmail.com>
In-Reply-To: <200703250240.39457.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703251413.07799.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 March 2007 01:40, Maxim wrote:
> On Friday 23 March 2007 16:42:44 Rafael J. Wysocki wrote:
> > On Friday, 23 March 2007 00:30, Rafael J. Wysocki wrote:
> > > On Thursday, 22 March 2007 00:53, Rafael J. Wysocki wrote:
> > > > On Thursday, 22 March 2007 00:39, Maxim wrote:
> > > > > On Thursday 22 March 2007 01:24:25 Rafael J. Wysocki wrote:
> > > > > > On Thursday, 22 March 2007 00:09, Maxim wrote:
> > > > > > > On Thursday 22 March 2007 00:39:02 you wrote:
> > > > > > > > On Wednesday, 21 March 2007 23:21, Pavel Machek wrote: 
> Hi,
> 	I confirm that the above patch works,
> 
> 	At least system didn't hang on resume with microcode driver loaded,
> 
> 	I can't really test whenever it did update microcode because I almost sure there is nothing to update
> 	(I use core 2 duo that I bought a month ago, and an intel motherboard with latest bios ( updated yesterday) )
> 	I selected this driver just in case when I compiled kernel.

OK, thanks for testing.

In the meantime I've prepared the more sophisticated version of the patch that is
appended.  Could you please check if it still works for you?

Greetings,
Rafael


---
 arch/i386/kernel/microcode.c |   71 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/cpu.h          |    2 +
 kernel/cpu.c                 |   32 +++++++++----------
 3 files changed, 85 insertions(+), 20 deletions(-)

Index: linux-2.6.21-rc4/arch/i386/kernel/microcode.c
===================================================================
--- linux-2.6.21-rc4.orig/arch/i386/kernel/microcode.c	2007-03-23 22:57:28.000000000 +0100
+++ linux-2.6.21-rc4/arch/i386/kernel/microcode.c	2007-03-23 23:43:27.000000000 +0100
@@ -567,6 +567,53 @@ static int cpu_request_microcode(int cpu
 	return error;
 }
 
+static int apply_microcode_on_cpu(int cpu)
+{
+	struct cpuinfo_x86 *c = cpu_data + cpu;
+	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	cpumask_t old;
+	unsigned int val[2];
+	int err = 0;
+
+	if (!uci->mc)
+		return -EINVAL;
+
+	old = current->cpus_allowed;
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+
+	/* Check if the microcode we have in memory matches the CPU */
+	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
+	    cpu_has(c, X86_FEATURE_IA64) || uci->sig != cpuid_eax(0x00000001))
+		err = -EINVAL;
+
+	if (!err && ((c->x86_model >= 5) || (c->x86 > 6))) {
+		/* get processor flags from MSR 0x17 */
+		rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
+		if (uci->pf != (1 << ((val[1] >> 18) & 7)))
+			err = -EINVAL;
+	}
+
+	if (!err) {
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		/* see notes above for revision 1.07.  Apparent chip bug */
+		sync_core();
+		/* get the current revision from MSR 0x8B */
+		rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
+		if (uci->rev != val[1])
+			err = -EINVAL;
+	}
+
+	if (!err)
+		apply_microcode(cpu);
+	else
+		printk(KERN_ERR "microcode: Could not apply microcode to CPU%d:"
+			" sig=0x%x, pf=0x%x, rev=0x%x\n",
+			cpu, uci->sig, uci->pf, uci->rev);
+
+	set_cpus_allowed(current, old);
+	return err;
+}
+
 static void microcode_init_cpu(int cpu)
 {
 	cpumask_t old;
@@ -577,7 +624,8 @@ static void microcode_init_cpu(int cpu)
 	set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
-	if (uci->valid && system_state == SYSTEM_RUNNING)
+	if (uci->valid && system_state == SYSTEM_RUNNING &&
+	    !suspend_cpu_hotplug)
 		cpu_request_microcode(cpu);
 	mutex_unlock(&microcode_mutex);
 	set_cpus_allowed(current, old);
@@ -663,13 +711,24 @@ static int mc_sysdev_add(struct sys_devi
 		return 0;
 
 	pr_debug("Microcode:CPU %d added\n", cpu);
-	memset(uci, 0, sizeof(*uci));
+	/* If suspend_cpu_hotplug is set, the system is resuming and we should
+	 * use the data from before the suspend.
+	 */
+	if (suspend_cpu_hotplug) {
+		err = apply_microcode_on_cpu(cpu);
+		if (err)
+			microcode_fini_cpu(cpu);
+	}
+	if (!uci->valid)
+		memset(uci, 0, sizeof(*uci));
 
 	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
 	if (err)
 		return err;
 
-	microcode_init_cpu(cpu);
+	if (!uci->valid)
+		microcode_init_cpu(cpu);
+
 	return 0;
 }
 
@@ -680,7 +739,11 @@ static int mc_sysdev_remove(struct sys_d
 	if (!cpu_online(cpu))
 		return 0;
 	pr_debug("Microcode:CPU %d removed\n", cpu);
-	microcode_fini_cpu(cpu);
+	/* If suspend_cpu_hotplug is set, the system is suspending and we should
+	 * keep the microcode in memory for the resume.
+	 */
+	if (!suspend_cpu_hotplug)
+		microcode_fini_cpu(cpu);
 	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 	return 0;
 }
Index: linux-2.6.21-rc4/include/linux/cpu.h
===================================================================
--- linux-2.6.21-rc4.orig/include/linux/cpu.h	2007-03-23 22:57:28.000000000 +0100
+++ linux-2.6.21-rc4/include/linux/cpu.h	2007-03-23 22:57:39.000000000 +0100
@@ -127,6 +127,8 @@ static inline int cpu_is_offline(int cpu
 #endif		/* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_SUSPEND_SMP
+extern int suspend_cpu_hotplug;
+
 extern int disable_nonboot_cpus(void);
 extern void enable_nonboot_cpus(void);
 #else
Index: linux-2.6.21-rc4/kernel/cpu.c
===================================================================
--- linux-2.6.21-rc4.orig/kernel/cpu.c	2007-03-23 22:57:28.000000000 +0100
+++ linux-2.6.21-rc4/kernel/cpu.c	2007-03-23 22:57:39.000000000 +0100
@@ -254,6 +254,12 @@ int __cpuinit cpu_up(unsigned int cpu)
 }
 
 #ifdef CONFIG_SUSPEND_SMP
+/* Needed to prevent the microcode driver from requesting firmware in its CPU
+ * hotplug notifier during the suspend/resume.
+ */
+int suspend_cpu_hotplug;
+EXPORT_SYMBOL(suspend_cpu_hotplug);
+
 static cpumask_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
@@ -261,16 +267,8 @@ int disable_nonboot_cpus(void)
 	int cpu, first_cpu, error = 0;
 
 	mutex_lock(&cpu_add_remove_lock);
-	first_cpu = first_cpu(cpu_present_map);
-	if (!cpu_online(first_cpu)) {
-		error = _cpu_up(first_cpu);
-		if (error) {
-			printk(KERN_ERR "Could not bring CPU%d up.\n",
-				first_cpu);
-			goto out;
-		}
-	}
-
+	suspend_cpu_hotplug = 1;
+	first_cpu = first_cpu(cpu_online_map);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
@@ -296,7 +294,7 @@ int disable_nonboot_cpus(void)
 	} else {
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
-out:
+	suspend_cpu_hotplug = 0;
 	mutex_unlock(&cpu_add_remove_lock);
 	return error;
 }
@@ -308,20 +306,22 @@ void enable_nonboot_cpus(void)
 	/* Allow everyone to use the CPU hotplug again */
 	mutex_lock(&cpu_add_remove_lock);
 	cpu_hotplug_disabled = 0;
-	mutex_unlock(&cpu_add_remove_lock);
 	if (cpus_empty(frozen_cpus))
-		return;
+		goto out;
 
+	suspend_cpu_hotplug = 1;
 	printk("Enabling non-boot CPUs ...\n");
 	for_each_cpu_mask(cpu, frozen_cpus) {
-		error = cpu_up(cpu);
+		error = _cpu_up(cpu);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
 			continue;
 		}
-		printk(KERN_WARNING "Error taking CPU%d up: %d\n",
-			cpu, error);
+		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
 	cpus_clear(frozen_cpus);
+	suspend_cpu_hotplug = 0;
+out:
+	mutex_unlock(&cpu_add_remove_lock);
 }
 #endif
