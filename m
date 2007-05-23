Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbXEWQu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbXEWQu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbXEWQuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:50:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59629 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758315AbXEWQuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:50:12 -0400
Date: Wed, 23 May 2007 17:55:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: chris@zankel.net, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Xtensa: Enable arbitary tty speed setting ioctls
Message-ID: <20070523175502.2ca3dc07@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the defines/constants activates the existing code in the tty layer
and allows arbitary tty speeds to be requested on this platform

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/ioctls.h linux-2.6.22-rc1-mm1/include/asm-xtensa/ioctls.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/ioctls.h	2007-04-30 10:48:19.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-xtensa/ioctls.h	2007-05-23 16:47:53.890712656 +0100
@@ -91,6 +91,10 @@
 #define TIOCSBRK	_IO('T', 39) 	     /* BSD compatibility */
 #define TIOCCBRK	_IO('T', 40)	     /* BSD compatibility */
 #define TIOCGSID	_IOR('T', 41, pid_t) /* Return the session ID of FD*/
+#define TCGETS2		_IOR('T', 42, struct termios2)
+#define TCSETS2		_IOW('T', 43, struct termios2)
+#define TCSETSW2	_IOW('T', 44, struct termios2)
+#define TCSETSF2	_IOW('T', 45, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h linux-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h	2007-04-30 10:48:19.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h	2007-05-23 16:46:59.730946192 +0100
@@ -146,6 +146,7 @@
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define	   BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -161,10 +162,12 @@
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 
 #define ISIG	0000001
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/termios.h linux-2.6.22-rc1-mm1/include/asm-xtensa/termios.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/termios.h	2007-04-30 11:00:09.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-xtensa/termios.h	2007-05-23 16:47:24.030252136 +0100
@@ -95,8 +95,10 @@
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 
