Return-Path: <linux-kernel-owner+w=401wt.eu-S1759850AbXGWHp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850AbXGWHp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbXGWHpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:45:46 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:60670 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbXGWHpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:45:45 -0400
Subject: Re: net/bluetooth/rfcomm/tty.c: use-after-free
From: Marcel Holtmann <marcel@holtmann.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Ville Tervo <ville.tervo@nokia.com>, maxk@qualcomm.com,
       bluez-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070723012543.GW26212@stusta.de>
References: <20070723012543.GW26212@stusta.de>
Content-Type: multipart/mixed; boundary="=-EtPTDyWlzq4wPVJ9lUcf"
Date: Mon, 23 Jul 2007 09:47:12 +0200
Message-Id: <1185176832.7111.32.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EtPTDyWlzq4wPVJ9lUcf
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Adrian,

> Commit 8de0a15483b357d0f0b821330ec84d1660cadc4e added the following 
> use-after-free in net/bluetooth/rfcomm/tty.c:
> 
> <--  snip  -->
> 
> ...
> static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
> {
> ...
>         if (IS_ERR(dev->tty_dev)) {
>                 list_del(&dev->list);
>                 kfree(dev);
>                 return PTR_ERR(dev->tty_dev);
>         }
> ...
> 
> <--  snip  -->
> 
> Spotted by the Coverity checker.

really good catch. I fully overlooked that one. The attached patch
should fix it.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


--=-EtPTDyWlzq4wPVJ9lUcf
Content-Disposition: attachment; filename=patch
Content-Type: text/x-patch; name=patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 23ba61a..22a8320 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -267,7 +267,7 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 out:
 	write_unlock_bh(&rfcomm_dev_lock);
 
-	if (err) {
+	if (err < 0) {
 		kfree(dev);
 		return err;
 	}
@@ -275,9 +275,10 @@ out:
 	dev->tty_dev = tty_register_device(rfcomm_tty_driver, dev->id, NULL);
 
 	if (IS_ERR(dev->tty_dev)) {
+		err = PTR_ERR(dev->tty_dev);
 		list_del(&dev->list);
 		kfree(dev);
-		return PTR_ERR(dev->tty_dev);
+		return err;
 	}
 
 	return dev->id;

--=-EtPTDyWlzq4wPVJ9lUcf--

