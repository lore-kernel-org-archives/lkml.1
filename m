Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYGHMIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYGHMIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbYGHMIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:08:25 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:25129 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756395AbYGHMIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:08:23 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 14/58] microblaze_v5: PVR support, cpuinfo support
Date: Tue,  8 Jul 2008 13:59:14 +0200
Message-Id: <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/mb.c  |  115 ++++++++++++++++++++++++++++++++++++++
 arch/microblaze/kernel/cpu/pvr.c |   81 ++++++++++++++++++++++++++
 2 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/cpu/mb.c
 create mode 100644 arch/microblaze/kernel/cpu/pvr.c

diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
new file mode 100644
index 0000000..31429ed
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
+	printk("%s\n",__func__);
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

