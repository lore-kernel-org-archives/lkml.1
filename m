Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZBQVtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZBQVtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZBQVtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:49:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZBQVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:49:45 -0500
Date: Tue, 17 Feb 2009 23:07:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: MCE: Implement dynamic machine check banks support v6
Message-ID: <20090217220713.GI26292@one.firstfloor.org>
References: <20090212143.515129156@firstfloor.org> <20090212124321.8A98B3E666D@basil.firstfloor.org> <1234461785.4286.1918.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234461785.4286.1918.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's the updated patch addressing Venki's comments. I also added in
another patch from Thomas which fixed the error allocation path
(that patch was previously separated)

---


x86: MCE: Implement dynamic machine check banks support v6

Impact: cleanup; making code future proof; memory saving on small systems

This patch replaces the hardcoded max number of machine check banks with 
dynamic allocation depending on what the CPU reports. The sysfs
data structures and the banks array are dynamically allocated.

There is still a hard bank limit (128) because the mcelog protocol uses
banks >= 128 as pseudo banks to escape other events. But we expect
that 128 banks is beyond any reasonable CPU for now.

This supersedes an earlier patch by Venki, but it solves the problem
more completely by making the limit fully dynamic (upto the 128 boundary)

This saves some memory on machines with less than 6 banks because
they won't need sysdevs for unused ones and also allows to 
use sysfs to control these banks on possible future CPUs with
more than 6 banks.

v2: Fix typo in initialization
v3: Fold fix banks message fix into this one.
v4: Fix cap init ordering
v5: Forward port to new patch order
v6: Use WARN_ON to complain about asymmetric configurations 
    (based on comments from Venki)
    Integrate Thomas Gleixner's memory allocation handling fix

Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |  147 ++++++++++++++++++++++++++++--------
 1 file changed, 115 insertions(+), 32 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-13 13:53:18.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-15 12:05:22.000000000 +0100
@@ -24,6 +24,8 @@
 #include <linux/ctype.h>
 #include <linux/kmod.h>
 #include <linux/kdebug.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
@@ -32,7 +34,12 @@
 #include <asm/idle.h>
 
 #define MISC_MCELOG_MINOR 227
-#define NR_SYSFS_BANKS 6
+
+/*
+ * To support more than 128 would need to escape the predefined
+ * Linux defined extended banks first.
+ */
+#define MAX_NR_BANKS (MCE_EXTENDED_BANK - 1)
 
 atomic_t mce_entry;
 
@@ -47,7 +54,7 @@
  */
 static int tolerant = 1;
 static int banks;
-static unsigned long bank[NR_SYSFS_BANKS] = { [0 ... NR_SYSFS_BANKS-1] = ~0UL };
+static u64 *bank;
 static unsigned long notify_user;
 static int rip_msr;
 static int mce_bootlog = -1;
@@ -212,7 +219,7 @@
 	barrier();
 
 	for (i = 0; i < banks; i++) {
-		if (i < NR_SYSFS_BANKS && !bank[i])
+		if (!bank[i])
 			continue;
 
 		m.misc = 0;
@@ -446,37 +453,54 @@
 /*
  * Initialize Machine Checks for a CPU.
  */
-static void mce_init(void *dummy)
+static int mce_cap_init(void)
 {
 	u64 cap;
-	int i;
+	unsigned b;
 
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
-	banks = cap & 0xff;
-	if (banks > MCE_EXTENDED_BANK) {
-		banks = MCE_EXTENDED_BANK;
-		printk(KERN_INFO "MCE: warning: using only %d banks\n",
-		       MCE_EXTENDED_BANK);
+	b = cap & 0xff;
+	if (b > MAX_NR_BANKS) {
+		printk(KERN_WARNING
+		       "MCE: Using only %u machine check banks out of %u\n",
+			MAX_NR_BANKS, b);
+		b = MAX_NR_BANKS;
+	}
+
+	/* Don't support asymmetric configurations today */
+	WARN_ON(banks != 0 && b != banks);
+	banks = b;
+	if (!bank) {
+		bank = kmalloc(banks * sizeof(u64), GFP_KERNEL);
+		if (!bank)
+			return -ENOMEM;
+		memset(bank, 0xff, banks * sizeof(u64));
 	}
+
 	/* Use accurate RIP reporting if available. */
 	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >= 9)
 		rip_msr = MSR_IA32_MCG_EIP;
 
+	return 0;
+}
+
+static void mce_init(void *dummy)
+{
+	u64 cap;
+	int i;
+
 	/* Log the machine checks left over from the previous reset.
 	   This also clears all registers */
 	do_machine_check(NULL, mce_bootlog ? -1 : -2);
 
 	set_in_cr4(X86_CR4_MCE);
 
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	if (cap & MCG_CTL_P)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
-		if (i < NR_SYSFS_BANKS)
-			wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
-		else
-			wrmsrl(MSR_IA32_MC0_CTL+4*i, ~0UL);
-
+		wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 }
@@ -486,10 +510,10 @@
 {
 	/* This should be disabled by the BIOS, but isn't always */
 	if (c->x86_vendor == X86_VENDOR_AMD) {
-		if(c->x86 == 15)
+		if (c->x86 == 15 && banks > 4)
 			/* disable GART TBL walk error reporting, which trips off
 			   incorrectly with the IOMMU & 3ware & Cerberus. */
-			clear_bit(10, &bank[4]);
+			clear_bit(10, (unsigned long *)&bank[4]);
 		if(c->x86 <= 17 && mce_bootlog < 0)
 			/* Lots of broken BIOS around that don't clear them
 			   by default and leave crap in there. Don't log. */
@@ -532,11 +556,15 @@
  */
 void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 {
-	mce_cpu_quirks(c);
-
 	if (!mce_available(c))
 		return;
 
+	if (mce_cap_init() < 0) {
+		mce_dont_init = 1;
+		return;
+	}
+	mce_cpu_quirks(c);
+
 	mce_init(NULL);
 	mce_cpu_features(c);
 	mce_init_timer();
@@ -819,16 +847,26 @@
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
@@ -855,8 +893,6 @@
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 ACCESSOR(check_interval,check_interval,mce_restart())
 static struct sysdev_attribute *mce_attributes[] = {
-	&attr_bank0ctl, &attr_bank1ctl, &attr_bank2ctl,
-	&attr_bank3ctl, &attr_bank4ctl, &attr_bank5ctl,
 	&attr_tolerant.attr, &attr_check_interval, &attr_trigger,
 	NULL
 };
@@ -886,11 +922,22 @@
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
@@ -909,6 +956,9 @@
 	for (i = 0; mce_attributes[i]; i++)
 		sysdev_remove_file(&per_cpu(device_mce,cpu),
 			mce_attributes[i]);
+	for (i = 0; i < banks; i++)
+		sysdev_remove_file(&per_cpu(device_mce, cpu),
+			&bank_attrs[i]);
 	sysdev_unregister(&per_cpu(device_mce,cpu));
 	cpu_clear(cpu, mce_device_initialized);
 }
@@ -973,6 +1023,34 @@
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
@@ -980,6 +1058,11 @@
 
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

-- 
ak@linux.intel.com -- Speaking for myself only.
