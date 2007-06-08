Return-Path: <linux-kernel-owner+w=401wt.eu-S1030366AbXFHPSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366AbXFHPSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966309AbXFHPSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:18:05 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:54236
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965353AbXFHPSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:18:03 -0400
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
From: Paul Fulghum <paulkf@microgate.com>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070608030629.GA18493@atjola.homenet>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	 <20070513154718.bb338ceb.akpm@linux-foundation.org>
	 <1179098742.7322.5.camel@rousalka.dyndns.org>
	 <1179396003.31796.4.camel@rousalka.dyndns.org>
	 <20070517094557.c96f7e54.randy.dunlap@oracle.com>
	 <1179421196.5000.5.camel@rousalka.dyndns.org>
	 <1180206615.3430.8.camel@rousalka.dyndns.org>
	 <20070608030629.GA18493@atjola.homenet>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 08 Jun 2007 10:16:49 -0500
Message-Id: <1181315809.4811.5.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 05:06 +0200, Björn Steinbrink wrote:
> This is do_tty_hangup() exchanging the fops while we're waiting for the
> lock. The new fops (hung_up_tty_fops) only have the unlocked variant and
> thus we Oops our way.
> 
> The following program reproduces it quite easily on a SMP box. I'm
> running it from X as root like this:
> while true; do xterm /path/to/program; done

I am unable to reproduce the oops on either i386 SMP or x86_64 SMP
using your test program. This is against plain 2.6.21 with only
my compat ioctl patch applied.

Here is a patch that restores the locked ioctl for hung_up_tty_ioctl.
Can you try it and see if it removes your oops?

--- a/drivers/char/tty_io.c	2007-06-08 10:07:39.000000000 -0500
+++ b/drivers/char/tty_io.c	2007-06-08 10:09:59.000000000 -0500
@@ -1150,8 +1150,14 @@ static unsigned int hung_up_tty_poll(str
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
@@ -1199,8 +1205,8 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.unlocked_ioctl = hung_up_tty_ioctl,
-	.compat_ioctl	= hung_up_tty_ioctl,
+	.ioctl		= hung_up_tty_ioctl,
+	.compat_ioctl	= hung_up_tty_compat_ioctl,
 	.release	= tty_release,
 };
 


