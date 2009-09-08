Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbZIHRuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbZIHRuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbZIHRuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:50:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZIHRuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:50:11 -0400
Date: Tue, 8 Sep 2009 14:49:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH RFC] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
Message-ID: <20090908144942.76ddf0e7@caramujo.chehab.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some use cases where more than 256 pty device pairs are needed.
   
With kernel 2.6, the number of minors is not 256 anymore. So, it is
possible to have more than 256 pty devices, either by specifying the number
of tty devices at CONFIG_LEGACY_PTY_COUNT or by using tty.legacy_count parameter
at boot time.

However, the pty_line_name() only provides device names for the first
256 tty/pty devices.

As this function is used to generate the sysfs class name, any number of
pty devices above 256 will fail to properly register them at sysfs.

This is a bug, since there's no limits for the maximum number of legacy
pty devices at Kconfig or at pty.legacy_count.

It is important to preserve the old nomenclature for tty/pty devices for the
first 256 devices, to avoid breakage on existing applications and with udev.

So, in order to allow more pty devices, the nomenclature were extended for
the devices with minor 256 or above. For those, the nomenclature will be:
	ttyf0000-ttfpffff	(pty slave)
	ptyf0000-ttyfffff	(pty master)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

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
