Return-Path: <linux-kernel-owner+w=401wt.eu-S1763342AbZEOQc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342AbZEOQc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZEOQcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:32:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50858 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbZEOQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:32:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/5] x86: convert termios.h to the asm-generic version
Date: Fri, 15 May 2009 18:32:09 +0200
Message-Id: <0fabca9c58df57af09754866f8eaed5d38051fb9.1242403836.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <cover.1242403836.git.arnd@arndb.de>
References: <cover.1242403836.git.arnd@arndb.de>
In-Reply-To: <cover.1242403836.git.arnd@arndb.de>
References: <cover.1242403836.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19q64u9PEaHx1lp7s2hRXhpWnulHEK9lLIhxS9
 KJOPu7UuARU853D1snR5FhCNPVRPkOO6iklHQPYB7D1ydQxXaA
 v1EfyAjDp/78PiQRy2SYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turned out more controversial than expected
and may get dropped in the future. I'm including it
for reference anyway.

The user_termio_to_kernel_termios and kernel_termios_to_user_termio
functions on x86 are lacking error checking from get_user and
are not portable to big-endian systems, so the asm-generic
header has to differ in this regard.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/include/asm/termios.h |   85 +++++++++++++++++++++++++++++----------
 1 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index f729563..d0922ad 100644
--- a/arch/x86/include/asm/termios.h
+++ b/arch/x86/include/asm/termios.h
@@ -1,5 +1,12 @@
-#ifndef _ASM_X86_TERMIOS_H
-#define _ASM_X86_TERMIOS_H
+#ifndef _ASM_GENERIC_TERMIOS_H
+#define _ASM_GENERIC_TERMIOS_H
+/*
+ * Most architectures have straight copies of the x86 code, with
+ * varying levels of bug fixes on top. Usually it's a good idea
+ * to use this generic version instead, but be careful to avoid
+ * ABI changes.
+ * New architectures should not provide their own version.
+ */
 
 #include <asm/termbits.h>
 #include <asm/ioctls.h>
@@ -54,36 +61,57 @@ struct termio {
 /*
  * Translate a "termio" structure into a "termios". Ugh.
  */
-#define SET_LOW_TERMIOS_BITS(termios, termio, x) { \
-	unsigned short __tmp; \
-	get_user(__tmp,&(termio)->x); \
-	*(unsigned short *) &(termios)->x = __tmp; \
-}
-
 static inline int user_termio_to_kernel_termios(struct ktermios *termios,
-						struct termio __user *termio)
+						const struct termio __user *termio)
 {
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
-	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
+	unsigned short tmp;
+
+	if (get_user(tmp, &termio->c_iflag) < 0)
+		goto fault;
+	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
+
+	if (get_user(tmp, &termio->c_oflag) < 0)
+		goto fault;
+	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
+
+	if (get_user(tmp, &termio->c_cflag) < 0)
+		goto fault;
+	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
+
+	if (get_user(tmp, &termio->c_lflag) < 0)
+		goto fault;
+	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
+
+	if (get_user(termios->c_line, &termio->c_line) < 0)
+		goto fault;
+
+	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
+		goto fault;
+
+	return 0;
+
+ fault:
+	return -EFAULT;
 }
 
 /*
  * Translate a "termios" structure into a "termio". Ugh.
  */
 static inline int kernel_termios_to_user_termio(struct termio __user *termio,
-					    struct ktermios *termios)
+						struct ktermios *termios)
 {
-	put_user((termios)->c_iflag, &(termio)->c_iflag);
-	put_user((termios)->c_oflag, &(termio)->c_oflag);
-	put_user((termios)->c_cflag, &(termio)->c_cflag);
-	put_user((termios)->c_lflag, &(termio)->c_lflag);
-	put_user((termios)->c_line,  &(termio)->c_line);
-	return copy_to_user((termio)->c_cc, (termios)->c_cc, NCC);
+	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
+	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
+	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
+	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
+	    put_user(termios->c_line,  &termio->c_line) < 0 ||
+	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
+		return -EFAULT;
+
+	return 0;
 }
 
+#ifdef TCGETS2
 static inline int user_termios_to_kernel_termios(struct ktermios *k,
 						 struct termios2 __user *u)
 {
@@ -107,7 +135,20 @@ static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
 {
 	return copy_to_user(u, k, sizeof(struct termios));
 }
+#else /* TCGETS2 */
+static inline int user_termios_to_kernel_termios(struct ktermios *k,
+						 struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
+
+static inline int kernel_termios_to_user_termios(struct termios __user *u,
+						 struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
+#endif /* TCGETS2 */
 
 #endif	/* __KERNEL__ */
 
-#endif /* _ASM_X86_TERMIOS_H */
+#endif /* _ASM_GENERIC_TERMIOS_H */
-- 
1.6.0.4

