Return-Path: <linux-kernel-owner+w=401wt.eu-S933915AbXFFMdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933915AbXFFMdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762458AbXFFMdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:33:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36270 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762329AbXFFMdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:33:13 -0400
Subject: Re: [PATCH] $ARCH: Enable arbitary speed tty ioctls and split
	input/output speed
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <18010.24300.599531.828815@cargo.ozlabs.ibm.com>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	 <1180012135.8303.89.camel@shinybook.infradead.org>
	 <20070524144109.7bd0f4d0@the-village.bc.nu>
	 <1180014338.8303.95.camel@shinybook.infradead.org>
	 <20070524160559.54c2c639@the-village.bc.nu>
	 <18010.24300.599531.828815@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 13:33:05 +0100
Message-Id: <1181133185.4096.32.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-28 at 14:47 +1000, Paul Mackerras wrote:
> Sure, we can add them.  I suggest IBSHIFT = 16 and CIBAUD = 0xff0000
> (or 077600000 if we are going to continue the peculiar convention of
> using octal for the C* constants). 

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

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
index 5e79198..a5a87f0 100644
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
@@ -152,6 +165,10 @@ struct ktermios {
 #define B3000000  00034
 #define B3500000  00035
 #define B4000000  00036
+#define   BOTHER  00037
+
+#define CIBAUD	077600000
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
 
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

