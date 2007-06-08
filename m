Return-Path: <linux-kernel-owner+w=401wt.eu-S1032092AbXFHUf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032092AbXFHUf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969310AbXFHUfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:35:13 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:34713
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968792AbXFHUfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:35:10 -0400
Subject: [PATCH] tty restore locked ioctl file op
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070608123350.5cc53c10.akpm@linux-foundation.org>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	 <20070513154718.bb338ceb.akpm@linux-foundation.org>
	 <1179098742.7322.5.camel@rousalka.dyndns.org>
	 <1179396003.31796.4.camel@rousalka.dyndns.org>
	 <20070517094557.c96f7e54.randy.dunlap@oracle.com>
	 <1179421196.5000.5.camel@rousalka.dyndns.org>
	 <1180206615.3430.8.camel@rousalka.dyndns.org>
	 <20070608030629.GA18493@atjola.homenet>
	 <1181315809.4811.5.camel@x2.microgate.com>
	 <1181330448.5365.7.camel@amdx2.microgate.com>
	 <20070608123350.5cc53c10.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 15:34:17 -0500
Message-Id: <1181334857.3408.0.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Restore tty locked ioctl handler which was replaced with
an unlocked ioctl handler in hung_up_tty_fops by the patch:

commit e10cc1df1d2014f68a4bdcf73f6dd122c4561f94
Author: Paul Fulghum <paulkf@microgate.com>
Date:   Thu May 10 22:22:50 2007 -0700

    tty: add compat_ioctl

This was reported in:
[Bug 8473] New: Oops: 0010 [1] SMP

The bug is caused by switching to hung_up_tty_fops in do_tty_hangup.
An ioctl call can be waiting on BLK after testing for existence of
the locked ioctl handler in the normal tty fops, but before calling
the locked ioctl handler. If a hangup occurs at that point, the
locked ioctl fop is NULL and an oops occurs.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/tty_io.c	2007-06-08 14:26:10.000000000 -0500
+++ b/drivers/char/tty_io.c	2007-06-08 14:28:58.000000000 -0500
@@ -1173,8 +1173,14 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static long hung_up_tty_ioctl(struct file * file,
-			      unsigned int cmd, unsigned long arg)
+static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
+			     unsigned int cmd, unsigned long arg)
+{
+	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
+}
+
+static long hung_up_tty_compat_ioctl(struct file * file,
+				     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1222,8 +1228,8 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.unlocked_ioctl = hung_up_tty_ioctl,
-	.compat_ioctl	= hung_up_tty_ioctl,
+	.ioctl		= hung_up_tty_ioctl,
+	.compat_ioctl	= hung_up_tty_compat_ioctl,
 	.release	= tty_release,
 };
 



