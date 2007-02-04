Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbXBDRmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbXBDRmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXBDRmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:42:36 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:55018 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbXBDRmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:42:36 -0500
Message-ID: <45C61B09.7010102@lwfinger.net>
Date: Sun, 04 Feb 2007 11:42:33 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: roucaries bastien <roucaries.bastien@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Bcm43xx oops after suspend to disk
References: <45B92488.6090908@lwfinger.net> <45B92536.2080909@lwfinger.net>	 <195c7a900701251530m409878a8id301c7cada76f342@mail.gmail.com>	 <45BA246B.6030505@lwfinger.net> <20070129115842.GA4928@ucw.cz>	 <195c7a900701290455o3ff9fc15k305637f8ced24caf@mail.gmail.com>	 <20070129140408.GA19379@srcf.ucam.org> <45BE1639.6040106@lwfinger.net> <195c7a900702040907y8b8eff0gc8b0bbddd79a6792@mail.gmail.com>
In-Reply-To: <195c7a900702040907y8b8eff0gc8b0bbddd79a6792@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

roucaries bastien wrote:
> 
> Sorry for the delay it works. This time I can use iwlist eth scan.
> I have some difficulties to associate and I need to rmmod/modprobe in
> order to associate but it is another problem linked to a really weak
> power.

Bastien,

Please try this patch instead.

Thanks,

Larry

============================

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3638,6 +3638,7 @@ error:
 static int bcm43xx_init_board(struct bcm43xx_private *bcm)
 {
 	int err;
+	struct bcm43xx_phyinfo *phy = bcm43xx_current_phy(bcm);

 	mutex_lock(&(bcm)->mutex);

@@ -3658,6 +3659,8 @@ static int bcm43xx_init_board(struct bcm
 	if (err)
 		goto err_sysfs_unreg;
 	bcm43xx_periodic_tasks_setup(bcm);
+	/* force initial LO calibration */
+	phy->lo_control->txctl2 = 0xFFFF;

 	/*FIXME: This should be handled by softmac instead. */
 	schedule_delayed_work(&bcm->softmac->associnfo.work, 0);
@@ -3763,7 +3766,6 @@ static int bcm43xx_read_phyinfo(struct b
 		phy->lo_control = kzalloc(sizeof(*(phy->lo_control)), GFP_KERNEL);
 		if (!phy->lo_control)
 			return -ENOMEM;
-		phy->lo_control->txctl2 = 0xFFFF;//FIXME this is the wrong place
 	}

 	return 0;

----
