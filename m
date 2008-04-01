Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYDAOE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYDAOE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYDAOER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:04:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41564 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYDAOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:04:17 -0400
Date: Tue, 1 Apr 2008 15:32:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       marcel@holtmann.org, maxk@qualcomm.com
Subject: hci_usb.h: fix hard-to-trigger race
Message-ID: <20080401133212.GA24598@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If someone tries to _urb_unlink while _urb_queue_head is running,
he'll see _urb->queue == NULL and fail to do any locking. Prevent that
from happening by strategically placed barriers.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/bluetooth/hci_usb.h b/drivers/bluetooth/hci_usb.h
index 414080a..1790cc8 100644
--- a/drivers/bluetooth/hci_usb.h
+++ b/drivers/bluetooth/hci_usb.h
@@ -70,7 +70,8 @@ static inline void _urb_queue_head(struc
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	list_add(&_urb->list, &q->head); _urb->queue = q;
+	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
+	_urb->queue = q; mb(); list_add(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
@@ -78,19 +79,23 @@ static inline void _urb_queue_tail(struc
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	list_add_tail(&_urb->list, &q->head); _urb->queue = q;
+	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
+	_urb->queue = q; mb(); list_add_tail(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 static inline void _urb_unlink(struct _urb *_urb)
 {
-	struct _urb_queue *q = _urb->queue;
+	struct _urb_queue *q;
 	unsigned long flags;
-	if (q) {
-		spin_lock_irqsave(&q->lock, flags);
-		list_del(&_urb->list); _urb->queue = NULL;
-		spin_unlock_irqrestore(&q->lock, flags);
-	}
+
+	mb();
+	q = _urb->queue;
+	/* If q is NULL, it will die at easy-to-debug NULL pointer dereference.
+	   No need to BUG(). */
+	spin_lock_irqsave(&q->lock, flags);
+	list_del(&_urb->list); _urb->queue = NULL;
+	spin_unlock_irqrestore(&q->lock, flags);
 }
 
 struct hci_usb {


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
