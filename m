Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbXKFFyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbXKFFyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbXKFFxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:53:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:42330 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXKFFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:53:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=t/Z+MXD/mJtJTmAnhOxwb/xxCRZFhYbv3YT28lOBHu43+KRhc4hmvtQCJ6a138fzcm0P48dpPht5iknh8heD5yiZtuKVbSa7J+pmosuRW8lG+NaCD7ZRlTLe6xPE1Y5ABdKLIroTY5gbLa5N341dB5aP9aIkBIngbbh5zyhtIDs=
Date: Tue, 6 Nov 2007 14:00:28 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: Re: [PATCH]bluetooth rfcomm_dev refcount bug fix
Message-ID: <20071106060028.GA3176@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi marcel,
I'm afraid to be considered as spam ;)

(Due to timezone offset, I have to mail again and cann't wait for your
reply, sorry for the annoying)

I think the rfcomm_dev_put could be seperated from the rfcomm_dev_put,
it will be more straitforward then.

please consider below patch, tested on my side. thanks.

diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2007-11-05 11:28:49.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2007-11-06 13:40:44.000000000 +0800
@@ -109,9 +109,6 @@ static void rfcomm_dev_destruct(struct r
 
 	tty_unregister_device(rfcomm_tty_driver, dev->id);
 
-	/* Refcount should only hit zero when called from rfcomm_dev_del()
-	   which will have taken us off the list. Everything else are
-	   refcounting bugs. */
 	BUG_ON(!list_empty(&dev->list));
 
 	kfree(dev);
@@ -128,13 +125,6 @@ static inline void rfcomm_dev_hold(struc
 
 static inline void rfcomm_dev_put(struct rfcomm_dev *dev)
 {
-	/* The reason this isn't actually a race, as you no
-	   doubt have a little voice screaming at you in your
-	   head, is that the refcount should never actually
-	   reach zero unless the device has already been taken
-	   off the list, in rfcomm_dev_del(). And if that's not
-	   true, we'll hit the BUG() in rfcomm_dev_destruct()
-	   anyway. */
 	if (atomic_dec_and_test(&dev->refcnt))
 		rfcomm_dev_destruct(dev);
 }
@@ -309,12 +299,11 @@ out:
 	return dev->id;
 }
 
-static void rfcomm_dev_del(struct rfcomm_dev *dev)
+static void rfcomm_dev_set_del(struct rfcomm_dev *dev)
 {
 	BT_DBG("dev %p", dev);
 
 	set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
-	rfcomm_dev_put(dev);
 }
 
 /* ---- Send buffer ---- */
@@ -425,7 +414,7 @@ static int rfcomm_release_dev(void __use
 	if (dev->tty)
 		tty_vhangup(dev->tty);
 
-	rfcomm_dev_del(dev);
+	rfcomm_dev_set_del(dev);
 	rfcomm_dev_put(dev);
 	return 0;
 }
@@ -564,7 +553,8 @@ static void rfcomm_dev_state_change(stru
 				if (rfcomm_dev_get(dev->id) == NULL)
 					return;
 
-				rfcomm_dev_del(dev);
+				rfcomm_dev_set_del(dev);
+				rfcomm_dev_put(dev);
 				/* We have to drop DLC lock here, otherwise
 				   rfcomm_dev_put() will dead lock if it's
 				   the last reference. */
@@ -1022,7 +1012,8 @@ static void rfcomm_tty_hangup(struct tty
 	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
 		if (rfcomm_dev_get(dev->id) == NULL)
 			return;
-		rfcomm_dev_del(dev);
+		rfcomm_dev_set_del(dev);
+		rfcomm_dev_put(dev);
 		rfcomm_dev_put(dev);
 	}
 }
