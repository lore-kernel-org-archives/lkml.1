Return-Path: <linux-kernel-owner+w=401wt.eu-S933233AbXGKT22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233AbXGKT22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 15:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765446AbXGKTTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 15:19:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762307AbXGKTTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 15:19:35 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 19/33] Command-line parsing code for the new x86 setup code
Date: Wed, 11 Jul 2007 12:18:44 -0700
Message-Id: <11841815412175-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841815412873-git-send-email-hpa@zytor.com>
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
Message-Id: <f0db7b1f909cdf2dd895c5c44273dd46ffb5addc.1184181208.git.hpa@zytor.com>
In-Reply-To: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
References: <7aca4ce0a222438c94300a2ea535270a21db8812.1184181208.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Simple command-line parser which allows us to access the kernel command
line from the setup code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/cmdline.c |   97 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 97 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/cmdline.c

diff --git a/arch/i386/boot/cmdline.c b/arch/i386/boot/cmdline.c
new file mode 100644
index 0000000..34bb778
--- /dev/null
+++ b/arch/i386/boot/cmdline.c
@@ -0,0 +1,97 @@
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
+ * arch/i386/boot/cmdline.c
+ *
+ * Simple command-line parser for early boot.
+ */
+
+#include "boot.h"
+
+static inline int myisspace(u8 c)
+{
+	return c <= ' ';	/* Close enough approximation */
+}
+
+/*
+ * Find a non-boolean option, that is, "option=argument".  In accordance
+ * with standard Linux practice, if this option is repeated, this returns
+ * the last instance on the command line.
+ *
+ * Returns the length of the argument (regardless of if it was
+ * truncated to fit in the buffer), or -1 on not found.
+ */
+int cmdline_find_option(const char *option, char *buffer, int bufsize)
+{
+	u32 cmdline_ptr = boot_params.hdr.cmd_line_ptr;
+	addr_t cptr;
+	char c;
+	int len = -1;
+	const char *opptr = NULL;
+	char *bufptr = buffer;
+	enum {
+		st_wordstart,	/* Start of word/after whitespace */
+		st_wordcmp,	/* Comparing this word */
+		st_wordskip,	/* Miscompare, skip */
+		st_bufcpy	/* Copying this to buffer */
+	} state = st_wordstart;
+
+	if (!cmdline_ptr || cmdline_ptr >= 0x100000)
+		return -1;	/* No command line, or inaccessible */
+
+	cptr = cmdline_ptr & 0xf;
+	set_fs(cmdline_ptr >> 4);
+
+	while (cptr < 0x10000 && (c = rdfs8(cptr++))) {
+		switch (state) {
+		case st_wordstart:
+			if (myisspace(c))
+				break;
+
+			/* else */
+			state = st_wordcmp;
+			opptr = option;
+			/* fall through */
+
+		case st_wordcmp:
+			if (c == '=' && !*opptr) {
+				len = 0;
+				bufptr = buffer;
+				state = st_bufcpy;
+			} else if (myisspace(c)) {
+				state = st_wordstart;
+			} else if (c != *opptr++) {
+				state = st_wordskip;
+			}
+			break;
+
+		case st_wordskip:
+			if (myisspace(c))
+				state = st_wordstart;
+			break;
+
+		case st_bufcpy:
+			if (myisspace(c)) {
+				state = st_wordstart;
+			} else {
+				if (len < bufsize-1)
+					*bufptr++ = c;
+				len++;
+			}
+			break;
+		}
+	}
+
+	if (bufsize)
+		*bufptr = '\0';
+
+	return len;
+}
-- 
1.5.2.2

