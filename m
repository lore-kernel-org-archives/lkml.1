Return-Path: <linux-kernel-owner+w=401wt.eu-S1764233AbYFZN2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764233AbYFZN2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763755AbYFZN2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:28:15 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24116 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754058AbYFZN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:28:13 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 15/60] microblaze_v4: PVR support, cpuinfo support
Date: Thu, 26 Jun 2008 14:29:44 +0200
Message-Id: <1214483429-32360-16-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-15-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/mb.c  |  115 ++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/pvr.c |   81 ++++++++++++++++++++++++++
 2 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/cpu/mb.c
 create mode 100644 arch/microblaze/kernel/cpu/pvr.c

diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
new file mode 100644
index 0000000..0124112
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/mb.c
@@ -0,0 +1,115 @@
+/*
+ * CPU-version specific code
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 PetaLogix
+ */
+
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/seq_file.h>
+#include <linux/cpu.h>
+#include <linux/initrd.h>
+
+#include <asm/cpuinfo.h>
+#include <asm/setup.h>
+#include <asm/sections.h>
+#include <asm/page.h>
+#include <asm/io.h>
+#include <asm/bug.h>
+#include <asm/param.h>
+#include <asm/delay.h>
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	int count = 0;
+	char *fpga_family = "Unknown";
+	char *cpu_ver = "Unknown";
+	int i;
+	printk("%s\n", __func__);
+
+	/* Denormalised to get the fpga family string */
+	for (i = 0; family_string_lookup[i].s != NULL; i++) {
+		if (cpuinfo.fpga_family_code == family_string_lookup[i].k) {
+			fpga_family = (char *)family_string_lookup[i].s;
+			break;
+		}
+	}
+
+	/* Denormalised to get the hw version string */
+	for (i = 0; cpu_ver_lookup[i].s != NULL; i++) {
+		if (cpuinfo.ver_code == cpu_ver_lookup[i].k) {
+			cpu_ver = (char *)cpu_ver_lookup[i].s;
+			break;
+		}
+	}
+
+	count = seq_printf(m,
+			"CPU-Family:	MicroBlaze\n"
+			"FPGA-Arch:	%s\n"
+			"CPU-Ver:	%s\n"
+			"CPU-MHz:	%d.%02d\n"
+			"BogoMips:	%lu.%02lu\n",
+			fpga_family,
+			cpu_ver,
+			cpuinfo.cpu_clock_freq /
+			1000000,
+			cpuinfo.cpu_clock_freq %
+			1000000,
+			loops_per_jiffy / (500000 / HZ),
+			(loops_per_jiffy / (5000 / HZ)) % 100);
+
+	count += seq_printf(m,
+			"HW-Div:\t\t%s\n"
+			"HW-Shift:\t%s\n",
+			cpuinfo.use_divider ? "yes" : "no",
+			cpuinfo.use_barrel ? "yes" : "no");
+
+	if (cpuinfo.use_icache)
+		count += seq_printf(m,
+				"Icache:\t\t%ukB\n",
+				cpuinfo.icache_size >> 10);
+	else
+		count += seq_printf(m, "Icache:\t\tno\n");
+
+	if (cpuinfo.use_dcache)
+		count += seq_printf(m,
+				"Dcache:\t\t%ukB\n",
+				cpuinfo.dcache_size >> 10);
+	else
+		count += seq_printf(m, "Dcache:\t\tno\n");
+
+	count += seq_printf(m,
+			"HW-Debug:\t%s\n",
+			cpuinfo.hw_debug ? "yes" : "no");
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	int i = *pos;
+
+	return i < NR_CPUS ? (void *) (i + 1) : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+struct seq_operations cpuinfo_op = {
+	.start = c_start,
+	.next = c_next,
+	.stop = c_stop,
+	.show = show_cpuinfo,
+};
diff --git a/arch/microblaze/kernel/cpu/pvr.c b/arch/microblaze/kernel/cpu/pvr.c
new file mode 100644
index 0000000..0b117bd
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/pvr.c
@@ -0,0 +1,81 @@
+/*
+ * Support for MicroBlaze PVR (processor version register)
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <asm/system.h>
+#include <asm/exceptions.h>
+#include <asm/pvr.h>
+
+/*
+ * Until we get an assembler that knows about the pvr registers,
+ * this horrible cruft will have to do.
+ * That hardcoded opcode is mfs r3, rpvrNN
+ */
+
+#define get_single_pvr(pvrid, val)				\
+{								\
+	register unsigned tmp __asm__("r3");			\
+	tmp = 0x0;	/* Prevent warning about unused */	\
+	__asm__ __volatile__ (					\
+			".byte 0x94,0x60,0xa0, " #pvrid "\n\t"	\
+			: "=r" (tmp):: "memory"); 		\
+	val = tmp;						\
+}
+
+/*
+ * Does the CPU support the PVR register?
+ * return value:
+ * 0: no PVR
+ * 1: simple PVR
+ * 2: full PVR
+ *
+ * This must work on all CPU versions, including those before the
+ * PVR was even an option.
+ */
+
+int cpu_has_pvr(void)
+{
+	unsigned flags;
+	unsigned pvr0;
+
+	local_save_flags(flags);
+
+	/* PVR bit in MSR tells us if there is any support */
+	if (!(flags & PVR_MSR_BIT))
+		return 0;
+
+	get_single_pvr(0x00, pvr0);
+	pr_debug("%s: pvr0 is 0x%08x\n", __func__, pvr0);
+
+	if (pvr0 & PVR0_PVR_FULL_MASK)
+		return 1;
+
+	/* for partial PVR use static cpuinfo */
+	return 2;
+}
+
+void get_pvr(struct pvr_s *p)
+{
+	get_single_pvr(0, p->pvr[0]);
+	get_single_pvr(1, p->pvr[1]);
+	get_single_pvr(2, p->pvr[2]);
+	get_single_pvr(3, p->pvr[3]);
+	get_single_pvr(4, p->pvr[4]);
+	get_single_pvr(5, p->pvr[5]);
+	get_single_pvr(6, p->pvr[6]);
+	get_single_pvr(7, p->pvr[7]);
+	get_single_pvr(8, p->pvr[8]);
+	get_single_pvr(9, p->pvr[9]);
+	get_single_pvr(10, p->pvr[10]);
+	get_single_pvr(11, p->pvr[11]);
+}
-- 
1.5.4.GIT

