Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbXGJDou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbXGJDou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXGJDon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:44:43 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbXGJDol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:44:41 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 26/33] Voyager support for the new x86 setup code
Date: Mon,  9 Jul 2007 19:52:05 -0700
Message-Id: <11840386682120-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184038562864-git-send-email-hpa@zytor.com>
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
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
 <11840381413065-git-send-email-hpa@zytor.com>
 <11840382473923-git-send-email-hpa@zytor.com>
 <11840383522914-git-send-email-hpa@zytor.com>
 <1184038457733-git-send-email-hpa@zytor.com>
 <1184038562864-git-send-email-hpa@zytor.com>
Message-Id: <dd2fade47882935c137f6d2a3c955eac1f6f8ecf.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
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

