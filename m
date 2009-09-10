Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZIJMda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZIJMda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 08:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZIJMda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:33:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbZIJMd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:33:29 -0400
Date: Thu, 10 Sep 2009 09:33:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
Message-ID: <20090910093301.4ccfd786@caramujo.chehab.org>
In-Reply-To: <4AA89B02.1050909@zytor.com>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
	<20090908235441.04549a29@caramujo.chehab.org>
	<4AA73309.8030302@zytor.com>
	<20090910010512.60a1f523@caramujo.chehab.org>
	<4AA89B02.1050909@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

char/tty_io: fix pty name convention

With kernel 2.6, the number of minors is not 255 anymore. So, it is
possible to have more than 255 pty devices.

However, the pty_line_name() only provides device names for the first
256 tty/pty devices.

This is a bug, since there's no limits for the maximum number of legacy
pty devices at Kconfig or at pty.legacy_count.

This patch preserves the old nomenclature for tty/pty devices for the
first 256 devices.

To preserve backward compatibility, the device index is broken into
nibbles, each nibble generating a letter, at the following order:
* The second nibble of the index is represented by one of pqrstuvwxyzabcde
  letters, indicating the 1st through 16th nibble value;
* The remaining nibbles are represented by one of 0123456789abcdef letters,
  indicating the 1st through 16th nibble value, starting from the most
  significative nibble to the least significative nibble, excluding the
  second nibble (that were already represented).

  So, device numbers will be:

	0     = ptyp0
	1     = ptyp1
	...
	255   = ptyef
	256   = ptyp10
	...
	4095  = ptyeff
	4096  = ptyp100
	...
	65535 = ptyefff
	65536 = ptyp1000
	...

Thanks to H. Peter Anvin <hpa@zytor.com> for proposing this algorithm.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 53d64d3..6a74635 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -114,17 +114,30 @@ Your cooperation is appreciated.
 		the initrd.
 
   2 char	Pseudo-TTY masters
-		  0 = /dev/ptyp0	First PTY master
-		  1 = /dev/ptyp1	Second PTY master
+		   0 = /dev/ptyp0	First PTY master
+		   1 = /dev/ptyp1	Second PTY master
 		    ...
-		255 = /dev/ptyef	256th PTY master
+		 255 = /dev/ptyef	256th PTY master
+		 256 = /dev/ptyp10	257th PTY master
+		 257 = /dev/ptyp11	258th PTY master
+		   ...
+		4095 = /dev/ptyeff	4095th PTY master
+		4096 = /dev/ptyp100	4096th PTY master
+		   ...
 
 		Pseudo-tty's are named as follows:
-		* Masters are "pty", slaves are "tty";
-		* the fourth letter is one of pqrstuvwxyzabcde indicating
-		  the 1st through 16th series of 16 pseudo-ttys each, and
-		* the fifth letter is one of 0123456789abcdef indicating
-		  the position within the series.
+		Masters are "pty", slaves are "tty";
+
+		The device index is broken into nibbles, each nibble
+		generating a letter, at the following order:
+		* The second nibble of the index is represented by one
+		  of pqrstuvwxyzabcde letters, indicating the 1st
+		  through 16th nibble value;
+		* The remaining nibbles are represented by one of
+		  0123456789abcdef letters, indicating the 1st through
+		  16th nibble value, starting from the most
+		  significative nibble to the least significative nibble,
+		  excluding the second nibble.
 
 		These are the old-style (BSD) PTY devices; Unix98
 		devices are on major 128 and above and use the PTY
@@ -189,10 +202,18 @@ Your cooperation is appreciated.
 		the drive type is insignificant for these devices.
 
   3 char	Pseudo-TTY slaves
-		  0 = /dev/ttyp0	First PTY slave
-		  1 = /dev/ttyp1	Second PTY slave
-		    ...
-		255 = /dev/ttyef	256th PTY slave
+		   0 = /dev/ttyp0	First PTY slave
+		   1 = /dev/ttyp1	Second PTY slave
+		  ...
+		 255 = /dev/ttyef	256th PTY slave
+		 256 = /dev/ttyp10	257th PTY slave
+		 257 = /dev/ttyp11	258th PTY slave
+		   ...
+		4095 = /dev/ttyeff	4095th PTY slave
+		4096 = /dev/ttyp100	4096th PTY slave
+		   ...
+
+		See char major number 2 for the used rules to name them.
 
 		These are the old-style (BSD) PTY devices; Unix98
 		devices are on major 136 and above.
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a3afa0c..de6d617 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1093,8 +1093,6 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 	return tty_write(file, buf, count, ppos);
 }
 
-static char ptychar[] = "pqrstuvwxyzabcde";
-
 /**
  *	pty_line_name	-	generate name for a pty
  *	@driver: the tty driver in use
@@ -1108,11 +1106,23 @@ static char ptychar[] = "pqrstuvwxyzabcde";
  */
 static void pty_line_name(struct tty_driver *driver, int index, char *p)
 {
+	static const char ptychar[] = "pqrstuvwxyzabcde";
+
 	int i = index + driver->name_base;
-	/* ->name is initialized to "ttyp", but "tty" is expected */
+	/*
+	 * On slave, driver->name is initialized to "ttyp",
+	 *	but "tty" is expected.
+	 * The index part of the name is broken into nibbles, following
+	 * this sequence:
+	 *   The second nibble encoded with ptychar;
+	 *   The other nibbles, printed in hexadecimal, from most to
+	 *     the least significant nibble.
+	 * This is done to preserve backward compatibility with the older
+	 * naming conventions.
+	 */
 	sprintf(p, "%s%c%x",
 		driver->subtype == PTY_TYPE_SLAVE ? "tty" : driver->name,
-		ptychar[i >> 4 & 0xf], i & 0xf);
+		ptychar[(i >> 4) & 0xf], (i & 0xf) | ((i >> 4) & ~0xf));
 }
 
 /**




Cheers,
Mauro
