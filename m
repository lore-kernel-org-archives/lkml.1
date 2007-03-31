Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXCaXXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXCaXXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 19:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbXCaXXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 19:23:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48015 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXCaXXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 19:23:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] Fix microcode-related suspend problem
Date: Sun, 1 Apr 2007 01:26:47 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Pavel Machek <pavel@ucw.cz>, Maxim <maximlevitsky@gmail.com>
References: <200703312204.15752.rjw@sisk.pl> <20070331133532.0d791f6e.akpm@linux-foundation.org> <20070331212337.GF14134@stusta.de>
In-Reply-To: <20070331212337.GF14134@stusta.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200704010126.48305.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 31 March 2007 23:23, Adrian Bunk wrote:
> On Sat, Mar 31, 2007 at 01:35:32PM -0700, Andrew Morton wrote:
> > On Sat, 31 Mar 2007 22:04:15 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > This patch appeard on LMKL six days ago and there have not been any negative
> > > comments since then, so I think I can try to make it official.
> > > 
> > > ---
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Fix the regression resulting from the recent change of suspend code ordering
> > > that causes systems based on Intel x86 CPUs using the microcode driver to
> > > hang during the resume.
> > > 
> > > The problem occurs since the microcode driver uses request_firmware() in its
> > > CPU hotplug notifier, which is called after tasks has been frozen and hangs.
> > > It can be fixed by telling the microcode driver to use the microcode stored in
> > > memory during the resume instead of trying to load it from disk.
> > 
> > CONFIG_SMP=n:
> > 
> > arch/i386/kernel/microcode.c: In function 'microcode_init_cpu':
> > arch/i386/kernel/microcode.c:628: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> > arch/i386/kernel/microcode.c:628: error: (Each undeclared identifier is reported only once
> > arch/i386/kernel/microcode.c:628: error: for each function it appears in.)
> > arch/i386/kernel/microcode.c: In function 'mc_sysdev_add':
> > arch/i386/kernel/microcode.c:717: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> > arch/i386/kernel/microcode.c: In function 'mc_sysdev_remove':
> > arch/i386/kernel/microcode.c:745: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> > 
> > Given this, and the overall intrusiveness of the change, I'd worry about
> > trying to get this into 2.6.21.
> 
> It fixes a regression, and we are still at least one month away from the 
> release of 2.6.21.
> 
> 2.6.20 was released with too many known regressions [1], let's not 
> repeat this mistake with 2.6.21.

Okay, the appended version of the patch compiles with CONFIG_SMP unset too.

I think it could be done in a more elegant way, but that would require some
additional infrastructure, which definitely is not 2.6.21 material.

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Fix the regression resulting from the recent change of suspend code ordering
that causes systems based on Intel x86 CPUs using the microcode driver to
hang during the resume.

The problem occurs since the microcode driver uses request_firmware() in its
CPU hotplug notifier, which is called after tasks has been frozen and hangs.
It can be fixed by telling the microcode driver to use the microcode stored in
memory during the resume instead of trying to load it from disk.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/i386/kernel/microcode.c |   71 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/cpu.h          |    4 ++
 kernel/cpu.c                 |   32 +++++++++----------
 3 files changed, 87 insertions(+), 20 deletions(-)

Index: linux-2.6.21-rc5/arch/i386/kernel/microcode.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/microcode.c
+++ linux-2.6.21-rc5/arch/i386/kernel/microcode.c
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
Index: linux-2.6.21-rc5/include/linux/cpu.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/cpu.h
+++ linux-2.6.21-rc5/include/linux/cpu.h
@@ -127,9 +127,13 @@ static inline int cpu_is_offline(int cpu
 #endif		/* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_SUSPEND_SMP
+extern int suspend_cpu_hotplug;
+
 extern int disable_nonboot_cpus(void);
 extern void enable_nonboot_cpus(void);
 #else
+#define suspend_cpu_hotplug	0
+
 static inline int disable_nonboot_cpus(void) { return 0; }
 static inline void enable_nonboot_cpus(void) {}
 #endif
Index: linux-2.6.21-rc5/kernel/cpu.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/cpu.c
+++ linux-2.6.21-rc5/kernel/cpu.c
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
