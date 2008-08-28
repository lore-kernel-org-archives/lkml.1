Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbYH1Twp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbYH1Twp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYH1Twg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:52:36 -0400
Received: from gw.goop.org ([64.81.55.164]:37163 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYH1Twf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:52:35 -0400
Message-ID: <48B701FB.2020905@goop.org>
Date: Thu, 28 Aug 2008 12:52:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] x86: check for and defend against BIOS memory corruption
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some BIOSes have been observed to corrupt memory in the low 64k.  This
patch does two things:
 - Reserves all memory which does not have to be in that area, to
   prevent it from being used as general memory by the kernel.  Things
   like the SMP trampoline are still in the memory, however.
 - Clears the reserved memory so we can observe changes to it.
 - Adds a function check_for_bios_corruption() which checks and reports on
   memory becoming unexpectedly non-zero.  Currently it's called in the
   x86 fault handler, and the powermanagement debug output.

RFC: What other places should we check for corruption in?

[ Alan, Rafał: could you check you see:
   1: corruption messages
   2: no crashes
  Thanks -J
]

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Hugh Dickens <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Rafał Miłecki <zajec5@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/Kconfig                    |    3 +
 arch/x86/kernel/setup.c             |   86 +++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault.c                 |    2 
 drivers/base/power/main.c           |    1 
 include/linux/kernel.h              |   12 ++++
 6 files changed, 109 insertions(+)

===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -359,6 +359,11 @@
 			BayCom Serial Port AX.25 Modem (Half Duplex Mode)
 			Format: <io>,<irq>,<mode>
 			See header of drivers/net/hamradio/baycom_ser_hdx.c.
+
+	bios_corruption_check=0/1 [X86]
+			Some BIOSes seem to corrupt the first 64k of memory
+			when doing things like suspend/resume.  Setting this
+			option will scan the memory looking for corruption.
 
 	boot_delay=	Milliseconds to delay each printk during boot.
 			Values larger than 10 seconds (10000) are changed to
===================================================================
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -203,6 +203,9 @@
 	bool
 	depends on X86_SMP || (X86_VOYAGER && SMP) || (64BIT && ACPI_SLEEP)
 	default y
+
+config X86_CHECK_BIOS_CORRUPTION
+        def_bool y
 
 config KTIME_SCALAR
 	def_bool X86_32
===================================================================
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -582,6 +582,88 @@
 struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
 
 /*
+ * Some BIOSes seem to corrupt the low 64k of memory during events
+ * like suspend/resume and unplugging an HDMI cable.  Reserve all
+ * remaining free memory in that area and fill it with a distinct
+ * pattern.
+ */
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+#define MAX_SCAN_AREAS	8
+static struct e820entry scan_areas[MAX_SCAN_AREAS];
+static int num_scan_areas;
+
+static void __init setup_bios_corruption_check(void)
+{
+	u64 addr = PAGE_SIZE;	/* assume first page is reserved anyway */
+
+	while(addr < 0x10000 && num_scan_areas < MAX_SCAN_AREAS) {
+		u64 size;
+		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
+
+		if (addr == 0)
+			break;
+
+		if ((addr + size) > 0x10000)
+			size = 0x10000 - addr;
+
+		if (size == 0)
+			break;
+
+		e820_update_range(addr, size, E820_RAM, E820_RESERVED);
+		scan_areas[num_scan_areas].addr = addr;
+		scan_areas[num_scan_areas].size = size;
+		num_scan_areas++;
+
+		/* Assume we've already mapped this early memory */
+		memset(__va(addr), 0, size);
+
+		addr += size;
+	}
+
+	printk(KERN_INFO "scanning %d areas for BIOS corruption\n",
+	       num_scan_areas);
+	update_e820();
+}
+
+static int __read_mostly bios_corruption_check = 1;
+
+void check_for_bios_corruption(void)
+{
+	int i;
+	int corruption = 0;
+
+	if (!bios_corruption_check)
+		return;
+
+	for(i = 0; i < num_scan_areas; i++) {
+		unsigned long *addr = __va(scan_areas[i].addr);
+		unsigned long size = scan_areas[i].size;
+
+		for(; size; addr++, size--) {
+			if (!*addr)
+				continue;
+			printk(KERN_ERR "Corrupted low memory at %p (%lx phys) = %08lx\n",
+			       addr, __pa(addr), *addr);
+			corruption = 1;
+		}
+	}
+
+	if (corruption)
+		dump_stack();
+}
+
+static int set_bios_corruption_check(char *arg)
+{
+	char *end;
+
+	bios_corruption_check = simple_strtol(arg, &end, 10);
+
+	return (*end == 0) ? 0 : -EINVAL;
+}
+early_param("bios_corruption_check", set_bios_corruption_check);
+#endif
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
@@ -766,6 +848,10 @@
 		max_low_pfn = max_pfn;
 
 	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+#endif
+
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+	setup_bios_corruption_check();
 #endif
 
 	/* max_pfn_mapped is updated here */
===================================================================
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -864,6 +864,8 @@
  * Oops. The kernel tried to access some bad page. We'll have to
  * terminate things with extreme prejudice.
  */
+	check_for_bios_corruption();
+
 #ifdef CONFIG_X86_32
 	bust_spinlocks(1);
 #else
===================================================================
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -254,6 +254,7 @@
 
 static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
 {
+	check_for_bios_corruption();
 	dev_dbg(dev, "%s%s%s\n", info, pm_verb(state.event),
 		((state.event & PM_EVENT_SLEEP) && device_may_wakeup(dev)) ?
 		", may wakeup" : "");
===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -246,6 +246,18 @@
 extern void add_taint(unsigned);
 extern int root_mountflags;
 
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+/*
+ * This is obviously not a great place for this, but we want to be
+ * able to scatter it around anywhere in the kernel.
+ */
+void check_for_bios_corruption(void);
+#else
+static inline void check_for_bios_corruption(void)
+{
+}
+#endif
+
 /* Values used for system_state */
 extern enum system_states {
 	SYSTEM_BOOTING,


