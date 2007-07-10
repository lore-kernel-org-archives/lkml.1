Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbXGJDZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbXGJDZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759089AbXGJDZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:25:25 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57205 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbXGJDZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:25:24 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 15/33] Simple bitops for the new x86 setup code.
Date: Mon,  9 Jul 2007 19:51:54 -0700
Message-Id: <1184037510289-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840374052662-git-send-email-hpa@zytor.com>
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
Message-Id: <899e4acb1fe3e4313dfdca5398431274808d71ef.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

A simple collection of bitops for the new x86 setup code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/bitops.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/bitops.h

diff --git a/arch/i386/boot/bitops.h b/arch/i386/boot/bitops.h
new file mode 100644
index 0000000..8dcc8dc
--- /dev/null
+++ b/arch/i386/boot/bitops.h
@@ -0,0 +1,45 @@
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
+ * arch/i386/boot/bitops.h
+ *
+ * Very simple bitops for the boot code.
+ */
+
+#ifndef BOOT_BITOPS_H
+#define BOOT_BITOPS_H
+#define _LINUX_BITOPS_H		/* Inhibit inclusion of <linux/bitops.h> */
+
+static inline int constant_test_bit(int nr, const void *addr)
+{
+	const u32 *p = (const u32 *)addr;
+	return ((1UL << (nr & 31)) & (p[nr >> 5])) != 0;
+}
+static inline int variable_test_bit(int nr, const void *addr)
+{
+	u8 v;
+	const u32 *p = (const u32 *)addr;
+
+	asm("btl %2,%1; setc %0" : "=qm" (v) : "m" (*p), "Ir" (nr));
+	return v;
+}
+
+#define test_bit(nr,addr) \
+(__builtin_constant_p(nr) ? \
+ constant_test_bit((nr),(addr)) : \
+ variable_test_bit((nr),(addr)))
+
+static inline void set_bit(int nr, void *addr)
+{
+	asm("btsl %1,%0" : "+m" (*(u32 *)addr) : "Ir" (nr));
+}
+
+#endif /* BOOT_BITOPS_H */
-- 
1.5.2.2

