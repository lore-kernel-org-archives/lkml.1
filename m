Return-Path: <linux-kernel-owner+w=401wt.eu-S1762366AbYCFWXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762366AbYCFWXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 17:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYCFWWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 17:22:53 -0500
Received: from mx1.riseup.net ([204.13.164.18]:51331 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYCFWWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 17:22:52 -0500
Date: Thu, 6 Mar 2008 23:22:46 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] Alchemy Semi Au1000 pcmcia driver: convert
	pcmcia_sockets_lock in a mutex
Message-ID: <20080306222246.GD2783@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alchemy Semi Au1000 pcmcia driver: The semaphore pcmcia_sockets_lock
is used as a mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--

 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 
 #include <asm/io.h>
@@ -71,7 +72,7 @@ extern struct au1000_pcmcia_socket au1000_pcmcia_socket[];
 u32 *pcmcia_base_vaddrs[2];
 extern const unsigned long mips_io_port_base;
 
-DECLARE_MUTEX(pcmcia_sockets_lock);
+DEFINE_MUTEX(pcmcia_sockets_lock);
 
 static int (*au1x00_pcmcia_hw_init[])(struct device *dev) = {
 	au1x_board_init,
@@ -472,7 +473,7 @@ int au1x00_drv_pcmcia_remove(struct device *dev)
 	struct skt_dev_info *sinfo = dev_get_drvdata(dev);
 	int i;
 
-	down(&pcmcia_sockets_lock);
+	mutex_lock(&pcmcia_sockets_lock);
 	dev_set_drvdata(dev, NULL);
 
 	for (i = 0; i < sinfo->nskt; i++) {
@@ -488,7 +489,7 @@ int au1x00_drv_pcmcia_remove(struct device *dev)
 	}
 
 	kfree(sinfo);
-	up(&pcmcia_sockets_lock);
+	mutex_unlock(&pcmcia_sockets_lock);
 	return 0;
 }
 
@@ -501,13 +502,13 @@ static int au1x00_drv_pcmcia_probe(struct device *dev)
 {
 	int i, ret = -ENODEV;
 
-	down(&pcmcia_sockets_lock);
+	mutex_lock(&pcmcia_sockets_lock);
 	for (i=0; i < ARRAY_SIZE(au1x00_pcmcia_hw_init); i++) {
 		ret = au1x00_pcmcia_hw_init[i](dev);
 		if (ret == 0)
 			break;
 	}
-	up(&pcmcia_sockets_lock);
+	mutex_unlock(&pcmcia_sockets_lock);
 	return ret;
 }

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
