Return-Path: <linux-kernel-owner+w=401wt.eu-S966122AbXHGV2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966122AbXHGV2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965137AbXHGU51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:57:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59995 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080AbXHGU5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:57:25 -0400
Date: Tue, 7 Aug 2007 13:49:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ville Tervo <ville.tervo@nokia.com>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [2.6.22.2 review 77/84] Keep rfcomm_dev on the list until it is
	freed
Message-ID: <20070807204923.GA23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="keep-rfcomm_dev-on-the-list-until-it-is-freed.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Tervo <ville.tervo@nokia.com>

This patch changes the RFCOMM TTY release process so that the TTY is kept
on the list until it is really freed. A new device flag is used to keep
track of released TTYs.

Signed-off-by: Ville Tervo <ville.tervo@nokia.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/bluetooth/rfcomm.h |    1 +
 net/bluetooth/rfcomm/tty.c     |   30 ++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 8 deletions(-)

--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -323,6 +323,7 @@ int  rfcomm_connect_ind(struct rfcomm_se
 #define RFCOMM_RELEASE_ONHUP  1
 #define RFCOMM_HANGUP_NOW     2
 #define RFCOMM_TTY_ATTACHED   3
+#define RFCOMM_TTY_RELEASED   4
 
 struct rfcomm_dev_req {
 	s16      dev_id;
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -95,6 +95,10 @@ static void rfcomm_dev_destruct(struct r
 
 	BT_DBG("dev %p dlc %p", dev, dlc);
 
+	write_lock_bh(&rfcomm_dev_lock);
+	list_del_init(&dev->list);
+	write_unlock_bh(&rfcomm_dev_lock);
+
 	rfcomm_dlc_lock(dlc);
 	/* Detach DLC if it's owned by this dev */
 	if (dlc->owner == dev)
@@ -156,8 +160,13 @@ static inline struct rfcomm_dev *rfcomm_
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
 
@@ -265,6 +274,12 @@ out:
 
 	dev->tty_dev = tty_register_device(rfcomm_tty_driver, dev->id, NULL);
 
+	if (IS_ERR(dev->tty_dev)) {
+		list_del(&dev->list);
+		kfree(dev);
+		return PTR_ERR(dev->tty_dev);
+	}
+
 	return dev->id;
 }
 
@@ -272,10 +287,7 @@ static void rfcomm_dev_del(struct rfcomm
 {
 	BT_DBG("dev %p", dev);
 
-	write_lock_bh(&rfcomm_dev_lock);
-	list_del_init(&dev->list);
-	write_unlock_bh(&rfcomm_dev_lock);
-
+	set_bit(RFCOMM_TTY_RELEASED, &dev->flags);
 	rfcomm_dev_put(dev);
 }
 
@@ -329,7 +341,7 @@ static int rfcomm_create_dev(struct sock
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
 
-	BT_DBG("sk %p dev_id %id flags 0x%x", sk, req.dev_id, req.flags);
+	BT_DBG("sk %p dev_id %d flags 0x%x", sk, req.dev_id, req.flags);
 
 	if (req.flags != NOCAP_FLAGS && !capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -370,7 +382,7 @@ static int rfcomm_release_dev(void __use
 	if (copy_from_user(&req, arg, sizeof(req)))
 		return -EFAULT;
 
-	BT_DBG("dev_id %id flags 0x%x", req.dev_id, req.flags);
+	BT_DBG("dev_id %d flags 0x%x", req.dev_id, req.flags);
 
 	if (!(dev = rfcomm_dev_get(req.dev_id)))
 		return -ENODEV;
@@ -419,6 +431,8 @@ static int rfcomm_get_dev_list(void __us
 
 	list_for_each(p, &rfcomm_dev_list) {
 		struct rfcomm_dev *dev = list_entry(p, struct rfcomm_dev, list);
+		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
+			continue;
 		(di + n)->id      = dev->id;
 		(di + n)->flags   = dev->flags;
 		(di + n)->state   = dev->dlc->state;

-- 
