Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYGSVNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYGSVNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 17:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbYGSVMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 17:12:55 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:28922 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470AbYGSVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 17:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=WYD272ZHQdxV04HgpGMh5BjUksbXSgZ+iAtarGJ2YRKt4Nog9MLcsOVj4W9nzhhfqg
         61pxptL+rdSkyEiCdxximeiW11U0inWrzBwdu3tHaeZ6Q8oqILjQ1KYkdXqYAnssnH9m
         I2hZKEBwaLJ3S99hwhvE5koWBTeXEItTL0ci0=
Date: Sat, 19 Jul 2008 23:12:27 +0200
To: Marcel Holtmann <marcel@holtmann.org>,
       Maxim Krasnyansky <maxk@qualcomm.com>,
       Dave Young <hidave.darkstar@gmail.com>
Cc: Soeren Sonnenburg <kernel@nn7.de>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: fix oops in rfcomm tty code (v2)
Message-ID: <20080719211227.GA14173@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a resend of a patch I sent earlier. It fixes a reproducible
oops (see http://lkml.org/lkml/2008/7/13/89 for test case), and I'd
be very happy for some feedback from Bluetooth people. Can this be
included for testing somewhere? I don't have any bluetooth devices
myself, so all my testing is limited to creating/releasing devices
with ioctl (I'm not sure that's good enough).

Dave: I have extended the rfcomm_dev_lock to include all the setup and
teardown of a single device. On second thought, it doesn't really make
sense to use a separate lock for that. May I have your opinion on this
second version? (I've fixed the comments/BUG_ON that you pointed out.)


Vegard


>From ee99cfaae05bf6173efc77e5a100f1fbbc668301 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 13 Jul 2008 19:02:11 +0200
Subject: [PATCH] Bluetooth: fix oops in rfcomm tty code

Soeren Sonnenburg reported:
> this oops happened after a couple of s2ram cycles so it might be very
> well crap. However I somehow triggered it by /etc/init.d/bluetooth
> stop/start's which also call hid2hci maybe even a connection was about
> to be established at that time. As I remember having seen a problem like
> this before I thought I report it (even though I have a madwifi tainted
> kernel).
>
> kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.

It turns out that the following sequence of actions will reproduce the
oops:

  1. Create a new rfcomm device (using RFCOMMCREATEDEV ioctl)
  2. (Try to) open the device
  3. Release the rfcomm device (using RFCOMMRELEASEDEV ioctl)

At this point, the "rfcomm?" tty is still in use, but the device is gone
from the internal rfcomm list, so the device id can be reused.

  4. Create a new rfcomm device with the same device id as before

And now kobject will complain that the tty already exists.

(See http://lkml.org/lkml/2008/7/13/89 for a reproducible test-case.)

This patch attempts to correct this by only removing the device from the
internal rfcomm list of devices at the final unregister, so that the id
won't get reused until the device has been completely destructed.

This should be safe as the RFCOMM_TTY_RELEASED bit will be set for the
device and prevent the device from being reopened after it has been
released.

We also fix a race (which would lead to the same oops) by including the
tty setup/teardown code in the rfcomm_dev_lock, the lock protecting the
list of devices.

Thanks to Dave Young for additional suggestions.

Reported-by: Soeren Sonnenburg <kernel@nn7.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 net/bluetooth/rfcomm/tty.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index c919187..1709ccf 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -96,9 +96,11 @@ static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
 	BT_DBG("dev %p dlc %p", dev, dlc);
 
 	/* Refcount should only hit zero when called from rfcomm_dev_del()
-	   which will have taken us off the list. Everything else are
-	   refcounting bugs. */
-	BUG_ON(!list_empty(&dev->list));
+	   which will have set the RFCOMM_TTY_RELEASED bit. Everything else
+	   are refcounting bugs. */
+	BUG_ON(!test_bit(RFCOMM_TTY_RELEASED, &dev->flags));
+
+	write_lock_bh(&rfcomm_dev_lock);
 
 	rfcomm_dlc_lock(dlc);
 	/* Detach DLC if it's owned by this dev */
@@ -108,8 +110,11 @@ static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
 
 	rfcomm_dlc_put(dlc);
 
+	list_del_init(&dev->list);
 	tty_unregister_device(rfcomm_tty_driver, dev->id);
 
+	write_unlock_bh(&rfcomm_dev_lock);
+
 	kfree(dev);
 
 	/* It's safe to call module_put() here because socket still
@@ -127,10 +132,8 @@ static inline void rfcomm_dev_put(struct rfcomm_dev *dev)
 	/* The reason this isn't actually a race, as you no
 	   doubt have a little voice screaming at you in your
 	   head, is that the refcount should never actually
-	   reach zero unless the device has already been taken
-	   off the list, in rfcomm_dev_del(). And if that's not
-	   true, we'll hit the BUG() in rfcomm_dev_destruct()
-	   anyway. */
+	   reach zero unless we've already set the
+	   RFCOMM_TTY_RELEASED bit in rfcomm_dev_del(). */
 	if (atomic_dec_and_test(&dev->refcnt))
 		rfcomm_dev_destruct(dev);
 }
@@ -278,9 +281,8 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	__module_get(THIS_MODULE);
 
 out:
-	write_unlock_bh(&rfcomm_dev_lock);
-
 	if (err < 0) {
+		write_unlock_bh(&rfcomm_dev_lock);
 		kfree(dev);
 		return err;
 	}
@@ -290,6 +292,7 @@ out:
 	if (IS_ERR(dev->tty_dev)) {
 		err = PTR_ERR(dev->tty_dev);
 		list_del(&dev->list);
+		write_unlock_bh(&rfcomm_dev_lock);
 		kfree(dev);
 		return err;
 	}
@@ -302,6 +305,8 @@ out:
 	if (device_create_file(dev->tty_dev, &dev_attr_channel) < 0)
 		BT_ERR("Failed to create channel attribute");
 
+	write_unlock_bh(&rfcomm_dev_lock);
+
 	return dev->id;
 }
 
@@ -314,10 +319,6 @@ static void rfcomm_dev_del(struct rfcomm_dev *dev)
 	else
 		set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
 
-	write_lock_bh(&rfcomm_dev_lock);
-	list_del_init(&dev->list);
-	write_unlock_bh(&rfcomm_dev_lock);
-
 	rfcomm_dev_put(dev);
 }
 
-- 
1.5.5.1

