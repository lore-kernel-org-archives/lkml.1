Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbXCHPp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbXCHPp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXCHPp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:45:56 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60693 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbXCHPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:45:55 -0500
Date: Thu, 8 Mar 2007 16:49:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Revised diff for the i386/x86_64 arbitary speed
 support
Message-ID: <20070308164944.14137e6c@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some more test cases found a bug in the definition of IBSHIFT. At
the moment we have no hardware support for split baud rates but this
showed up once I did testing of that...

Replaces the previous diff.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/include/asm-i386/ioctls.h linux-2.6.21-rc2-mm2/include/asm-i386/ioctls.h
--- linux.vanilla-2.6.21-rc2-mm2/include/asm-i386/ioctls.h	2007-03-06 23:06:31.000000000 +0000
+++ linux-2.6.21-rc2-mm2/include/asm-i386/ioctls.h	2007-03-08 16:39:26.000000000 +0000
@@ -47,6 +47,10 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/include/asm-i386/termbits.h linux-2.6.21-rc2-mm2/include/asm-i386/termbits.h
--- linux.vanilla-2.6.21-rc2-mm2/include/asm-i386/termbits.h	2007-03-06 23:06:31.000000000 +0000
+++ linux-2.6.21-rc2-mm2/include/asm-i386/termbits.h	2007-03-08 16:38:55.000000000 +0000
@@ -17,6 +17,17 @@
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
@@ -129,6 +140,7 @@
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define   BOTHER  0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -148,6 +160,8 @@
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/include/asm-i386/termios.h linux-2.6.21-rc2-mm2/include/asm-i386/termios.h
--- linux.vanilla-2.6.21-rc2-mm2/include/asm-i386/termios.h	2007-03-06 23:06:31.000000000 +0000
+++ linux-2.6.21-rc2-mm2/include/asm-i386/termios.h	2007-03-06 17:00:58.000000000 +0000
@@ -81,8 +81,10 @@
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/include/asm-x86_64/termbits.h linux-2.6.21-rc2-mm2/include/asm-x86_64/termbits.h
--- linux.vanilla-2.6.21-rc2-mm2/include/asm-x86_64/termbits.h	2007-03-06 23:06:37.000000000 +0000
+++ linux-2.6.21-rc2-mm2/include/asm-x86_64/termbits.h	2007-03-08 16:39:06.000000000 +0000
@@ -160,7 +160,7 @@
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
-#define IBSHIFT	  8		/* Shift from CBAUD to CIBAUD */
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
 
 /* c_lflag bits */
 #define ISIG	0000001
