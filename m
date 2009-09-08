Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbZIHS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbZIHS7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZIHS7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:59:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZIHS7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:59:34 -0400
Date: Tue, 8 Sep 2009 15:59:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH v2 RFC] char/tty_io: fix legacy pty name when more than 256
 pty devices are requested
Message-ID: <20090908155906.0d30f4bc@caramujo.chehab.org>
In-Reply-To: <20090908185926.042ba9aa@lxorguk.ukuu.org.uk>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<20090908185926.042ba9aa@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 2.6, the number of minors is not 255 anymore. So, it is
possible to have more than 255 pty devices.

However, the pty_line_name() only provides device names for the first
256 tty/pty devices.

This is a bug, since there's no limits for the maximum number of legacy
pty devices at Kconfig or at pty.legacy_count.

This patch preserves the old nomenclature for tty/pty devices for the
first 256 devices. After that, it names the next devices as:
	ttyf0000-ttfpffff	(pty slave)
	ptyf0000-ttyfffff	(pty master)

This way, the existing udev rules for legacy pty devices to not
break. Only after minor 255, it will start to use the new nomenclature.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

Version 2: devices.txt namespace doc were updated accordingly.

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 53d64d3..cfd3e20 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -114,18 +114,27 @@ Your cooperation is appreciated.
 		the initrd.
 
   2 char	Pseudo-TTY masters
-		  0 = /dev/ptyp0	First PTY master
-		  1 = /dev/ptyp1	Second PTY master
+		    0 = /dev/ptyp0	First PTY master
+		    1 = /dev/ptyp1	Second PTY master
 		    ...
-		255 = /dev/ptyef	256th PTY master
+		  255 = /dev/ptyef	256th PTY master
+		  256 = /dev/ptyf0000	257th PTY slave
+		  257 = /dev/ptyf0001	258th PTY slave
+		   ...
+		65791 = /dev/ptyfffff	65791 PTY slave
 
-		Pseudo-tty's are named as follows:
+		Pseudo-tty's up to 256 are named as follows:
 		* Masters are "pty", slaves are "tty";
 		* the fourth letter is one of pqrstuvwxyzabcde indicating
 		  the 1st through 16th series of 16 pseudo-ttys each, and
 		* the fifth letter is one of 0123456789abcdef indicating
 		  the position within the series.
 
+		Pseudo-tty's above 256 are named as follows:
+		* Masters are "ptyf", slaves are "ttyf";
+		* the fifth to eighth letters are hexadecimal digits
+		  indicating the position within the series.
+
 		These are the old-style (BSD) PTY devices; Unix98
 		devices are on major 128 and above and use the PTY
 		master multiplex (/dev/ptmx) to acquire a PTY on
@@ -189,10 +198,14 @@ Your cooperation is appreciated.
 		the drive type is insignificant for these devices.
 
   3 char	Pseudo-TTY slaves
-		  0 = /dev/ttyp0	First PTY slave
-		  1 = /dev/ttyp1	Second PTY slave
-		    ...
-		255 = /dev/ttyef	256th PTY slave
+		    0 = /dev/ttyp0	First PTY slave
+		    1 = /dev/ttyp1	Second PTY slave
+		  ...
+		  255 = /dev/ttyef	256th PTY slave
+		  256 = /dev/ttyf0000	257th PTY slave
+		  257 = /dev/ttyf0001	258th PTY slave
+		   ...
+		65791 = /dev/ttyfffff	65791 PTY slave
 
 		These are the old-style (BSD) PTY devices; Unix98
 		devices are on major 136 and above.
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a3afa0c..fdea89b 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1110,9 +1110,15 @@ static void pty_line_name(struct tty_driver *driver, int index, char *p)
 {
 	int i = index + driver->name_base;
 	/* ->name is initialized to "ttyp", but "tty" is expected */
-	sprintf(p, "%s%c%x",
-		driver->subtype == PTY_TYPE_SLAVE ? "tty" : driver->name,
-		ptychar[i >> 4 & 0xf], i & 0xf);
+	if (i < 256) {
+		sprintf(p, "%s%c%x",
+				driver->subtype == PTY_TYPE_SLAVE ? "tty" : driver->name,
+				ptychar[i >> 4 & 0xf], i & 0xf);
+	} else {	/* Up to 4096 */
+		sprintf(p, "%sf%04x",
+				driver->subtype == PTY_TYPE_SLAVE ? "tty" : driver->name,
+				i - 256);
+	}
 }
 
 /**







Cheers,
Mauro
