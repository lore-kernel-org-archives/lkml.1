Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbXEWT4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbXEWT4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755619AbXEWT4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:56:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33712 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754956AbXEWT4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:56:40 -0400
Date: Wed, 23 May 2007 20:56:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, akpm@osdl.org,
       rmk@arm.linux.kernel.org, spyro@f2s.com, <starvik@axis.com>,
       <ysato@users.sourceforge.jp>, "Luck, Tony" <tony.luck@intel.com>,
       <takata@linux-m32r.org>, chris@zankel.net, <uclinux-v850@lsi.nec.co.jp>,
       kyle@parisc-linux.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] m68k: Enable arbitary speed tty support
Message-ID: <20070523205645.07b03581@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0705232117260.10610@anakin>
References: <20070523174446.37abfa7a@the-village.bc.nu>
	<Pine.LNX.4.64.0705232117260.10610@anakin>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#define TCSETS2		_IOW('T',0x2B, struct termios2)
> > +#define TCSETSW2	_IOW('T',0x2C, struct termios2)
> > +#define TCSETSF2	_IOW('T',0x2D, struct termios2)
> 
> Where is `struct termios2' defined? Right now it doesn't compile because
> of that.
> 

Sorry, shortage of qualified gnomes: One of them forgot to post this diff first

Add the termios2 structure ready for enabling on most platforms. One or two like
Sparc are plain weird so have been left alone. Most can use the same structure as
ktermios for termios2 (ie the newer ioctl uses the structure matching the current
kernel structure)

(cc'd various maintainers who get stuff)

Signed-off-by: Alan Cox <alan@redhat.com>

ddiff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-arm/termbits.h linux-2.6.22-rc1-mm1/include/asm-arm/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-arm/termbits.h	2007-04-30 10:48:14.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-arm/termbits.h	2007-05-23 20:23:25.000000000 +0100
@@ -15,6 +15,17 @@
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
+struct termios_2 {
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-arm26/termbits.h linux-2.6.22-rc1-mm1/include/asm-arm26/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-arm26/termbits.h	2007-04-30 10:48:14.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-arm26/termbits.h	2007-05-23 20:23:49.391177216 +0100
@@ -15,7 +15,7 @@
 	cc_t c_cc[NCCS];		/* control characters */
 };
 
-struct ktermios {
+struct termios2 {
 	tcflag_t c_iflag;		/* input mode flags */
 	tcflag_t c_oflag;		/* output mode flags */
 	tcflag_t c_cflag;		/* control mode flags */
@@ -26,6 +26,16 @@
 	speed_t c_ospeed;		/* output speed */
 };
 
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
 
 /* c_cc characters */
 #define VINTR 0
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-avr32/termbits.h linux-2.6.22-rc1-mm1/include/asm-avr32/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-avr32/termbits.h	2007-04-30 10:48:23.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-avr32/termbits.h	2007-05-23 20:24:26.447543792 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h linux-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h	2007-05-18 16:22:03.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-blackfin/termbits.h	2007-05-23 20:24:08.401287240 +0100
@@ -17,6 +17,17 @@
 	cc_t c_cc[NCCS];	/* control characters */
 };
 
+struct termios2 {
+	tcflag_t c_iflag;               /* input mode flags */
+	tcflag_t c_oflag;               /* output mode flags */
+	tcflag_t c_cflag;               /* control mode flags */
+	tcflag_t c_lflag;               /* local mode flags */
+	cc_t c_line;                    /* line discipline */
+	cc_t c_cc[NCCS];                /* control characters */
+	speed_t c_ispeed;               /* input speed */
+	speed_t c_ospeed;               /* output speed */
+};
+
 struct ktermios {
 	tcflag_t c_iflag;               /* input mode flags */
 	tcflag_t c_oflag;               /* output mode flags */
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/termbits.h linux-2.6.22-rc1-mm1/include/asm-cris/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-cris/termbits.h	2007-04-30 10:48:14.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-cris/termbits.h	2007-05-23 20:25:05.976534472 +0100
@@ -19,6 +19,17 @@
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-frv/termbits.h linux-2.6.22-rc1-mm1/include/asm-frv/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-frv/termbits.h	2007-04-30 10:48:14.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-frv/termbits.h	2007-05-23 20:24:43.107011168 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-h8300/termbits.h linux-2.6.22-rc1-mm1/include/asm-h8300/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-h8300/termbits.h	2007-04-30 10:48:15.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-h8300/termbits.h	2007-05-23 20:25:24.482721104 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/termbits.h linux-2.6.22-rc1-mm1/include/asm-ia64/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-ia64/termbits.h	2007-04-30 10:48:16.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-ia64/termbits.h	2007-05-23 20:21:59.400898280 +0100
@@ -26,6 +26,17 @@
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-m32r/termbits.h linux-2.6.22-rc1-mm1/include/asm-m32r/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-m32r/termbits.h	2007-04-30 11:00:07.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-m32r/termbits.h	2007-05-23 20:25:49.042987376 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-m68k/termbits.h linux-2.6.22-rc1-mm1/include/asm-m68k/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-m68k/termbits.h	2007-04-30 10:48:17.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-m68k/termbits.h	2007-05-23 20:21:00.208896832 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-mips/termbits.h linux-2.6.22-rc1-mm1/include/asm-mips/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-mips/termbits.h	2007-04-30 10:48:18.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-mips/termbits.h	2007-05-23 20:26:11.453580448 +0100
@@ -30,6 +30,17 @@
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-parisc/termbits.h linux-2.6.22-rc1-mm1/include/asm-parisc/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-parisc/termbits.h	2007-04-30 10:48:18.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-parisc/termbits.h	2007-05-23 20:23:07.292577176 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-s390/termbits.h linux-2.6.22-rc1-mm1/include/asm-s390/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-s390/termbits.h	2007-04-30 10:48:19.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-s390/termbits.h	2007-05-23 20:26:30.484687280 +0100
@@ -25,6 +25,17 @@
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-sh/termbits.h linux-2.6.22-rc1-mm1/include/asm-sh/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-sh/termbits.h	2007-04-30 10:48:19.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-sh/termbits.h	2007-05-23 20:26:48.510946872 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-v850/termbits.h linux-2.6.22-rc1-mm1/include/asm-v850/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-v850/termbits.h	2007-04-30 10:48:19.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-v850/termbits.h	2007-05-23 20:27:13.174197488 +0100
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h linux-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h
--- linux.vanilla-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h	2007-04-30 10:48:19.000000000 +0100
+++ linux-2.6.22-rc1-mm1/include/asm-xtensa/termbits.h	2007-05-23 20:27:28.654844072 +0100
@@ -30,6 +30,17 @@
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
