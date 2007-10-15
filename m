Return-Path: <linux-kernel-owner+w=401wt.eu-S934485AbXJOUJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485AbXJOUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbXJOUJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:09:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55355 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755047AbXJOUJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:09:45 -0400
Date: Mon, 15 Oct 2007 21:13:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] sparc support for new termios
Message-ID: <20071015211312.21d0e3cd@the-village.bc.nu>
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
Signed-off-by: David Miller <davem@davemloft.net>
Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/include/asm-sparc/ioctls.h linux-2.6.23-mm1/include/asm-sparc/ioctls.h
--- linux.vanilla-2.6.23-mm1/include/asm-sparc/ioctls.h	2007-10-15 15:01:58.000000000 +0100
+++ linux-2.6.23-mm1/include/asm-sparc/ioctls.h	2007-10-15 15:26:51.000000000 +0100
@@ -15,6 +15,10 @@
 #define TCSETS		_IOW('T', 9, struct termios)
 #define TCSETSW		_IOW('T', 10, struct termios)
 #define TCSETSF		_IOW('T', 11, struct termios)
+#define TCGETS2		_IOR('T', 12, struct termios2)
+#define TCSETS2		_IOW('T', 13, struct termios2)
+#define TCSETSW2	_IOW('T', 14, struct termios2)
+#define TCSETSF2	_IOW('T', 15, struct termios2)
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/include/asm-sparc/termbits.h linux-2.6.23-mm1/include/asm-sparc/termbits.h
--- linux.vanilla-2.6.23-mm1/include/asm-sparc/termbits.h	2007-10-15 15:01:58.000000000 +0100
+++ linux-2.6.23-mm1/include/asm-sparc/termbits.h	2007-10-15 15:26:51.000000000 +0100
@@ -31,6 +31,18 @@
 #endif
 };
 
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t _x_cc[2];                  /* padding to match ktermios */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
@@ -160,6 +172,7 @@
 #define CLOCAL	  0x00000800
 #define CBAUDEX   0x00001000
 /* We'll never see these speeds with the Zilogs, but for completeness... */
+#define  BOTHER   0x00001000
 #define  B57600   0x00001001
 #define  B115200  0x00001002
 #define  B230400  0x00001003
@@ -189,6 +202,8 @@
 #define CMSPAR	  0x40000000  /* mark or space (stick) parity */
 #define CRTSCTS	  0x80000000  /* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0x00000001
 #define ICANON	0x00000002
diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/include/asm-sparc/termios.h linux-2.6.23-mm1/include/asm-sparc/termios.h
--- linux.vanilla-2.6.23-mm1/include/asm-sparc/termios.h	2007-10-15 15:03:38.000000000 +0100
+++ linux-2.6.23-mm1/include/asm-sparc/termios.h	2007-10-15 15:26:59.000000000 +0100
@@ -108,6 +108,48 @@
 
 #define user_termios_to_kernel_termios(k, u) \
 ({ \
+	int err; \
+	err  = get_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= get_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= get_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= get_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= get_user((k)->c_line,  &(u)->c_line); \
+	err |= copy_from_user((k)->c_cc, (u)->c_cc, NCCS); \
+	if((k)->c_lflag & ICANON) { \
+		err |= get_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= get_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} else { \
+		err |= get_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= get_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} \
+	err |= get_user((k)->c_ispeed,  &(u)->c_ispeed); \
+	err |= get_user((k)->c_ospeed,  &(u)->c_ospeed); \
+	err; \
+})
+
+#define kernel_termios_to_user_termios(u, k) \
+({ \
+	int err; \
+	err  = put_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= put_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= put_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= put_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= put_user((k)->c_line, &(u)->c_line); \
+	err |= copy_to_user((u)->c_cc, (k)->c_cc, NCCS); \
+	if(!((k)->c_lflag & ICANON)) { \
+		err |= put_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= put_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} else { \
+		err |= put_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= put_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} \
+	err |= put_user((k)->c_ispeed, &(u)->c_ispeed); \
+	err |= put_user((k)->c_ospeed, &(u)->c_ospeed); \
+	err; \
+})
+
+#define user_termios_to_kernel_termios_1(k, u) \
+({ \
 	get_user((k)->c_iflag, &(u)->c_iflag); \
 	get_user((k)->c_oflag, &(u)->c_oflag); \
 	get_user((k)->c_cflag, &(u)->c_cflag); \
@@ -124,7 +166,7 @@
 	0; \
 })
 
-#define kernel_termios_to_user_termios(u, k) \
+#define kernel_termios_to_user_termios_1(u, k) \
 ({ \
 	put_user((k)->c_iflag, &(u)->c_iflag); \
 	put_user((k)->c_oflag, &(u)->c_oflag); \
diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/include/asm-sparc64/ioctls.h linux-2.6.23-mm1/include/asm-sparc64/ioctls.h
--- linux.vanilla-2.6.23-mm1/include/asm-sparc64/ioctls.h	2007-10-15 15:01:58.000000000 +0100
+++ linux-2.6.23-mm1/include/asm-sparc64/ioctls.h	2007-10-15 15:26:59.000000000 +0100
@@ -16,6 +16,10 @@
 #define TCSETS		_IOW('T', 9, struct termios)
 #define TCSETSW		_IOW('T', 10, struct termios)
 #define TCSETSF		_IOW('T', 11, struct termios)
+#define TCGETS2		_IOR('T', 12, struct termios2)
+#define TCSETS2		_IOW('T', 13, struct termios2)
+#define TCSETSW2	_IOW('T', 14, struct termios2)
+#define TCSETSF2	_IOW('T', 15, struct termios2)
 
 /* Note that all the ioctls that are not available in Linux have a 
  * double underscore on the front to: a) avoid some programs to
diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/include/asm-sparc64/termbits.h linux-2.6.23-mm1/include/asm-sparc64/termbits.h
--- linux.vanilla-2.6.23-mm1/include/asm-sparc64/termbits.h	2007-10-15 15:01:59.000000000 +0100
+++ linux-2.6.23-mm1/include/asm-sparc64/termbits.h	2007-10-15 15:26:59.000000000 +0100
@@ -5,8 +5,6 @@
 
 typedef unsigned char   cc_t;
 typedef unsigned int    speed_t;
-
-/* XXX is this right for sparc64?  it was an unsigned long... XXX */
 typedef unsigned int    tcflag_t;
 
 #define NCC 8
@@ -33,6 +31,18 @@
 #endif
 };
 
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t _x_cc[2];                  /* padding to match ktermios */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
@@ -161,6 +171,7 @@
 #define HUPCL	  0x00000400
 #define CLOCAL	  0x00000800
 #define CBAUDEX   0x00001000
+#define  BOTHER   0x00001000
 #define  B57600   0x00001001
 #define  B115200  0x00001002
 #define  B230400  0x00001003
@@ -190,6 +201,8 @@
 #define CMSPAR    0x40000000  /* mark or space (stick) parity */
 #define CRTSCTS	  0x80000000  /* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0x00000001
 #define ICANON	0x00000002
diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/include/asm-sparc64/termios.h linux-2.6.23-mm1/include/asm-sparc64/termios.h
--- linux.vanilla-2.6.23-mm1/include/asm-sparc64/termios.h	2007-10-15 15:03:38.000000000 +0100
+++ linux-2.6.23-mm1/include/asm-sparc64/termios.h	2007-10-15 15:26:59.000000000 +0100
@@ -123,6 +123,8 @@
 		err |= get_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
 		err |= get_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
 	} \
+	err |= get_user((k)->c_ispeed,  &(u)->c_ispeed); \
+	err |= get_user((k)->c_ospeed,  &(u)->c_ospeed); \
 	err; \
 })
 
@@ -142,6 +144,46 @@
 		err |= put_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
 		err |= put_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
 	} \
+	err |= put_user((k)->c_ispeed, &(u)->c_ispeed); \
+	err |= put_user((k)->c_ospeed, &(u)->c_ospeed); \
+	err; \
+})
+
+#define user_termios_to_kernel_termios_1(k, u) \
+({ \
+	int err; \
+	err  = get_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= get_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= get_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= get_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= get_user((k)->c_line,  &(u)->c_line); \
+	err |= copy_from_user((k)->c_cc, (u)->c_cc, NCCS); \
+	if((k)->c_lflag & ICANON) { \
+		err |= get_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= get_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} else { \
+		err |= get_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= get_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} \
+	err; \
+})
+
+#define kernel_termios_to_user_termios_1(u, k) \
+({ \
+	int err; \
+	err  = put_user((k)->c_iflag, &(u)->c_iflag); \
+	err |= put_user((k)->c_oflag, &(u)->c_oflag); \
+	err |= put_user((k)->c_cflag, &(u)->c_cflag); \
+	err |= put_user((k)->c_lflag, &(u)->c_lflag); \
+	err |= put_user((k)->c_line, &(u)->c_line); \
+	err |= copy_to_user((u)->c_cc, (k)->c_cc, NCCS); \
+	if(!((k)->c_lflag & ICANON)) { \
+		err |= put_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
+		err |= put_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
+	} else { \
+		err |= put_user((k)->c_cc[VEOF], &(u)->c_cc[VEOF]); \
+		err |= put_user((k)->c_cc[VEOL], &(u)->c_cc[VEOL]); \
+	} \
 	err; \
 })
 
