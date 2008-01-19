Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbYASQHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbYASQHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761119AbYASQGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:06:52 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50062 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759611AbYASQGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:06:52 -0500
Date: Sat, 19 Jan 2008 16:05:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH][RESEND] sh: termios ioctl definitions
Message-ID: <20080119160506.5aab8000@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These ports are holding up progress and now have been for months. Do the
job for them.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/include/asm-sh/ioctls.h linux-2.6.24-rc8-mm1/include/asm-sh/ioctls.h
--- linux.vanilla-2.6.24-rc8-mm1/include/asm-sh/ioctls.h	2008-01-19 14:19:51.000000000 +0000
+++ linux-2.6.24-rc8-mm1/include/asm-sh/ioctls.h	2008-01-19 15:07:16.000000000 +0000
@@ -78,6 +78,10 @@
 #define TIOCSBRK	_IO('T', 39) /* 0x5427 */ /* BSD compatibility */
 #define TIOCCBRK	_IO('T', 40) /* 0x5428 */ /* BSD compatibility */
 #define TIOCGSID	_IOR('T', 41, pid_t) /* 0x5429 */ /* Return the session ID of FD */
+#define TCGETS2		_IOR('T', 42, struct termios2)
+#define TCSETS2		_IOW('T', 43, struct termios2)
+#define TCSETSW2	_IOW('T', 44, struct termios2)
+#define TCSETSF2	_IOW('T', 45, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/include/asm-sh/termbits.h linux-2.6.24-rc8-mm1/include/asm-sh/termbits.h
--- linux.vanilla-2.6.24-rc8-mm1/include/asm-sh/termbits.h	2008-01-19 14:19:51.000000000 +0000
+++ linux-2.6.24-rc8-mm1/include/asm-sh/termbits.h	2008-01-19 15:07:16.000000000 +0000
@@ -140,6 +140,7 @@
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define	   BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -155,10 +156,12 @@
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
 #define ICANON	0000002
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/include/asm-sh/termios.h linux-2.6.24-rc8-mm1/include/asm-sh/termios.h
--- linux.vanilla-2.6.24-rc8-mm1/include/asm-sh/termios.h	2008-01-19 14:19:51.000000000 +0000
+++ linux-2.6.24-rc8-mm1/include/asm-sh/termios.h	2008-01-19 15:07:16.000000000 +0000
@@ -80,8 +80,10 @@
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 
