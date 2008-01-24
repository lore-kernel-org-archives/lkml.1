Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYAZP5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYAZP5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbYAZPy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:27 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755185AbYAZPyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:25 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 13/52] [microblaze] PVR support, cpuinfo support
Date: Thu, 24 Jan 2008 16:02:48 +0100
Message-Id: <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/mb.c  |  115 ++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/pvr.c |   83 +++++++++++++++++++++++++++
 2 files changed, 198 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/cpu/mb.c
 create mode 100644 arch/microblaze/kernel/cpu/pvr.c

diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
new file mode 100644
index 0000000..2e68c3f
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/mb.c
@@ -0,0 +1,115 @@
+/*
+ * arch/microblaze/kernel/cpu/mb.c
+ *
+ * CPU-version specific code
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) Michal Simek <monstr@monstr.eu>
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
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	int count = 0;
+	char *fpga_family = "Unknown";
+	char *cpu_ver = "Unknown";
+	int i;
+
+	/* Denormalised to get the fpga family string */
+	for (i = 0; family_string_lookup[i].s != NULL; i++) {
+		if (cpuinfo->fpga_family_code == family_string_lookup[i].k) {
+			fpga_family = family_string_lookup[i].s;
+			break;
+		}
+	}
+
+	/* Denormalised to get the hw version string */
+	for (i = 0; cpu_ver_lookup[i].s != NULL; i++) {
+		if (cpuinfo->ver_code == cpu_ver_lookup[i].k) {
+			cpu_ver = cpu_ver_lookup[i].s;
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
+			cpuinfo->cpu_clock_freq /
+			1000000,
+			cpuinfo->cpu_clock_freq %
+			1000000,
+			loops_per_jiffy / (500000 / HZ),
+			(loops_per_jiffy / (5000 / HZ)) % 100);
+
+	count += seq_printf(m,
+			"HW-Div:\t\t%s\n"
+			"HW-Shift:\t%s\n",
+			cpuinfo->use_divider ? "yes" : "no",
+			cpuinfo->use_barrel ? "yes" : "no");
+
+	if (cpuinfo->use_icache)
+		count += seq_printf(m,
+				"Icache:\t\t%ukB\n",
+				cpuinfo->icache_size >> 10);
+	else
+		count += seq_printf(m, "Icache:\t\tno\n");
+
+	if (cpuinfo->use_dcache)
+		count += seq_printf(m,
+				"Dcache:\t\t%ukB\n",
+				cpuinfo->dcache_size >> 10);
+	else
+		count += seq_printf(m, "Dcache:\t\tno\n");
+
+	count += seq_printf(m,
+			"HW-Debug:\t%s\n",
+			cpuinfo->hw_debug ? "yes" : "no");
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
index 0000000..37e3a45
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/pvr.c
@@ -0,0 +1,83 @@
+/*
+ * arch/microblaze/kernel/cpu/pvr.c
+ *
+ * Support for MicroBlaze PVR (processor version register)
+ *
+ * (C) 2007 Michal Simek <monstr@monstr.eu>
+ * (C) 2007 John Williams <john.williams@petalogix.com>
+ * (C) 2007 PetaLogix
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
+	int ret = 0;
+
+	local_irq_save(flags);
+
+	/* PVR bit in MSR tells us if there is any support */
+	if (!(flags & PVR_MSR_BIT))
+		goto out;
+
+	get_single_pvr(0x00, pvr0);
+	pr_debug("%s: pvr0 is 0x%08x\n", __FUNCTION__, pvr0);
+
+	if (pvr0 & PVR0_PVR_FULL_MASK)
+		ret = 2;
+	else
+		ret = 1;
+
+out:
+	local_irq_restore(flags);
+	return ret;
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
1.5.4.rc4.14.g6fc74

