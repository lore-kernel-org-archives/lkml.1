Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbXGKTZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbXGKTZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764946AbXGKTTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:38 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbXGKTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:30 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 15/33] Simple bitops for the new x86 setup code.
Date: Wed, 11 Jul 2007 12:18:40 -0700
Message-Id: <11841815411443-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815401476-git-send-email-hpa@zytor.com>
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
Message-Id: <03eade29601f9ca92ea95e241aaa7bfbcaaf0c6c.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
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

