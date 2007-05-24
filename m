Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXEXNI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXEXNI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXEXNIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:08:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38759 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbXEXNIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:08:48 -0400
Subject: Re: [PATCH] $ARCH: Enable arbitary speed tty ioctls and split
	input/output speed
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
In-Reply-To: <20070523172739.1d3a918c@the-village.bc.nu>
References: <20070523172739.1d3a918c@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 24 May 2007 09:08:55 -0400
Message-Id: <1180012135.8303.89.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is my mailbox (or brain) failing me, or did you just send out these
patches for every architecture _except_ PowerPC? :)

Presumably this is because of the mess in tty_termios_encode_baud_rate
when we fix its bogus assumptions about IBSHIFT always being defined?
There has to be a cleaner way to do that than this, but it shows the
problem...

diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index fd471cb..f5f4568 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -215,6 +215,11 @@ speed_t tty_termios_input_baud_rate(struct ktermios *termios)
 	}
 	return baud_table[cbaud];
 #else
+#ifdef BOTHER
+	/* Magic token for arbitary speed via c_ispeed/c_ospeed */
+	if ((termios->c_cflag & CBAUD) == BOTHER)
+		return termios->c_ispeed;
+#endif
 	return tty_termios_baud_rate(termios);
 #endif
 }
@@ -252,16 +257,27 @@ void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed
 	termios->c_ispeed = ibaud;
 	termios->c_ospeed = obaud;
 
+#ifndef IBSHIFT
+	/* If the only way to express differing input and output baud rates
+	   is to use BOTHER, then that's what we have to do... */
+	if (ibaud != obaud) {
+		termios->c_cflag |= BOTHER;
+		return;
+	}
+#endif
+
 	/* If the user asked for a precise weird speed give a precise weird
 	   answer. If they asked for a Bfoo speed they many have problems
 	   digesting non-exact replies so fuzz a bit */
 
 	if ((termios->c_cflag & CBAUD) == BOTHER)
 		oclose = 0;
+#ifdef IBSHIFT
 	if (((termios->c_cflag >> IBSHIFT) & CBAUD) == BOTHER)
 		iclose = 0;
 	if ((termios->c_cflag >> IBSHIFT) & CBAUD)
 		ibinput = 1;	/* An input speed was specified */
+#endif
 
 	termios->c_cflag &= ~CBAUD;
 
@@ -270,20 +286,24 @@ void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed
 			termios->c_cflag |= baud_bits[i];
 			ofound = i;
 		}
+#ifdef IBSHIFT
 		if (ibaud - iclose >= baud_table[i] && ibaud + iclose <= baud_table[i]) {
 			/* For the case input == output don't set IBAUD bits if the user didn't do so */
 			if (ofound != i || ibinput)
 				termios->c_cflag |= (baud_bits[i] << IBSHIFT);
 			ifound = i;
 		}
-	}
-	while(++i < n_baud_table);
+#endif
+	} while(++i < n_baud_table);
+
 	if (ofound == -1)
 		termios->c_cflag |= BOTHER;
+#ifdef IBSHIFT
 	/* Set exact input bits only if the input and output differ or the
 	   user already did */
 	if (ifound == -1 && (ibaud != obaud  || ibinput))
 		termios->c_cflag |= (BOTHER << IBSHIFT);
+#endif
 }
 
 EXPORT_SYMBOL_GPL(tty_termios_encode_baud_rate);
diff --git a/include/asm-powerpc/ioctls.h b/include/asm-powerpc/ioctls.h
index 279a622..b6dfe7f 100644
--- a/include/asm-powerpc/ioctls.h
+++ b/include/asm-powerpc/ioctls.h
@@ -31,6 +31,11 @@
 #define TCXONC		_IO('t', 30)
 #define TCFLSH		_IO('t', 31)
 
+#define TCGETS2		_IOR('t', 32, struct termios2)
+#define TCSETS2		_IOW('t', 33, struct termios2)
+#define TCSETSW2	_IOW('t', 34, struct termios2)
+#define TCSETSF2	_IOW('t', 35, struct termios2)
+
 #define TIOCSWINSZ	_IOW('t', 103, struct winsize)
 #define TIOCGWINSZ	_IOR('t', 104, struct winsize)
 #define	TIOCSTART	_IO('t', 110)		/* start output, like ^Q */
diff --git a/include/asm-powerpc/termbits.h b/include/asm-powerpc/termbits.h
index 5e79198..c39877f 100644
--- a/include/asm-powerpc/termbits.h
+++ b/include/asm-powerpc/termbits.h
@@ -43,6 +43,19 @@ struct ktermios {
 	speed_t c_ospeed;		/* output speed */
 };
 
+/* Yay. A third identical definition of the same structure. */
+
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_cc[NCCS];		/* control characters */
+	cc_t c_line;			/* line discipline (== c_cc[19]) */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
 /* c_cc characters */
 #define VINTR 	         0
 #define VQUIT 	         1
@@ -152,6 +165,7 @@ struct ktermios {
 #define B3000000  00034
 #define B3500000  00035
 #define B4000000  00036
+#define   BOTHER  00037
 
 #define CSIZE	00001400
 #define   CS5	00000000
diff --git a/include/asm-powerpc/termios.h b/include/asm-powerpc/termios.h
index 2c14fea..2841fb1 100644
--- a/include/asm-powerpc/termios.h
+++ b/include/asm-powerpc/termios.h
@@ -80,6 +80,9 @@ struct termio {
 
 #include <asm-generic/termios.h>
 
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _ASM_POWERPC_TERMIOS_H */

-- 
dwmw2

