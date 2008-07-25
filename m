Return-Path: <linux-kernel-owner+w=401wt.eu-S1756259AbYGYJTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbYGYJTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbYGYJSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:18:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:13081 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYGYJSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=NZYwtt3J38YapJdtnWQ5J9d/A8iilWE/P1dgcV09GwF+aN9YnbwIg33i4Xfz3j+dLq
         X8WNYf/KZqIq1XgZrOJsBD4futU7RZFpG/Q5BAOommuK/ojDMq0EQTJ0qyLByf2vnZ4g
         IPu2m0lYALcQeizUMbY7sSGI+4BLiC1kA61Ps=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: mach_es7000 to es7000
Date: Fri, 25 Jul 2008 02:17:33 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807250214.28786.yhlu.kernel@gmail.com> <200807250215.15588.yhlu.kernel@gmail.com> <200807250215.54393.yhlu.kernel@gmail.com>
In-Reply-To: <200807250215.54393.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807250217.33855.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


---
 arch/x86/es7000/Makefile                   |    5 
 arch/x86/es7000/es7000.h                   |  114 ++++++++++++
 arch/x86/es7000/es7000plat.c               |  262 +++++++++++++++++++++++++++++
 arch/x86/mach-es7000/Makefile              |    5 
 arch/x86/mach-es7000/es7000.h              |  114 ------------
 arch/x86/mach-es7000/es7000plat.c          |  262 -----------------------------
 arch/x86/mach-generic/Makefile             |    2 
 include/asm-x86/es7000/apic.h              |  194 +++++++++++++++++++++
 include/asm-x86/es7000/apicdef.h           |   13 +
 include/asm-x86/es7000/ipi.h               |   24 ++
 include/asm-x86/es7000/mpparse.h           |   29 +++
 include/asm-x86/es7000/wakecpu.h           |   59 ++++++
 include/asm-x86/mach-es7000/mach_apic.h    |  194 ---------------------
 include/asm-x86/mach-es7000/mach_apicdef.h |   13 -
 include/asm-x86/mach-es7000/mach_ipi.h     |   24 --
 include/asm-x86/mach-es7000/mach_mpparse.h |   29 ---
 include/asm-x86/mach-es7000/mach_wakecpu.h |   59 ------
 17 files changed, 701 insertions(+), 701 deletions(-)

Index: linux-2.6/arch/x86/es7000/Makefile
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/es7000/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the linux kernel.
+#
+
+obj-$(CONFIG_X86_ES7000)	:= es7000plat.o
Index: linux-2.6/arch/x86/es7000/es7000.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/es7000/es7000.h
@@ -0,0 +1,114 @@
+/*
+ * Written by: Garry Forsgren, Unisys Corporation
+ *             Natalie Protasevich, Unisys Corporation
+ * This file contains the code to configure and interface
+ * with Unisys ES7000 series hardware system manager.
+ *
+ * Copyright (c) 2003 Unisys Corporation.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * Contact information: Unisys Corporation, Township Line & Union Meeting
+ * Roads-A, Unisys Way, Blue Bell, Pennsylvania, 19424, or:
+ *
+ * http://www.unisys.com
+ */
+
+/*
+ * ES7000 chipsets
+ */
+
+#define NON_UNISYS		0
+#define ES7000_CLASSIC		1
+#define ES7000_ZORRO		2
+
+
+#define	MIP_REG			1
+#define	MIP_PSAI_REG		4
+
+#define	MIP_BUSY		1
+#define	MIP_SPIN		0xf0000
+#define	MIP_VALID		0x0100000000000000ULL
+#define	MIP_PORT(VALUE)	((VALUE >> 32) & 0xffff)
+
+#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)
+
+struct mip_reg_info {
+	unsigned long long mip_info;
+	unsigned long long delivery_info;
+	unsigned long long host_reg;
+	unsigned long long mip_reg;
+};
+
+struct part_info {
+	unsigned char type;
+	unsigned char length;
+	unsigned char part_id;
+	unsigned char apic_mode;
+	unsigned long snum;
+	char ptype[16];
+	char sname[64];
+	char pname[64];
+};
+
+struct psai {
+	unsigned long long entry_type;
+	unsigned long long addr;
+	unsigned long long bep_addr;
+};
+
+struct es7000_mem_info {
+	unsigned char type;
+	unsigned char length;
+	unsigned char resv[6];
+	unsigned long long  start;
+	unsigned long long  size;
+};
+
+struct es7000_oem_table {
+	unsigned long long hdr;
+	struct mip_reg_info mip;
+	struct part_info pif;
+	struct es7000_mem_info shm;
+	struct psai psai;
+};
+
+#ifdef CONFIG_ACPI
+
+struct oem_table {
+	struct acpi_table_header Header;
+	u32 OEMTableAddr;
+	u32 OEMTableSize;
+};
+
+extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+#endif
+
+struct mip_reg {
+	unsigned long long off_0;
+	unsigned long long off_8;
+	unsigned long long off_10;
+	unsigned long long off_18;
+	unsigned long long off_20;
+	unsigned long long off_28;
+	unsigned long long off_30;
+	unsigned long long off_38;
+};
+
+#define	MIP_SW_APIC		0x1020b
+#define	MIP_FUNC(VALUE)		(VALUE & 0xff)
+
+extern int parse_unisys_oem (char *oemptr);
+extern void setup_unisys(void);
+extern int es7000_start_cpu(int cpu, unsigned long eip);
+extern void es7000_sw_apic(void);
Index: linux-2.6/arch/x86/es7000/es7000plat.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/es7000/es7000plat.c
@@ -0,0 +1,262 @@
+/*
+ * Written by: Garry Forsgren, Unisys Corporation
+ *             Natalie Protasevich, Unisys Corporation
+ * This file contains the code to configure and interface
+ * with Unisys ES7000 series hardware system manager.
+ *
+ * Copyright (c) 2003 Unisys Corporation.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write the Free Software Foundation, Inc., 59
+ * Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * Contact information: Unisys Corporation, Township Line & Union Meeting
+ * Roads-A, Unisys Way, Blue Bell, Pennsylvania, 19424, or:
+ *
+ * http://www.unisys.com
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <asm/io.h>
+#include <asm/nmi.h>
+#include <asm/smp.h>
+#include <asm/apicdef.h>
+#include "es7000.h"
+#include <mach_mpparse.h>
+
+/*
+ * ES7000 Globals
+ */
+
+static volatile unsigned long	*psai = NULL;
+static struct mip_reg		*mip_reg;
+static struct mip_reg		*host_reg;
+static int 			mip_port;
+static unsigned long		mip_addr, host_addr;
+
+int es7000_plat;
+
+/*
+ * GSI override for ES7000 platforms.
+ */
+
+static unsigned int base;
+
+static int
+es7000_rename_gsi(int ioapic, int gsi)
+{
+	if (es7000_plat == ES7000_ZORRO)
+		return gsi;
+
+	if (!base) {
+		int i;
+		for (i = 0; i < nr_ioapics; i++)
+			base += nr_ioapic_registers[i];
+	}
+
+	if (!ioapic && (gsi < 16))
+		gsi += base;
+	return gsi;
+}
+
+void __init
+setup_unisys(void)
+{
+	/*
+	 * Determine the generation of the ES7000 currently running.
+	 *
+	 * es7000_plat = 1 if the machine is a 5xx ES7000 box
+	 * es7000_plat = 2 if the machine is a x86_64 ES7000 box
+	 *
+	 */
+	if (!(boot_cpu_data.x86 <= 15 && boot_cpu_data.x86_model <= 2))
+		es7000_plat = ES7000_ZORRO;
+	else
+		es7000_plat = ES7000_CLASSIC;
+	ioapic_renumber_irq = es7000_rename_gsi;
+}
+
+/*
+ * Parse the OEM Table
+ */
+
+int __init
+parse_unisys_oem (char *oemptr)
+{
+	int                     i;
+	int 			success = 0;
+	unsigned char           type, size;
+	unsigned long           val;
+	char                    *tp = NULL;
+	struct psai             *psaip = NULL;
+	struct mip_reg_info 	*mi;
+	struct mip_reg		*host, *mip;
+
+	tp = oemptr;
+
+	tp += 8;
+
+	for (i=0; i <= 6; i++) {
+		type = *tp++;
+		size = *tp++;
+		tp -= 2;
+		switch (type) {
+		case MIP_REG:
+			mi = (struct mip_reg_info *)tp;
+			val = MIP_RD_LO(mi->host_reg);
+			host_addr = val;
+			host = (struct mip_reg *)val;
+			host_reg = __va(host);
+			val = MIP_RD_LO(mi->mip_reg);
+			mip_port = MIP_PORT(mi->mip_info);
+			mip_addr = val;
+			mip = (struct mip_reg *)val;
+			mip_reg = __va(mip);
+			pr_debug("es7000_mipcfg: host_reg = 0x%lx \n",
+				 (unsigned long)host_reg);
+			pr_debug("es7000_mipcfg: mip_reg = 0x%lx \n",
+				 (unsigned long)mip_reg);
+			success++;
+			break;
+		case MIP_PSAI_REG:
+			psaip = (struct psai *)tp;
+			if (tp != NULL) {
+				if (psaip->addr)
+					psai = __va(psaip->addr);
+				else
+					psai = NULL;
+				success++;
+			}
+			break;
+		default:
+			break;
+		}
+		tp += size;
+	}
+
+	if (success < 2) {
+		es7000_plat = NON_UNISYS;
+	} else
+		setup_unisys();
+	return es7000_plat;
+}
+
+#ifdef CONFIG_ACPI
+int __init
+find_unisys_acpi_oem_table(unsigned long *oem_addr)
+{
+	struct acpi_table_header *header = NULL;
+	int i = 0;
+	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
+		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
+			struct oem_table *t = (struct oem_table *)header;
+			*oem_addr = (unsigned long)__acpi_map_table(t->OEMTableAddr,
+								    t->OEMTableSize);
+			return 0;
+		}
+	}
+	return -1;
+}
+#endif
+
+static void
+es7000_spin(int n)
+{
+	int i = 0;
+
+	while (i++ < n)
+		rep_nop();
+}
+
+static int __init
+es7000_mip_write(struct mip_reg *mip_reg)
+{
+	int			status = 0;
+	int			spin;
+
+	spin = MIP_SPIN;
+	while (((unsigned long long)host_reg->off_38 &
+		(unsigned long long)MIP_VALID) != 0) {
+			if (--spin <= 0) {
+				printk("es7000_mip_write: Timeout waiting for Host Valid Flag");
+				return -1;
+			}
+		es7000_spin(MIP_SPIN);
+	}
+
+	memcpy(host_reg, mip_reg, sizeof(struct mip_reg));
+	outb(1, mip_port);
+
+	spin = MIP_SPIN;
+
+	while (((unsigned long long)mip_reg->off_38 &
+		(unsigned long long)MIP_VALID) == 0) {
+		if (--spin <= 0) {
+			printk("es7000_mip_write: Timeout waiting for MIP Valid Flag");
+			return -1;
+		}
+		es7000_spin(MIP_SPIN);
+	}
+
+	status = ((unsigned long long)mip_reg->off_0 &
+		(unsigned long long)0xffff0000000000ULL) >> 48;
+	mip_reg->off_38 = ((unsigned long long)mip_reg->off_38 &
+		(unsigned long long)~MIP_VALID);
+	return status;
+}
+
+int
+es7000_start_cpu(int cpu, unsigned long eip)
+{
+	unsigned long vect = 0, psaival = 0;
+
+	if (psai == NULL)
+		return -1;
+
+	vect = ((unsigned long)__pa(eip)/0x1000) << 16;
+	psaival = (0x1000000 | vect | cpu);
+
+	while (*psai & 0x1000000)
+                ;
+
+	*psai = psaival;
+
+	return 0;
+
+}
+
+void __init
+es7000_sw_apic(void)
+{
+	if (es7000_plat) {
+		int mip_status;
+		struct mip_reg es7000_mip_reg;
+
+		printk("ES7000: Enabling APIC mode.\n");
+        	memset(&es7000_mip_reg, 0, sizeof(struct mip_reg));
+        	es7000_mip_reg.off_0 = MIP_SW_APIC;
+        	es7000_mip_reg.off_38 = (MIP_VALID);
+        	while ((mip_status = es7000_mip_write(&es7000_mip_reg)) != 0)
+              		printk("es7000_sw_apic: command failed, status = %x\n",
+				mip_status);
+		return;
+	}
+}
Index: linux-2.6/arch/x86/mach-es7000/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/mach-es7000/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-obj-$(CONFIG_X86_ES7000)	:= es7000plat.o
Index: linux-2.6/arch/x86/mach-es7000/es7000.h
===================================================================
--- linux-2.6.orig/arch/x86/mach-es7000/es7000.h
+++ /dev/null
@@ -1,114 +0,0 @@
-/*
- * Written by: Garry Forsgren, Unisys Corporation
- *             Natalie Protasevich, Unisys Corporation
- * This file contains the code to configure and interface 
- * with Unisys ES7000 series hardware system manager.
- *
- * Copyright (c) 2003 Unisys Corporation.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * Contact information: Unisys Corporation, Township Line & Union Meeting 
- * Roads-A, Unisys Way, Blue Bell, Pennsylvania, 19424, or:
- *
- * http://www.unisys.com
- */
-
-/*
- * ES7000 chipsets
- */
-
-#define NON_UNISYS		0
-#define ES7000_CLASSIC		1
-#define ES7000_ZORRO		2
-
-
-#define	MIP_REG			1
-#define	MIP_PSAI_REG		4
-
-#define	MIP_BUSY		1
-#define	MIP_SPIN		0xf0000
-#define	MIP_VALID		0x0100000000000000ULL
-#define	MIP_PORT(VALUE)	((VALUE >> 32) & 0xffff)
-
-#define	MIP_RD_LO(VALUE)	(VALUE & 0xffffffff)   
-
-struct mip_reg_info {
-	unsigned long long mip_info;
-	unsigned long long delivery_info;
-	unsigned long long host_reg;
-	unsigned long long mip_reg;
-};
-
-struct part_info {
-	unsigned char type;   
-	unsigned char length;
-	unsigned char part_id;
-	unsigned char apic_mode;
-	unsigned long snum;    
-	char ptype[16];
-	char sname[64];
-	char pname[64];
-};
-
-struct psai {
-	unsigned long long entry_type;
-	unsigned long long addr;
-	unsigned long long bep_addr;
-};
-
-struct es7000_mem_info {
-	unsigned char type;   
-	unsigned char length;
-	unsigned char resv[6];
-	unsigned long long  start; 
-	unsigned long long  size; 
-};
-
-struct es7000_oem_table {
-	unsigned long long hdr;
-	struct mip_reg_info mip;
-	struct part_info pif;
-	struct es7000_mem_info shm;
-	struct psai psai;
-};
-
-#ifdef CONFIG_ACPI
-
-struct oem_table {
-	struct acpi_table_header Header;
-	u32 OEMTableAddr;
-	u32 OEMTableSize;
-};
-
-extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
-#endif
-
-struct mip_reg {
-	unsigned long long off_0;
-	unsigned long long off_8;
-	unsigned long long off_10;
-	unsigned long long off_18;
-	unsigned long long off_20;
-	unsigned long long off_28;
-	unsigned long long off_30;
-	unsigned long long off_38;
-};
-
-#define	MIP_SW_APIC		0x1020b
-#define	MIP_FUNC(VALUE) 	(VALUE & 0xff)
-
-extern int parse_unisys_oem (char *oemptr);
-extern void setup_unisys(void);
-extern int es7000_start_cpu(int cpu, unsigned long eip);
-extern void es7000_sw_apic(void);
Index: linux-2.6/arch/x86/mach-es7000/es7000plat.c
===================================================================
--- linux-2.6.orig/arch/x86/mach-es7000/es7000plat.c
+++ /dev/null
@@ -1,262 +0,0 @@
-/*
- * Written by: Garry Forsgren, Unisys Corporation
- *             Natalie Protasevich, Unisys Corporation
- * This file contains the code to configure and interface
- * with Unisys ES7000 series hardware system manager.
- *
- * Copyright (c) 2003 Unisys Corporation.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * Contact information: Unisys Corporation, Township Line & Union Meeting
- * Roads-A, Unisys Way, Blue Bell, Pennsylvania, 19424, or:
- *
- * http://www.unisys.com
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/smp.h>
-#include <linux/string.h>
-#include <linux/spinlock.h>
-#include <linux/errno.h>
-#include <linux/notifier.h>
-#include <linux/reboot.h>
-#include <linux/init.h>
-#include <linux/acpi.h>
-#include <asm/io.h>
-#include <asm/nmi.h>
-#include <asm/smp.h>
-#include <asm/apicdef.h>
-#include "es7000.h"
-#include <mach_mpparse.h>
-
-/*
- * ES7000 Globals
- */
-
-static volatile unsigned long	*psai = NULL;
-static struct mip_reg		*mip_reg;
-static struct mip_reg		*host_reg;
-static int 			mip_port;
-static unsigned long		mip_addr, host_addr;
-
-int es7000_plat;
-
-/*
- * GSI override for ES7000 platforms.
- */
-
-static unsigned int base;
-
-static int
-es7000_rename_gsi(int ioapic, int gsi)
-{
-	if (es7000_plat == ES7000_ZORRO)
-		return gsi;
-
-	if (!base) {
-		int i;
-		for (i = 0; i < nr_ioapics; i++)
-			base += nr_ioapic_registers[i];
-	}
-
-	if (!ioapic && (gsi < 16)) 
-		gsi += base;
-	return gsi;
-}
-
-void __init
-setup_unisys(void)
-{
-	/*
-	 * Determine the generation of the ES7000 currently running.
-	 *
-	 * es7000_plat = 1 if the machine is a 5xx ES7000 box
-	 * es7000_plat = 2 if the machine is a x86_64 ES7000 box
-	 *
-	 */
-	if (!(boot_cpu_data.x86 <= 15 && boot_cpu_data.x86_model <= 2))
-		es7000_plat = ES7000_ZORRO;
-	else
-		es7000_plat = ES7000_CLASSIC;
-	ioapic_renumber_irq = es7000_rename_gsi;
-}
-
-/*
- * Parse the OEM Table
- */
-
-int __init
-parse_unisys_oem (char *oemptr)
-{
-	int                     i;
-	int 			success = 0;
-	unsigned char           type, size;
-	unsigned long           val;
-	char                    *tp = NULL;
-	struct psai             *psaip = NULL;
-	struct mip_reg_info 	*mi;
-	struct mip_reg		*host, *mip;
-
-	tp = oemptr;
-
-	tp += 8;
-
-	for (i=0; i <= 6; i++) {
-		type = *tp++;
-		size = *tp++;
-		tp -= 2;
-		switch (type) {
-		case MIP_REG:
-			mi = (struct mip_reg_info *)tp;
-			val = MIP_RD_LO(mi->host_reg);
-			host_addr = val;
-			host = (struct mip_reg *)val;
-			host_reg = __va(host);
-			val = MIP_RD_LO(mi->mip_reg);
-			mip_port = MIP_PORT(mi->mip_info);
-			mip_addr = val;
-			mip = (struct mip_reg *)val;
-			mip_reg = __va(mip);
-			pr_debug("es7000_mipcfg: host_reg = 0x%lx \n",
-				 (unsigned long)host_reg);
-			pr_debug("es7000_mipcfg: mip_reg = 0x%lx \n",
-				 (unsigned long)mip_reg);
-			success++;
-			break;
-		case MIP_PSAI_REG:
-			psaip = (struct psai *)tp;
-			if (tp != NULL) {
-				if (psaip->addr)
-					psai = __va(psaip->addr);
-				else
-					psai = NULL;
-				success++;
-			}
-			break;
-		default:
-			break;
-		}
-		tp += size;
-	}
-
-	if (success < 2) {
-		es7000_plat = NON_UNISYS;
-	} else
-		setup_unisys();
-	return es7000_plat;
-}
-
-#ifdef CONFIG_ACPI
-int __init
-find_unisys_acpi_oem_table(unsigned long *oem_addr)
-{
-	struct acpi_table_header *header = NULL;
-	int i = 0;
-	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
-		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
-			struct oem_table *t = (struct oem_table *)header;
-			*oem_addr = (unsigned long)__acpi_map_table(t->OEMTableAddr,
-								    t->OEMTableSize);
-			return 0;
-		}
-	}
-	return -1;
-}
-#endif
-
-static void
-es7000_spin(int n)
-{
-	int i = 0;
-
-	while (i++ < n)
-		rep_nop();
-}
-
-static int __init
-es7000_mip_write(struct mip_reg *mip_reg)
-{
-	int			status = 0;
-	int			spin;
-
-	spin = MIP_SPIN;
-	while (((unsigned long long)host_reg->off_38 &
-		(unsigned long long)MIP_VALID) != 0) {
-			if (--spin <= 0) {
-				printk("es7000_mip_write: Timeout waiting for Host Valid Flag");
-				return -1;
-			}
-		es7000_spin(MIP_SPIN);
-	}
-
-	memcpy(host_reg, mip_reg, sizeof(struct mip_reg));
-	outb(1, mip_port);
-
-	spin = MIP_SPIN;
-
-	while (((unsigned long long)mip_reg->off_38 &
-		(unsigned long long)MIP_VALID) == 0) {
-		if (--spin <= 0) {
-			printk("es7000_mip_write: Timeout waiting for MIP Valid Flag");
-			return -1;
-		}
-		es7000_spin(MIP_SPIN);
-	}
-
-	status = ((unsigned long long)mip_reg->off_0 &
-		(unsigned long long)0xffff0000000000ULL) >> 48;
-	mip_reg->off_38 = ((unsigned long long)mip_reg->off_38 &
-		(unsigned long long)~MIP_VALID);
-	return status;
-}
-
-int
-es7000_start_cpu(int cpu, unsigned long eip)
-{
-	unsigned long vect = 0, psaival = 0;
-
-	if (psai == NULL)
-		return -1;
-
-	vect = ((unsigned long)__pa(eip)/0x1000) << 16;
-	psaival = (0x1000000 | vect | cpu);
-
-	while (*psai & 0x1000000)
-                ;
-
-	*psai = psaival;
-
-	return 0;
-
-}
-
-void __init
-es7000_sw_apic(void)
-{
-	if (es7000_plat) {
-		int mip_status;
-		struct mip_reg es7000_mip_reg;
-
-		printk("ES7000: Enabling APIC mode.\n");
-        	memset(&es7000_mip_reg, 0, sizeof(struct mip_reg));
-        	es7000_mip_reg.off_0 = MIP_SW_APIC;
-        	es7000_mip_reg.off_38 = (MIP_VALID);
-        	while ((mip_status = es7000_mip_write(&es7000_mip_reg)) != 0)
-              		printk("es7000_sw_apic: command failed, status = %x\n",
-				mip_status);
-		return;
-	}
-}
Index: linux-2.6/arch/x86/mach-generic/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/mach-generic/Makefile
+++ linux-2.6/arch/x86/mach-generic/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq.o
 obj-$(CONFIG_X86_SUMMIT)	+= summit.o
 obj-$(CONFIG_X86_BIGSMP)	+= bigsmp.o
 obj-$(CONFIG_X86_ES7000)	+= es7000.o
-obj-$(CONFIG_X86_ES7000)	+= ../../x86/mach-es7000/
+obj-$(CONFIG_X86_ES7000)	+= ../../x86/es7000/
Index: linux-2.6/include/asm-x86/es7000/apic.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/es7000/apic.h
@@ -0,0 +1,194 @@
+#ifndef __ASM_ES7000_APIC_H
+#define __ASM_ES7000_APIC_H
+
+#define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
+#define esr_disable (1)
+
+static inline int apic_id_registered(void)
+{
+	        return (1);
+}
+
+static inline cpumask_t target_cpus(void)
+{
+#if defined CONFIG_ES7000_CLUSTERED_APIC
+	return CPU_MASK_ALL;
+#else
+	return cpumask_of_cpu(smp_processor_id());
+#endif
+}
+#define TARGET_CPUS	(target_cpus())
+
+#if defined CONFIG_ES7000_CLUSTERED_APIC
+#define APIC_DFR_VALUE		(APIC_DFR_CLUSTER)
+#define INT_DELIVERY_MODE	(dest_LowestPrio)
+#define INT_DEST_MODE		(1)    /* logical delivery broadcast to all procs */
+#define NO_BALANCE_IRQ		(1)
+#undef  WAKE_SECONDARY_VIA_INIT
+#define WAKE_SECONDARY_VIA_MIP
+#else
+#define APIC_DFR_VALUE		(APIC_DFR_FLAT)
+#define INT_DELIVERY_MODE	(dest_Fixed)
+#define INT_DEST_MODE		(0)    /* phys delivery to target procs */
+#define NO_BALANCE_IRQ		(0)
+#undef  APIC_DEST_LOGICAL
+#define APIC_DEST_LOGICAL	0x0
+#define WAKE_SECONDARY_VIA_INIT
+#endif
+
+static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
+{
+	return 0;
+}
+static inline unsigned long check_apicid_present(int bit)
+{
+	return physid_isset(bit, phys_cpu_present_map);
+}
+
+#define apicid_cluster(apicid) (apicid & 0xF0)
+
+static inline unsigned long calculate_ldr(int cpu)
+{
+	unsigned long id;
+	id = xapic_phys_to_log_apicid(cpu);
+	return (SET_APIC_LOGICAL_ID(id));
+}
+
+/*
+ * Set up the logical destination ID.
+ *
+ * Intel recommends to set DFR, LdR and TPR before enabling
+ * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
+ * document number 292116).  So here it goes...
+ */
+static inline void init_apic_ldr(void)
+{
+	unsigned long val;
+	int cpu = smp_processor_id();
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
+	val = calculate_ldr(cpu);
+	apic_write(APIC_LDR, val);
+}
+
+#ifndef CONFIG_X86_GENERICARCH
+extern void enable_apic_mode(void);
+#endif
+
+extern int apic_version [MAX_APICS];
+static inline void setup_apic_routing(void)
+{
+	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
+	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
+		(apic_version[apic] == 0x14) ?
+		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(TARGET_CPUS)[0]);
+}
+
+static inline int multi_timer_check(int apic, int irq)
+{
+	return 0;
+}
+
+static inline int apicid_to_node(int logical_apicid)
+{
+	return 0;
+}
+
+
+static inline int cpu_present_to_apicid(int mps_cpu)
+{
+	if (!mps_cpu)
+		return boot_cpu_physical_apicid;
+	else if (mps_cpu < NR_CPUS)
+		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
+	else
+		return BAD_APICID;
+}
+
+static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
+{
+	static int id = 0;
+	physid_mask_t mask;
+	mask = physid_mask_of_physid(id);
+	++id;
+	return mask;
+}
+
+extern u8 cpu_2_logical_apicid[];
+/* Mapping from cpu number to logical apicid */
+static inline int cpu_to_logical_apicid(int cpu)
+{
+#ifdef CONFIG_SMP
+       if (cpu >= NR_CPUS)
+	       return BAD_APICID;
+       return (int)cpu_2_logical_apicid[cpu];
+#else
+	return logical_smp_processor_id();
+#endif
+}
+
+static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	/* For clustered we don't have a good way to do this yet - hack */
+	return physids_promote(0xff);
+}
+
+
+static inline void setup_portio_remap(void)
+{
+}
+
+extern unsigned int boot_cpu_physical_apicid;
+static inline int check_phys_apicid_present(int cpu_physical_apicid)
+{
+	boot_cpu_physical_apicid = read_apic_id();
+	return (1);
+}
+
+static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
+{
+	int num_bits_set;
+	int cpus_found = 0;
+	int cpu;
+	int apicid;
+
+	num_bits_set = cpus_weight(cpumask);
+	/* Return id to all */
+	if (num_bits_set == NR_CPUS)
+#if defined CONFIG_ES7000_CLUSTERED_APIC
+		return 0xFF;
+#else
+		return cpu_to_logical_apicid(0);
+#endif
+	/*
+	 * The cpus in the mask must all be on the apic cluster.  If are not
+	 * on the same apicid cluster return default value of TARGET_CPUS.
+	 */
+	cpu = first_cpu(cpumask);
+	apicid = cpu_to_logical_apicid(cpu);
+	while (cpus_found < num_bits_set) {
+		if (cpu_isset(cpu, cpumask)) {
+			int new_apicid = cpu_to_logical_apicid(cpu);
+			if (apicid_cluster(apicid) !=
+					apicid_cluster(new_apicid)){
+				printk ("%s: Not a valid mask!\n",__FUNCTION__);
+#if defined CONFIG_ES7000_CLUSTERED_APIC
+				return 0xFF;
+#else
+				return cpu_to_logical_apicid(0);
+#endif
+			}
+			apicid = new_apicid;
+			cpus_found++;
+		}
+		cpu++;
+	}
+	return apicid;
+}
+
+static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
+{
+	return cpuid_apic >> index_msb;
+}
+
+#endif /* __ASM_ES7000_APIC_H */
Index: linux-2.6/include/asm-x86/es7000/apicdef.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/es7000/apicdef.h
@@ -0,0 +1,13 @@
+#ifndef __ASM_ES7000_APICDEF_H
+#define __ASM_ES7000_APICDEF_H
+
+#define		APIC_ID_MASK		(0xFF<<24)
+
+static inline unsigned get_apic_id(unsigned long x)
+{
+	return (((x)>>24)&0xFF);
+}
+
+#define		GET_APIC_ID(x)	get_apic_id(x)
+
+#endif
Index: linux-2.6/include/asm-x86/es7000/ipi.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/es7000/ipi.h
@@ -0,0 +1,24 @@
+#ifndef __ASM_ES7000_IPI_H
+#define __ASM_ES7000_IPI_H
+
+void send_IPI_mask_sequence(cpumask_t mask, int vector);
+
+static inline void send_IPI_mask(cpumask_t mask, int vector)
+{
+	send_IPI_mask_sequence(mask, vector);
+}
+
+static inline void send_IPI_allbutself(int vector)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(smp_processor_id(), mask);
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, vector);
+}
+
+static inline void send_IPI_all(int vector)
+{
+	send_IPI_mask(cpu_online_map, vector);
+}
+
+#endif /* __ASM_ES7000_IPI_H */
Index: linux-2.6/include/asm-x86/es7000/mpparse.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/es7000/mpparse.h
@@ -0,0 +1,29 @@
+#ifndef __ASM_ES7000_MPPARSE_H
+#define __ASM_ES7000_MPPARSE_H
+
+#include <linux/acpi.h>
+
+extern int parse_unisys_oem (char *oemptr);
+extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
+extern void setup_unisys(void);
+
+#ifndef CONFIG_X86_GENERICARCH
+extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
+extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
+				char *productid);
+#endif
+
+#ifdef CONFIG_ACPI
+
+static inline int es7000_check_dsdt(void)
+{
+	struct acpi_table_header header;
+
+	if (ACPI_SUCCESS(acpi_get_table_header(ACPI_SIG_DSDT, 0, &header)) &&
+	    !strncmp(header.oem_id, "UNISYS", 6))
+		return 1;
+	return 0;
+}
+#endif
+
+#endif /* __ASM_MACH_MPPARSE_H */
Index: linux-2.6/include/asm-x86/es7000/wakecpu.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-x86/es7000/wakecpu.h
@@ -0,0 +1,59 @@
+#ifndef __ASM_ES7000_WAKECPU_H
+#define __ASM_ES7000_WAKECPU_H
+
+/*
+ * This file copes with machines that wakeup secondary CPUs by the
+ * INIT, INIT, STARTUP sequence.
+ */
+
+#ifdef CONFIG_ES7000_CLUSTERED_APIC
+#define WAKE_SECONDARY_VIA_MIP
+#else
+#define WAKE_SECONDARY_VIA_INIT
+#endif
+
+#ifdef WAKE_SECONDARY_VIA_MIP
+extern int es7000_start_cpu(int cpu, unsigned long eip);
+static inline int
+wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
+{
+	int boot_error = 0;
+	boot_error = es7000_start_cpu(phys_apicid, start_eip);
+	return boot_error;
+}
+#endif
+
+#define TRAMPOLINE_LOW phys_to_virt(0x467)
+#define TRAMPOLINE_HIGH phys_to_virt(0x469)
+
+#define boot_cpu_apicid boot_cpu_physical_apicid
+
+static inline void wait_for_init_deassert(atomic_t *deassert)
+{
+#ifdef WAKE_SECONDARY_VIA_INIT
+	while (!atomic_read(deassert))
+		cpu_relax();
+#endif
+	return;
+}
+
+/* Nothing to do for most platforms, since cleared by the INIT cycle */
+static inline void smp_callin_clear_local_apic(void)
+{
+}
+
+static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
+{
+}
+
+static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
+{
+}
+
+#if APIC_DEBUG
+ #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
+#else
+ #define inquire_remote_apic(apicid) {}
+#endif
+
+#endif /* __ASM_MACH_WAKECPU_H */
Index: linux-2.6/include/asm-x86/mach-es7000/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-es7000/mach_apic.h
+++ /dev/null
@@ -1,194 +0,0 @@
-#ifndef __ASM_MACH_APIC_H
-#define __ASM_MACH_APIC_H
-
-#define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
-#define esr_disable (1)
-
-static inline int apic_id_registered(void)
-{
-	        return (1);
-}
-
-static inline cpumask_t target_cpus(void)
-{ 
-#if defined CONFIG_ES7000_CLUSTERED_APIC
-	return CPU_MASK_ALL;
-#else
-	return cpumask_of_cpu(smp_processor_id());
-#endif
-}
-#define TARGET_CPUS	(target_cpus())
-
-#if defined CONFIG_ES7000_CLUSTERED_APIC
-#define APIC_DFR_VALUE		(APIC_DFR_CLUSTER)
-#define INT_DELIVERY_MODE	(dest_LowestPrio)
-#define INT_DEST_MODE		(1)    /* logical delivery broadcast to all procs */
-#define NO_BALANCE_IRQ 		(1)
-#undef  WAKE_SECONDARY_VIA_INIT
-#define WAKE_SECONDARY_VIA_MIP
-#else
-#define APIC_DFR_VALUE		(APIC_DFR_FLAT)
-#define INT_DELIVERY_MODE	(dest_Fixed)
-#define INT_DEST_MODE		(0)    /* phys delivery to target procs */
-#define NO_BALANCE_IRQ 		(0)
-#undef  APIC_DEST_LOGICAL
-#define APIC_DEST_LOGICAL	0x0
-#define WAKE_SECONDARY_VIA_INIT
-#endif
-
-static inline unsigned long check_apicid_used(physid_mask_t bitmap, int apicid)
-{ 
-	return 0;
-} 
-static inline unsigned long check_apicid_present(int bit) 
-{
-	return physid_isset(bit, phys_cpu_present_map);
-}
-
-#define apicid_cluster(apicid) (apicid & 0xF0)
-
-static inline unsigned long calculate_ldr(int cpu)
-{
-	unsigned long id;
-	id = xapic_phys_to_log_apicid(cpu);
-	return (SET_APIC_LOGICAL_ID(id));
-}
-
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LdR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-static inline void init_apic_ldr(void)
-{
-	unsigned long val;
-	int cpu = smp_processor_id();
-
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = calculate_ldr(cpu);
-	apic_write(APIC_LDR, val);
-}
-
-#ifndef CONFIG_X86_GENERICARCH
-extern void enable_apic_mode(void);
-#endif
-
-extern int apic_version [MAX_APICS];
-static inline void setup_apic_routing(void)
-{
-	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
-	printk("Enabling APIC mode:  %s.  Using %d I/O APICs, target cpus %lx\n",
-		(apic_version[apic] == 0x14) ? 
-		"Physical Cluster" : "Logical Cluster", nr_ioapics, cpus_addr(TARGET_CPUS)[0]);
-}
-
-static inline int multi_timer_check(int apic, int irq)
-{
-	return 0;
-}
-
-static inline int apicid_to_node(int logical_apicid)
-{
-	return 0;
-}
-
-
-static inline int cpu_present_to_apicid(int mps_cpu)
-{
-	if (!mps_cpu)
-		return boot_cpu_physical_apicid;
-	else if (mps_cpu < NR_CPUS)
-		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
-	else
-		return BAD_APICID;
-}
-
-static inline physid_mask_t apicid_to_cpu_present(int phys_apicid)
-{
-	static int id = 0;
-	physid_mask_t mask;
-	mask = physid_mask_of_physid(id);
-	++id;
-	return mask;
-}
-
-extern u8 cpu_2_logical_apicid[];
-/* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
-{
-#ifdef CONFIG_SMP
-       if (cpu >= NR_CPUS)
-	       return BAD_APICID;
-       return (int)cpu_2_logical_apicid[cpu];
-#else
-	return logical_smp_processor_id();
-#endif
-}
-
-static inline physid_mask_t ioapic_phys_id_map(physid_mask_t phys_map)
-{
-	/* For clustered we don't have a good way to do this yet - hack */
-	return physids_promote(0xff);
-}
-
-
-static inline void setup_portio_remap(void)
-{
-}
-
-extern unsigned int boot_cpu_physical_apicid;
-static inline int check_phys_apicid_present(int cpu_physical_apicid)
-{
-	boot_cpu_physical_apicid = read_apic_id();
-	return (1);
-}
-
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	int num_bits_set;
-	int cpus_found = 0;
-	int cpu;
-	int apicid;	
-
-	num_bits_set = cpus_weight(cpumask);
-	/* Return id to all */
-	if (num_bits_set == NR_CPUS)
-#if defined CONFIG_ES7000_CLUSTERED_APIC
-		return 0xFF;
-#else
-		return cpu_to_logical_apicid(0);
-#endif
-	/* 
-	 * The cpus in the mask must all be on the apic cluster.  If are not 
-	 * on the same apicid cluster return default value of TARGET_CPUS. 
-	 */
-	cpu = first_cpu(cpumask);
-	apicid = cpu_to_logical_apicid(cpu);
-	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, cpumask)) {
-			int new_apicid = cpu_to_logical_apicid(cpu);
-			if (apicid_cluster(apicid) != 
-					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n",__FUNCTION__);
-#if defined CONFIG_ES7000_CLUSTERED_APIC
-				return 0xFF;
-#else
-				return cpu_to_logical_apicid(0);
-#endif
-			}
-			apicid = new_apicid;
-			cpus_found++;
-		}
-		cpu++;
-	}
-	return apicid;
-}
-
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-#endif /* __ASM_MACH_APIC_H */
Index: linux-2.6/include/asm-x86/mach-es7000/mach_apicdef.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-es7000/mach_apicdef.h
+++ /dev/null
@@ -1,13 +0,0 @@
-#ifndef __ASM_MACH_APICDEF_H
-#define __ASM_MACH_APICDEF_H
-
-#define		APIC_ID_MASK		(0xFF<<24)
-
-static inline unsigned get_apic_id(unsigned long x) 
-{ 
-	return (((x)>>24)&0xFF);
-} 
-
-#define		GET_APIC_ID(x)	get_apic_id(x)
-
-#endif
Index: linux-2.6/include/asm-x86/mach-es7000/mach_ipi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-es7000/mach_ipi.h
+++ /dev/null
@@ -1,24 +0,0 @@
-#ifndef __ASM_MACH_IPI_H
-#define __ASM_MACH_IPI_H
-
-void send_IPI_mask_sequence(cpumask_t mask, int vector);
-
-static inline void send_IPI_mask(cpumask_t mask, int vector)
-{
-	send_IPI_mask_sequence(mask, vector);
-}
-
-static inline void send_IPI_allbutself(int vector)
-{
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(smp_processor_id(), mask);
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, vector);
-}
-
-static inline void send_IPI_all(int vector)
-{
-	send_IPI_mask(cpu_online_map, vector);
-}
-
-#endif /* __ASM_MACH_IPI_H */
Index: linux-2.6/include/asm-x86/mach-es7000/mach_mpparse.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-es7000/mach_mpparse.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef __ASM_MACH_MPPARSE_H
-#define __ASM_MACH_MPPARSE_H
-
-#include <linux/acpi.h>
-
-extern int parse_unisys_oem (char *oemptr);
-extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
-extern void setup_unisys(void);
-
-#ifndef CONFIG_X86_GENERICARCH
-extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
-extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
-				char *productid);
-#endif
-
-#ifdef CONFIG_ACPI
-
-static inline int es7000_check_dsdt(void)
-{
-	struct acpi_table_header header;
-
-	if (ACPI_SUCCESS(acpi_get_table_header(ACPI_SIG_DSDT, 0, &header)) &&
-	    !strncmp(header.oem_id, "UNISYS", 6))
-		return 1;
-	return 0;
-}
-#endif
-
-#endif /* __ASM_MACH_MPPARSE_H */
Index: linux-2.6/include/asm-x86/mach-es7000/mach_wakecpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-es7000/mach_wakecpu.h
+++ /dev/null
@@ -1,59 +0,0 @@
-#ifndef __ASM_MACH_WAKECPU_H
-#define __ASM_MACH_WAKECPU_H
-
-/* 
- * This file copes with machines that wakeup secondary CPUs by the
- * INIT, INIT, STARTUP sequence.
- */
-
-#ifdef CONFIG_ES7000_CLUSTERED_APIC
-#define WAKE_SECONDARY_VIA_MIP
-#else
-#define WAKE_SECONDARY_VIA_INIT
-#endif
-
-#ifdef WAKE_SECONDARY_VIA_MIP
-extern int es7000_start_cpu(int cpu, unsigned long eip);
-static inline int
-wakeup_secondary_cpu(int phys_apicid, unsigned long start_eip)
-{
-	int boot_error = 0;
-	boot_error = es7000_start_cpu(phys_apicid, start_eip);
-	return boot_error;
-}
-#endif
-
-#define TRAMPOLINE_LOW phys_to_virt(0x467)
-#define TRAMPOLINE_HIGH phys_to_virt(0x469)
-
-#define boot_cpu_apicid boot_cpu_physical_apicid
-
-static inline void wait_for_init_deassert(atomic_t *deassert)
-{
-#ifdef WAKE_SECONDARY_VIA_INIT
-	while (!atomic_read(deassert))
-		cpu_relax();
-#endif
-	return;
-}
-
-/* Nothing to do for most platforms, since cleared by the INIT cycle */
-static inline void smp_callin_clear_local_apic(void)
-{
-}
-
-static inline void store_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
-static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
-{
-}
-
-#if APIC_DEBUG
- #define inquire_remote_apic(apicid) __inquire_remote_apic(apicid)
-#else
- #define inquire_remote_apic(apicid) {}
-#endif
-
-#endif /* __ASM_MACH_WAKECPU_H */
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 9b30547..520cca0 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -11,12 +11,12 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/init.h>
-#include <asm/mach-es7000/mach_apicdef.h>
+#include <asm/es7000/apicdef.h>
 #include <linux/smp.h>
-#include <asm/mach-es7000/mach_apic.h>
-#include <asm/mach-es7000/mach_ipi.h>
-#include <asm/mach-es7000/mach_mpparse.h>
-#include <asm/mach-es7000/mach_wakecpu.h>
+#include <asm/es7000/apic.h>
+#include <asm/es7000/ipi.h>
+#include <asm/es7000/mpparse.h>
+#include <asm/es7000/wakecpu.h>
 
 static int probe_es7000(void)
 {
