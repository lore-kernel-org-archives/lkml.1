Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbYEDPS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbYEDPS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYEDPSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:18:21 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:41947 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750847AbYEDPST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:18:19 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 13/56] microblaze_v2: PVR support, cpuinfo support
Date: Sun,  4 May 2008 13:41:02 +0200
Message-Id: <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
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
index 0000000..44a911c
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
index 0000000..19d99a8
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/pvr.c
@@ -0,0 +1,83 @@
+/*
+ * arch/microblaze/kernel/cpu/pvr.c
+ *
+ * Support for MicroBlaze PVR (processor version register)
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * Copyright (C) 2007 PetaLogix
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
+	pr_debug("%s: pvr0 is 0x%08x\n", __func__, pvr0);
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
1.5.4.GIT

