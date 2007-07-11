Return-Path: <linux-kernel-owner+w=401wt.eu-S933436AbXGKT1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436AbXGKT1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXGKTTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762604AbXGKTTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:33 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 18/33] APM probing code
Date: Wed, 11 Jul 2007 12:18:43 -0700
Message-Id: <11841815412873-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815411436-git-send-email-hpa@zytor.com>
References: <1184181538674-git-send-email-hpa@zytor.com>
 <118418153862-git-send-email-hpa@zytor.com>
 <11841815382283-git-send-email-hpa@zytor.com>
 <11841815392122-git-send-email-hpa@zytor.com>
 <11841815393975-git-send-email-hpa@zytor.com>
 <11841815393014-git-send-email-hpa@zytor.com>
 <1184181539416-git-send-email-hpa@zytor.com>
 <118418153972-git-send-email-hpa@zytor.com>
 <11841815391923-git-send-email-hpa@zytor.com>
 <11841815403678-git-send-email-hpa@zytor.com>
 <11841815403041-git-send-email-hpa@zytor.com>
 <11841815402349-git-send-email-hpa@zytor.com>
 <11841815401013-git-send-email-hpa@zytor.com>
 <1184181540369-git-send-email-hpa@zytor.com>
 <11841815401476-git-send-email-hpa@zytor.com>
 <11841815411443-git-send-email-hpa@zytor.com>
 <1184181541746-git-send-email-hpa@zytor.com>
 <11841815411436-git-send-email-hpa@zytor.com>
Message-Id: <d1d88acb7f06459e4d906701132bfeffebfb04a3.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

APM probing code for the new x86 setup code.  This implements the
same functionality as the assembly version.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/apm.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/apm.c

diff --git a/arch/i386/boot/apm.c b/arch/i386/boot/apm.c
new file mode 100644
index 0000000..a34087c
--- /dev/null
+++ b/arch/i386/boot/apm.c
@@ -0,0 +1,97 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   Original APM BIOS checking by Stephen Rothwell, May 1994
+ *   (sfr@canb.auug.org.au)
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/apm.c
+ *
+ * Get APM BIOS information
+ */
+
+#include "boot.h"
+
+#if defined(CONFIG_APM) || defined(CONFIG_APM_MODULE)
+
+int query_apm_bios(void)
+{
+	u16 ax, bx, cx, dx, di;
+	u32 ebx, esi;
+	u8 err;
+
+	/* APM BIOS installation check */
+	ax = 0x5300;
+	bx = cx = 0;
+	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %0"
+		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
+		     : : "esi", "edi");
+
+	if (err)
+		return -1;		/* No APM BIOS */
+
+	if (bx != 0x504d)	/* "PM" signature */
+		return -1;
+
+	if (cx & 0x02)		/* 32 bits supported? */
+		return -1;
+
+	/* Disconnect first, just in case */
+	ax = 0x5304;
+	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
+		     : "+a" (ax)
+		     : : "ebx", "ecx", "edx", "esi", "edi");
+
+	/* Paranoia */
+	ebx = esi = 0;
+	cx = dx = di = 0;
+
+	/* 32-bit connect */
+	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %6"
+		     : "=a" (ax), "+b" (ebx), "+c" (cx), "+d" (dx),
+		       "+S" (esi), "+D" (di), "=m" (err)
+		     : "a" (0x5303));
+
+	boot_params.apm_bios_info.cseg = ax;
+	boot_params.apm_bios_info.offset = ebx;
+	boot_params.apm_bios_info.cseg_16 = cx;
+	boot_params.apm_bios_info.dseg = dx;
+	boot_params.apm_bios_info.cseg_len = (u16)esi;
+	boot_params.apm_bios_info.cseg_16_len = esi >> 16;
+	boot_params.apm_bios_info.dseg_len = di;
+
+	if (err)
+		return -1;
+
+	/* Redo the installation check as the 32-bit connect;
+	   some BIOSes return different flags this way... */
+
+	ax = 0x5300;
+	bx = cx = 0;
+	asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp ; setc %0"
+		     : "=d" (err), "+a" (ax), "+b" (bx), "+c" (cx)
+		     : : "esi", "edi");
+
+	if (err || bx != 0x504d) {
+		/* Failure with 32-bit connect, try to disconect and ignore */
+		ax = 0x5304;
+		bx = 0;
+		asm volatile("pushl %%ebp ; int $0x15 ; popl %%ebp"
+			     : "+a" (ax), "+b" (bx)
+			     : : "ecx", "edx", "esi", "edi");
+		return -1;
+	}
+
+	boot_params.apm_bios_info.version = ax;
+	boot_params.apm_bios_info.flags = cx;
+	return 0;
+}
+
+#endif
-- 
1.5.2.2

