Return-Path: <linux-kernel-owner+w=401wt.eu-S1764295AbZFLK5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764295AbZFLK5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZFLK46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:56:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42903 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZFLK45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:56:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] Blackfin: sync termios header changes with x86
Date: Fri, 12 Jun 2009 06:56:42 -0400
Message-Id: <1244804202-17030-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <200906121247.50745.arnd@arndb.de>
References: <200906121247.50745.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin port copied the x86 termios interface, so pull updates from
it to get the latest termios ioctls and such.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
Arnd: if you don't mind, i'd rather merge this ... i can put it into my
next batch of Blackfin changes for 2.6.31

 arch/blackfin/include/asm/ioctls.h   |   35 ++++++++------
 arch/blackfin/include/asm/termbits.h |   54 +++++++++++-----------
 arch/blackfin/include/asm/termios.h  |   86 +++++++++++++++++++++-------------
 3 files changed, 101 insertions(+), 74 deletions(-)

diff --git a/arch/blackfin/include/asm/ioctls.h b/arch/blackfin/include/asm/ioctls.h
index 895e317..e22c400 100644
--- a/arch/blackfin/include/asm/ioctls.h
+++ b/arch/blackfin/include/asm/ioctls.h
@@ -6,7 +6,7 @@
 /* 0x54 is just a magic number to make these relatively unique ('T') */
 
 #define TCGETS		0x5401
-#define TCSETS		0x5402
+#define TCSETS		0x5402 /* Clashes with SNDCTL_TMR_START sound ioctl */
 #define TCSETSW		0x5403
 #define TCSETSF		0x5404
 #define TCGETA		0x5405
@@ -43,19 +43,25 @@
 #define TIOCSETD	0x5423
 #define TIOCGETD	0x5424
 #define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
-#define TIOCTTYGSTRUCT	0x5426	/* For debugging only */
-#define TIOCSBRK	0x5427	/* BSD compatibility */
-#define TIOCCBRK	0x5428	/* BSD compatibility */
-#define TIOCGSID	0x5429	/* Return the session ID of FD */
+/* #define TIOCTTYGSTRUCT 0x5426 - Former debugging-only ioctl */
+#define TIOCSBRK	0x5427  /* BSD compatibility */
+#define TIOCCBRK	0x5428  /* BSD compatibility */
+#define TIOCGSID	0x5429  /* Return the session ID of FD */
 #define TCGETS2		_IOR('T', 0x2A, struct termios2)
 #define TCSETS2		_IOW('T', 0x2B, struct termios2)
 #define TCSETSW2	_IOW('T', 0x2C, struct termios2)
 #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
-/* Get Pty Number (of pty-mux device) */
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int)
-#define TIOCSPTLCK	_IOW('T', 0x31, int)	/* Lock/unlock Pty */
+				/* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
+#define TCSETX		0x5433
+#define TCSETXF		0x5434
+#define TCSETXW		0x5435
 
-#define FIONCLEX	0x5450	/* these numbers need to be adjusted. */
+#define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
 #define FIOASYNC	0x5452
 #define TIOCSERCONFIG	0x5453
@@ -63,15 +69,16 @@
 #define TIOCSERSWILD	0x5455
 #define TIOCGLCKTRMIOS	0x5456
 #define TIOCSLCKTRMIOS	0x5457
-#define TIOCSERGSTRUCT	0x5458	/* For debugging only */
-#define TIOCSERGETLSR   0x5459	/* Get line status register */
-#define TIOCSERGETMULTI 0x545A	/* Get multiport config  */
-#define TIOCSERSETMULTI 0x545B	/* Set multiport config */
+#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
+#define TIOCSERGETLSR   0x5459 /* Get line status register */
+#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
+#define TIOCSERSETMULTI 0x545B /* Set multiport config */
 
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-
-#define FIOQSIZE	0x545E
+#define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
+#define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
+#define FIOQSIZE	0x5460
 
 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
diff --git a/arch/blackfin/include/asm/termbits.h b/arch/blackfin/include/asm/termbits.h
index f37feb7..faa569f 100644
--- a/arch/blackfin/include/asm/termbits.h
+++ b/arch/blackfin/include/asm/termbits.h
@@ -3,40 +3,40 @@
 
 #include <linux/posix_types.h>
 
-typedef unsigned char cc_t;
-typedef unsigned int speed_t;
-typedef unsigned int tcflag_t;
+typedef unsigned char	cc_t;
+typedef unsigned int	speed_t;
+typedef unsigned int	tcflag_t;
 
 #define NCCS 19
 struct termios {
-	tcflag_t c_iflag;	/* input mode flags */
-	tcflag_t c_oflag;	/* output mode flags */
-	tcflag_t c_cflag;	/* control mode flags */
-	tcflag_t c_lflag;	/* local mode flags */
-	cc_t c_line;		/* line discipline */
-	cc_t c_cc[NCCS];	/* control characters */
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
 };
 
 struct termios2 {
-	tcflag_t c_iflag;               /* input mode flags */
-	tcflag_t c_oflag;               /* output mode flags */
-	tcflag_t c_cflag;               /* control mode flags */
-	tcflag_t c_lflag;               /* local mode flags */
-	cc_t c_line;                    /* line discipline */
-	cc_t c_cc[NCCS];                /* control characters */
-	speed_t c_ispeed;               /* input speed */
-	speed_t c_ospeed;               /* output speed */
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
 };
 
 struct ktermios {
-	tcflag_t c_iflag;               /* input mode flags */
-	tcflag_t c_oflag;               /* output mode flags */
-	tcflag_t c_cflag;               /* control mode flags */
-	tcflag_t c_lflag;               /* local mode flags */
-	cc_t c_line;                    /* line discipline */
-	cc_t c_cc[NCCS];                /* control characters */
-	speed_t c_ispeed;               /* input speed */
-	speed_t c_ospeed;               /* output speed */
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
 };
 
 /* c_cc characters */
@@ -140,7 +140,7 @@ struct ktermios {
 #define HUPCL	0002000
 #define CLOCAL	0004000
 #define CBAUDEX 0010000
-#define BOTHER	0010000
+#define	   BOTHER 0010000		/* non standard rate */
 #define    B57600 0010001
 #define   B115200 0010002
 #define   B230400 0010003
@@ -160,7 +160,7 @@ struct ktermios {
 #define CMSPAR	  010000000000	/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000	/* flow control */
 
-#define IBSHIFT	16	/* Shift from CBAUD to CIBAUD */
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
 
 /* c_lflag bits */
 #define ISIG	0000001
diff --git a/arch/blackfin/include/asm/termios.h b/arch/blackfin/include/asm/termios.h
index d50d063..a5f2f13 100644
--- a/arch/blackfin/include/asm/termios.h
+++ b/arch/blackfin/include/asm/termios.h
@@ -13,11 +13,11 @@ struct winsize {
 
 #define NCC 8
 struct termio {
-	unsigned short c_iflag;	/* input mode flags */
-	unsigned short c_oflag;	/* output mode flags */
-	unsigned short c_cflag;	/* control mode flags */
-	unsigned short c_lflag;	/* local mode flags */
-	unsigned char c_line;	/* line discipline */
+	unsigned short c_iflag;		/* input mode flags */
+	unsigned short c_oflag;		/* output mode flags */
+	unsigned short c_cflag;		/* control mode flags */
+	unsigned short c_lflag;		/* local mode flags */
+	unsigned char c_line;		/* line discipline */
 	unsigned char c_cc[NCC];	/* control characters */
 };
 
@@ -41,6 +41,8 @@ struct termio {
 
 #ifdef __KERNEL__
 
+#include <asm/uaccess.h>
+
 /*	intr=^C		quit=^\		erase=del	kill=^U
 	eof=^D		vtime=\0	vmin=\1		sxtc=\0
 	start=^Q	stop=^S		susp=^Z		eol=\0
@@ -58,37 +60,55 @@ struct termio {
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
+	get_user(termios->c_line, &termio->c_line);
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
-#define kernel_termios_to_user_termios(u, k) \
-	copy_to_user(u, k, sizeof(struct termios2))
-#define user_termios_to_kernel_termios_1(k, u) \
-	copy_from_user(k, u, sizeof(struct termios))
-#define kernel_termios_to_user_termios_1(u, k) \
-	copy_to_user(u, k, sizeof(struct termios))
-
-#endif				/* __KERNEL__ */
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
+
+static inline int kernel_termios_to_user_termios(struct termios2 __user *u,
+						 struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios2));
+}
+
+static inline int user_termios_to_kernel_termios_1(struct ktermios *k,
+						   struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
+
+static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
+						   struct ktermios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
+
+#endif	/* __KERNEL__ */
 
 #endif				/* __BFIN_TERMIOS_H__ */
-- 
1.6.3.1

