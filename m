Return-Path: <linux-kernel-owner+w=401wt.eu-S1760373AbXH1Kxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373AbXH1Kxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbXH1KxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:53:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346AbXH1KxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:53:18 -0400
Date: Tue, 28 Aug 2007 10:53:16 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Linux 2.6.20.18
Message-ID: <20070828105316.GA21492@hera.kernel.org>
References: <20070828105252.GA17747@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828105252.GA17747@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index bce2fbf..48daec7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .17
+EXTRAVERSION = .18
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 17d75ec..b50ebb6 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -283,7 +283,6 @@ static const struct pci_device_id atiixp[] = {
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP300_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), },
-	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), },
 
 	{ },
 };
diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 25aa575..3c563f0 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -323,7 +323,6 @@ int  rfcomm_connect_ind(struct rfcomm_session *s, u8 channel, struct rfcomm_dlc
 #define RFCOMM_RELEASE_ONHUP  1
 #define RFCOMM_HANGUP_NOW     2
 #define RFCOMM_TTY_ATTACHED   3
-#define RFCOMM_TTY_RELEASED   4
 
 struct rfcomm_dev_req {
 	s16      dev_id;
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 26e8c02..e1b8663 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -93,10 +93,6 @@ static void rfcomm_dev_destruct(struct rfcomm_dev *dev)
 
 	BT_DBG("dev %p dlc %p", dev, dlc);
 
-	write_lock_bh(&rfcomm_dev_lock);
-	list_del_init(&dev->list);
-	write_unlock_bh(&rfcomm_dev_lock);
-
 	rfcomm_dlc_lock(dlc);
 	/* Detach DLC if it's owned by this dev */
 	if (dlc->owner == dev)
@@ -158,13 +154,8 @@ static inline struct rfcomm_dev *rfcomm_dev_get(int id)
 	read_lock(&rfcomm_dev_lock);
 
 	dev = __rfcomm_dev_get(id);
-
-	if (dev) {
-		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
-			dev = NULL;
-		else
-			rfcomm_dev_hold(dev);
-	}
+	if (dev)
+		rfcomm_dev_hold(dev);
 
 	read_unlock(&rfcomm_dev_lock);
 
@@ -272,12 +263,6 @@ out:
 
 	tty_register_device(rfcomm_tty_driver, dev->id, rfcomm_get_device(dev));
 
-	if (IS_ERR(dev->tty_dev)) {
-		list_del(&dev->list);
-		kfree(dev);
-		return PTR_ERR(dev->tty_dev);
-	}
-
 	return dev->id;
 }
 
@@ -285,7 +270,10 @@ static void rfcomm_dev_del(struct rfcomm_dev *dev)
 {
 	BT_DBG("dev %p", dev);
 
-	set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
+	write_lock_bh(&rfcomm_dev_lock);
+	list_del_init(&dev->list);
+	write_unlock_bh(&rfcomm_dev_lock);
+
 	rfcomm_dev_put(dev);
 }
 
@@ -339,7 +327,7 @@ static int rfcomm_create_dev(struct sock *sk, void __user *arg)
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
 
-	BT_DBG("sk %p dev_id %d flags 0x%x", sk, req.dev_id, req.flags);
+	BT_DBG("sk %p dev_id %id flags 0x%x", sk, req.dev_id, req.flags);
 
 	if (req.flags != NOCAP_FLAGS && !capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -380,7 +368,7 @@ static int rfcomm_release_dev(void __user *arg)
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
 
-	BT_DBG("dev_id %d flags 0x%x", req.dev_id, req.flags);
+	BT_DBG("dev_id %id flags 0x%x", req.dev_id, req.flags);
 
 	if (!(dev = rfcomm_dev_get(req.dev_id)))
 		return -ENODEV;
@@ -429,8 +417,6 @@ static int rfcomm_get_dev_list(void __user *arg)
 
 	list_for_each(p, &rfcomm_dev_list) {
 		struct rfcomm_dev *dev = list_entry(p, struct rfcomm_dev, list);
-		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
-			continue;
 		(di + n)->id      = dev->id;
 		(di + n)->flags   = dev->flags;
 		(di + n)->state   = dev->dlc->state;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ba94969..915ea28 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -499,8 +499,8 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 	n->tc_verd = CLR_TC_MUNGED(n->tc_verd);
 	C(iif);
 #endif
-	skb_copy_secmark(n, skb);
 #endif
+	skb_copy_secmark(n, skb);
 	C(truesize);
 	atomic_set(&n->users, 1);
 	C(head);
