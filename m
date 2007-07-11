Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbXGKTbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbXGKTbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765338AbXGKTUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:20:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbXGKTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:43 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 25/33] Memory probing support for the new x86 setup code
Date: Wed, 11 Jul 2007 12:18:50 -0700
Message-Id: <11841815422973-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815423652-git-send-email-hpa@zytor.com>
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
 <11841815412873-git-send-email-hpa@zytor.com>
 <11841815412175-git-send-email-hpa@zytor.com>
 <1184181541492-git-send-email-hpa@zytor.com>
 <11841815421028-git-send-email-hpa@zytor.com>
 <118418154292-git-send-email-hpa@zytor.com>
 <11841815421819-git-send-email-hpa@zytor.com>
 <11841815423652-git-send-email-hpa@zytor.com>
Message-Id: <67bea0be0e4af894483cd7d8e725631d24e9c263.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Probe memory (INT 15h: E820, E801, 88).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/memory.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 99 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/memory.c

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
new file mode 100644
index 0000000..1a2e62d
--- /dev/null
+++ b/arch/i386/boot/memory.c
@@ -0,0 +1,99 @@
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
+ * arch/i386/boot/memory.c
+ *
+ * Memory detection code
+ */
+
+#include "boot.h"
+
+#define SMAP	0x534d4150	/* ASCII "SMAP" */
+
+static int detect_memory_e820(void)
+{
+	u32 next = 0;
+	u32 size, id;
+	u8 err;
+	struct e820entry *desc = boot_params.e820_map;
+
+	do {
+		size = sizeof(struct e820entry);
+		id = SMAP;
+		asm("int $0x15; setc %0"
+		    : "=am" (err), "+b" (next), "+d" (id), "+c" (size),
+		      "=m" (*desc)
+		    : "D" (desc), "a" (0xe820));
+
+		if (err || id != SMAP)
+			break;
+
+		boot_params.e820_entries++;
+		desc++;
+	} while (next && boot_params.e820_entries < E820MAX);
+
+	return boot_params.e820_entries;
+}
+
+static int detect_memory_e801(void)
+{
+	u16 ax, bx, cx, dx;
+	u8 err;
+
+	bx = cx = dx = 0;
+	ax = 0xe801;
+	asm("stc; int $0x15; setc %0"
+	    : "=m" (err), "+a" (ax), "+b" (bx), "+c" (cx), "+d" (dx));
+
+	if (err)
+		return -1;
+
+	/* Do we really need to do this? */
+	if (cx || dx) {
+		ax = cx;
+		bx = dx;
+	}
+
+	if (ax > 15*1024)
+		return -1;	/* Bogus! */
+
+	/* This ignores memory above 16MB if we have a memory hole
+	   there.  If someone actually finds a machine with a memory
+	   hole at 16MB and no support for 0E820h they should probably
+	   generate a fake e820 map. */
+	boot_params.alt_mem_k = (ax == 15*1024) ? (dx << 6)+ax : ax;
+
+	return 0;
+}
+
+static int detect_memory_88(void)
+{
+	u16 ax;
+	u8 err;
+
+	ax = 0x8800;
+	asm("stc; int $0x15; setc %0" : "=bcdm" (err), "+a" (ax));
+
+	boot_params.screen_info.ext_mem_k = ax;
+
+	return -err;
+}
+
+int detect_memory(void)
+{
+	if (detect_memory_e820() > 0)
+		return 0;
+
+	if (!detect_memory_e801())
+		return 0;
+
+	return detect_memory_88();
+}
-- 
1.5.2.2

