Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbXGJDav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbXGJDav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbXGJDam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:30:42 -0400
Received: from terminus.zytor.com ([192.83.249.54]:50682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbXGJDak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:30:40 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 18/33] APM probing code
Date: Mon,  9 Jul 2007 19:51:57 -0700
Message-Id: <11840378261081-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840377211519-git-send-email-hpa@zytor.com>
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
 <11840377211519-git-send-email-hpa@zytor.com>
Message-Id: <c488ae7cd0ddd799b666f55652248be3c346a076.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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

