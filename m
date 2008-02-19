Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYBSMYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYBSMYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 07:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYBSMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 07:24:37 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:22214 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbYBSMYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:24:33 -0500
X-Belgacom-Dynamic: yes
Date: Tue, 19 Feb 2008 13:24:25 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.5.25-rc patches
Message-ID: <20080219122425.GA4727@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig     |   25 +
 drivers/watchdog/Makefile    |    2 
 drivers/watchdog/bfin_wdt.c  |    7 
 drivers/watchdog/hpwdt.c     |  926 +++++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/mtx-1_wdt.c |   35 +
 drivers/watchdog/sb_wdog.c   |  353 ++++++++++++++++
 6 files changed, 1340 insertions(+), 8 deletions(-)

with these Changes:

Author: Thomas Mingarelli <thomas.mingarelli@hp.com>
Date:   Tue Dec 4 17:41:54 2007 +0000

    [WATCHDOG] HP ProLiant WatchDog driver
    
    Hp is providing a Hardware WatchDog Timer driver that will only work with the
    specific HW Timer located in the HP ProLiant iLO 2 ASIC. The iLO 2 HW Timer
    will generate a Non-maskable Interrupt (NMI) 9 seconds before physically
    resetting the server, by removing power, so that the event can be logged to
    the HP Integrated Management Log (IML), a Non-Volatile Random Access Memory
    (NVRAM). The logging of the event is performed using the HP ProLiant ROM via
    an Industry Standard access known as a BIOS Service Directory Entry.
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mike Frysinger <michael.frysinger@analog.com>
Date:   Wed Jan 30 17:38:21 2008 +0800

    [WATCHDOG] blackfin Watchdog driver: relocate all strings used in __init functions to __initdata
    
    Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
    Signed-off-by: Bryan Wu <bryan.wu@analog.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Florian Fainelli <florian.fainelli@telecomint.eu>
Date:   Mon Jan 7 19:08:49 2008 +0100

    [WATCHDOG] Convert mtx1 wdt to be a platform device and use generic GPIO API
    
    This patch converts the MTX-1 to be a platform device, use the available
    generic GPIO API for the MTX-1 board and register the miscdev alias.
    
    Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Andrew Sharp <andy.sharp@onstor.com>
Date:   Thu Dec 13 16:16:42 2007 -0800

    [WATCHDOG] Add support for SB1 hardware watchdog
    
    Support watchdog timers built into SiByte MIPS SoCs.
    
    Signed-off-by: Andy Sharp <andy.sharp@onstor.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index afcdc69..254d115 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -402,6 +402,18 @@ config IT8712F_WDT
 	  To compile this driver as a module, choose M here: the
 	  module will be called it8712f_wdt.
 
+config HP_WATCHDOG
+	tristate "HP Proliant iLO 2 Hardware Watchdog Timer"
+	depends on X86
+	help
+	  A software monitoring watchdog and NMI sourcing driver. This driver
+	  will detect lockups and provide stack trace. Also, when an NMI
+	  occurs this driver will make the necessary BIOS calls to log
+	  the cause of the NMI. This is a driver that will only load on a
+	  HP ProLiant system with a minimum of iLO2 support.
+	  To compile this driver as a module, choose M here: the
+	  module will be called hpwdt.
+
 config SC1200_WDT
 	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
 	depends on X86
@@ -633,6 +645,19 @@ config WDT_RM9K_GPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called rm9k_wdt.
 
+config SIBYTE_WDOG
+	tristate "Sibyte SoC hardware watchdog"
+	depends on CPU_SB1
+	help
+	  Watchdog driver for the built in watchdog hardware in Sibyte
+	  SoC processors.  There are apparently two watchdog timers
+	  on such processors; this driver supports only the first one,
+	  because currently Linux only supports exporting one watchdog
+	  to userspace.
+
+	  To compile this driver as a loadable module, choose M here.
+	  The module will be called sb_wdog.
+
 config AR7_WDT
 	tristate "TI AR7 Watchdog Timer"
 	depends on AR7
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index ebc2114..f3fb170 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -67,6 +67,7 @@ obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
+obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
 obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
@@ -92,6 +93,7 @@ obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
+obj-$(CONFIG_SIBYTE_WDOG) += sb_wdog.o
 obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
 obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 472be10..1237113 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -29,6 +29,7 @@
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
+#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
 
 #define WATCHDOG_NAME "bfin-wdt"
 #define PFX WATCHDOG_NAME ": "
@@ -445,19 +446,19 @@ static int __init bfin_wdt_init(void)
 
 	ret = register_reboot_notifier(&bfin_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		pr_init(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		pr_init(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 		       WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
 
-	printk(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
+	pr_init(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
 	       timeout, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
new file mode 100644
index 0000000..a2e174b
--- /dev/null
+++ b/drivers/watchdog/hpwdt.c
@@ -0,0 +1,926 @@
+/*
+ *	HP WatchDog Driver
+ *	based on
+ *
+ *	SoftDog	0.05:	A Software Watchdog Device
+ *
+ *	(c) Copyright 2007 Hewlett-Packard Development Company, L.P.
+ *	Thomas Mingarelli <thomas.mingarelli@hp.com>
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	version 2 as published by the Free Software Foundation
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/reboot.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+#include <linux/dmi.h>
+#include <linux/efi.h>
+#include <linux/string.h>
+#include <linux/bootmem.h>
+#include <linux/slab.h>
+#include <asm/dmi.h>
+#include <asm/desc.h>
+#include <asm/kdebug.h>
+
+#define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
+#define CRU_BIOS_SIGNATURE_VALUE	0x55524324
+#define PCI_BIOS32_PARAGRAPH_LEN	16
+#define PCI_ROM_BASE1			0x000F0000
+#define ROM_SIZE			0x10000
+
+struct bios32_service_dir {
+	u32 signature;
+	u32 entry_point;
+	u8 revision;
+	u8 length;
+	u8 checksum;
+	u8 reserved[5];
+};
+
+/*
+ * smbios_entry_point     - defines SMBIOS entry point structure
+ *
+ * anchor[4]              - anchor string (_SM_)
+ * checksum               - checksum of the entry point structure
+ * length                 - length of the entry point structure
+ * major_ver              - major version (02h for revision 2.1)
+ * minor_ver              - minor version (01h for revision 2.1)
+ * max_struct_size        - size of the largest SMBIOS structure
+ * revision               - entry point structure revision implemented
+ * formatted_area[5]      - reserved
+ * intermediate_anchor[5] - intermediate anchor string (_DMI_)
+ * intermediate_checksum  - intermediate checksum
+ * table_length           - structure table length
+ * table_address          - structure table address
+ * table_num_structs      - number of SMBIOS structures present
+ * bcd_revision           - BCD revision
+ */
+struct smbios_entry_point {
+	u8 anchor[4];
+	u8 checksum;
+	u8 length;
+	u8 major_ver;
+	u8 minor_ver;
+	u16 max_struct_size;
+	u8 revision;
+	u8 formatted_area[5];
+	u8 intermediate_anchor[5];
+	u8 intermediate_checksum;
+	u16 table_length;
+	u64 table_address;
+	u16 table_num_structs;
+	u8 bcd_revision;
+};
+
+/* type 212 */
+struct smbios_cru64_info {
+	u8 type;
+	u8 byte_length;
+	u16 handle;
+	u32 signature;
+	u64 physical_address;
+	u32 double_length;
+	u32 double_offset;
+};
+#define SMBIOS_CRU64_INFORMATION	212
+
+struct cmn_registers {
+	union {
+		struct {
+			u8 ral;
+			u8 rah;
+			u16 rea2;
+		};
+		u32 reax;
+	} u1;
+	union {
+		struct {
+			u8 rbl;
+			u8 rbh;
+			u8 reb2l;
+			u8 reb2h;
+		};
+		u32 rebx;
+	} u2;
+	union {
+		struct {
+			u8 rcl;
+			u8 rch;
+			u16 rec2;
+		};
+		u32 recx;
+	} u3;
+	union {
+		struct {
+			u8 rdl;
+			u8 rdh;
+			u16 red2;
+		};
+		u32 redx;
+	} u4;
+
+	u32 resi;
+	u32 redi;
+	u16 rds;
+	u16 res;
+	u32 reflags;
+}  __attribute__((packed));
+
+#define DEFAULT_MARGIN	30
+static unsigned int soft_margin = DEFAULT_MARGIN;	/* in seconds */
+static unsigned int reload;			/* the computed soft_margin */
+static int nowayout = WATCHDOG_NOWAYOUT;
+static char expect_release;
+static unsigned long hpwdt_is_open;
+
+static void __iomem *pci_mem_addr;		/* the PCI-memory address */
+static unsigned long __iomem *hpwdt_timer_reg;
+static unsigned long __iomem *hpwdt_timer_con;
+
+static DEFINE_SPINLOCK(rom_lock);
+
+static void *cru_rom_addr;
+
+static struct cmn_registers cmn_regs;
+
+static struct pci_device_id hpwdt_devices[] = {
+	{
+	 .vendor = PCI_VENDOR_ID_COMPAQ,
+	 .device = 0xB203,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	},
+	{0},			/* terminate list */
+};
+MODULE_DEVICE_TABLE(pci, hpwdt_devices);
+
+/*
+ *	bios_checksum
+ */
+static int __devinit bios_checksum(const char __iomem *ptr, int len)
+{
+	char sum = 0;
+	int i;
+
+	/*
+	 * calculate checksum of size bytes. This should add up
+	 * to zero if we have a valid header.
+	 */
+	for (i = 0; i < len; i++)
+		sum += ptr[i];
+
+	return ((sum == 0) && (len > 0));
+}
+
+#ifndef CONFIG_X86_64
+/* --32 Bit Bios------------------------------------------------------------ */
+
+#define HPWDT_ARCH	32
+
+asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
+			       unsigned long *pRomEntry)
+{
+	asm("pushl       %ebp               \n\t"
+	    "movl        %esp, %ebp         \n\t"
+	    "pusha                          \n\t"
+	    "pushf                          \n\t"
+	    "push        %es                \n\t"
+	    "push        %ds                \n\t"
+	    "pop         %es                \n\t"
+	    "movl        8(%ebp),%eax       \n\t"
+	    "movl        4(%eax),%ebx       \n\t"
+	    "movl        8(%eax),%ecx       \n\t"
+	    "movl        12(%eax),%edx      \n\t"
+	    "movl        16(%eax),%esi      \n\t"
+	    "movl        20(%eax),%edi      \n\t"
+	    "movl        (%eax),%eax        \n\t"
+	    "push        %cs                \n\t"
+	    "call        *12(%ebp)          \n\t"
+	    "pushf                          \n\t"
+	    "pushl       %eax               \n\t"
+	    "movl        8(%ebp),%eax       \n\t"
+	    "movl        %ebx,4(%eax)       \n\t"
+	    "movl        %ecx,8(%eax)       \n\t"
+	    "movl        %edx,12(%eax)      \n\t"
+	    "movl        %esi,16(%eax)      \n\t"
+	    "movl        %edi,20(%eax)      \n\t"
+	    "movw        %ds,24(%eax)       \n\t"
+	    "movw        %es,26(%eax)       \n\t"
+	    "popl        %ebx               \n\t"
+	    "movl        %ebx,(%eax)        \n\t"
+	    "popl        %ebx               \n\t"
+	    "movl        %ebx,28(%eax)      \n\t"
+	    "pop         %es                \n\t"
+	    "popf                           \n\t"
+	    "popa                           \n\t"
+	    "leave                          \n\t" "ret");
+}
+
+/*
+ *	cru_detect
+ *
+ *	Routine Description:
+ *	This function uses the 32-bit BIOS Service Directory record to
+ *	search for a $CRU record.
+ *
+ *	Return Value:
+ *	0        :  SUCCESS
+ *	<0       :  FAILURE
+ */
+static int __devinit cru_detect(unsigned long map_entry,
+	unsigned long map_offset)
+{
+	void *bios32_map;
+	unsigned long *bios32_entrypoint;
+	unsigned long cru_physical_address;
+	unsigned long cru_length;
+	unsigned long physical_bios_base = 0;
+	unsigned long physical_bios_offset = 0;
+	int retval = -ENODEV;
+
+	bios32_map = ioremap(map_entry, (2 * PAGE_SIZE));
+
+	if (bios32_map == NULL)
+		return -ENODEV;
+
+	bios32_entrypoint = bios32_map + map_offset;
+
+	cmn_regs.u1.reax = CRU_BIOS_SIGNATURE_VALUE;
+
+	asminline_call(&cmn_regs, bios32_entrypoint);
+
+	if (cmn_regs.u1.ral != 0) {
+		printk(KERN_WARNING
+		       "hpwdt: Call succeeded but with an error: 0x%x\n",
+		       cmn_regs.u1.ral);
+	} else {
+		physical_bios_base = cmn_regs.u2.rebx;
+		physical_bios_offset = cmn_regs.u4.redx;
+		cru_length = cmn_regs.u3.recx;
+		cru_physical_address =
+		    physical_bios_base + physical_bios_offset;
+
+		/* If the values look OK, then map it in. */
+		if ((physical_bios_base + physical_bios_offset)) {
+			cru_rom_addr =
+			    ioremap(cru_physical_address, cru_length);
+			if (cru_rom_addr)
+				retval = 0;
+		}
+
+		printk(KERN_DEBUG "hpwdt: CRU Base Address:   0x%lx\n",
+			physical_bios_base);
+		printk(KERN_DEBUG "hpwdt: CRU Offset Address: 0x%lx\n",
+			physical_bios_offset);
+		printk(KERN_DEBUG "hpwdt: CRU Length:         0x%lx\n",
+			cru_length);
+		printk(KERN_DEBUG "hpwdt: CRU Mapped Address: 0x%x\n",
+			(unsigned int)&cru_rom_addr);
+	}
+	iounmap(bios32_map);
+	return retval;
+}
+
+/*
+ *	bios32_present
+ *
+ *	Routine Description:
+ *	This function finds the 32-bit BIOS Service Directory
+ *
+ *	Return Value:
+ *	0        :  SUCCESS
+ *	<0       :  FAILURE
+ */
+static int __devinit bios32_present(const char __iomem *p)
+{
+	struct bios32_service_dir *bios_32_ptr;
+	int length;
+	unsigned long map_entry, map_offset;
+
+	bios_32_ptr = (struct bios32_service_dir *) p;
+
+	/*
+	 * Search for signature by checking equal to the swizzled value
+	 * instead of calling another routine to perform a strcmp.
+	 */
+	if (bios_32_ptr->signature == PCI_BIOS32_SD_VALUE) {
+		length = bios_32_ptr->length * PCI_BIOS32_PARAGRAPH_LEN;
+		if (bios_checksum(p, length)) {
+			/*
+			 * According to the spec, we're looking for the
+			 * first 4KB-aligned address below the entrypoint
+			 * listed in the header. The Service Directory code
+			 * is guaranteed to occupy no more than 2 4KB pages.
+			 */
+			map_entry = bios_32_ptr->entry_point & ~(PAGE_SIZE - 1);
+			map_offset = bios_32_ptr->entry_point - map_entry;
+
+			return cru_detect(map_entry, map_offset);
+		}
+	}
+	return -ENODEV;
+}
+
+static int __devinit detect_cru_service(void)
+{
+	char __iomem *p, *q;
+	int rc = -1;
+
+	/*
+	 * Search from 0x0f0000 through 0x0fffff, inclusive.
+	 */
+	p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
+	if (p == NULL)
+		return -ENOMEM;
+
+	for (q = p; q < p + ROM_SIZE; q += 16) {
+		rc = bios32_present(q);
+		if (!rc)
+			break;
+	}
+	iounmap(p);
+	return rc;
+}
+
+#else
+/* --64 Bit Bios------------------------------------------------------------ */
+
+#define HPWDT_ARCH	64
+
+asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
+			       unsigned long *pRomEntry)
+{
+	asm("pushq      %rbp            \n\t"
+	    "movq       %rsp, %rbp      \n\t"
+	    "pushq      %rax            \n\t"
+	    "pushq      %rbx            \n\t"
+	    "pushq      %rdx            \n\t"
+	    "pushq      %r12            \n\t"
+	    "pushq      %r9             \n\t"
+	    "movq       %rsi, %r12      \n\t"
+	    "movq       %rdi, %r9       \n\t"
+	    "movl       4(%r9),%ebx     \n\t"
+	    "movl       8(%r9),%ecx     \n\t"
+	    "movl       12(%r9),%edx    \n\t"
+	    "movl       16(%r9),%esi    \n\t"
+	    "movl       20(%r9),%edi    \n\t"
+	    "movl       (%r9),%eax      \n\t"
+	    "call       *%r12           \n\t"
+	    "pushfq                     \n\t"
+	    "popq        %r12           \n\t"
+	    "popfq                      \n\t"
+	    "movl       %eax, (%r9)     \n\t"
+	    "movl       %ebx, 4(%r9)    \n\t"
+	    "movl       %ecx, 8(%r9)    \n\t"
+	    "movl       %edx, 12(%r9)   \n\t"
+	    "movl       %esi, 16(%r9)   \n\t"
+	    "movl       %edi, 20(%r9)   \n\t"
+	    "movq       %r12, %rax      \n\t"
+	    "movl       %eax, 28(%r9)   \n\t"
+	    "popq       %r9             \n\t"
+	    "popq       %r12            \n\t"
+	    "popq       %rdx            \n\t"
+	    "popq       %rbx            \n\t"
+	    "popq       %rax            \n\t"
+	    "leave                      \n\t" "ret");
+}
+
+/*
+ *	dmi_find_cru
+ *
+ *	Routine Description:
+ *	This function checks wether or not a SMBIOS/DMI record is
+ *	the 64bit CRU info or not
+ *
+ *	Return Value:
+ *	0        :  SUCCESS - if record found
+ *	<0       :  FAILURE - if record not found
+ */
+static void __devinit dmi_find_cru(const struct dmi_header *dm)
+{
+	struct smbios_cru64_info *smbios_cru64_ptr;
+	unsigned long cru_physical_address;
+
+	if (dm->type == SMBIOS_CRU64_INFORMATION) {
+		smbios_cru64_ptr = (struct smbios_cru64_info *) dm;
+		if (smbios_cru64_ptr->signature == CRU_BIOS_SIGNATURE_VALUE) {
+			cru_physical_address =
+			    smbios_cru64_ptr->physical_address +
+			    smbios_cru64_ptr->double_offset;
+			cru_rom_addr = ioremap(cru_physical_address,
+				    smbios_cru64_ptr->double_length);
+		}
+	}
+}
+
+/*
+ *	dmi_table
+ *
+ *	Routine Description:
+ *	Decode the SMBIOS/DMI table and check if we have a 64bit CRU record
+ *	or not.
+ *
+ *	We have to be cautious here. We have seen BIOSes with DMI pointers
+ *	pointing to completely the wrong place for example
+ */
+static void __devinit dmi_table(u8 *buf, int len, int num,
+		      void (*decode)(const struct dmi_header *))
+{
+	u8 *data = buf;
+	int i = 0;
+
+	/*
+	 *	Stop when we see all the items the table claimed to have
+	 *	OR we run off the end of the table (also happens)
+	 */
+	while ((i < num) && (data - buf + sizeof(struct dmi_header)) <= len) {
+		const struct dmi_header *dm = (const struct dmi_header *)data;
+
+		/*
+		 *  We want to know the total length (formated area and strings)
+		 *  before decoding to make sure we won't run off the table in
+		 *  dmi_decode or dmi_string
+		 */
+		data += dm->length;
+		while ((data - buf < len - 1) && (data[0] || data[1]))
+			data++;
+		if (data - buf < len - 1)
+			decode(dm);
+		data += 2;
+		i++;
+	}
+}
+
+/*
+ *	smbios_present
+ *
+ *	Routine Description:
+ *	This function parses the SMBIOS entry point table to retrieve
+ *	the 64 bit CRU Service.
+ *
+ *	Return Value:
+ *	0        :  SUCCESS
+ *	<0       :  FAILURE
+ */
+static int __devinit smbios_present(const char __iomem *p)
+{
+	struct smbios_entry_point *eps =
+		(struct smbios_entry_point *) p;
+	int length;
+	u8 *buf;
+
+	/* check if we have indeed the SMBIOS table entry point */
+	if ((strncmp((char *)eps->anchor, "_SM_",
+			     sizeof(eps->anchor))) == 0) {
+		length = eps->length;
+
+		/* SMBIOS v2.1 implementation might use 0x1e */
+		if ((length == 0x1e) &&
+		    (eps->major_ver == 2) &&
+		    (eps->minor_ver == 1))
+			length = 0x1f;
+
+		/*
+		 * Now we will check:
+		 * - SMBIOS checksum must be 0
+		 * - intermediate anchor should be _DMI_
+		 * - intermediate checksum should be 0
+		 */
+		if ((bios_checksum(p, length)) &&
+		    (strncmp((char *)eps->intermediate_anchor, "_DMI_",
+		             sizeof(eps->intermediate_anchor)) == 0) &&
+		    (bios_checksum(p+0x10, 15))) {
+			buf = ioremap(eps->table_address, eps->table_length);
+			if (buf == NULL)
+				return -ENODEV;
+
+
+			/* Scan the DMI table for the 64 bit CRU service */
+			dmi_table(buf, eps->table_length,
+			          eps->table_num_structs, dmi_find_cru);
+
+			iounmap(buf);
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+
+static int __devinit smbios_scan_machine(void)
+{
+	char __iomem *p, *q;
+	int rc;
+
+	if (efi_enabled) {
+		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
+			return -ENODEV;
+
+		p = ioremap(efi.smbios, 32);
+		if (p == NULL)
+			return -ENOMEM;
+
+		rc = smbios_present(p);
+		iounmap(p);
+	} else {
+		/*
+		 * Search from 0x0f0000 through 0x0fffff, inclusive.
+		 */
+		p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
+		if (p == NULL)
+			return -ENOMEM;
+
+		for (q = p; q < p + ROM_SIZE; q += 16) {
+			rc = smbios_present(q);
+			if (!rc) {
+				break;
+			}
+		}
+		iounmap(p);
+	}
+}
+
+static int __devinit detect_cru_service(void)
+{
+	cru_rom_addr = NULL;
+
+	smbios_scan_machine();	/* will become dmi_walk(dmi_find_cru); */
+
+	/* if cru_rom_addr has been set then we found a CRU service */
+	return ((cru_rom_addr != NULL)? 0: -ENODEV);
+}
+
+/* ------------------------------------------------------------------------- */
+
+#endif
+
+/*
+ *	NMI Handler
+ */
+static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
+			    void *data)
+{
+	static unsigned long rom_pl;
+	static int die_nmi_called;
+
+	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
+		return NOTIFY_OK;
+
+	spin_lock_irqsave(&rom_lock, rom_pl);
+	if (!die_nmi_called)
+		asminline_call(&cmn_regs, cru_rom_addr);
+	die_nmi_called = 1;
+	spin_unlock_irqrestore(&rom_lock, rom_pl);
+	if (cmn_regs.u1.ral == 0) {
+		printk(KERN_WARNING "hpwdt: An NMI occurred, "
+		       "but unable to determine source.\n");
+	} else {
+		panic("An NMI occurred, please see the Integrated "
+			"Management Log for details.\n");
+	}
+
+	return NOTIFY_STOP;
+}
+
+/*
+ *	Watchdog operations
+ */
+static void hpwdt_start(void)
+{
+	reload = (soft_margin * 1000) / 128;
+	iowrite16(reload, hpwdt_timer_reg);
+	iowrite16(0x85, hpwdt_timer_con);
+}
+
+static void hpwdt_stop(void)
+{
+	unsigned long data;
+
+	data = ioread16(hpwdt_timer_con);
+	data &= 0xFE;
+	iowrite16(data, hpwdt_timer_con);
+}
+
+static void hpwdt_ping(void)
+{
+	iowrite16(reload, hpwdt_timer_reg);
+}
+
+static int hpwdt_change_timer(int new_margin)
+{
+	/* Arbitrary, can't find the card's limits */
+	if (new_margin < 30 || new_margin > 600) {
+		printk(KERN_WARNING
+			"hpwdt: New value passed in is invalid: %d seconds.\n",
+			new_margin);
+		return -EINVAL;
+	}
+
+	soft_margin = new_margin;
+	printk(KERN_DEBUG
+		"hpwdt: New timer passed in is %d seconds.\n",
+		new_margin);
+	reload = (soft_margin * 1000) / 128;
+
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+static int hpwdt_open(struct inode *inode, struct file *file)
+{
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &hpwdt_is_open))
+		return -EBUSY;
+
+	/* Start the watchdog */
+	hpwdt_start();
+	hpwdt_ping();
+
+	return nonseekable_open(inode, file);
+}
+
+static int hpwdt_release(struct inode *inode, struct file *file)
+{
+	/* Stop the watchdog */
+	if (expect_release == 42) {
+		hpwdt_stop();
+	} else {
+		printk(KERN_CRIT
+			"hpwdt: Unexpected close, not stopping watchdog!\n");
+		hpwdt_ping();
+	}
+
+	expect_release = 0;
+
+	/* /dev/watchdog is being closed, make sure it can be re-opened */
+	clear_bit(0, &hpwdt_is_open);
+
+	return 0;
+}
+
+static ssize_t hpwdt_write(struct file *file, const char __user *data,
+	size_t len, loff_t *ppos)
+{
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* note: just in case someone wrote the magic character
+			 * five months ago... */
+			expect_release = 0;
+
+			/* scan to see whether or not we got the magic char. */
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data+i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_release = 42;
+			}
+		}
+
+		/* someone wrote to us, we should reload the timer */
+		hpwdt_ping();
+	}
+
+	return len;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_SETTIMEOUT |
+		   WDIOF_KEEPALIVEPING |
+		   WDIOF_MAGICCLOSE,
+	.identity = "HP iLO2 HW Watchdog Timer",
+};
+
+static long hpwdt_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_margin;
+	int ret = -ENOTTY;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = 0;
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			ret = -EFAULT;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		hpwdt_ping();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(new_margin, p);
+		if (ret)
+			break;
+
+		ret = hpwdt_change_timer(new_margin);
+		if (ret)
+			break;
+
+		hpwdt_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(soft_margin, p);
+		break;
+	}
+	return ret;
+}
+
+/*
+ *	Kernel interfaces
+ */
+static struct file_operations hpwdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = hpwdt_write,
+	.unlocked_ioctl = hpwdt_ioctl,
+	.open = hpwdt_open,
+	.release = hpwdt_release,
+};
+
+static struct miscdevice hpwdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &hpwdt_fops,
+};
+
+static struct notifier_block die_notifier = {
+	.notifier_call = hpwdt_pretimeout,
+	.priority = 0x7FFFFFFF,
+};
+
+/*
+ *	Init & Exit
+ */
+
+static int __devinit hpwdt_init_one(struct pci_dev *dev,
+				    const struct pci_device_id *ent)
+{
+	int retval;
+
+	/*
+	 * First let's find out if we are on an iLO2 server. We will
+	 * not run on a legacy ASM box.
+	 */
+	if (dev->subsystem_vendor != PCI_VENDOR_ID_HP) {
+		dev_warn(&dev->dev,
+		       "This server does not have an iLO2 ASIC.\n");
+		return -ENODEV;
+	}
+
+	if (pci_enable_device(dev)) {
+		dev_warn(&dev->dev,
+			"Not possible to enable PCI Device: 0x%x:0x%x.\n",
+			ent->vendor, ent->device);
+		return -ENODEV;
+	}
+
+	pci_mem_addr = pci_iomap(dev, 1, 0x80);
+	if (!pci_mem_addr) {
+		dev_warn(&dev->dev,
+			"Unable to detect the iLO2 server memory.\n");
+		retval = -ENOMEM;
+		goto error_pci_iomap;
+	}
+	hpwdt_timer_reg = pci_mem_addr + 0x70;
+	hpwdt_timer_con = pci_mem_addr + 0x72;
+
+	/* Make sure that we have a valid soft_margin */
+	if (hpwdt_change_timer(soft_margin))
+		hpwdt_change_timer(DEFAULT_MARGIN);
+
+	/*
+	 * We need to map the ROM to get the CRU service.
+	 * For 32 bit Operating Systems we need to go through the 32 Bit
+	 * BIOS Service Directory
+	 * For 64 bit Operating Systems we get that service through SMBIOS.
+	 */
+	retval = detect_cru_service();
+	if (retval < 0) {
+		dev_warn(&dev->dev,
+		       "Unable to detect the %d Bit CRU Service.\n",
+			HPWDT_ARCH);
+		goto error_get_cru;
+	}
+
+	/*
+	 * We know this is the only CRU call we need to make so lets keep as
+	 * few instructions as possible once the NMI comes in.
+	 */
+	cmn_regs.u1.rah = 0x0D;
+	cmn_regs.u1.ral = 0x02;
+
+	retval = register_die_notifier(&die_notifier);
+	if (retval != 0) {
+		dev_warn(&dev->dev,
+		       "Unable to register a die notifier (err=%d).\n",
+			retval);
+		goto error_die_notifier;
+	}
+
+	retval = misc_register(&hpwdt_miscdev);
+	if (retval < 0) {
+		dev_warn(&dev->dev,
+			"Unable to register miscdev on minor=%d (err=%d).\n",
+			WATCHDOG_MINOR, retval);
+		goto error_misc_register;
+	}
+
+	printk(KERN_INFO
+		"hp Watchdog Timer Driver: 1.00"
+		", timer margin: %d seconds( nowayout=%d).\n",
+		soft_margin, nowayout);
+
+	return 0;
+
+error_misc_register:
+	unregister_die_notifier(&die_notifier);
+error_die_notifier:
+	if (cru_rom_addr)
+		iounmap(cru_rom_addr);
+error_get_cru:
+	pci_iounmap(dev, pci_mem_addr);
+error_pci_iomap:
+	pci_disable_device(dev);
+	return retval;
+}
+
+static void __devexit hpwdt_exit(struct pci_dev *dev)
+{
+	if (!nowayout)
+		hpwdt_stop();
+
+	misc_deregister(&hpwdt_miscdev);
+	unregister_die_notifier(&die_notifier);
+
+	if (cru_rom_addr)
+		iounmap(cru_rom_addr);
+	pci_iounmap(dev, pci_mem_addr);
+	pci_disable_device(dev);
+}
+
+static struct pci_driver hpwdt_driver = {
+	.name = "hpwdt",
+	.id_table = hpwdt_devices,
+	.probe = hpwdt_init_one,
+	.remove = __devexit_p(hpwdt_exit),
+};
+
+static void __exit hpwdt_cleanup(void)
+{
+	pci_unregister_driver(&hpwdt_driver);
+}
+
+static int __init hpwdt_init(void)
+{
+	return pci_register_driver(&hpwdt_driver);
+}
+
+MODULE_AUTHOR("Tom Mingarelli");
+MODULE_DESCRIPTION("hp watchdog driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
+module_param(soft_margin, int, 0);
+MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+module_init(hpwdt_init);
+module_exit(hpwdt_cleanup);
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 9845174..789831b 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -45,10 +45,13 @@
 #include <linux/completion.h>
 #include <linux/jiffies.h>
 #include <linux/watchdog.h>
+#include <linux/platform_device.h>
+
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
 #include <asm/mach-au1x00/au1000.h>
+#include <asm/gpio.h>
 
 #define MTX1_WDT_INTERVAL	(5 * HZ)
 
@@ -61,6 +64,7 @@ static struct {
 	volatile int queue;
 	int default_ticks;
 	unsigned long inuse;
+	unsigned gpio;
 } mtx1_wdt_device;
 
 static void mtx1_wdt_trigger(unsigned long unused)
@@ -73,7 +77,8 @@ static void mtx1_wdt_trigger(unsigned long unused)
 	 * toggle GPIO2_15
 	 */
 	tmp = au_readl(GPIO2_DIR);
-	tmp = (tmp & ~(1<<15)) | ((~tmp) & (1<<15));
+	tmp = (tmp & ~(1 << mtx1_wdt_device.gpio)) |
+	      ((~tmp) & (1 << mtx1_wdt_device.gpio));
 	au_writel (tmp, GPIO2_DIR);
 
 	if (mtx1_wdt_device.queue && ticks)
@@ -93,7 +98,7 @@ static void mtx1_wdt_start(void)
 {
 	if (!mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 1;
-		au_writel (au_readl(GPIO2_DIR) | (u32)(1<<15), GPIO2_DIR);
+		gpio_set_value(mtx1_wdt_device.gpio, 1);
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
 	}
 	mtx1_wdt_device.running++;
@@ -103,7 +108,7 @@ static int mtx1_wdt_stop(void)
 {
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
-		au_writel (au_readl(GPIO2_DIR) & ~((u32)(1<<15)), GPIO2_DIR);
+		gpio_set_value(mtx1_wdt_device.gpio, 0);
 	}
 
 	ticks = mtx1_wdt_device.default_ticks;
@@ -197,10 +202,12 @@ static struct miscdevice mtx1_wdt_misc = {
 };
 
 
-static int __init mtx1_wdt_init(void)
+static int mtx1_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	mtx1_wdt_device.gpio = pdev->resource[0].start;
+
 	if ((ret = misc_register(&mtx1_wdt_misc)) < 0) {
 		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
 		return ret;
@@ -222,13 +229,30 @@ static int __init mtx1_wdt_init(void)
 	return 0;
 }
 
-static void __exit mtx1_wdt_exit(void)
+static int mtx1_wdt_remove(struct platform_device *pdev)
 {
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);
 	}
 	misc_deregister(&mtx1_wdt_misc);
+	return 0;
+}
+
+static struct platform_driver mtx1_wdt = {
+	.probe = mtx1_wdt_probe,
+	.remove = mtx1_wdt_remove,
+	.driver.name = "mtx1-wdt",
+};
+
+static int __init mtx1_wdt_init(void)
+{
+	return platform_driver_register(&mtx1_wdt);
+}
+
+static void __exit mtx1_wdt_exit(void)
+{
+	platform_driver_unregister(&mtx1_wdt);
 }
 
 module_init(mtx1_wdt_init);
@@ -237,3 +261,4 @@ module_exit(mtx1_wdt_exit);
 MODULE_AUTHOR("Michael Stickel, Florian Fainelli");
 MODULE_DESCRIPTION("Driver for the MTX-1 watchdog");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
new file mode 100644
index 0000000..b944314
--- /dev/null
+++ b/drivers/watchdog/sb_wdog.c
@@ -0,0 +1,353 @@
+/*
+ * Watchdog driver for SiByte SB1 SoCs
+ *
+ * Copyright (C) 2007 OnStor, Inc. * Andrew Sharp <andy.sharp@onstor.com>
+ *
+ * This driver is intended to make the second of two hardware watchdogs
+ * on the Sibyte 12XX and 11XX SoCs available to the user.  There are two
+ * such devices available on the SoC, but it seems that there isn't an
+ * enumeration class for watchdogs in Linux like there is for RTCs.
+ * The second is used rather than the first because it uses IRQ 1,
+ * thereby avoiding all that IRQ 0 problematic nonsense.
+ *
+ * I have not tried this driver on a 1480 processor; it might work
+ * just well enough to really screw things up.
+ *
+ * It is a simple timer, and there is an interrupt that is raised the
+ * first time the timer expires.  The second time it expires, the chip
+ * is reset and there is no way to redirect that NMI.  Which could
+ * be problematic in some cases where this chip is sitting on the HT
+ * bus and has just taken responsibility for providing a cache block.
+ * Since the reset can't be redirected to the external reset pin, it is
+ * possible that other HT connected processors might hang and not reset.
+ * For Linux, a soft reset would probably be even worse than a hard reset.
+ * There you have it.
+ *
+ * The timer takes 23 bits of a 64 bit register (?) as a count value,
+ * and decrements the count every microsecond, for a max value of
+ * 0x7fffff usec or about 8.3ish seconds.
+ *
+ * This watchdog borrows some user semantics from the softdog driver,
+ * in that if you close the fd, it leaves the watchdog running, unless
+ * you previously wrote a 'V' to the fd, in which case it disables
+ * the watchdog when you close the fd like some other drivers.
+ *
+ * Based on various other watchdog drivers, which are probably all
+ * loosely based on something Alan Cox wrote years ago.
+ *
+ *	(c) Copyright 1996 Alan Cox <alan@redhat.com>, All Rights Reserved.
+ *				http://www.redhat.com
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	version 1 or 2 as published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/reboot.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/interrupt.h>
+
+#include <asm/sibyte/sb1250.h>
+#include <asm/sibyte/sb1250_regs.h>
+#include <asm/sibyte/sb1250_int.h>
+#include <asm/sibyte/sb1250_scd.h>
+
+
+/*
+ * set the initial count value of a timer
+ *
+ * wdog is the iomem address of the cfg register
+ */
+void sbwdog_set(char __iomem *wdog, unsigned long t)
+{
+	__raw_writeb(0, wdog - 0x10);
+	__raw_writeq(t & 0x7fffffUL, wdog);
+}
+
+/*
+ * cause the timer to [re]load it's initial count and start counting
+ * all over again
+ *
+ * wdog is the iomem address of the cfg register
+ */
+void sbwdog_pet(char __iomem *wdog)
+{
+	__raw_writeb(__raw_readb(wdog) | 1, wdog);
+}
+
+static unsigned long sbwdog_gate; /* keeps it to one thread only */
+static char __iomem *kern_dog = (char __iomem *)(IO_BASE + (A_SCD_WDOG_CFG_0));
+static char __iomem *user_dog = (char __iomem *)(IO_BASE + (A_SCD_WDOG_CFG_1));
+static unsigned long timeout = 0x7fffffUL;	/* useconds: 8.3ish secs. */
+static int expect_close;
+
+static struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity	= "SiByte Watchdog",
+};
+
+/*
+ * Allow only a single thread to walk the dog
+ */
+static int sbwdog_open(struct inode *inode, struct file *file)
+{
+	nonseekable_open(inode, file);
+	if (test_and_set_bit(0, &sbwdog_gate)) {
+		return -EBUSY;
+	}
+	__module_get(THIS_MODULE);
+
+	/*
+	 * Activate the timer
+	 */
+	sbwdog_set(user_dog, timeout);
+	__raw_writeb(1, user_dog);
+
+	return 0;
+}
+
+/*
+ * Put the dog back in the kennel.
+ */
+static int sbwdog_release(struct inode *inode, struct file *file)
+{
+	if (expect_close == 42) {
+		__raw_writeb(0, user_dog);
+		module_put(THIS_MODULE);
+	} else {
+		printk(KERN_CRIT "%s: Unexpected close, not stopping watchdog!\n",
+			ident.identity);
+		sbwdog_pet(user_dog);
+	}
+	clear_bit(0, &sbwdog_gate);
+	expect_close = 0;
+
+	return 0;
+}
+
+/*
+ * 42 - the answer
+ */
+static ssize_t sbwdog_write(struct file *file, const char __user *data,
+			size_t len, loff_t *ppos)
+{
+	int i;
+
+	if (len) {
+		/*
+		 * restart the timer
+		 */
+		expect_close = 0;
+
+		for (i = 0; i != len; i++) {
+			char c;
+
+			if (get_user(c, data + i)) {
+				return -EFAULT;
+			}
+			if (c == 'V') {
+				expect_close = 42;
+			}
+		}
+		sbwdog_pet(user_dog);
+	}
+
+	return len;
+}
+
+static int sbwdog_ioctl(struct inode *inode, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	unsigned long time;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret) {
+			break;
+		}
+
+		time *= 1000000;
+		if (time > 0x7fffffUL) {
+			ret = -EINVAL;
+			break;
+		}
+		timeout = time;
+		sbwdog_set(user_dog, timeout);
+		sbwdog_pet(user_dog);
+
+	case WDIOC_GETTIMEOUT:
+		/*
+		 * get the remaining count from the ... count register
+		 * which is 1*8 before the config register
+		 */
+		ret = put_user(__raw_readq(user_dog - 8) / 1000000, p);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		sbwdog_pet(user_dog);
+		ret = 0;
+		break;
+	}
+	return ret;
+}
+
+/*
+ *	Notifier for system down
+ */
+static int
+sbwdog_notify_sys(struct notifier_block *this, unsigned long code, void *erf)
+{
+	if (code == SYS_DOWN || code == SYS_HALT) {
+		/*
+		 * sit and sit
+		 */
+		__raw_writeb(0, user_dog);
+		__raw_writeb(0, kern_dog);
+	}
+
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations sbwdog_fops =
+{
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= sbwdog_write,
+	.ioctl		= sbwdog_ioctl,
+	.open		= sbwdog_open,
+	.release	= sbwdog_release,
+};
+
+static struct miscdevice sbwdog_miscdev =
+{
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &sbwdog_fops,
+};
+
+static struct notifier_block sbwdog_notifier = {
+	.notifier_call	= sbwdog_notify_sys,
+};
+
+/*
+ * interrupt handler
+ *
+ * doesn't do a whole lot for user, but oh so cleverly written so kernel
+ * code can use it to re-up the watchdog, thereby saving the kernel from
+ * having to create and maintain a timer, just to tickle another timer,
+ * which is just so wrong.
+ */
+irqreturn_t sbwdog_interrupt(int irq, void *addr)
+{
+	unsigned long wd_init;
+	char *wd_cfg_reg = (char *)addr;
+	u8 cfg;
+
+	cfg = __raw_readb(wd_cfg_reg);
+	wd_init = __raw_readq(wd_cfg_reg - 8) & 0x7fffff;
+
+	/*
+	 * if it's the second watchdog timer, it's for those users
+	 */
+	if (wd_cfg_reg == user_dog) {
+		printk(KERN_CRIT
+			"%s in danger of initiating system reset in %ld.%01ld seconds\n",
+			ident.identity, wd_init / 1000000, (wd_init / 100000) % 10);
+	} else {
+		cfg |= 1;
+	}
+
+	__raw_writeb(cfg, wd_cfg_reg);
+
+	return IRQ_HANDLED;
+}
+
+static int __init sbwdog_init(void)
+{
+	int ret;
+
+	/*
+	 * register a reboot notifier
+	 */
+	ret = register_reboot_notifier(&sbwdog_notifier);
+	if (ret) {
+		printk (KERN_ERR "%s: cannot register reboot notifier (err=%d)\n",
+			ident.identity, ret);
+		return ret;
+	}
+
+	/*
+	 * get the resources
+	 */
+	ret = misc_register(&sbwdog_miscdev);
+	if (ret == 0) {
+		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n", ident.identity,
+			timeout / 1000000, (timeout / 100000) % 10);
+	}
+
+	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+		ident.identity, (void *)user_dog);
+	if (ret) {
+		printk(KERN_ERR "%s: failed to request irq 1 - %d\n", ident.identity,
+			ret);
+		misc_deregister(&sbwdog_miscdev);
+	}
+
+	return ret;
+}
+
+static void __exit sbwdog_exit(void)
+{
+	misc_deregister(&sbwdog_miscdev);
+}
+
+module_init(sbwdog_init);
+module_exit(sbwdog_exit);
+
+MODULE_AUTHOR("Andrew Sharp <andy.sharp@onstor.com>");
+MODULE_DESCRIPTION("SiByte Watchdog");
+
+module_param(timeout, ulong, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
+/*
+ * example code that can be put in a platform code area to utilize the
+ * first watchdog timer for the kernels own purpose.
+
+ void
+platform_wd_setup(void)
+{
+	int ret;
+
+	ret = request_irq(0, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
+	if (ret) {
+		printk(KERN_CRIT "Watchdog IRQ zero(0) failed to be requested - %d\n",
+			ret);
+	}
+}
+
+
+ */
