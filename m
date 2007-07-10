Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbXGJD1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbXGJD1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760853AbXGJD1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:27:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57222 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760750AbXGJD1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:27:09 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 16/33] String-handling functions for the new x86 setup code.
Date: Mon,  9 Jul 2007 19:51:55 -0700
Message-Id: <11840376162370-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184037510289-git-send-email-hpa@zytor.com>
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
Message-Id: <d5bd30fc697149284a73e09efe54884ab178de7e.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

strcmp(), memcpy(), memset(), as well as routines to copy to and from
other segments (as pointed to by fs and gs).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/copy.S   |  101 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/i386/boot/string.c |   34 ++++++++++++++++
 2 files changed, 135 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/copy.S
 create mode 100644 arch/i386/boot/string.c

diff --git a/arch/i386/boot/copy.S b/arch/i386/boot/copy.S
new file mode 100644
index 0000000..ef127e5
--- /dev/null
+++ b/arch/i386/boot/copy.S
@@ -0,0 +1,101 @@
+/* ----------------------------------------------------------------------- *
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
+ * arch/i386/boot/copy.S
+ *
+ * Memory copy routines
+ */
+
+	.code16gcc
+	.text
+
+	.globl	memcpy
+	.type	memcpy, @function
+memcpy:
+	pushw	%si
+	pushw	%di
+	movw	%ax, %di
+	movw	%dx, %si
+	pushw	%cx
+	shrw	$2, %cx
+	rep; movsl
+	popw	%cx
+	andw	$3, %cx
+	rep; movsb
+	popw	%di
+	popw	%si
+	ret
+	.size	memcpy, .-memcpy
+
+	.globl	memset
+	.type	memset, @function
+memset:
+	pushw	%di
+	movw	%ax, %di
+	movzbl	%dl, %eax
+	imull	$0x01010101,%eax
+	pushw	%cx
+	shrw	$2, %cx
+	rep; stosl
+	popw	%cx
+	andw	$3, %cx
+	rep; stosb
+	popw	%di
+	ret
+	.size	memset, .-memset
+
+	.globl	copy_from_fs
+	.type	copy_from_fs, @function
+copy_from_fs:
+	pushw	%ds
+	pushw	%fs
+	popw	%ds
+	call	memcpy
+	popw	%ds
+	ret
+	.size	copy_from_fs, .-copy_from_fs
+
+	.globl	copy_to_fs
+	.type	copy_to_fs, @function
+copy_to_fs:
+	pushw	%es
+	pushw	%fs
+	popw	%es
+	call	memcpy
+	popw	%es
+	ret
+	.size	copy_to_fs, .-copy_to_fs
+
+#if 0 /* Not currently used, but can be enabled as needed */
+
+	.globl	copy_from_gs
+	.type	copy_from_gs, @function
+copy_from_gs:
+	pushw	%ds
+	pushw	%gs
+	popw	%ds
+	call	memcpy
+	popw	%ds
+	ret
+	.size	copy_from_gs, .-copy_from_gs
+	.globl	copy_to_gs
+
+	.type	copy_to_gs, @function
+copy_to_gs:
+	pushw	%es
+	pushw	%gs
+	popw	%es
+	call	memcpy
+	popw	%es
+	ret
+	.size	copy_to_gs, .-copy_to_gs
+
+#endif
diff --git a/arch/i386/boot/string.c b/arch/i386/boot/string.c
new file mode 100644
index 0000000..0808197
--- /dev/null
+++ b/arch/i386/boot/string.c
@@ -0,0 +1,34 @@
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
+ * arch/i386/boot/string.c
+ *
+ * Very basic string functions
+ */
+
+#include "boot.h"
+#include <linux/edd.h>
+
+int strcmp(const char *str1, const char *str2)
+{
+	const unsigned char *s1 = (const unsigned char *)str1;
+	const unsigned char *s2 = (const unsigned char *)str2;
+	int delta = 0;
+
+	while (*s1 || *s2) {
+		delta = *s2 - *s1;
+		if (delta)
+			return delta;
+		s1++;
+		s2++;
+	}
+	return 0;
+}
-- 
1.5.2.2

