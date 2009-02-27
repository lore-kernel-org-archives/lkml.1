Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbZB0Kn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbZB0Kn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZB0Knr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:43:47 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:53519 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZB0Knp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VsOY++fYf1kw84djSV3UdPRSlLNjvcf0S6ldzHBIYnObEFwrZziwl86dl0AkYvOhR8
         MyFea+4ZxJQmtJgUfEn568wUPJepcSDdquWyuQVlRDELYEPVaBCvWrWpiVushIP2c9nn
         ILJYz//0Tkf6gnNehWaChrbtuZKvNs2y5clNQ=
Date: Fri, 27 Feb 2009 11:43:39 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kmemcheck: add opcode self-testing at boot
Message-ID: <20090227104338.GA1899@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 01fb811b6c25ecb113af9230b7297ac45ed91519 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 27 Feb 2009 11:35:55 +0100
Subject: [PATCH] kmemcheck: add opcode self-testing at boot

We've had some troubles in the past with weird instructions. This
patch adds a self-test framework which can be used to verify that
a certain set of opcodes are decoded correctly. Of course, the
opcodes which are not tested can still give the wrong results.

In short, this is just a safeguard to catch unintentional changes
in the opcode decoder. It does not mean that errors can't still
occur!

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/mm/kmemcheck/Makefile    |    2 +-
 arch/x86/mm/kmemcheck/kmemcheck.c |   38 ++++++++++++--------
 arch/x86/mm/kmemcheck/selftest.c  |   69 +++++++++++++++++++++++++++++++++++++
 arch/x86/mm/kmemcheck/selftest.h  |    6 +++
 4 files changed, 99 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/mm/kmemcheck/selftest.c
 create mode 100644 arch/x86/mm/kmemcheck/selftest.h

diff --git a/arch/x86/mm/kmemcheck/Makefile b/arch/x86/mm/kmemcheck/Makefile
index 4666b7a..520b3bc 100644
--- a/arch/x86/mm/kmemcheck/Makefile
+++ b/arch/x86/mm/kmemcheck/Makefile
@@ -1 +1 @@
-obj-y := error.o kmemcheck.o opcode.o pte.o shadow.o
+obj-y := error.o kmemcheck.o opcode.o pte.o selftest.o shadow.o
diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
index 9349565..2b5ca65 100644
--- a/arch/x86/mm/kmemcheck/kmemcheck.c
+++ b/arch/x86/mm/kmemcheck/kmemcheck.c
@@ -29,12 +29,26 @@
 #include "error.h"
 #include "opcode.h"
 #include "pte.h"
+#include "selftest.h"
 #include "shadow.h"
 
+
+#ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
+#  define KMEMCHECK_ENABLED 0
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT
+#  define KMEMCHECK_ENABLED 1
+#endif
+
+#ifdef CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT
+#  define KMEMCHECK_ENABLED 2
+#endif
+
+int kmemcheck_enabled = KMEMCHECK_ENABLED;
+
 void __init kmemcheck_init(void)
 {
-	printk(KERN_INFO "kmemcheck: Initialized\n");
-
 #ifdef CONFIG_SMP
 	/*
 	 * Limit SMP to use a single CPU. We rely on the fact that this code
@@ -46,21 +60,15 @@ void __init kmemcheck_init(void)
 		setup_max_cpus = 1;
 	}
 #endif
-}
 
-#ifdef CONFIG_KMEMCHECK_DISABLED_BY_DEFAULT
-#  define KMEMCHECK_ENABLED 0
-#endif
-
-#ifdef CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT
-#  define KMEMCHECK_ENABLED 1
-#endif
-
-#ifdef CONFIG_KMEMCHECK_ONESHOT_BY_DEFAULT
-#  define KMEMCHECK_ENABLED 2
-#endif
+	if (!kmemcheck_selftest()) {
+		printk(KERN_INFO "kmemcheck: self-tests failed; disabling\n");
+		kmemcheck_enabled = 0;
+		return;
+	}
 
-int kmemcheck_enabled = KMEMCHECK_ENABLED;
+	printk(KERN_INFO "kmemcheck: Initialized\n");
+}
 
 /*
  * We need to parse the kmemcheck= option before any memory is allocated.
diff --git a/arch/x86/mm/kmemcheck/selftest.c b/arch/x86/mm/kmemcheck/selftest.c
new file mode 100644
index 0000000..036efbe
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/selftest.c
@@ -0,0 +1,69 @@
+#include <linux/kernel.h>
+
+#include "opcode.h"
+#include "selftest.h"
+
+struct selftest_opcode {
+	unsigned int expected_size;
+	const uint8_t *insn;
+	const char *desc;
+};
+
+static const struct selftest_opcode selftest_opcodes[] = {
+	/* REP MOVS */
+	{1, "\xf3\xa4", 		"rep movsb <mem8>, <mem8>"},
+	{4, "\xf3\xa5",			"rep movsl <mem32>, <mem32>"},
+
+	/* MOVZX / MOVZXD */
+	{1, "\x66\x0f\xb6\x51\xf8",	"movzwq <mem8>, <reg16>"},
+	{1, "\x0f\xb6\x51\xf8",		"movzwq <mem8>, <reg32>"},
+
+	/* MOVSX / MOVSXD */
+	{1, "\x66\x0f\xbe\x51\xf8",	"movswq <mem8>, <reg16>"},
+	{1, "\x0f\xbe\x51\xf8",		"movswq <mem8>, <reg32>"},
+
+#ifdef CONFIG_X86_64
+	/* MOVZX / MOVZXD */
+	{1, "\x49\x0f\xb6\x51\xf8",	"movzbq <mem8>, <reg64>"},
+	{2, "\x49\x0f\xb7\x51\xf8",	"movzbq <mem16>, <reg64>"},
+
+	/* MOVSX / MOVSXD */
+	{1, "\x49\x0f\xbe\x51\xf8",	"movsbq <mem8>, <reg64>"},
+	{2, "\x49\x0f\xbf\x51\xf8",	"movsbq <mem16>, <reg64>"},
+	{4, "\x49\x63\x51\xf8",		"movslq <mem32>, <reg64>"},
+#endif
+};
+
+static bool selftest_opcode_one(const struct selftest_opcode *op)
+{
+	unsigned size;
+
+	kmemcheck_opcode_decode(op->insn, &size);
+
+	if (size == op->expected_size)
+		return true;
+
+	printk(KERN_WARNING "kmemcheck: opcode %s: expected size %d, got %d\n",
+		op->desc, op->expected_size, size);
+	return false;
+}
+
+static bool selftest_opcodes_all(void)
+{
+	bool pass = true;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(selftest_opcodes); ++i)
+		pass = pass && selftest_opcode_one(&selftest_opcodes[i]);
+
+	return pass;
+}
+
+bool kmemcheck_selftest(void)
+{
+	bool pass = true;
+
+	pass = pass && selftest_opcodes_all();
+
+	return pass;
+}
diff --git a/arch/x86/mm/kmemcheck/selftest.h b/arch/x86/mm/kmemcheck/selftest.h
new file mode 100644
index 0000000..8fed4fe
--- /dev/null
+++ b/arch/x86/mm/kmemcheck/selftest.h
@@ -0,0 +1,6 @@
+#ifndef ARCH_X86_MM_KMEMCHECK_SELFTEST_H
+#define ARCH_X86_MM_KMEMCHECK_SELFTEST_H
+
+bool kmemcheck_selftest(void);
+
+#endif
-- 
1.6.0.6

