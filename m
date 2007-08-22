Return-Path: <linux-kernel-owner+w=401wt.eu-S1763822AbXHVJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763822AbXHVJJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758905AbXHVIxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:49 -0400
Received: from 1wt.eu ([62.212.114.60]:2166 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758821AbXHVIxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:45 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084035.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:30 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Ville Tervo <ville.tervo@nokia.com>, Marcel Holtmann <marcel@holtmann.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 46/58] Keep rfcomm_dev on the list until it is freed
Content-Disposition: inline; filename=0046-Keep-rfcomm_dev-on-the-list-until-it-is-freed.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the RFCOMM TTY release process so that the TTY is kept
on the list until it is really freed. A new device flag is used to keep
track of released TTYs.

Signed-off-by: Ville Tervo <ville.tervo@nokia.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 include/net/bluetooth/rfcomm.h |    1 +
 net/bluetooth/rfcomm/tty.c     |   30 ++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 3c563f0..25aa575 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -323,6 +323,7 @@ int  rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc
 #define RFCOMM_RELEASE_ONHUP  1
 #define RFCOMM_HANGUP_NOW     2
 #define RFCOMM_TTY_ATTACHED   3
+#define RFCOMM_TTY_RELEASED   4
 
 struct rfcomm_dev_req {
 	s16      dev_id;
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index e1b8663..26e8c02 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -93,6 +93,10 @@ static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
 
 	BT_DBG("dev %p dlc %p", dev, dlc);
 
+	write_lock_bh(&rfcomm_dev_lock);
+	list_del_init(&dev->list);
+	write_unlock_bh(&rfcomm_dev_lock);
+
 	rfcomm_dlc_lock(dlc);
 	/* Detach DLC if it's owned by this dev */
 	if (dlc->owner == dev)
@@ -154,8 +158,13 @@ static inline struct rfcomm_dev *rfcomm_dev_get(int id)
 	read_lock(&rfcomm_dev_lock);
 
 	dev = __rfcomm_dev_get(id);
-	if (dev)
-		rfcomm_dev_hold(dev);
+
+	if (dev) {
+		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
+			dev = NULL;
+		else
+			rfcomm_dev_hold(dev);
+	}
 
 	read_unlock(&rfcomm_dev_lock);
 
@@ -263,6 +272,12 @@ out:
 
 	tty_register_device(rfcomm_tty_driver, dev->id, rfcomm_get_device(dev));
 
+	if (IS_ERR(dev->tty_dev)) {
+		list_del(&dev->list);
+		kfree(dev);
+		return PTR_ERR(dev->tty_dev);
+	}
+
 	return dev->id;
 }
 
@@ -270,10 +285,7 @@ static void rfcomm_dev_del(struct rfcomm_dev *dev)
 {
 	BT_DBG("dev %p", dev);
 
-	write_lock_bh(&rfcomm_dev_lock);
-	list_del_init(&dev->list);
-	write_unlock_bh(&rfcomm_dev_lock);
-
+	set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
 	rfcomm_dev_put(dev);
 }
 
@@ -327,7 +339,7 @@ static int rfcomm_create_dev(struct sock *sk, void __user *arg)
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
 
-	BT_DBG("sk %p dev_id %id flags 0x%x", sk, req.dev_id, req.flags);
+	BT_DBG("sk %p dev_id %d flags 0x%x", sk, req.dev_id, req.flags);
 
 	if (req.flags != NOCAP_FLAGS && !capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -368,7 +380,7 @@ static int rfcomm_release_dev(void __user *arg)
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
 
-	BT_DBG("dev_id %id flags 0x%x", req.dev_id, req.flags);
+	BT_DBG("dev_id %d flags 0x%x", req.dev_id, req.flags);
 
 	if (!(dev = rfcomm_dev_get(req.dev_id)))
 		return -ENODEV;
@@ -417,6 +429,8 @@ static int rfcomm_get_dev_list(void __user *arg)
 
 	list_for_each(p, &rfcomm_dev_list) {
 		struct rfcomm_dev *dev = list_entry(p, struct rfcomm_dev, list);
+		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
+			continue;
 		(di + n)->id      = dev->id;
 		(di + n)->flags   = dev->flags;
 		(di + n)->state   = dev->dlc->state;
-- 
1.5.2.5

-- 
