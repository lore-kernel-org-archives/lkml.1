Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbYEHVSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbYEHVSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760586AbYEHVSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:18:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:59153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759675AbYEHVSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:18:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,456,1204531200"; 
   d="scan'208";a="326070481"
Date: Thu, 8 May 2008 14:18:36 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, arjan@infradead.org,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] x86: Remove 6 bank limitation in 64 bit MCE reporting code
Message-ID: <20080508211836.GA26353@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eliminate the 6 bank restriction in 64 bit mce reporting code. This restriction
is artificial (due to static creation of sysfs files) and 32 bit code
does not have any such restriction.

This change helps in reporting the details of machine checks on a machine check
exception with errors in bank 6 and above on CPUs that support those banks.
Without the patch, machine check errors in those banks are not reported.

We still have 128 (MCE_EXTENDED_BANK) bank restriction instead of max 256
supported in hardware. That is not changed in the patch below as it will have
some user level mcelog utility dependency, with bank 128 being used for
thermal reporting currently.

The patch below does not create sysfs control (bankNctl) for banks higher
than 6 as well. That needs some pre-cleanup in /sysfs mce layout, removal of
per cpu /sysfs entries for bankctl as they are really global system level
control today. That change will follow. This basic change is critical to
report the detailed errors on banks higher than 6.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-05-08 13:27:53.000000000 -0700
+++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-05-08 14:07:10.000000000 -0700
@@ -31,7 +31,7 @@
 #include <asm/idle.h>
 
 #define MISC_MCELOG_MINOR 227
-#define NR_BANKS 6
+#define NR_SYSFS_BANKS 6
 
 atomic_t mce_entry;
 
@@ -46,7 +46,7 @@ static int mce_dont_init;
  */
 static int tolerant = 1;
 static int banks;
-static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
+static unsigned long bank[NR_SYSFS_BANKS] = { [0 ... NR_SYSFS_BANKS-1] = ~0UL };
 static unsigned long notify_user;
 static int rip_msr;
 static int mce_bootlog = -1;
@@ -209,7 +209,7 @@ void do_machine_check(struct pt_regs * r
 	barrier();
 
 	for (i = 0; i < banks; i++) {
-		if (!bank[i])
+		if (i < NR_SYSFS_BANKS && !bank[i])
 			continue;
 
 		m.misc = 0;
@@ -444,9 +444,10 @@ static void mce_init(void *dummy)
 
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	banks = cap & 0xff;
-	if (banks > NR_BANKS) {
-		printk(KERN_INFO "MCE: warning: using only %d banks\n", banks);
-		banks = NR_BANKS;
+	if (banks > MCE_EXTENDED_BANK) {
+		printk(KERN_INFO "MCE: warning: using only %d banks\n",
+		       MCE_EXTENDED_BANK);
+		banks = MCE_EXTENDED_BANK;
 	}
 	/* Use accurate RIP reporting if available. */
 	if ((cap & (1<<9)) && ((cap >> 16) & 0xff) >= 9)
@@ -462,7 +463,7 @@ static void mce_init(void *dummy)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
 
 	for (i = 0; i < banks; i++) {
-		wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
+		wrmsrl(MSR_IA32_MC0_CTL+4*i, ~0UL);
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
 }
@@ -766,7 +767,10 @@ DEFINE_PER_CPU(struct sys_device, device
 	}								\
 	static SYSDEV_ATTR(name, 0644, show_ ## name, set_ ## name);
 
-/* TBD should generate these dynamically based on number of available banks */
+/*
+ * TBD should generate these dynamically based on number of available banks.
+ * Have only 6 contol banks in /sysfs until then.
+ */
 ACCESSOR(bank0ctl,bank[0],mce_restart())
 ACCESSOR(bank1ctl,bank[1],mce_restart())
 ACCESSOR(bank2ctl,bank[2],mce_restart())
