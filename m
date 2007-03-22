Return-Path: <linux-kernel-owner+w=401wt.eu-S934173AbXCVX1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934173AbXCVX1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934147AbXCVX1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:27:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37197 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934215AbXCVX1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:27:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim <maximlevitsky@gmail.com>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Fri, 23 Mar 2007 00:30:28 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
References: <200703211840.53242.maximlevitsky@gmail.com> <200703220139.25071.maximlevitsky@gmail.com> <200703220053.54671.rjw@sisk.pl>
In-Reply-To: <200703220053.54671.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703230030.28746.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 March 2007 00:53, Rafael J. Wysocki wrote:
> On Thursday, 22 March 2007 00:39, Maxim wrote:
> > On Thursday 22 March 2007 01:24:25 Rafael J. Wysocki wrote:
> > > On Thursday, 22 March 2007 00:09, Maxim wrote:
> > > > On Thursday 22 March 2007 00:39:02 you wrote:
> > > > > On Wednesday, 21 March 2007 23:21, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > > Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> > > > > > > 
> > > > > > > I did a git-bisect and found that those commits break it:
> > > > > > > 
> > > > > > > e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> > > > > > > ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> > > > > > > 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> > > > > > > 
> > > > > > 
> > > > > > (Yep, it was in my "to analyze" queue).
> > > > > > 
> > > > > > > I already reported about it, but now i know the reason why suspend breaks.
> > > > > > > 
> > > > > > > The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> > > > > > > and it did work because those functions could be called only in process context
> > > > > > > (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> > > > > > > 
> > > > > > > But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> > > > > > > that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> > > > > > > 
> > > > > > 
> > > > > > Thanks for detailed explanation.
> > > > > > 
> > > > > > ...but, on my machine suspend works ok in -rc4. I'm not seeing this.
> > > > > > 
> > > > > > ...by design, "frozen" tasks must not hold any locks. If frozen task
> > > > > > holds a lock, that's a bug.
> > > > > > 
> > > > > > > Or, it is also possible to revert this change.
> > > > > > 
> > > > > > Are you using xfs?
> > > > > 
> > > > > Well, this is the only case that can trigger it.  There are no other freezable
> > > > > workqueues.
> > > > > 
> > > > > Greetings,
> > > > > Rafael
> > > > > 
> > > > 
> > > > Hello,
> > > > 
> > > > 	Yes, you are right and it is XFS
> > > > 
> > > > 	System suspends and resumes with xfs and your patch correctly,
> > > 
> > > Could you please sent this information to the list?  I'd like it to reach all
> > > of the CCed parites. ;-)
> > 
> > I did now ( sorry I just keep using this Answer command, instead of Answer to everybody)
> > I didn't intend to send private email.
> > > 
> > > > 	Of course I need to mention that I had to unload microcode update driver because it prevented resume,
> > > > 	because it calls firmware loader helper, and again sleeps on lock
> > > 
> > > This is interesting.  Did it happen before or is it a regression?
> > 
> > It is from the same group of bugs , I mean hang because cpu_up/down is called with frozen tasks
> > Of course it didn't happen before those reordering commits were introduced
> 
> Well, we want cpu_up/down to be called after processes have been frozen, for
> various reasons (one of them being that applications shouldn't see us playing
> with the CPUs).
> 
> Thanks for reporting this, I'll have a look at the microcode update driver.

Well, I have invented the appended workaround, but I'm not sure how much
sense it makes with respect to the microcode driver.  At least, it doesn't
break my AMD64 SMP setup. ;-)

Greetings,
Rafael

---
 arch/i386/kernel/microcode.c |   23 +++++++++++++++++++++--
 include/linux/cpu.h          |    2 ++
 kernel/cpu.c                 |   20 +++++++++++++++-----
 3 files changed, 38 insertions(+), 7 deletions(-)

Index: linux-2.6.21-rc4/arch/i386/kernel/microcode.c
===================================================================
--- linux-2.6.21-rc4.orig/arch/i386/kernel/microcode.c	2007-03-16 21:51:23.000000000 +0100
+++ linux-2.6.21-rc4/arch/i386/kernel/microcode.c	2007-03-22 23:55:40.000000000 +0100
@@ -703,6 +703,16 @@ static struct sysdev_driver mc_sysdev_dr
 	.resume = mc_sysdev_resume,
 };
 
+static __cpuinit void apply_microcode_on_cpu(int cpu)
+{
+	cpumask_t old;
+
+	old = current->cpus_allowed;
+	set_cpus_allowed(current, cpumask_of_cpu(cpu));
+	apply_microcode(cpu);
+	set_cpus_allowed(current, old);
+}
+
 static __cpuinit int
 mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
@@ -713,10 +723,19 @@ mc_cpu_callback(struct notifier_block *n
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
-		mc_sysdev_add(sys_dev);
+		if (suspend_cpu_hotplug)
+			/* This means we have been called during the resume.
+			 * This is not the real CPU hotplug and we don't need
+			 * to register the sysdev
+			 */
+			apply_microcode_on_cpu(cpu);
+		else
+			mc_sysdev_add(sys_dev);
 		break;
 	case CPU_DOWN_PREPARE:
-		mc_sysdev_remove(sys_dev);
+		/* During the suspend there is no need to remove the sysdev */
+		if (!suspend_cpu_hotplug)
+			mc_sysdev_remove(sys_dev);
 		break;
 	}
 	return NOTIFY_OK;
Index: linux-2.6.21-rc4/include/linux/cpu.h
===================================================================
--- linux-2.6.21-rc4.orig/include/linux/cpu.h	2007-03-16 21:51:34.000000000 +0100
+++ linux-2.6.21-rc4/include/linux/cpu.h	2007-03-22 23:55:54.000000000 +0100
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
--- linux-2.6.21-rc4.orig/kernel/cpu.c	2007-03-16 21:51:35.000000000 +0100
+++ linux-2.6.21-rc4/kernel/cpu.c	2007-03-23 00:05:41.000000000 +0100
@@ -254,6 +254,12 @@ int __cpuinit cpu_up(unsigned int cpu)
 }
 
 #ifdef CONFIG_SUSPEND_SMP
+/* Needed to prevent the microcode driver from playing with sysfs in its CPU
+ * hotplug notifier.
+ */
+int suspend_cpu_hotplug;
+EXPORT_SYMBOL(suspend_cpu_hotplug);
+
 static cpumask_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
@@ -261,6 +267,7 @@ int disable_nonboot_cpus(void)
 	int cpu, first_cpu, error = 0;
 
 	mutex_lock(&cpu_add_remove_lock);
+	suspend_cpu_hotplug = 1;
 	first_cpu = first_cpu(cpu_present_map);
 	if (!cpu_online(first_cpu)) {
 		error = _cpu_up(first_cpu);
@@ -297,6 +304,7 @@ int disable_nonboot_cpus(void)
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
 out:
+	suspend_cpu_hotplug = 0;
 	mutex_unlock(&cpu_add_remove_lock);
 	return error;
 }
@@ -308,20 +316,22 @@ void enable_nonboot_cpus(void)
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
