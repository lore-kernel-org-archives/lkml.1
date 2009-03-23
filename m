Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbZCWU7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbZCWU7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760011AbZCWU5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:57:47 -0400
Received: from tichy.grunau.be ([85.131.189.73]:57425 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759887AbZCWU5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:57:45 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 16:57:45 EDT
Date: Mon, 23 Mar 2009 21:49:40 +0100
From: Janne Grunau <j@jannau.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for March 23 (media/video/hdpvr)
Message-ID: <20090323204940.GA5079@aniel>
References: <20090323205454.d0cbf721.sfr@canb.auug.org.au> <49C7D965.5080202@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <49C7D965.5080202@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Mon, Mar 23, 2009 at 11:48:05AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > 
> > Changes since 20090320:
> 
> > The v4l-dvb tree gained a build failure for which I have reverted 3 commits.
> 
> drivers/built-in.o: In function `hdpvr_disconnect':
> hdpvr-core.c:(.text+0xf3894): undefined reference to `i2c_del_adapter'
> drivers/built-in.o: In function `hdpvr_register_i2c_adapter':
> (.text+0xf4145): undefined reference to `i2c_add_adapter'
> 
> 
> CONFIG_I2C is not enabled.

following patch should fix that.

Janne

ps: Mauro, I'll send a pull request shortly

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hdpvr_without_i2c.diff"

make hdpvr build without CONFIG_I2C

Signed-off-by: Janne Grunau <j@jannau.net>
---
diff --git a/drivers/media/video/hdpvr/Makefile b/drivers/media/video/hdpvr/Makefile
index 79ad2e1..145163b 100644
--- a/drivers/media/video/hdpvr/Makefile
+++ b/drivers/media/video/hdpvr/Makefile
@@ -1,4 +1,6 @@
-hdpvr-objs	:= hdpvr-control.o hdpvr-core.o hdpvr-i2c.o hdpvr-video.o
+hdpvr-objs := hdpvr-control.o hdpvr-core.o hdpvr-video.o
+
+hdpvr-$(CONFIG_I2C) += hdpvr-i2c.o
 
 obj-$(CONFIG_VIDEO_HDPVR) += hdpvr.o
 
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index e7300b5..dadb2e7 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -21,6 +21,7 @@
 #include <linux/usb.h>
 #include <linux/mutex.h>
 #include <linux/i2c.h>
+#include <linux/autoconf.h>
 
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
@@ -389,12 +390,14 @@ static void hdpvr_disconnect(struct usb_interface *interface)
 	mutex_unlock(&dev->io_mutex);
 
 	/* deregister I2C adapter */
+#ifdef CONFIG_I2C
 	mutex_lock(&dev->i2c_mutex);
 	if (dev->i2c_adapter)
 		i2c_del_adapter(dev->i2c_adapter);
 	kfree(dev->i2c_adapter);
 	dev->i2c_adapter = NULL;
 	mutex_unlock(&dev->i2c_mutex);
+#endif /* CONFIG_I2C */
 
 	atomic_dec(&dev_nr);
 

--SUOF0GtieIMvvwua--
