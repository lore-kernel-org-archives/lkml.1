Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbXGKTY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbXGKTY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbXGKTTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbXGKTTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:30 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 16/33] String-handling functions for the new x86 setup code.
Date: Wed, 11 Jul 2007 12:18:41 -0700
Message-Id: <1184181541746-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815411443-git-send-email-hpa@zytor.com>
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
Message-Id: <8697ab9d1471721ca1c40a2224191d276c78ea0e.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

strcmp(), memcpy(), memset(), as well as routines to copy to and from
other segments (as pointed to by fs and gs).

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/copy.S   |  101 +++++++++++++++++++++++++++++++++++++++++++++++
 arch/i386/boot/string.c |   52 ++++++++++++++++++++++++
 2 files changed, 153 insertions(+), 0 deletions(-)
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
index 0000000..481a220
--- /dev/null
+++ b/arch/i386/boot/string.c
@@ -0,0 +1,52 @@
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
+
+size_t strnlen(const char *s, size_t maxlen)
+{
+	const char *es = s;
+	while (*es && maxlen) {
+		es++;
+		maxlen--;
+	}
+
+	return (es - s);
+}
+
+unsigned int atou(const char *s)
+{
+	unsigned int i = 0;
+	while (isdigit(*s))
+		i = i * 10 + (*s++ - '0');
+	return i;
+}
-- 
1.5.2.2

