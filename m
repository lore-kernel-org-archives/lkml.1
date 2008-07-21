Return-Path: <linux-kernel-owner+w=401wt.eu-S1752756AbYGURcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbYGURcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYGURco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:32:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:22393 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYGURcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:32:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=UE1nV7hJWbm42XzAUjlTN1aVOkbxzoYLK5brxeAC/zk46QQRJRkR1btukQjP8bxiri
         x4OY3Ro0p6HKGRRWVw7Br72d3oRMYJ821dcjDjUyFrtFFPPND4z/uwePgRkASo0GUyFp
         n3tn+TyUzVt+RfKPFq1shrBmw4r5MGjREfXA4=
Date: Mon, 21 Jul 2008 19:32:10 +0200
To: Marcel Holtmann <marcel@holtmann.org>,
       Maxim Krasnyansky <maxk@qualcomm.com>,
       Dave Young <hidave.darkstar@gmail.com>
Cc: Soeren Sonnenburg <kernel@nn7.de>, David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: fix oops in rfcomm tty code (v3)
Message-ID: <20080721173210.GA10710@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've respun the patch, now addressing Marcel's comments.

The change is basically that we _don't_ hold the &rfcomm_dev_lock while
registering tty devices. Instead, to prevent the race, we unregister the
device *before* it's removed from the list.

Does this look any better? I think that if I don't make it this time, I
will give up and let somebody else fix it :-)

I've tested it briefly and it doesn't block the creation of new devices,
however, it seems that the device is now deleted as soon as the first
socket is closed, which means that in order to create /dev/rfcomm0 and
also open it, in the test program, the first socket must not be closed
before the device is opened. I'm sure if this is the intended behaviour?

Thanks,


Vegard


>From 5be8c4d5011f23d5e2b116f4965a6c6061d049a5 Mon Sep 17 00:00:00 2001
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

We also fix a race (which would lead to the same oops) by unregistering
with the tty layer before the device is taken off the list of devices.

Thanks to Dave Young for additional suggestions.

Reported-by: Soeren Sonnenburg <kernel@nn7.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 net/bluetooth/rfcomm/tty.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index d3340dd..ef4bdaa 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -96,9 +96,13 @@ static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
 	BT_DBG("dev %p dlc %p", dev, dlc);
 
 	/* Refcount should only hit zero when called from rfcomm_dev_del()
-	   which will have taken us off the list. Everything else are
-	   refcounting bugs. */
-	BUG_ON(!list_empty(&dev->list));
+	   which will have set the RFCOMM_TTY_RELEASED bit. Everything else
+	   are refcounting bugs. */
+	BUG_ON(!test_bit(RFCOMM_TTY_RELEASED, &dev->flags));
+
+	tty_unregister_device(rfcomm_tty_driver, dev->id);
+
+	write_lock_bh(&rfcomm_dev_lock);
 
 	rfcomm_dlc_lock(dlc);
 	/* Detach DLC if it's owned by this dev */
@@ -108,7 +112,9 @@ static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
 
 	rfcomm_dlc_put(dlc);
 
-	tty_unregister_device(rfcomm_tty_driver, dev->id);
+	list_del_init(&dev->list);
+
+	write_unlock_bh(&rfcomm_dev_lock);
 
 	kfree(dev);
 
@@ -127,10 +133,8 @@ static inline void rfcomm_dev_put(struct rfcomm_dev *dev)
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
@@ -335,10 +339,6 @@ static void rfcomm_dev_del(struct rfcomm_dev *dev)
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

