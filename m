Return-Path: <linux-kernel-owner+w=401wt.eu-S1030321AbXBTRSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321AbXBTRSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030337AbXBTRSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:18:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40516 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030321AbXBTRSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:18:30 -0500
Date: Tue, 20 Feb 2007 18:22:16 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Turn on new termios for x86 32bit systems.
Message-ID: <20070220182216.2ea7640f@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been running this way on my laptop for some time with no problems so
it's time to turn it on for everyone. Unless you've got a hacked libc you
shouldn't even notice this change.

<hint>
(Note to other platform maintainers: those who've not made changes for their
platform soon after all the hints will find me submitting patches for their
platform. So if you want particular encodings you might want to do it soon)
</hint>

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/include/asm-i386/ioctls.h linux-2.6.20-mm2/include/asm-i386/ioctls.h
--- linux.vanilla-2.6.20-mm2/include/asm-i386/ioctls.h	2007-01-31 14:05:06.000000000 +0000
+++ linux-2.6.20-mm2/include/asm-i386/ioctls.h	2007-02-20 14:01:37.000000000 +0000
@@ -49,6 +49,12 @@
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
+#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/include/asm-i386/termbits.h linux-2.6.20-mm2/include/asm-i386/termbits.h
--- linux.vanilla-2.6.20-mm2/include/asm-i386/termbits.h	2007-02-20 12:32:36.000000000 +0000
+++ linux-2.6.20-mm2/include/asm-i386/termbits.h	2007-02-20 14:01:46.000000000 +0000
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
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/include/asm-i386/termios.h linux-2.6.20-mm2/include/asm-i386/termios.h
--- linux.vanilla-2.6.20-mm2/include/asm-i386/termios.h	2007-02-20 13:38:11.000000000 +0000
+++ linux-2.6.20-mm2/include/asm-i386/termios.h	2007-02-20 14:01:46.000000000 +0000
@@ -83,6 +83,8 @@
 
 #define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
 #define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
+#define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
 #endif	/* __KERNEL__ */
 
