Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbZDGPPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbZDGPPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbZDGPIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48866 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbZDGPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:04 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [17/28] x86: MCE: Add table driven machine check grading
Message-Id: <20090407150759.9823D1D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
 arch/x86/kernel/cpu/mcheck/Makefile       |    1 
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   10 ++++
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   61 ++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce-severity.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/cpu/mcheck/mce-severity.c	2009-04-07 16:43:08.000000000 +0200
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
Index: linux/arch/x86/kernel/cpu/mcheck/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/Makefile	2009-04-07 16:09:53.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/Makefile	2009-04-07 16:43:09.000000000 +0200
@@ -5,3 +5,4 @@
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
+obj-$(CONFIG_X86_64)		+= mce-severity.o
Index: linux/arch/x86/kernel/cpu/mcheck/mce-internal.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/arch/x86/kernel/cpu/mcheck/mce-internal.h	2009-04-07 16:43:08.000000000 +0200
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
