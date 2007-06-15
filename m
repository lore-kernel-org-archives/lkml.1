Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbXFOX6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbXFOX6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXFOX6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:58:07 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:60906 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbXFOX6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:58:05 -0400
Date: Fri, 15 Jun 2007 16:58:04 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Adrian Bunk <bunk@stusta.de>
cc: Michal CIJOML Semler <cijoml@volny.cz>,
       Markus Rechberger <markus.rechberger@amd.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] drivers/media/dvb/dvb-core/dvb_net.c:
 check-after-use
In-Reply-To: <20070615210031.GK3588@stusta.de>
Message-ID: <Pine.LNX.4.58.0706151621000.4914@shell4.speakeasy.net>
References: <20070615210031.GK3588@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Adrian Bunk wrote:
> The Coverity checker spotted the following obvious check-after-use in
> drivers/media/dvb/dvb-core/dvb_net.c:

I spotted it before the patch was even applied:
http://www.linuxtv.org/pipermail/v4l-dvb-maintainer/2007-April/003917.html
If only coverity would get people to fix their bugs too.

I'm almost certain the check for !dvbdev ( = file->private_data) is not
necessary.

If you trace it, starting from the beginning:

dvb device is created:
dvbdev.c:425  cdev_init(&dvb_device_cdev, &dvb_device_fops);

dvb_device_fops defined:
dvbdev.c:117 static struct file_operations dvb_device_fops =
dvbdev.c:118 {
dvbdev.c:119         .owner =        THIS_MODULE,
dvbdev.c:120         .open =         dvb_device_open,
dvbdev.c:121 };

BTW, this struct should be const, no?  In fact, why not make it a static
local to "__init init_dvbdev()", the only place it's used?  That way it
will go into the init.data section, right?

Anyway, the relevant code for dvb_device_open:

dvbdev.c:87  static int dvb_device_open(struct inode *inode, struct file *file)
dvbdev.c:91          dvbdev = dvbdev_find_device (iminor(inode));
dvbdev.c:93          if (dvbdev && dvbdev->fops) {
dvbdev.c:101                 file->private_data = dvbdev;
dvbdev.c:111                 return err;
dvbdev.c:112         }
dvbdev.c:113         return -ENODEV;

So file->private_data must be non-NULL when the file is opened, or the open
function for the dvb device will return ENODEV.

The only code code in the dvb tree that assigns to private_data that I
could find is in the open function for dmx devices, and it doesn't apply to
dvb net devices and can't set private_data to NULL anyway.

So, if there file->private_data starts as non-NULL, and there is no code
that changes it, it can't ever be non-NULL, right?

BTW, I hate checks for a pointer being NULL if it's not actually part of
the design that the pointer can be NULL.  It just clutters the code, as
other programmers see the check and they need to handle the pointer being
NULL too.  And if there is a bug and the pointer is NULL, the check doesn't
fix the bug it just masks it.  The farther it is from a bug's cause to the
point it's detected, the harder it is to fix.

Here is a patch to fix it.  Actually, there is still a check-after-use
after the patch, but is Coverity smart enough to find it?

--------------------------------------------------------------------------
diff -r 2f04637aaea8 linux/drivers/media/dvb/dvb-core/dvb_net.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_net.c	Fri Jun 08 08:58:41 2007 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_net.c	Fri Jun 15 15:34:08 2007 -0700
@@ -1502,18 +1502,9 @@ static int dvb_net_close(struct inode *i
 	struct dvb_device *dvbdev = file->private_data;
 	struct dvb_net *dvbnet = dvbdev->priv;

-	if (!dvbdev)
-		return -ENODEV;
-
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
-		dvbdev->readers++;
-	} else {
-		dvbdev->writers++;
-	}
-
-	dvbdev->users++;
-
-	if(dvbdev->users == 1 && dvbnet->exit==1) {
+	dvb_generic_release(inode, file);
+
+	if(dvbdev->users == 1 && dvbnet->exit == 1) {
 		fops_put(file->f_op);
 		file->f_op = NULL;
 		wake_up(&dvbdev->wait_queue);
