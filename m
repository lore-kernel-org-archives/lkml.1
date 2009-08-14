Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbZHNQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbZHNQgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 12:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbZHNQgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 12:36:19 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:5866 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbZHNQgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 12:36:19 -0400
Date: Fri, 14 Aug 2009 10:36:18 -0600
From: Alex Chiang <achiang@hp.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: andi@firstfloor.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090814163618.GQ7185@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As systems become larger and more complex, it is not always possible
to assume that an APIC ID maps directly to a given physical slot.

>From a UI point-of-view, it's nice if the 'physical id' field in
/proc/cpuinfo matches the silk-screening or labelling on the system
chassis.

Add a quirk that allows oddball platforms to ensure that what the kernel
displays in /proc/cpuinfo matches the physical reality.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
 Makefile        |    2 +-
 common.c        |    5 +++++
 cpu.h           |    8 ++++++++
 physid_quirks.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 1 deletion(-)

---
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..95d54cf 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -9,7 +9,7 @@ endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o physid_quirks.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 54a3ead..714c56f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -815,6 +815,11 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	detect_ht(c);
 #endif
 
+	physid_fixup_table = NULL;
+	dmi_check_system(physid_need_fixups_table);
+	if (physid_fixup_table)
+		c->phys_proc_id = physid_fixup_table[c->phys_proc_id];
+
 	init_hypervisor(c);
 
 	/*
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 6de9a90..5ae221e 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -8,6 +8,8 @@ struct cpu_model_info {
 	const char	*model_names[16];
 };
 
+struct cpuinfo_x86;
+
 /* attempt to consolidate cpu attributes */
 struct cpu_dev {
 	const char	*c_vendor;
@@ -34,4 +36,10 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
+/* defined in physid_quirks.c */
+#include <linux/dmi.h>
+extern int (*physid_fixup_table);
+extern int hp_check_fixup_physids(const struct dmi_system_id *);
+extern struct dmi_system_id physid_need_fixups_table[];
+
 #endif
diff --git a/arch/x86/kernel/cpu/physid_quirks.c b/arch/x86/kernel/cpu/physid_quirks.c
new file mode 100644
index 0000000..40cf429
--- /dev/null
+++ b/arch/x86/kernel/cpu/physid_quirks.c
@@ -0,0 +1,54 @@
+/*
+ *  physid_quirks.c - quirks for the 'physical id' field in /proc/cpuinfo
+ *
+ *  Copyright (C) 2009 Hewlett-Packard Development Company, L.P.
+ *	Alex Chiang <achiang@hp.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms and conditions of the GNU General Public License,
+ *  version 2, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include "cpu.h"
+
+int (*physid_fixup_table);
+
+struct dmi_system_id __initdata physid_need_fixups_table[] = {
+	{
+		.callback = hp_check_fixup_physids,
+		.ident = "HP ProLiant DL785 G5/G6",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL785"),
+		},
+	},
+	{}
+};
+
+/*
+ * The mapping from node to physical socket id is described
+ * in the (HP internal) DL785 system specification.
+ */
+static int hp_dl785_physids_4p[8] = { 8, 2, 7, 1, 0, 0, 0, 0 };
+static int hp_dl785_physids_8p[8] = { 8, 6, 7, 4, 3, 5, 2, 1 };
+int __cpuinit hp_check_fixup_physids(const struct dmi_system_id *d)
+{
+	int present = num_present_cpus();
+
+	/* DL785 only supports 4-socket and 8-socket configs */
+	if (present == 16 || present == 24)
+		physid_fixup_table = hp_dl785_physids_4p;
+	else
+		physid_fixup_table = hp_dl785_physids_8p;
+
+	return 1;
+}
