Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbZEZX6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbZEZX6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbZEZXyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38606 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbZEZXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:47 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 14/31] x86: MCE: Add table driven machine check grading
Date: Wed, 27 May 2009 01:54:16 +0200
Message-Id: <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Impact: Feature

The machine check grading (as in deciding what should be done for a given
register value) has to be done multiple times soon and it's also getting more complicated.
So it makes sense to consolidate it into a single function. To get smaller
and more straight forward and possibly more extensible code I opted towards
a new table driven method. The various rules are put into a table
when is then executed by a very simple interpreter.

The grading engine is in a new file mce-severity.c. I also added a private
include file mce-internal.h, because mce.h is already a bit too cluttered.

This is dead code right now, but will be used in followon patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/mcheck/Makefile       |    1 +
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   10 +++++
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   61 +++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-internal.h
 create mode 100644 arch/x86/kernel/cpu/mcheck/mce-severity.c

diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index 60ee182..45004fa 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,5 +1,6 @@
 obj-y				=  mce.o therm_throt.o
 
+obj-$(CONFIG_X86_NEW_MCE)	+= mce-severity.o
 obj-$(CONFIG_X86_OLD_MCE)	+= k7.o p4.o p6.o
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
 obj-$(CONFIG_X86_MCE_P4THERMAL)	+= mce_intel.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
new file mode 100644
index 0000000..f126b4a
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -0,0 +1,10 @@
+#include <asm/mce.h>
+
+enum severity_level {
+	MCE_NO_SEVERITY,
+	MCE_SOME_SEVERITY,
+	MCE_UC_SEVERITY,
+	MCE_PANIC_SEVERITY,
+};
+
+int mce_severity(struct mce *a, int tolerant, char **msg);
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
new file mode 100644
index 0000000..c189e89
--- /dev/null
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -0,0 +1,61 @@
+/*
+ * MCE grading rules.
+ * Copyright 2008, 2009 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Author: Andi Kleen
+ */
+#include <linux/kernel.h>
+#include <asm/mce.h>
+
+#include "mce-internal.h"
+
+/*
+ * Grade an mce by severity. In general the most severe ones are processed
+ * first. Since there are quite a lot of combinations test the bits in a
+ * table-driven way. The rules are simply processed in order, first
+ * match wins.
+ */
+
+static struct severity {
+	u64 mask;
+	u64 result;
+	unsigned char sev;
+	unsigned char mcgmask;
+	unsigned char mcgres;
+	char *msg;
+} severities[] = {
+#define SEV(s) .sev = MCE_ ## s ## _SEVERITY
+#define BITCLR(x, s, m, r...) { .mask = x, .result = 0, SEV(s), .msg = m, ## r }
+#define BITSET(x, s, m, r...) { .mask = x, .result = x, SEV(s), .msg = m, ## r }
+#define MCGMASK(x, res, s, m, r...) \
+	{ .mcgmask = x, .mcgres = res, SEV(s), .msg = m, ## r }
+	BITCLR(MCI_STATUS_VAL, NO, "Invalid"),
+	BITCLR(MCI_STATUS_EN, NO, "Not enabled"),
+	BITSET(MCI_STATUS_PCC, PANIC, "Processor context corrupt"),
+	MCGMASK(MCG_STATUS_RIPV, 0, PANIC, "No restart IP"),
+	BITSET(MCI_STATUS_UC|MCI_STATUS_OVER, PANIC, "Overflowed uncorrected"),
+	BITSET(MCI_STATUS_UC, UC, "Uncorrected"),
+	BITSET(0, SOME, "No match")	/* always matches. keep at end */
+};
+
+int mce_severity(struct mce *a, int tolerant, char **msg)
+{
+	struct severity *s;
+	for (s = severities;; s++) {
+		if ((a->status & s->mask) != s->result)
+			continue;
+		if ((a->mcgstatus & s->mcgmask) != s->mcgres)
+			continue;
+		if (s->sev > MCE_NO_SEVERITY && (a->status & MCI_STATUS_UC) &&
+			tolerant < 1)
+			return MCE_PANIC_SEVERITY;
+		if (msg)
+			*msg = s->msg;
+		return s->sev;
+	}
+}
-- 
1.6.0.2

