Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYIBL1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYIBL1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYIBL0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:26:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60342 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYIBL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:26:39 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080902126.215915333@firstfloor.org>
To: venkatesh.pallipadi@intel.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] MCE: Implement dynamic machine check banks support
Date: Tue,  2 Sep 2008 13:26:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Needs to be applied on top of the x86/unify-mce branch]

This patch replaces the hardcoded max number of machine check banks with 
dynamic allocation depending on what the CPU reports. The sysfs
data structures and the banks array are dynamically allocated.

There is still a hard bank limit (128) because the mcelog protocol uses
banks >= 128 as pseudo banks to escape other events. But we expect
that 128 banks is beyond any reasonable CPU for now.

This supersedes an earlier patch by Venki, but it solves the problem
more completely by making the limit fully dynamic (upto the 128 boundary)

Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |  140 ++++++++++++++++++++++++++++--------
 1 file changed, 109 insertions(+), 31 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -24,6 +24,8 @@
 #include <linux/ctype.h>
 #include <linux/kmod.h>
 #include <linux/kdebug.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
@@ -35,7 +37,12 @@
 #include "ancient.h"
 
 #define MISC_MCELOG_MINOR 227
-#define NR_SYSFS_BANKS 6
+
+/*
+ * To support more than 128 would need to escape the predefined
+ * Linux defined extended banks first.
+ */
+#define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
 
 atomic_t mce_entry;
 
@@ -50,7 +57,7 @@ int mce_disabled __cpuinitdata;
  */
 static int tolerant = 1;
 static int banks;
-static u64 bank[NR_SYSFS_BANKS] = { [0 ... NR_SYSFS_BANKS-1] = ~0UL };
+static u64 *bank;
 static unsigned long notify_user;
 static int rip_msr;
 static int mce_bootlog = -1;
@@ -251,7 +258,7 @@ void do_machine_check(struct pt_regs * r
 	barrier();
 
 	for (i = 0; i < banks; i++) {
-		if (i < NR_SYSFS_BANKS && !bank[i])
+		if (!bank[i])
 			continue;
 
 		m.misc = 0;
@@ -468,38 +475,52 @@ static int dont_init_bank0;
 /*
  * Initialize Machine Checks for a CPU.
  */
+static void mce_cap_init(void)
+{
+	u64 cap;
+
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	/* Handle the unlikely case of one CPU having less banks than others */
+	if (banks == 0 || banks > (cap & 0xff))
+		banks = cap & 0xff;
+	if (banks > MAX_NR_BANKS) {
+		printk(KERN_WARNING
+		       "MCE: Using only %d machine check banks out of %u\n",
+			banks, MAX_NR_BANKS);
+		banks = MAX_NR_BANKS;
+	}
+	if (!bank) {
+		bank = kmalloc(banks * sizeof(u64), GFP_KERNEL);
+		if (!bank)
+			return;
+		memset(bank, 0xff, banks * sizeof(u64));
+	}
+
+	/* Use accurate RIP reporting if available. */
+	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >= 9)
+		rip_msr = MSR_IA32_MCG_EIP;
+}
+
 static void mce_init(void *dummy)
 {
 	u64 cap;
 	int i;
 
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-	banks = cap & 0xff;
-	if (banks > MCE_EXTENDED_BANK) {
-		banks = MCE_EXTENDED_BANK;
-		printk(KERN_INFO "MCE: warning: using only %d banks\n",
-		       MCE_EXTENDED_BANK);
-	}
-	/* Use accurate RIP reporting if available. */
-	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >= 9)
-		rip_msr = MSR_IA32_MCG_EIP;
-
 	/* Log the machine checks left over from the previous reset.
 	   This also clears all registers */
 	do_machine_check(NULL, mce_bootlog ? -1 : -2);
 
 	set_in_cr4(X86_CR4_MCE);
 
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	if (cap & MCG_CTL_P)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
-		if (i == 0 && dont_init_bank0)
-			;
-		else if (i < NR_SYSFS_BANKS)
+		if (!(i == 0 && dont_init_bank0)) {
 			wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
-		else
 			wrmsrl(MSR_IA32_MC0_CTL+4*i, ~0UL);
+		}
 
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
@@ -584,6 +605,8 @@ void __cpuinit mcheck_init(struct cpuinf
 	    !mce_available(c))
 		return;
 
+	mce_cap_init();
+
 	machine_check_vector = do_machine_check;
 
 	mce_init(NULL);
@@ -835,16 +858,26 @@ void (*threshold_cpu_callback)(unsigned 
 	}								\
 	static SYSDEV_ATTR(name, 0644, show_ ## name, set_ ## name);
 
-/*
- * TBD should generate these dynamically based on number of available banks.
- * Have only 6 contol banks in /sysfs until then.
- */
-ACCESSOR(bank0ctl,bank[0],mce_restart())
-ACCESSOR(bank1ctl,bank[1],mce_restart())
-ACCESSOR(bank2ctl,bank[2],mce_restart())
-ACCESSOR(bank3ctl,bank[3],mce_restart())
-ACCESSOR(bank4ctl,bank[4],mce_restart())
-ACCESSOR(bank5ctl,bank[5],mce_restart())
+static struct sysdev_attribute *bank_attrs;
+
+static ssize_t show_bank(struct sys_device *s, struct sysdev_attribute *attr,
+			 char *buf)
+{
+	u64 b = bank[attr - bank_attrs];
+	return sprintf(buf, "%Lx\n", b);
+}
+
+static ssize_t set_bank(struct sys_device *s, struct sysdev_attribute *attr,
+			const char *buf, size_t siz)
+{
+	char *end;
+	u64 new = simple_strtoull(buf, &end, 0);
+	if (end == buf)
+		return -EINVAL;
+	bank[attr - bank_attrs] = new;
+	mce_restart();
+	return end-buf;
+}
 
 static ssize_t show_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 				char *buf)
@@ -871,8 +904,6 @@ static SYSDEV_ATTR(trigger, 0644, show_t
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 ACCESSOR(check_interval,check_interval,mce_restart())
 static struct sysdev_attribute *mce_attributes[] = {
-	&attr_bank0ctl, &attr_bank1ctl, &attr_bank2ctl,
-	&attr_bank3ctl, &attr_bank4ctl, &attr_bank5ctl,
 	&attr_tolerant.attr, &attr_check_interval, &attr_trigger,
 	NULL
 };
@@ -902,11 +933,22 @@ static __cpuinit int mce_create_device(u
 		if (err)
 			goto error;
 	}
+	for (i = 0; i < banks; i++) {
+		err = sysdev_create_file(&per_cpu(device_mce, cpu),
+					&bank_attrs[i]);
+		if (err)
+			goto error2;
+	}
 	cpu_set(cpu, mce_device_initialized);
 
 	return 0;
+error2:
+	while (--i >= 0) {
+		sysdev_remove_file(&per_cpu(device_mce, cpu),
+					&bank_attrs[i]);
+	}
 error:
-	while (i--) {
+	while (--i >= 0) {
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 				   mce_attributes[i]);
 	}
@@ -925,6 +967,9 @@ static void mce_remove_device(unsigned i
 	for (i = 0; mce_attributes[i]; i++)
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 			mce_attributes[i]);
+	for (i = 0; i < banks; i++)
+		sysdev_remove_file(&per_cpu(device_mce, cpu),
+			&bank_attrs[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
 	cpu_clear(cpu, mce_device_initialized);
 }
@@ -956,6 +1001,34 @@ static struct notifier_block mce_cpu_not
 	.notifier_call = mce_cpu_callback,
 };
 
+static __init int mce_init_banks(void)
+{
+	int i;
+
+	bank_attrs = kzalloc(sizeof(struct sysdev_attribute) * banks,
+				GFP_KERNEL);
+	if (!bank_attrs)
+		return -ENOMEM;
+
+	for (i = 0; i < banks; i++) {
+		struct sysdev_attribute *a = &bank_attrs[i];
+		a->attr.name = kasprintf(GFP_KERNEL, "bank%d", i);
+		if (!a->attr.name)
+			goto nomem;
+		a->attr.mode = 0644;
+		a->show = show_bank;
+		a->store = set_bank;
+	}
+	return 0;
+
+nomem:
+	while (--i >= 0)
+		kfree(bank_attrs[i].attr.name);
+	kfree(bank_attrs);
+	bank_attrs = NULL;
+	return -ENOMEM;
+}
+
 static __init int mce_init_device(void)
 {
 	int err;
@@ -963,6 +1036,11 @@ static __init int mce_init_device(void)
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
+
+	err = mce_init_banks();
+	if (err)
+		return err;
+
 	err = sysdev_class_register(&mce_sysclass);
 	if (err)
 		return err;
