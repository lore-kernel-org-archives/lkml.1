Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbYHBFeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbYHBFeQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 01:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHBFeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 01:34:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:3268 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYHBFd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 01:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tCQfX6fXm1F7eo5jGGbILbVgvCwyl95j4rqx8ow0jaqXUWWL1Lmu8V+n882cPrs82a
         pssc7r8rWiN0cTonHmVh0D/zLnd1dHN3Cql6hhAz2rgph9rylyCxFjIqo3Tmn1YNAyB2
         qEbTX9I4sPlssUjWCHZF+Pfq5BobHaN+9sDpo=
From: tom.leiming@gmail.com
To: marcel@holtmann.org
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] hci_usb:replace mb with smp_mb
Date: Sat,  2 Aug 2008 13:33:45 +0800
Message-Id: <1217655225-4232-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.5.6.rc2.45.gdc92c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

smp_mb is enough for ordering memory operations among processors,and
mb is more expensive than smp_mb for UP machine, so replace it with
smp_mb().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/bluetooth/hci_usb.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_usb.h b/drivers/bluetooth/hci_usb.h
index 1790cc8..8e65991 100644
--- a/drivers/bluetooth/hci_usb.h
+++ b/drivers/bluetooth/hci_usb.h
@@ -70,8 +70,8 @@ static inline void _urb_queue_head(struct _urb_queue *q, struct _urb *_urb)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
-	_urb->queue = q; mb(); list_add(&_urb->list, &q->head);
+	/* _urb_unlink needs to know which spinlock to use, thus smp_mb(). */
+	_urb->queue = q; smp_mb(); list_add(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
@@ -79,8 +79,8 @@ static inline void _urb_queue_tail(struct _urb_queue *q, struct _urb *_urb)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&q->lock, flags);
-	/* _urb_unlink needs to know which spinlock to use, thus mb(). */
-	_urb->queue = q; mb(); list_add_tail(&_urb->list, &q->head);
+	/* _urb_unlink needs to know which spinlock to use, thus smp_mb(). */
+	_urb->queue = q; smp_mb(); list_add_tail(&_urb->list, &q->head);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
@@ -89,7 +89,7 @@ static inline void _urb_unlink(struct _urb *_urb)
 	struct _urb_queue *q;
 	unsigned long flags;
 
-	mb();
+	smp_mb();
 	q = _urb->queue;
 	/* If q is NULL, it will die at easy-to-debug NULL pointer dereference.
 	   No need to BUG(). */
-- 
1.5.6.rc2.45.gdc92c

