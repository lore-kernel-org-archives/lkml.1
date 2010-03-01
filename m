Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab0CAWDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:03:32 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:50691 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab0CAWDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:03:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=Ck3MZ5o6neacSksc9abuPGJRteHgdpmtn4z02ue3NIqcXL6DFC+ga2EGfZLx+SO2NA
         vM6LMklcLMopnI7PXcv8neuYEYh2kvTfyPWmjcJxuoDkdJWv4Hcp+CtzHo/NW2LHol1k
         qjGld/XFivt/Lb1Azg1z8Jqs98+15pG7y0L1s=
MIME-Version: 1.0
From: Matteo Croce <technoboy85@gmail.com>
Date: Mon, 1 Mar 2010 23:03:09 +0100
Message-ID: <40101cc31003011403x4423cb3em1f6fcb04d64dd2bb@mail.gmail.com>
Subject: AMD Geode i686
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have refreshed my AMD Geode i686 patch with NOPL and I have added a
new nice feature.
When a NOPL is found the parser looks for any NOPL after the current
one, so they are emulated in bulk.
Tested ok on a Pcengines Alix.

Signed-off-by: Matteo Croce <technoboy85@gmail.com>

--- a/arch/x86/kernel/Makefile	2010-03-01 01:18:51.697166322 +0100
+++ b/arch/x86/kernel/Makefile	2010-03-01 01:19:45.727095700 +0100
@@ -89,6 +89,8 @@
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o

 obj-$(CONFIG_K8_NB)		+= k8.o
+obj-$(CONFIG_MGEODEGX1)		+= nopl_emu.o
+obj-$(CONFIG_MGEODE_LX)		+= nopl_emu.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o

--- a/arch/x86/kernel/cpu/amd.c	2010-03-01 01:18:51.737097341 +0100
+++ b/arch/x86/kernel/cpu/amd.c	2010-03-01 01:19:27.867865836 +0100
@@ -138,8 +138,10 @@
 	}

 	if (c->x86_model == 10) {
-		/Index: linux-2.6.33/arch/x86/kernel/Makefile
===================================================================
* AMD Geode LX is model 10 */
-		/* placeholder for any needed mods */
+		/* Geode only lacks the NOPL instruction to be i686,
+		   but we can emulate it in the exception handler
+		   and promote it to a class 6 cpu */
+		boot_cpu_data.x86 = 6;
 		return;
 	}
 }
--- a/arch/x86/kernel/entry_32.S	2010-03-01 01:18:51.717096708 +0100
+++ b/arch/x86/kernel/entry_32.S	2010-03-01 01:19:27.867865836 +0100
@@ -960,7 +960,11 @@
 	RING0_INT_FRAME
 	pushl $0
 	CFI_ADJUST_CFA_OFFSET 4
+#ifdef CONFIG_MGEODE_LX
+	pushl $do_nopl_emu
+#else
 	pushl $do_invalid_op
+#endif
 	CFI_ADJUST_CFA_OFFSET 4
 	jmp error_code
 	CFI_ENDPROC
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/arch/x86/kernel/nopl_emu.c	2010-03-01 02:40:44.324595733 +0100
@@ -0,0 +1,107 @@
+/*
+ *  linux/arch/x86/kernel/nopl_emu.c
+ *
+ *  Copyright (C) 2002  Willy Tarreau
+ *  Copyright (C) 2010  Matteo Croce
+ */
+
+#include <asm/processor.h>
+#include <asm/traps.h>
+
+/* This code can be used to allow the AMD Geode to hopefully correctly execute
+ * some code which was originally compiled for an i686, by emulating NOPL,
+ * the only missing i686 instruction in the CPU
+ *
+ * Willy Tarreau <willy@meta-x.org>
+ * Matteo Croce <technoboy85@gmail.com>
+ */
+
+static inline int do_1f(u8 *ip)
+{
+	int length = 3;
+	switch (*ip) {
+	case 0x84:
+		if (!ip[5])
+			length++;
+		else
+			return 0;
+	case 0x80:
+		if (!ip[4] && !ip[3])
+			length += 2;
+		else
+			return 0;
+	case 0x44:
+		if (!ip[2])
+			length++;
+		else
+			return 0;
+	case 0x40:
+		if (!ip[1])
+			length++;
+		else
+			return 0;
+	case 0x00:
+		return length;
+	}
+	return 0;
+}
+
+static inline int do_0f(u8 *ip)
+{
+	if (*ip == 0x1f)
+		return do_1f(ip + 1);
+	return 0;
+}
+
+static inline int do_66(u8 *ip)
+{
+	if (*ip == 0x90)
+		return 2;
+	if (*ip == 0x0f) {
+		int res = do_0f(ip + 1);
+		if (res)
+			return res + 1;
+		else
+			return 0;
+	}
+	return 0;
+}
+
+static inline int do_start(u8 *ip)
+{
+	if (*ip == 0x0f)
+		return do_0f(ip + 1);
+	if (*ip == 0x66)
+		return do_66(ip + 1);
+	return 0;
+}
+
+/* [do_nopl_emu] is called by exception 6 after an invalid opcode has been
+ * encountered. It will try to emulate it by doing nothing,
+ * and will send a SIGILL or SIGSEGV to the process if not possible.
+ * the NOPL can have variable length opcodes:
+
+bytes number	opcode
+	2	66 90
+	3	0f 1f 00
+	4	0f 1f 40 00
+	5	0f 1f 44 00 00
+	6	66 0f 1f 44 00 00
+	7	0f 1f 80 00 00 00 00
+	8	0f 1f 84 00 00 00 00 00
+	9	66 0f 1f 84 00 00 00 00 00
+*/
+void do_nopl_emu(struct pt_regs *regs, long error_code)
+{
+	u8 *ip = (u8 *)instruction_pointer(regs);
+	int res = do_start(ip);
+
+	if (res) {
+		do {
+			ip += res;
+			res = do_start(ip);
+		} while (res);
+		regs->ip = (typeof(regs->ip))ip;
+	} else
+		do_invalid_op(regs, error_code);
+}
