Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZIAIwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZIAIwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbZIAIwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:52:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:30723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZIAIwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:52:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,311,1249282800"; 
   d="scan'208";a="444495399"
Message-ID: <4A9CE0B2.5060608@intel.com>
Date: Tue, 01 Sep 2009 16:52:02 +0800
From: Shane Wang <shane.wang@intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>, shane.wang@intel.com
Subject: [PATCH] intel_txt: fix the build errors of intel_txt patch on non-X86
 platforms (resend)
Content-Type: multipart/mixed;
 boundary="------------040009070407080906020001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040009070407080906020001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Move tboot.h from asm to linux to fix the build errors of intel_txt patch on 
non-X86 platforms. Remove the tboot code from generic code init/main.c and 
kernel/cpu.c.

---
  arch/x86/Kconfig              |    4
  arch/x86/include/asm/tboot.h  |  197 --------------------------------
  arch/x86/kernel/reboot.c      |    3
  arch/x86/kernel/setup.c       |    3
  arch/x86/kernel/smpboot.c     |    2
  arch/x86/kernel/tboot.c       |   58 +++++++--
  drivers/acpi/acpica/hwsleep.c |    2
  drivers/pci/dmar.c            |    2
  drivers/pci/intel-iommu.c     |    2
  include/linux/tboot.h         |  162 ++++++++++++++++++++++++++
  init/main.c                   |    3
  kernel/cpu.c                  |    6
  security/Kconfig              |    2
  13 files changed, 221 insertions(+), 225 deletions(-)


Signed-off-by: Shane Wang <shane.wang@intel.com>

diff -r c6f74b152a32 arch/x86/Kconfig
--- a/arch/x86/Kconfig	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/Kconfig	Tue Sep 01 07:28:21 2009 -0700
@@ -179,6 +179,10 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING

  config ARCH_SUPPORTS_DEBUG_PAGEALLOC
  	def_bool y
+
+config HAVE_INTEL_TXT
+	def_bool y
+	depends on EXPERIMENTAL && DMAR && ACPI

  # Use the generic interrupt handling code in kernel/irq/:
  config GENERIC_HARDIRQS
diff -r c6f74b152a32 arch/x86/include/asm/tboot.h
--- a/arch/x86/include/asm/tboot.h	Tue Sep 01 07:24:42 2009 -0700
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,197 +0,0 @@
-/*
- * tboot.h: shared data structure with tboot and kernel and functions
- *          used by kernel for runtime support of Intel(R) Trusted
- *          Execution Technology
- *
- * Copyright (c) 2006-2009, Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-
-#ifndef _ASM_TBOOT_H
-#define _ASM_TBOOT_H
-
-#include <acpi/acpi.h>
-
-/* these must have the values from 0-5 in this order */
-enum {
-	TB_SHUTDOWN_REBOOT = 0,
-	TB_SHUTDOWN_S5,
-	TB_SHUTDOWN_S4,
-	TB_SHUTDOWN_S3,
-	TB_SHUTDOWN_HALT,
-	TB_SHUTDOWN_WFS
-};
-
-#ifdef CONFIG_INTEL_TXT
-
-/* used to communicate between tboot and the launched kernel */
-
-#define TB_KEY_SIZE             64   /* 512 bits */
-
-#define MAX_TB_MAC_REGIONS      32
-
-struct tboot_mac_region {
-	u64  start;         /* must be 64 byte -aligned */
-	u32  size;          /* must be 64 byte -granular */
-} __packed;
-
-/* GAS - Generic Address Structure (ACPI 2.0+) */
-struct tboot_acpi_generic_address {
-	u8  space_id;
-	u8  bit_width;
-	u8  bit_offset;
-	u8  access_width;
-	u64 address;
-} __packed;
-
-/*
- * combines Sx info from FADT and FACS tables per ACPI 2.0+ spec
- * (http://www.acpi.info/)
- */
-struct tboot_acpi_sleep_info {
-	struct tboot_acpi_generic_address pm1a_cnt_blk;
-	struct tboot_acpi_generic_address pm1b_cnt_blk;
-	struct tboot_acpi_generic_address pm1a_evt_blk;
-	struct tboot_acpi_generic_address pm1b_evt_blk;
-	u16 pm1a_cnt_val;
-	u16 pm1b_cnt_val;
-	u64 wakeup_vector;
-	u32 vector_width;
-	u64 kernel_s3_resume_vector;
-} __packed;
-
-/*
- * shared memory page used for communication between tboot and kernel
- */
-struct tboot {
-	/*
-	 * version 3+ fields:
-	 */
-
-	/* TBOOT_UUID */
-	u8 uuid[16];
-
-	/* version number: 5 is current */
-	u32 version;
-
-	/* physical addr of tb_log_t log */
-	u32 log_addr;
-
-	/*
-	 * physical addr of entry point for tboot shutdown and
-	 * type of shutdown (TB_SHUTDOWN_*) being requested
-	 */
-	u32 shutdown_entry;
-	u32 shutdown_type;
-
-	/* kernel-specified ACPI info for Sx shutdown */
-	struct tboot_acpi_sleep_info acpi_sinfo;
-
-	/* tboot location in memory (physical) */
-	u32 tboot_base;
-	u32 tboot_size;
-
-	/* memory regions (phys addrs) for tboot to MAC on S3 */
-	u8 num_mac_regions;
-	struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
-
-
-	/*
-	 * version 4+ fields:
-	 */
-
-	/* symmetric key for use by kernel; will be encrypted on S3 */
-	u8 s3_key[TB_KEY_SIZE];
-
-
-	/*
-	 * version 5+ fields:
-	 */
-
-	/* used to 4byte-align num_in_wfs */
-	u8 reserved_align[3];
-
-	/* number of processors in wait-for-SIPI */
-	u32 num_in_wfs;
-} __packed;
-
-/*
- * UUID for tboot data struct to facilitate matching
- * defined as {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} by tboot, which is
- * represented as {} in the char array used here
- */
-#define TBOOT_UUID	{0xff, 0x8d, 0x3c, 0x66, 0xb3, 0xe8, 0x82, 0x4b, 0xbf,\
-			 0xaa, 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8}
-
-extern struct tboot *tboot;
-
-static inline int tboot_enabled(void)
-{
-	return tboot != NULL;
-}
-
-extern void tboot_probe(void);
-extern void tboot_create_trampoline(void);
-extern void tboot_shutdown(u32 shutdown_type);
-extern void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control);
-extern int tboot_wait_for_aps(int num_aps);
-extern struct acpi_table_header *tboot_get_dmar_table(
-				      struct acpi_table_header *dmar_tbl);
-extern int tboot_force_iommu(void);
-
-#else     /* CONFIG_INTEL_TXT */
-
-static inline int tboot_enabled(void)
-{
-	return 0;
-}
-
-static inline void tboot_probe(void)
-{
-}
-
-static inline void tboot_create_trampoline(void)
-{
-}
-
-static inline void tboot_shutdown(u32 shutdown_type)
-{
-}
-
-static inline void tboot_sleep(u8 sleep_state, u32 pm1a_control,
-			       u32 pm1b_control)
-{
-}
-
-static inline int tboot_wait_for_aps(int num_aps)
-{
-	return 0;
-}
-
-static inline struct acpi_table_header *tboot_get_dmar_table(
-					struct acpi_table_header *dmar_tbl)
-{
-	return dmar_tbl;
-}
-
-static inline int tboot_force_iommu(void)
-{
-	return 0;
-}
-
-#endif /* !CONFIG_INTEL_TXT */
-
-#endif /* _ASM_TBOOT_H */
diff -r c6f74b152a32 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/reboot.c	Tue Sep 01 07:28:21 2009 -0700
@@ -4,6 +4,7 @@
  #include <linux/pm.h>
  #include <linux/efi.h>
  #include <linux/dmi.h>
+#include <linux/tboot.h>
  #include <acpi/reboot.h>
  #include <asm/io.h>
  #include <asm/apic.h>
@@ -23,8 +24,6 @@
  #else
  # include <asm/iommu.h>
  #endif
-
-#include <asm/tboot.h>

  /*
   * Power off function, if any
diff -r c6f74b152a32 arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/setup.c	Tue Sep 01 07:28:21 2009 -0700
@@ -66,6 +66,7 @@

  #include <linux/percpu.h>
  #include <linux/crash_dump.h>
+#include <linux/tboot.h>

  #include <video/edid.h>

@@ -140,8 +141,6 @@ struct boot_params __initdata boot_param
  #else
  struct boot_params boot_params;
  #endif
-
-#include <asm/tboot.h>

  /*
   * Machine setup..
diff -r c6f74b152a32 arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/smpboot.c	Tue Sep 01 07:28:21 2009 -0700
@@ -47,6 +47,7 @@
  #include <linux/bootmem.h>
  #include <linux/err.h>
  #include <linux/nmi.h>
+#include <linux/tboot.h>

  #include <asm/acpi.h>
  #include <asm/desc.h>
@@ -62,7 +63,6 @@
  #include <asm/vmi.h>
  #include <asm/apic.h>
  #include <asm/setup.h>
-#include <asm/tboot.h>
  #include <asm/uv/uv.h>
  #include <asm/debugreg.h>
  #include <linux/mc146818rtc.h>
diff -r c6f74b152a32 arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/tboot.c	Tue Sep 01 07:28:21 2009 -0700
@@ -22,11 +22,14 @@
  #include <linux/dma_remapping.h>
  #include <linux/init_task.h>
  #include <linux/spinlock.h>
+#include <linux/delay.h>
  #include <linux/sched.h>
  #include <linux/init.h>
  #include <linux/dmar.h>
+#include <linux/cpu.h>
  #include <linux/pfn.h>
  #include <linux/mm.h>
+#include <linux/tboot.h>

  #include <asm/trampoline.h>
  #include <asm/processor.h>
@@ -36,7 +39,6 @@
  #include <asm/fixmap.h>
  #include <asm/proto.h>
  #include <asm/setup.h>
-#include <asm/tboot.h>
  #include <asm/e820.h>
  #include <asm/io.h>

@@ -154,12 +156,9 @@ static int map_tboot_pages(unsigned long
  	return 0;
  }

-void tboot_create_trampoline(void)
+static void tboot_create_trampoline(void)
  {
  	u32 map_base, map_size;
-
-	if (!tboot_enabled())
-		return;

  	/* Create identity map for tboot shutdown code. */
  	map_base = PFN_DOWN(tboot->tboot_base);
@@ -295,20 +294,57 @@ void tboot_sleep(u8 sleep_state, u32 pm1
  	tboot_shutdown(acpi_shutdown_map[sleep_state]);
  }

-int tboot_wait_for_aps(int num_aps)
+static atomic_t ap_wfs_count;
+
+static int tboot_wait_for_aps(int num_aps)
  {
  	unsigned long timeout;

+	timeout = AP_WAIT_TIMEOUT*HZ;
+	while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
+	       timeout) {
+		mdelay(1);
+		timeout--;
+	}
+
+	if (timeout)
+		pr_warning("tboot wait for APs timeout\n");
+
+	return !(atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps);
+}
+
+static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,
+			unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_DYING:
+		atomic_inc(&ap_wfs_count);
+		if (num_online_cpus() == 1)
+			if (tboot_wait_for_aps(atomic_read(&ap_wfs_count)))
+				return NOTIFY_BAD;
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tboot_cpu_notifier __cpuinitdata =
+{
+	.notifier_call = tboot_cpu_callback,
+};
+
+static __init int tboot_late_init(void)
+{
  	if (!tboot_enabled())
  		return 0;

-	timeout = jiffies + AP_WAIT_TIMEOUT*HZ;
-	while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
-	       time_before(jiffies, timeout))
-		cpu_relax();
+	tboot_create_trampoline();

-	return time_before(jiffies, timeout) ? 0 : 1;
+	atomic_set(&ap_wfs_count, 0);
+	register_hotcpu_notifier(&tboot_cpu_notifier);
+	return 0;
  }
+
+late_initcall(tboot_late_init);

  /*
   * TXT configuration registers (offsets from TXT_{PUB, PRIV}_CONFIG_REGS_BASE)
diff -r c6f74b152a32 drivers/acpi/acpica/hwsleep.c
--- a/drivers/acpi/acpica/hwsleep.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/drivers/acpi/acpica/hwsleep.c	Tue Sep 01 07:28:21 2009 -0700
@@ -45,7 +45,7 @@
  #include <acpi/acpi.h>
  #include "accommon.h"
  #include "actables.h"
-#include <asm/tboot.h>
+#include <linux/tboot.h>

  #define _COMPONENT          ACPI_HARDWARE
  ACPI_MODULE_NAME("hwsleep")
diff -r c6f74b152a32 drivers/pci/dmar.c
--- a/drivers/pci/dmar.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/drivers/pci/dmar.c	Tue Sep 01 07:28:21 2009 -0700
@@ -33,7 +33,7 @@
  #include <linux/timer.h>
  #include <linux/irq.h>
  #include <linux/interrupt.h>
-#include <asm/tboot.h>
+#include <linux/tboot.h>

  #undef PREFIX
  #define PREFIX "DMAR:"
diff -r c6f74b152a32 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/drivers/pci/intel-iommu.c	Tue Sep 01 07:28:21 2009 -0700
@@ -37,8 +37,8 @@
  #include <linux/iommu.h>
  #include <linux/intel-iommu.h>
  #include <linux/sysdev.h>
+#include <linux/tboot.h>
  #include <asm/cacheflush.h>
-#include <asm/tboot.h>
  #include <asm/iommu.h>
  #include "pci.h"

diff -r c6f74b152a32 include/linux/tboot.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/linux/tboot.h	Tue Sep 01 07:28:21 2009 -0700
@@ -0,0 +1,162 @@
+/*
+ * tboot.h: shared data structure with tboot and kernel and functions
+ *          used by kernel for runtime support of Intel(R) Trusted
+ *          Execution Technology
+ *
+ * Copyright (c) 2006-2009, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef _LINUX_TBOOT_H
+#define _LINUX_TBOOT_H
+
+/* these must have the values from 0-5 in this order */
+enum {
+	TB_SHUTDOWN_REBOOT = 0,
+	TB_SHUTDOWN_S5,
+	TB_SHUTDOWN_S4,
+	TB_SHUTDOWN_S3,
+	TB_SHUTDOWN_HALT,
+	TB_SHUTDOWN_WFS
+};
+
+#ifdef CONFIG_INTEL_TXT
+#include <acpi/acpi.h>
+/* used to communicate between tboot and the launched kernel */
+
+#define TB_KEY_SIZE             64   /* 512 bits */
+
+#define MAX_TB_MAC_REGIONS      32
+
+struct tboot_mac_region {
+	u64  start;         /* must be 64 byte -aligned */
+	u32  size;          /* must be 64 byte -granular */
+} __packed;
+
+/* GAS - Generic Address Structure (ACPI 2.0+) */
+struct tboot_acpi_generic_address {
+	u8  space_id;
+	u8  bit_width;
+	u8  bit_offset;
+	u8  access_width;
+	u64 address;
+} __packed;
+
+/*
+ * combines Sx info from FADT and FACS tables per ACPI 2.0+ spec
+ * (http://www.acpi.info/)
+ */
+struct tboot_acpi_sleep_info {
+	struct tboot_acpi_generic_address pm1a_cnt_blk;
+	struct tboot_acpi_generic_address pm1b_cnt_blk;
+	struct tboot_acpi_generic_address pm1a_evt_blk;
+	struct tboot_acpi_generic_address pm1b_evt_blk;
+	u16 pm1a_cnt_val;
+	u16 pm1b_cnt_val;
+	u64 wakeup_vector;
+	u32 vector_width;
+	u64 kernel_s3_resume_vector;
+} __packed;
+
+/*
+ * shared memory page used for communication between tboot and kernel
+ */
+struct tboot {
+	/*
+	 * version 3+ fields:
+	 */
+
+	/* TBOOT_UUID */
+	u8 uuid[16];
+
+	/* version number: 5 is current */
+	u32 version;
+
+	/* physical addr of tb_log_t log */
+	u32 log_addr;
+
+	/*
+	 * physical addr of entry point for tboot shutdown and
+	 * type of shutdown (TB_SHUTDOWN_*) being requested
+	 */
+	u32 shutdown_entry;
+	u32 shutdown_type;
+
+	/* kernel-specified ACPI info for Sx shutdown */
+	struct tboot_acpi_sleep_info acpi_sinfo;
+
+	/* tboot location in memory (physical) */
+	u32 tboot_base;
+	u32 tboot_size;
+
+	/* memory regions (phys addrs) for tboot to MAC on S3 */
+	u8 num_mac_regions;
+	struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
+
+
+	/*
+	 * version 4+ fields:
+	 */
+
+	/* symmetric key for use by kernel; will be encrypted on S3 */
+	u8 s3_key[TB_KEY_SIZE];
+
+
+	/*
+	 * version 5+ fields:
+	 */
+
+	/* used to 4byte-align num_in_wfs */
+	u8 reserved_align[3];
+
+	/* number of processors in wait-for-SIPI */
+	u32 num_in_wfs;
+} __packed;
+
+/*
+ * UUID for tboot data struct to facilitate matching
+ * defined as {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} by tboot, which is
+ * represented as {} in the char array used here
+ */
+#define TBOOT_UUID	{0xff, 0x8d, 0x3c, 0x66, 0xb3, 0xe8, 0x82, 0x4b, 0xbf,\
+			 0xaa, 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8}
+
+extern struct tboot *tboot;
+
+static inline int tboot_enabled(void)
+{
+	return tboot != NULL;
+}
+
+extern void tboot_probe(void);
+extern void tboot_shutdown(u32 shutdown_type);
+extern void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control);
+extern struct acpi_table_header *tboot_get_dmar_table(
+				      struct acpi_table_header *dmar_tbl);
+extern int tboot_force_iommu(void);
+
+#else
+
+#define tboot_probe()			do { } while (0)
+#define tboot_shutdown(shutdown_type)	do { } while (0)
+#define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
+					do { } while (0)
+#define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
+#define tboot_force_iommu()		0
+
+#endif /* !CONFIG_INTEL_TXT */
+
+#endif /* _LINUX_TBOOT_H */
diff -r c6f74b152a32 init/main.c
--- a/init/main.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/init/main.c	Tue Sep 01 07:28:21 2009 -0700
@@ -73,7 +73,6 @@
  #include <asm/io.h>
  #include <asm/bugs.h>
  #include <asm/setup.h>
-#include <asm/tboot.h>
  #include <asm/sections.h>
  #include <asm/cacheflush.h>

@@ -716,8 +715,6 @@ asmlinkage void __init start_kernel(void

  	ftrace_init();

-	tboot_create_trampoline();
-
  	/* Do the rest non-__init'ed, we're now alive */
  	rest_init();
  }
diff -r c6f74b152a32 kernel/cpu.c
--- a/kernel/cpu.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/kernel/cpu.c	Tue Sep 01 07:28:21 2009 -0700
@@ -14,7 +14,6 @@
  #include <linux/kthread.h>
  #include <linux/stop_machine.h>
  #include <linux/mutex.h>
-#include <asm/tboot.h>

  #ifdef CONFIG_SMP
  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -377,7 +376,7 @@ static cpumask_var_t frozen_cpus;

  int disable_nonboot_cpus(void)
  {
-	int cpu, first_cpu, error, num_cpus = 0;
+	int cpu, first_cpu, error;

  	error = stop_machine_create();
  	if (error)
@@ -392,7 +391,6 @@ int disable_nonboot_cpus(void)
  	for_each_online_cpu(cpu) {
  		if (cpu == first_cpu)
  			continue;
-		num_cpus++;
  		error = _cpu_down(cpu, 1);
  		if (!error) {
  			cpumask_set_cpu(cpu, frozen_cpus);
@@ -403,8 +401,6 @@ int disable_nonboot_cpus(void)
  			break;
  		}
  	}
-	/* ensure all CPUs have gone into wait-for-SIPI */
-	error |= tboot_wait_for_aps(num_cpus);

  	if (!error) {
  		BUG_ON(num_online_cpus() > 1);
diff -r c6f74b152a32 security/Kconfig
--- a/security/Kconfig	Tue Sep 01 07:24:42 2009 -0700
+++ b/security/Kconfig	Tue Sep 01 07:28:21 2009 -0700
@@ -131,7 +131,7 @@ config LSM_MMAP_MIN_ADDR

  config INTEL_TXT
  	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
-	depends on EXPERIMENTAL && X86 && DMAR && ACPI
+	depends on HAVE_INTEL_TXT
  	help
  	  This option enables support for booting the kernel with the
  	  Trusted Boot (tboot) module. This will utilize


--------------040009070407080906020001
Content-Type: text/plain;
 name="tboot_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tboot_fix.patch"

Move tboot.h from asm to linux to fix the build errors of intel_txt patch on non-X86 platforms. Remove the tboot code from generic code init/main.c and kernel/cpu.c.

Signed-off-by: Shane Wang <shane.wang@intel.com>

diff -r c6f74b152a32 arch/x86/Kconfig
--- a/arch/x86/Kconfig	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/Kconfig	Tue Sep 01 07:28:21 2009 -0700
@@ -179,6 +179,10 @@ config ARCH_SUPPORTS_OPTIMIZED_INLINING
 
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
+
+config HAVE_INTEL_TXT
+	def_bool y
+	depends on EXPERIMENTAL && DMAR && ACPI
 
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
diff -r c6f74b152a32 arch/x86/include/asm/tboot.h
--- a/arch/x86/include/asm/tboot.h	Tue Sep 01 07:24:42 2009 -0700
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,197 +0,0 @@
-/*
- * tboot.h: shared data structure with tboot and kernel and functions
- *          used by kernel for runtime support of Intel(R) Trusted
- *          Execution Technology
- *
- * Copyright (c) 2006-2009, Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-
-#ifndef _ASM_TBOOT_H
-#define _ASM_TBOOT_H
-
-#include <acpi/acpi.h>
-
-/* these must have the values from 0-5 in this order */
-enum {
-	TB_SHUTDOWN_REBOOT = 0,
-	TB_SHUTDOWN_S5,
-	TB_SHUTDOWN_S4,
-	TB_SHUTDOWN_S3,
-	TB_SHUTDOWN_HALT,
-	TB_SHUTDOWN_WFS
-};
-
-#ifdef CONFIG_INTEL_TXT
-
-/* used to communicate between tboot and the launched kernel */
-
-#define TB_KEY_SIZE             64   /* 512 bits */
-
-#define MAX_TB_MAC_REGIONS      32
-
-struct tboot_mac_region {
-	u64  start;         /* must be 64 byte -aligned */
-	u32  size;          /* must be 64 byte -granular */
-} __packed;
-
-/* GAS - Generic Address Structure (ACPI 2.0+) */
-struct tboot_acpi_generic_address {
-	u8  space_id;
-	u8  bit_width;
-	u8  bit_offset;
-	u8  access_width;
-	u64 address;
-} __packed;
-
-/*
- * combines Sx info from FADT and FACS tables per ACPI 2.0+ spec
- * (http://www.acpi.info/)
- */
-struct tboot_acpi_sleep_info {
-	struct tboot_acpi_generic_address pm1a_cnt_blk;
-	struct tboot_acpi_generic_address pm1b_cnt_blk;
-	struct tboot_acpi_generic_address pm1a_evt_blk;
-	struct tboot_acpi_generic_address pm1b_evt_blk;
-	u16 pm1a_cnt_val;
-	u16 pm1b_cnt_val;
-	u64 wakeup_vector;
-	u32 vector_width;
-	u64 kernel_s3_resume_vector;
-} __packed;
-
-/*
- * shared memory page used for communication between tboot and kernel
- */
-struct tboot {
-	/*
-	 * version 3+ fields:
-	 */
-
-	/* TBOOT_UUID */
-	u8 uuid[16];
-
-	/* version number: 5 is current */
-	u32 version;
-
-	/* physical addr of tb_log_t log */
-	u32 log_addr;
-
-	/*
-	 * physical addr of entry point for tboot shutdown and
-	 * type of shutdown (TB_SHUTDOWN_*) being requested
-	 */
-	u32 shutdown_entry;
-	u32 shutdown_type;
-
-	/* kernel-specified ACPI info for Sx shutdown */
-	struct tboot_acpi_sleep_info acpi_sinfo;
-
-	/* tboot location in memory (physical) */
-	u32 tboot_base;
-	u32 tboot_size;
-
-	/* memory regions (phys addrs) for tboot to MAC on S3 */
-	u8 num_mac_regions;
-	struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
-
-
-	/*
-	 * version 4+ fields:
-	 */
-
-	/* symmetric key for use by kernel; will be encrypted on S3 */
-	u8 s3_key[TB_KEY_SIZE];
-
-
-	/*
-	 * version 5+ fields:
-	 */
-
-	/* used to 4byte-align num_in_wfs */
-	u8 reserved_align[3];
-
-	/* number of processors in wait-for-SIPI */
-	u32 num_in_wfs;
-} __packed;
-
-/*
- * UUID for tboot data struct to facilitate matching
- * defined as {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} by tboot, which is
- * represented as {} in the char array used here
- */
-#define TBOOT_UUID	{0xff, 0x8d, 0x3c, 0x66, 0xb3, 0xe8, 0x82, 0x4b, 0xbf,\
-			 0xaa, 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8}
-
-extern struct tboot *tboot;
-
-static inline int tboot_enabled(void)
-{
-	return tboot != NULL;
-}
-
-extern void tboot_probe(void);
-extern void tboot_create_trampoline(void);
-extern void tboot_shutdown(u32 shutdown_type);
-extern void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control);
-extern int tboot_wait_for_aps(int num_aps);
-extern struct acpi_table_header *tboot_get_dmar_table(
-				      struct acpi_table_header *dmar_tbl);
-extern int tboot_force_iommu(void);
-
-#else     /* CONFIG_INTEL_TXT */
-
-static inline int tboot_enabled(void)
-{
-	return 0;
-}
-
-static inline void tboot_probe(void)
-{
-}
-
-static inline void tboot_create_trampoline(void)
-{
-}
-
-static inline void tboot_shutdown(u32 shutdown_type)
-{
-}
-
-static inline void tboot_sleep(u8 sleep_state, u32 pm1a_control,
-			       u32 pm1b_control)
-{
-}
-
-static inline int tboot_wait_for_aps(int num_aps)
-{
-	return 0;
-}
-
-static inline struct acpi_table_header *tboot_get_dmar_table(
-					struct acpi_table_header *dmar_tbl)
-{
-	return dmar_tbl;
-}
-
-static inline int tboot_force_iommu(void)
-{
-	return 0;
-}
-
-#endif /* !CONFIG_INTEL_TXT */
-
-#endif /* _ASM_TBOOT_H */
diff -r c6f74b152a32 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/reboot.c	Tue Sep 01 07:28:21 2009 -0700
@@ -4,6 +4,7 @@
 #include <linux/pm.h>
 #include <linux/efi.h>
 #include <linux/dmi.h>
+#include <linux/tboot.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
@@ -23,8 +24,6 @@
 #else
 # include <asm/iommu.h>
 #endif
-
-#include <asm/tboot.h>
 
 /*
  * Power off function, if any
diff -r c6f74b152a32 arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/setup.c	Tue Sep 01 07:28:21 2009 -0700
@@ -66,6 +66,7 @@
 
 #include <linux/percpu.h>
 #include <linux/crash_dump.h>
+#include <linux/tboot.h>
 
 #include <video/edid.h>
 
@@ -140,8 +141,6 @@ struct boot_params __initdata boot_param
 #else
 struct boot_params boot_params;
 #endif
-
-#include <asm/tboot.h>
 
 /*
  * Machine setup..
diff -r c6f74b152a32 arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/smpboot.c	Tue Sep 01 07:28:21 2009 -0700
@@ -47,6 +47,7 @@
 #include <linux/bootmem.h>
 #include <linux/err.h>
 #include <linux/nmi.h>
+#include <linux/tboot.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -62,7 +63,6 @@
 #include <asm/vmi.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
-#include <asm/tboot.h>
 #include <asm/uv/uv.h>
 #include <asm/debugreg.h>
 #include <linux/mc146818rtc.h>
diff -r c6f74b152a32 arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/arch/x86/kernel/tboot.c	Tue Sep 01 07:28:21 2009 -0700
@@ -22,11 +22,14 @@
 #include <linux/dma_remapping.h>
 #include <linux/init_task.h>
 #include <linux/spinlock.h>
+#include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/dmar.h>
+#include <linux/cpu.h>
 #include <linux/pfn.h>
 #include <linux/mm.h>
+#include <linux/tboot.h>
 
 #include <asm/trampoline.h>
 #include <asm/processor.h>
@@ -36,7 +39,6 @@
 #include <asm/fixmap.h>
 #include <asm/proto.h>
 #include <asm/setup.h>
-#include <asm/tboot.h>
 #include <asm/e820.h>
 #include <asm/io.h>
 
@@ -154,12 +156,9 @@ static int map_tboot_pages(unsigned long
 	return 0;
 }
 
-void tboot_create_trampoline(void)
+static void tboot_create_trampoline(void)
 {
 	u32 map_base, map_size;
-
-	if (!tboot_enabled())
-		return;
 
 	/* Create identity map for tboot shutdown code. */
 	map_base = PFN_DOWN(tboot->tboot_base);
@@ -295,20 +294,57 @@ void tboot_sleep(u8 sleep_state, u32 pm1
 	tboot_shutdown(acpi_shutdown_map[sleep_state]);
 }
 
-int tboot_wait_for_aps(int num_aps)
+static atomic_t ap_wfs_count;
+
+static int tboot_wait_for_aps(int num_aps)
 {
 	unsigned long timeout;
 
+	timeout = AP_WAIT_TIMEOUT*HZ;
+	while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
+	       timeout) {
+		mdelay(1);
+		timeout--;
+	}
+
+	if (timeout)
+		pr_warning("tboot wait for APs timeout\n");
+
+	return !(atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps);
+}
+
+static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,
+			unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_DYING:
+		atomic_inc(&ap_wfs_count);
+		if (num_online_cpus() == 1)
+			if (tboot_wait_for_aps(atomic_read(&ap_wfs_count)))
+				return NOTIFY_BAD;
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tboot_cpu_notifier __cpuinitdata =
+{
+	.notifier_call = tboot_cpu_callback,
+};
+
+static __init int tboot_late_init(void)
+{
 	if (!tboot_enabled())
 		return 0;
 
-	timeout = jiffies + AP_WAIT_TIMEOUT*HZ;
-	while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
-	       time_before(jiffies, timeout))
-		cpu_relax();
+	tboot_create_trampoline();
 
-	return time_before(jiffies, timeout) ? 0 : 1;
+	atomic_set(&ap_wfs_count, 0);
+	register_hotcpu_notifier(&tboot_cpu_notifier);
+	return 0;
 }
+
+late_initcall(tboot_late_init);
 
 /*
  * TXT configuration registers (offsets from TXT_{PUB, PRIV}_CONFIG_REGS_BASE)
diff -r c6f74b152a32 drivers/acpi/acpica/hwsleep.c
--- a/drivers/acpi/acpica/hwsleep.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/drivers/acpi/acpica/hwsleep.c	Tue Sep 01 07:28:21 2009 -0700
@@ -45,7 +45,7 @@
 #include <acpi/acpi.h>
 #include "accommon.h"
 #include "actables.h"
-#include <asm/tboot.h>
+#include <linux/tboot.h>
 
 #define _COMPONENT          ACPI_HARDWARE
 ACPI_MODULE_NAME("hwsleep")
diff -r c6f74b152a32 drivers/pci/dmar.c
--- a/drivers/pci/dmar.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/drivers/pci/dmar.c	Tue Sep 01 07:28:21 2009 -0700
@@ -33,7 +33,7 @@
 #include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <asm/tboot.h>
+#include <linux/tboot.h>
 
 #undef PREFIX
 #define PREFIX "DMAR:"
diff -r c6f74b152a32 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/drivers/pci/intel-iommu.c	Tue Sep 01 07:28:21 2009 -0700
@@ -37,8 +37,8 @@
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <linux/sysdev.h>
+#include <linux/tboot.h>
 #include <asm/cacheflush.h>
-#include <asm/tboot.h>
 #include <asm/iommu.h>
 #include "pci.h"
 
diff -r c6f74b152a32 include/linux/tboot.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/linux/tboot.h	Tue Sep 01 07:28:21 2009 -0700
@@ -0,0 +1,162 @@
+/*
+ * tboot.h: shared data structure with tboot and kernel and functions
+ *          used by kernel for runtime support of Intel(R) Trusted
+ *          Execution Technology
+ *
+ * Copyright (c) 2006-2009, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef _LINUX_TBOOT_H
+#define _LINUX_TBOOT_H
+
+/* these must have the values from 0-5 in this order */
+enum {
+	TB_SHUTDOWN_REBOOT = 0,
+	TB_SHUTDOWN_S5,
+	TB_SHUTDOWN_S4,
+	TB_SHUTDOWN_S3,
+	TB_SHUTDOWN_HALT,
+	TB_SHUTDOWN_WFS
+};
+
+#ifdef CONFIG_INTEL_TXT
+#include <acpi/acpi.h>
+/* used to communicate between tboot and the launched kernel */
+
+#define TB_KEY_SIZE             64   /* 512 bits */
+
+#define MAX_TB_MAC_REGIONS      32
+
+struct tboot_mac_region {
+	u64  start;         /* must be 64 byte -aligned */
+	u32  size;          /* must be 64 byte -granular */
+} __packed;
+
+/* GAS - Generic Address Structure (ACPI 2.0+) */
+struct tboot_acpi_generic_address {
+	u8  space_id;
+	u8  bit_width;
+	u8  bit_offset;
+	u8  access_width;
+	u64 address;
+} __packed;
+
+/*
+ * combines Sx info from FADT and FACS tables per ACPI 2.0+ spec
+ * (http://www.acpi.info/)
+ */
+struct tboot_acpi_sleep_info {
+	struct tboot_acpi_generic_address pm1a_cnt_blk;
+	struct tboot_acpi_generic_address pm1b_cnt_blk;
+	struct tboot_acpi_generic_address pm1a_evt_blk;
+	struct tboot_acpi_generic_address pm1b_evt_blk;
+	u16 pm1a_cnt_val;
+	u16 pm1b_cnt_val;
+	u64 wakeup_vector;
+	u32 vector_width;
+	u64 kernel_s3_resume_vector;
+} __packed;
+
+/*
+ * shared memory page used for communication between tboot and kernel
+ */
+struct tboot {
+	/*
+	 * version 3+ fields:
+	 */
+
+	/* TBOOT_UUID */
+	u8 uuid[16];
+
+	/* version number: 5 is current */
+	u32 version;
+
+	/* physical addr of tb_log_t log */
+	u32 log_addr;
+
+	/*
+	 * physical addr of entry point for tboot shutdown and
+	 * type of shutdown (TB_SHUTDOWN_*) being requested
+	 */
+	u32 shutdown_entry;
+	u32 shutdown_type;
+
+	/* kernel-specified ACPI info for Sx shutdown */
+	struct tboot_acpi_sleep_info acpi_sinfo;
+
+	/* tboot location in memory (physical) */
+	u32 tboot_base;
+	u32 tboot_size;
+
+	/* memory regions (phys addrs) for tboot to MAC on S3 */
+	u8 num_mac_regions;
+	struct tboot_mac_region mac_regions[MAX_TB_MAC_REGIONS];
+
+
+	/*
+	 * version 4+ fields:
+	 */
+
+	/* symmetric key for use by kernel; will be encrypted on S3 */
+	u8 s3_key[TB_KEY_SIZE];
+
+
+	/*
+	 * version 5+ fields:
+	 */
+
+	/* used to 4byte-align num_in_wfs */
+	u8 reserved_align[3];
+
+	/* number of processors in wait-for-SIPI */
+	u32 num_in_wfs;
+} __packed;
+
+/*
+ * UUID for tboot data struct to facilitate matching
+ * defined as {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} by tboot, which is
+ * represented as {} in the char array used here
+ */
+#define TBOOT_UUID	{0xff, 0x8d, 0x3c, 0x66, 0xb3, 0xe8, 0x82, 0x4b, 0xbf,\
+			 0xaa, 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8}
+
+extern struct tboot *tboot;
+
+static inline int tboot_enabled(void)
+{
+	return tboot != NULL;
+}
+
+extern void tboot_probe(void);
+extern void tboot_shutdown(u32 shutdown_type);
+extern void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control);
+extern struct acpi_table_header *tboot_get_dmar_table(
+				      struct acpi_table_header *dmar_tbl);
+extern int tboot_force_iommu(void);
+
+#else
+
+#define tboot_probe()			do { } while (0)
+#define tboot_shutdown(shutdown_type)	do { } while (0)
+#define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
+					do { } while (0)
+#define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
+#define tboot_force_iommu()		0
+
+#endif /* !CONFIG_INTEL_TXT */
+
+#endif /* _LINUX_TBOOT_H */
diff -r c6f74b152a32 init/main.c
--- a/init/main.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/init/main.c	Tue Sep 01 07:28:21 2009 -0700
@@ -73,7 +73,6 @@
 #include <asm/io.h>
 #include <asm/bugs.h>
 #include <asm/setup.h>
-#include <asm/tboot.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
@@ -716,8 +715,6 @@ asmlinkage void __init start_kernel(void
 
 	ftrace_init();
 
-	tboot_create_trampoline();
-
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }
diff -r c6f74b152a32 kernel/cpu.c
--- a/kernel/cpu.c	Tue Sep 01 07:24:42 2009 -0700
+++ b/kernel/cpu.c	Tue Sep 01 07:28:21 2009 -0700
@@ -14,7 +14,6 @@
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
 #include <linux/mutex.h>
-#include <asm/tboot.h>
 
 #ifdef CONFIG_SMP
 /* Serializes the updates to cpu_online_mask, cpu_present_mask */
@@ -377,7 +376,7 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error, num_cpus = 0;
+	int cpu, first_cpu, error;
 
 	error = stop_machine_create();
 	if (error)
@@ -392,7 +391,6 @@ int disable_nonboot_cpus(void)
 	for_each_online_cpu(cpu) {
 		if (cpu == first_cpu)
 			continue;
-		num_cpus++;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
 			cpumask_set_cpu(cpu, frozen_cpus);
@@ -403,8 +401,6 @@ int disable_nonboot_cpus(void)
 			break;
 		}
 	}
-	/* ensure all CPUs have gone into wait-for-SIPI */
-	error |= tboot_wait_for_aps(num_cpus);
 
 	if (!error) {
 		BUG_ON(num_online_cpus() > 1);
diff -r c6f74b152a32 security/Kconfig
--- a/security/Kconfig	Tue Sep 01 07:24:42 2009 -0700
+++ b/security/Kconfig	Tue Sep 01 07:28:21 2009 -0700
@@ -131,7 +131,7 @@ config LSM_MMAP_MIN_ADDR
 
 config INTEL_TXT
 	bool "Enable Intel(R) Trusted Execution Technology (Intel(R) TXT)"
-	depends on EXPERIMENTAL && X86 && DMAR && ACPI
+	depends on HAVE_INTEL_TXT
 	help
 	  This option enables support for booting the kernel with the
 	  Trusted Boot (tboot) module. This will utilize

--------------040009070407080906020001--
