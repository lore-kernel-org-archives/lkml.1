Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbXKEPBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbXKEPBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 10:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbXKEPBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 10:01:37 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:35917 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXKEPBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 10:01:36 -0500
Subject: Re: [PATCH]bluetooth rfcomm_dev refcount bug fix
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
In-Reply-To: <20071105045921.GA3556@darkstar.te-china.tietoenator.com>
References: <20071105045921.GA3556@darkstar.te-china.tietoenator.com>
Content-Type: multipart/mixed; boundary="=-jYvkVJrTABd2+jwqR89U"
Date: Mon, 05 Nov 2007 16:01:10 +0100
Message-Id: <1194274870.4437.8.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jYvkVJrTABd2+jwqR89U
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Dave,

> In the rfcomm_tty_hangup the rfcomm_dev refcnt should be dropped later.
> 
> If rfcomm_dev is destructed in tty_hangup function, then the later tty_close function will oops.

your patch removes the complete release on hangup logic. That can't be
right. I think the problem is with calling tty_vhangup() and then
decrementing the reference count. In case we call tty_vhangup and we
have release on hangup we should not delete the device here. What about
the attached patch? Does it solve it?

What are the steps to reproduce this?

Regards

Marcel


--=-jYvkVJrTABd2+jwqR89U
Content-Disposition: attachment; filename=patch
Content-Type: text/x-patch; name=patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index e447651..b405b9a 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -425,8 +425,11 @@ static int rfcomm_release_dev(void __user *arg)
 	if (dev->tty)
 		tty_vhangup(dev->tty);
 
-	rfcomm_dev_del(dev);
-	rfcomm_dev_put(dev);
+	if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
+		rfcomm_dev_del(dev);
+		rfcomm_dev_put(dev);
+	}
+
 	return 0;
 }
 

--=-jYvkVJrTABd2+jwqR89U--

