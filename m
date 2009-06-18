Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZFRVoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZFRVoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbZFRVnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:43:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:34666 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851AbZFRVnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:43:52 -0400
Date: Thu, 18 Jun 2009 21:43:28 GMT
From: tip-bot for Arnd Bergmann <arnd@arndb.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <cover.1245354003.git.arnd@arndb.de>
References: <cover.1245354003.git.arnd@arndb.de>
Subject: [tip:x86/asm-generic] x86: convert termios.h to the asm-generic version
Message-ID: <tip-69d5ffdaad7b77b97229b55c36afb20e5bebd29e@git.kernel.org>
Git-Commit-ID: 69d5ffdaad7b77b97229b55c36afb20e5bebd29e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 21:43:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69d5ffdaad7b77b97229b55c36afb20e5bebd29e
Gitweb:     http://git.kernel.org/tip/69d5ffdaad7b77b97229b55c36afb20e5bebd29e
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Thu, 18 Jun 2009 21:48:19 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Jun 2009 14:39:58 -0700

x86: convert termios.h to the asm-generic version

This patch turned out more controversial than expected
and may get dropped in the future. I'm including it
for reference anyway.

The user_termio_to_kernel_termios and kernel_termios_to_user_termio
functions on x86 are lacking error checking from get_user and
are not portable to big-endian systems, so the asm-generic
header has to differ in this regard.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
LKML-Reference: <cover.1245354003.git.arnd@arndb.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/termios.h |   86 +++++++++++++++++++++++++++++-----------
 1 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index c4ee805..d0922ad 100644
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
@@ -54,37 +61,57 @@ struct termio {
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
-	get_user(termios->c_line, &termio->c_line);
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
@@ -108,7 +135,20 @@ static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
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
