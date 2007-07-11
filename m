Return-Path: <linux-kernel-owner+w=401wt.eu-S933666AbXGKTc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666AbXGKTc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761716AbXGKTUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:20:04 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763301AbXGKTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:44 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 26/33] Voyager support for the new x86 setup code
Date: Wed, 11 Jul 2007 12:18:51 -0700
Message-Id: <11841815423976-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815422973-git-send-email-hpa@zytor.com>
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
 <11841815422973-git-send-email-hpa@zytor.com>
Message-Id: <76894ec63ab814078b628b5697e1b86d6421b187.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Voyager support for the new x86 setup code.  This implements the same
functionality as the assembly version.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/voyager.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/voyager.c

diff --git a/arch/i386/boot/voyager.c b/arch/i386/boot/voyager.c
new file mode 100644
index 0000000..9221614
--- /dev/null
+++ b/arch/i386/boot/voyager.c
@@ -0,0 +1,46 @@
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
+ * arch/i386/boot/voyager.c
+ *
+ * Get the Voyager config information
+ */
+
+#include "boot.h"
+
+#ifdef CONFIG_X86_VOYAGER
+
+int query_voyager(void)
+{
+	u8 err;
+	u16 es, di;
+	/* Abuse the apm_bios_info area for this */
+	u8 *data_ptr = (u8 *)&boot_params.apm_bios_info;
+
+	data_ptr[0] = 0xff;	/* Flag on config not found(?) */
+
+	asm("pushw %%es ; "
+	    "int $0x15 ; "
+	    "setc %0 ; "
+	    "movw %%es, %1 ; "
+	    "popw %%es"
+	    : "=qm" (err), "=rm" (es), "=D" (di)
+	    : "a" (0xffc0));
+
+	if (err)
+		return -1;	/* Not Voyager */
+
+	set_fs(es);
+	copy_from_fs(data_ptr, di, 7);	/* Table is 7 bytes apparently */
+	return 0;
+}
+
+#endif /* CONFIG_X86_VOYAGER */
-- 
1.5.2.2

