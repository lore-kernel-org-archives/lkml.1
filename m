Return-Path: <linux-kernel-owner+w=401wt.eu-S1762053AbXHaWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762053AbXHaWXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbXHaWXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:23:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60009
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754812AbXHaWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:23:15 -0400
Date: Fri, 31 Aug 2007 15:23:15 -0700 (PDT)
Message-Id: <20070831.152315.39158142.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: Heads Up: Next Batch Of Serial/TTY Changes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070831231613.6b0fcdfd@the-village.bc.nu>
References: <20070831221105.2fce9023@the-village.bc.nu>
	<20070831.144115.48807246.davem@davemloft.net>
	<20070831231613.6b0fcdfd@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 31 Aug 2007 23:16:13 +0100

> I don't see a real problem. You aren't using
> 
> 	c_cflags & CBAUD = 0x00001000
> 
> so that could become BOTHER.
> 
> the input bits also appear to be reserved and free ?

Nevermind, I missed how you were doing the new termios2
struct.

I'm trying to wrap things up before jumping onto a plan early tomorrow
morning, but I still tried to whip together a patch and while mostly
straightforward I ran into a few problems.

n_tty_ioctl() for instance:

drivers/char/tty_ioctl.c:799: error: $,1rx(Bstruct termios$,1ry(B has no member named $,1rx(Bc_ispeed$,1ry(B

This is calling the copy interface that is supposed to be using
a termios2 when the new interfaces are defined, however:

		case TIOCGLCKTRMIOS:
			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
				return -EFAULT;
			return 0;

This is going to write over the end of the userspace
structure by a few bytes, and wasn't caught by you yet
because the i386 implementation is simply copy_to_user()
which does zero type checking.

Who knows what other gremlins like this now live in the tree :-)

There was a similar spot a few lines down, both fixed
as follows:

====================
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 3423e9e..4a8969c 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -796,14 +796,14 @@ int n_tty_ioctl(struct tty_struct * tty, struct file * file,
 				retval = inq_canon(tty);
 			return put_user(retval, (unsigned int __user *) arg);
 		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
+			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
 				return -EFAULT;
 			return 0;
 
 		case TIOCSLCKTRMIOS:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EPERM;
-			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
+			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
 				return -EFAULT;
 			return 0;
 
====================

And here is the sparc patch, could you please add it to
your serial queue?  Thanks Alan.

[SPARC]: Add support for arbitrary serial speeds.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/asm-sparc/ioctls.h b/include/asm-sparc/ioctls.h
index bdf77b0..058c206 100644
--- a/include/asm-sparc/ioctls.h
+++ b/include/asm-sparc/ioctls.h
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
diff --git a/include/asm-sparc/termbits.h b/include/asm-sparc/termbits.h
index 5eb00a1..90cf221 100644
--- a/include/asm-sparc/termbits.h
+++ b/include/asm-sparc/termbits.h
@@ -31,6 +31,18 @@ struct termios {
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
@@ -160,6 +172,7 @@ struct ktermios {
 #define CLOCAL	  0x00000800
 #define CBAUDEX   0x00001000
 /* We'll never see these speeds with the Zilogs, but for completeness... */
+#define  BOTHER   0x00001000
 #define  B57600   0x00001001
 #define  B115200  0x00001002
 #define  B230400  0x00001003
@@ -189,6 +202,8 @@ struct ktermios {
 #define CMSPAR	  0x40000000  /* mark or space (stick) parity */
 #define CRTSCTS	  0x80000000  /* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0x00000001
 #define ICANON	0x00000002
diff --git a/include/asm-sparc/termios.h b/include/asm-sparc/termios.h
index d767f20..ff16a8e 100644
--- a/include/asm-sparc/termios.h
+++ b/include/asm-sparc/termios.h
@@ -108,6 +108,48 @@ struct winsize {
 
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
@@ -124,7 +166,7 @@ struct winsize {
 	0; \
 })
 
-#define kernel_termios_to_user_termios(u, k) \
+#define kernel_termios_to_user_termios_1(u, k) \
 ({ \
 	put_user((k)->c_iflag, &(u)->c_iflag); \
 	put_user((k)->c_oflag, &(u)->c_oflag); \
diff --git a/include/asm-sparc64/ioctls.h b/include/asm-sparc64/ioctls.h
index 2223b6d..083c9a0 100644
--- a/include/asm-sparc64/ioctls.h
+++ b/include/asm-sparc64/ioctls.h
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
diff --git a/include/asm-sparc64/termbits.h b/include/asm-sparc64/termbits.h
index 705cd44..ebe31c1 100644
--- a/include/asm-sparc64/termbits.h
+++ b/include/asm-sparc64/termbits.h
@@ -5,8 +5,6 @@
 
 typedef unsigned char   cc_t;
 typedef unsigned int    speed_t;
-
-/* XXX is this right for sparc64?  it was an unsigned long... XXX */
 typedef unsigned int    tcflag_t;
 
 #define NCC 8
@@ -33,6 +31,18 @@ struct termios {
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
@@ -161,6 +171,7 @@ struct ktermios {
 #define HUPCL	  0x00000400
 #define CLOCAL	  0x00000800
 #define CBAUDEX   0x00001000
+#define  BOTHER   0x00001000
 #define  B57600   0x00001001
 #define  B115200  0x00001002
 #define  B230400  0x00001003
@@ -190,6 +201,8 @@ struct ktermios {
 #define CMSPAR    0x40000000  /* mark or space (stick) parity */
 #define CRTSCTS	  0x80000000  /* flow control */
 
+#define IBSHIFT	  16		/* Shift from CBAUD to CIBAUD */
+
 /* c_lflag bits */
 #define ISIG	0x00000001
 #define ICANON	0x00000002
diff --git a/include/asm-sparc64/termios.h b/include/asm-sparc64/termios.h
index f05d390..ef52721 100644
--- a/include/asm-sparc64/termios.h
+++ b/include/asm-sparc64/termios.h
@@ -123,6 +123,8 @@ struct winsize {
 		err |= get_user((k)->c_cc[VMIN],  &(u)->c_cc[_VMIN]); \
 		err |= get_user((k)->c_cc[VTIME], &(u)->c_cc[_VTIME]); \
 	} \
+	err |= get_user((k)->c_ispeed,  &(u)->c_ispeed); \
+	err |= get_user((k)->c_ospeed,  &(u)->c_ospeed); \
 	err; \
 })
 
@@ -142,6 +144,46 @@ struct winsize {
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
 
