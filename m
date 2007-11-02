Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbXKBP7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbXKBP7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXKBP7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:59:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32796 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753907AbXKBP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:59:38 -0400
Date: Fri, 2 Nov 2007 16:00:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tty - fix tty network driver interactions with
 TCGET/TCSET calls
Message-ID: <20071102160039.55df8c26@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Miller <davem@davemloft.net>

And to go with it Dave's type checking x86 termios headers. I've updated these as the original sent by Dave had some wrong types in it.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/include/asm-x86/termios.h linux-2.6.24-rc1/include/asm-x86/termios.h
--- linux.vanilla-2.6.24-rc1/include/asm-x86/termios.h	2007-11-01 11:42:08.000000000 +0000
+++ linux-2.6.24-rc1/include/asm-x86/termios.h	2007-11-02 12:41:44.635869768 +0000
@@ -41,6 +41,8 @@
 
 #ifdef __KERNEL__
 
+#include <asm/uaccess.h>
+
 /*	intr=^C		quit=^\		erase=del	kill=^U
 	eof=^D		vtime=\0	vmin=\1		sxtc=\0
 	start=^Q	stop=^S		susp=^Z		eol=\0
@@ -58,39 +60,53 @@
 	*(unsigned short *) &(termios)->x = __tmp; \
 }
 
-#define user_termio_to_kernel_termios(termios, termio) \
-({ \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
-	copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
-})
+static inline int user_termio_to_kernel_termios(struct ktermios *termios,
+						struct termio __user *termio)
+{
+	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
+	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
+}
 
 /*
  * Translate a "termios" structure into a "termio". Ugh.
  */
-#define kernel_termios_to_user_termio(termio, termios) \
-({ \
-	put_user((termios)->c_iflag, &(termio)->c_iflag); \
-	put_user((termios)->c_oflag, &(termio)->c_oflag); \
-	put_user((termios)->c_cflag, &(termio)->c_cflag); \
-	put_user((termios)->c_lflag, &(termio)->c_lflag); \
-	put_user((termios)->c_line,  &(termio)->c_line); \
-	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
-})
-
-#define user_termios_to_kernel_termios(k, u) \
-	copy_from_user(k, u, sizeof(struct termios2))
+static inline int kernel_termios_to_user_termio(struct termio __user *termio,
+					    struct ktermios *termios)
+{
+	put_user((termios)->c_iflag, &(termio)->c_iflag);
+	put_user((termios)->c_oflag, &(termio)->c_oflag);
+	put_user((termios)->c_cflag, &(termio)->c_cflag);
+	put_user((termios)->c_lflag, &(termio)->c_lflag);
+	put_user((termios)->c_line,  &(termio)->c_line);
+	return copy_to_user((termio)->c_cc, (termios)->c_cc, NCC);
+}
+
+static inline int user_termios_to_kernel_termios(struct ktermios *k,
+						 struct termios2 __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios2));
+}
 
-#define kernel_termios_to_user_termios(u, k) \
-	copy_to_user(u, k, sizeof(struct termios2))
+static inline int kernel_termios_to_user_termios(struct termios2 __user *u,
+						 struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios2));
+}
 
-#define user_termios_to_kernel_termios_1(k, u) \
-	copy_from_user(k, u, sizeof(struct termios))
+static inline int user_termios_to_kernel_termios_1(struct ktermios *k,
+						   struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
 
-#define kernel_termios_to_user_termios_1(u, k) \
-	copy_to_user(u, k, sizeof(struct termios))
+static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
+						   struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
 
 #endif	/* __KERNEL__ */
 
