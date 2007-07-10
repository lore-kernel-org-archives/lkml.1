Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbXGJD3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbXGJD3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbXGJD24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:28:56 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbXGJD2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:28:55 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 17/33] A20 handling code
Date: Mon,  9 Jul 2007 19:51:56 -0700
Message-Id: <11840377211519-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840376162370-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
Message-Id: <17db5b2c8a43cf36b2eb36afc142ce9ca0552282.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

A20 handling code for the new x86 setup code.  This implements the same
algorithms as the assembly version.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/a20.c |  161 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 161 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/a20.c

diff --git a/arch/i386/boot/a20.c b/arch/i386/boot/a20.c
new file mode 100644
index 0000000..31348d0
--- /dev/null
+++ b/arch/i386/boot/a20.c
@@ -0,0 +1,161 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/a20.c
+ *
+ * Enable A20 gate (return -1 on failure)
+ */
+
+#include "boot.h"
+
+#define MAX_8042_LOOPS	100000
+
+static int empty_8042(void)
+{
+	u8 status;
+	int loops = MAX_8042_LOOPS;
+
+	while (loops--) {
+		io_delay();
+
+		status = inb(0x64);
+		if (status & 1) {
+			/* Read and discard input data */
+			io_delay();
+			(void)inb(0x60);
+		} else if (!(status & 2)) {
+			/* Buffers empty, finished! */
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+/* Returns nonzero if the A20 line is enabled.  The memory address
+   used as a test is the int $0x80 vector, which should be safe. */
+
+#define A20_TEST_ADDR	(4*0x80)
+#define A20_TEST_SHORT  32
+#define A20_TEST_LONG	2097152	/* 2^21 */
+
+static int a20_test(int loops)
+{
+	int ok = 0;
+	int saved, ctr;
+
+	set_fs(0x0000);
+	set_gs(0xffff);
+
+	saved = ctr = rdfs32(A20_TEST_ADDR);
+
+	while (loops--) {
+		wrfs32(++ctr, A20_TEST_ADDR);
+		io_delay();	/* Serialize and make delay constant */
+		ok = rdgs32(A20_TEST_ADDR+0x10) ^ ctr;
+		if (ok)
+			break;
+	}
+
+	wrfs32(saved, A20_TEST_ADDR);
+	return ok;
+}
+
+/* Quick test to see if A20 is already enabled */
+static int a20_test_short(void)
+{
+	return a20_test(A20_TEST_SHORT);
+}
+
+/* Longer test that actually waits for A20 to come on line; this
+   is useful when dealing with the KBC or other slow external circuitry. */
+static int a20_test_long(void)
+{
+	return a20_test(A20_TEST_LONG);
+}
+
+static void enable_a20_bios(void)
+{
+	asm volatile("pushfl; int $0x15; popfl"
+		     : : "a" ((u16)0x2401));
+}
+
+static void enable_a20_kbc(void)
+{
+	empty_8042();
+
+	outb(0xd1, 0x64);	/* Command write */
+	empty_8042();
+
+	outb(0xdf, 0x60);	/* A20 on */
+	empty_8042();
+}
+
+static void enable_a20_fast(void)
+{
+	u8 port_a;
+
+	port_a = inb(0x92);	/* Configuration port A */
+	port_a |=  0x02;	/* Enable A20 */
+	port_a &= ~0x01;	/* Do not reset machine */
+	outb(port_a, 0x92);
+}
+
+/*
+ * Actual routine to enable A20; return 0 on ok, -1 on failure
+ */
+
+#define A20_ENABLE_LOOPS 255	/* Number of times to try */
+
+int enable_a20(void)
+{
+	int loops = A20_ENABLE_LOOPS;
+
+#if defined(CONFIG_X86_ELAN)
+	/* Elan croaks if we try to touch the KBC */
+	enable_a20_fast();
+	while (!a20_test_long())
+		;
+	return 0;
+#elif defined(CONFIG_X86_VOYAGER)
+	/* On Voyager, a20_test() is unsafe? */
+	enable_a20_kbc();
+	return 0;
+#else
+	while (loops--) {
+		/* First, check to see if A20 is already enabled
+		   (legacy free, etc.) */
+		if (a20_test_short())
+			return 0;
+
+		/* Next, try the BIOS (INT 0x15, AX=0x2401) */
+		enable_a20_bios();
+		if (a20_test_short())
+			return 0;
+
+		/* Try enabling A20 through the keyboard controller */
+		empty_8042();
+		if (a20_test_short())
+			return 0; /* BIOS worked, but with delayed reaction */
+
+		enable_a20_kbc();
+		if (a20_test_long())
+			return 0;
+
+		/* Finally, try enabling the "fast A20 gate" */
+		enable_a20_fast();
+		if (a20_test_long())
+			return 0;
+	}
+
+	return -1;
+#endif
+}
-- 
1.5.2.2

