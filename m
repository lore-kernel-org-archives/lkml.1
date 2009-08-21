Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZHUNEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZHUNEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZHUNEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:04:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:20225 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZHUND7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:03:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,250,1249282800"; 
   d="scan'208";a="543537101"
Message-ID: <4A8E9B3C.5070604@intel.com>
Date: Fri, 21 Aug 2009 21:03:56 +0800
From: Shane Wang <shane.wang@intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: [PATCH] txt: fix the build errors on non-X86 platforms
References: <4A4ACA66.2000706@intel.com> <20090817154055.GA12985@elte.hu> <20090817155348.GA2254@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EC3AB3B2@pdsmsx502.ccr.corp.intel.com> <20090820161038.GA29994@basil.fritz.box>
In-Reply-To: <20090820161038.GA29994@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves tboot.h from asm to linux to fix the build errors on non-X86 
platforms.

Signed-off-by: Shane Wang <shane.wang@intel.com>


diff -r 04f249f00303 arch/x86/include/asm/tboot.h
--- a/arch/x86/include/asm/tboot.h	Tue Aug 18 12:06:57 2009 -0700
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
diff -r 04f249f00303 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/arch/x86/kernel/reboot.c	Thu Aug 20 19:22:30 2009 -0700
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
diff -r 04f249f00303 arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/arch/x86/kernel/setup.c	Thu Aug 20 19:22:30 2009 -0700
@@ -66,6 +66,7 @@

  #include <linux/percpu.h>
  #include <linux/crash_dump.h>
+#include <linux/tboot.h>

  #include <video/edid.h>

@@ -144,8 +145,6 @@ struct boot_params __initdata boot_param
  #else
  struct boot_params boot_params;
  #endif
-
-#include <asm/tboot.h>

  /*
   * Machine setup..
diff -r 04f249f00303 arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/arch/x86/kernel/smpboot.c	Thu Aug 20 19:22:30 2009 -0700
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
diff -r 04f249f00303 arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/arch/x86/kernel/tboot.c	Thu Aug 20 19:22:30 2009 -0700
@@ -27,6 +27,7 @@
  #include <linux/dmar.h>
  #include <linux/pfn.h>
  #include <linux/mm.h>
+#include <linux/tboot.h>

  #include <asm/trampoline.h>
  #include <asm/processor.h>
@@ -36,7 +37,6 @@
  #include <asm/fixmap.h>
  #include <asm/proto.h>
  #include <asm/setup.h>
-#include <asm/tboot.h>
  #include <asm/e820.h>
  #include <asm/io.h>

diff -r 04f249f00303 drivers/acpi/acpica/hwsleep.c
--- a/drivers/acpi/acpica/hwsleep.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/drivers/acpi/acpica/hwsleep.c	Thu Aug 20 19:22:30 2009 -0700
@@ -45,7 +45,7 @@
  #include <acpi/acpi.h>
  #include "accommon.h"
  #include "actables.h"
-#include <asm/tboot.h>
+#include <linux/tboot.h>

  #define _COMPONENT          ACPI_HARDWARE
  ACPI_MODULE_NAME("hwsleep")
diff -r 04f249f00303 drivers/pci/dmar.c
--- a/drivers/pci/dmar.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/drivers/pci/dmar.c	Thu Aug 20 19:22:30 2009 -0700
@@ -33,7 +33,7 @@
  #include <linux/timer.h>
  #include <linux/irq.h>
  #include <linux/interrupt.h>
-#include <asm/tboot.h>
+#include <linux/tboot.h>

  #undef PREFIX
  #define PREFIX "DMAR:"
diff -r 04f249f00303 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/drivers/pci/intel-iommu.c	Thu Aug 20 19:22:31 2009 -0700
@@ -37,8 +37,8 @@
  #include <linux/iommu.h>
  #include <linux/intel-iommu.h>
  #include <linux/sysdev.h>
+#include <linux/tboot.h>
  #include <asm/cacheflush.h>
-#include <asm/tboot.h>
  #include <asm/iommu.h>
  #include "pci.h"

diff -r 04f249f00303 include/linux/tboot.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/linux/tboot.h	Thu Aug 20 19:22:31 2009 -0700
@@ -0,0 +1,169 @@
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
+#ifdef CONFIG_X86
+/* these must have the values from 0-5 in this order */
+enum {
+	TB_SHUTDOWN_REBOOT = 0,
+	TB_SHUTDOWN_S5,
+	TB_SHUTDOWN_S4,
+	TB_SHUTDOWN_S3,
+	TB_SHUTDOWN_HALT,
+	TB_SHUTDOWN_WFS
+};
+#endif
+
+#if defined(CONFIG_X86) && defined(CONFIG_INTEL_TXT)
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
+extern void tboot_create_trampoline(void);
+extern void tboot_shutdown(u32 shutdown_type);
+extern void tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control);
+extern int tboot_wait_for_aps(int num_aps);
+extern struct acpi_table_header *tboot_get_dmar_table(
+				      struct acpi_table_header *dmar_tbl);
+extern int tboot_force_iommu(void);
+
+#else	/* !CONFIG_X86 || !CONFIG_INTEL_TXT */
+
+#define tboot_enabled()			0
+#define tboot_probe()			do { } while (0)
+#define tboot_create_trampoline()	do { } while (0)
+#define tboot_shutdown(shutdown_type)	do { } while (0)
+#define tboot_sleep(sleep_state, pm1a_control, pm1b_control)	\
+					do { } while (0)
+#define tboot_wait_for_aps(num_aps)	0
+#define tboot_get_dmar_table(dmar_tbl)	(dmar_tbl)
+#define tboot_force_iommu()		0
+
+#endif /* !CONFIG_X86 || !CONFIG_INTEL_TXT */
+
+#endif /* _LINUX_TBOOT_H */
diff -r 04f249f00303 init/main.c
--- a/init/main.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/init/main.c	Thu Aug 20 19:22:31 2009 -0700
@@ -68,12 +68,12 @@
  #include <linux/async.h>
  #include <linux/kmemcheck.h>
  #include <linux/kmemtrace.h>
+#include <linux/tboot.h>
  #include <trace/boot.h>

  #include <asm/io.h>
  #include <asm/bugs.h>
  #include <asm/setup.h>
-#include <asm/tboot.h>
  #include <asm/sections.h>
  #include <asm/cacheflush.h>

diff -r 04f249f00303 kernel/cpu.c
--- a/kernel/cpu.c	Tue Aug 18 12:06:57 2009 -0700
+++ b/kernel/cpu.c	Thu Aug 20 19:22:31 2009 -0700
@@ -14,7 +14,7 @@
  #include <linux/kthread.h>
  #include <linux/stop_machine.h>
  #include <linux/mutex.h>
-#include <asm/tboot.h>
+#include <linux/tboot.h>

  #ifdef CONFIG_SMP
  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
