Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXHOJzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXHOJzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761097AbXHOJuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:50:17 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:60865 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbXHOJt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:49:58 -0400
Message-Id: <20070815094850.616878278@mail.of.borg>
References: <20070815094539.181979221@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 15 Aug 2007 11:45:47 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: [patch 08/10] m68k: Enable arbitary speed tty support
Content-Disposition: inline; filename=m68k-arbitrary-speed-tty-support.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Add the needed constants and defines to activate the existing code. 

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/asm-m68k/ioctls.h   |    8 ++++++--
 include/asm-m68k/termbits.h |    5 ++++-
 include/asm-m68k/termios.h  |   10 ++++++++--
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/include/asm-m68k/ioctls.h
+++ b/include/asm-m68k/ioctls.h
@@ -46,8 +46,12 @@
 #define TIOCSBRK	0x5427  /* BSD compatibility */
 #define TIOCCBRK	0x5428  /* BSD compatibility */
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
-#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
-#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TCGETS2		_IOR('T', 0x2A, struct termios2)
+#define TCSETS2		_IOW('T', 0x2B, struct termios2)
+#define TCSETSW2	_IOW('T', 0x2C, struct termios2)
+#define TCSETSF2	_IOW('T', 0x2D, struct termios2)
+#define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
--- a/include/asm-m68k/termbits.h
+++ b/include/asm-m68k/termbits.h
@@ -141,6 +141,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
+#define    BOTHER 0010000
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -156,10 +157,12 @@ struct ktermios {
 #define  B3000000 0010015
 #define  B3500000 0010016
 #define  B4000000 0010017
-#define CIBAUD	  002003600000	/* input baud rate (not used) */
+#define CIBAUD	  002003600000		/* input baud rate */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
+#define IBSHIFT	16			/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0000001
 #define ICANON	0000002
--- a/include/asm-m68k/termios.h
+++ b/include/asm-m68k/termios.h
@@ -82,8 +82,14 @@ struct termio {
 	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
 })
 
-#define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios(k, u)	\
+	copy_from_user(k, u, sizeof(struct termios2))
+#define kernel_termios_to_user_termios(u, k)	\
+	copy_to_user(u, k, sizeof(struct termios2))
+#define user_termios_to_kernel_termios_1(k, u)	\
+	copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k)	\
+	copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

