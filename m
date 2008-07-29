Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYG2LlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYG2LlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 07:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbYG2LlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 07:41:01 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:54000 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbYG2LlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=w7mMkCJKHUJJ5xeDcmf4IoLGIkL2ZEnQJAdFr5I5wD4GSe+QdYigOnuiPgj11rJjyP
         lQWNBULkGC+uhGcbgHftdpRodgnvky16M6E/cTqsb0332w/nJHMZJ8m3oqNPc3AF1yv3
         655T8vzhKwGrdW17CB5Eu51dYkaZKYQPG8oHc=
Date: Tue, 29 Jul 2008 13:40:30 +0200
To: Roland Dreier <rolandd@cisco.com>,
       Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Julia Lawall <julia@diku.dk>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] IB/ipath: use unsigned long for irqflags
Message-ID: <20080729114030.GA26181@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PS: Using a bit more context once the patch is applied, it's easier to spot
where the flags are used.

The semantic patch I used was this:

@@
expression lock;
identifier flags;
expression subclass;
@@

- unsigned int flags;
+ unsigned long flags;

...

<+...

(
 spin_lock_irqsave(lock, flags)
|
 _spin_lock_irqsave(lock)
|
 spin_unlock_irqrestore(lock, flags)
|
 _spin_unlock_irqrestore(lock, flags)
|
 read_lock_irqsave(lock, flags)
|
 _read_lock_irqsave(lock)
|
 read_unlock_irqrestore(lock, flags)
|
 _read_unlock_irqrestore(lock, flags)
|
 write_lock_irqsave(lock, flags)
|
 _write_lock_irqsave(lock)
|
 write_unlock_irqrestore(lock, flags)
|
 _write_unlock_irqrestore(lock, flags)
|
 spin_lock_irqsave_nested(lock, flags, subclass)
|
 _spin_lock_irqsave_nested(lock, subclass)
|
 spin_unlock_irqrestore(lock, flags)
|
 _spin_unlock_irqrestore(lock, flags)
|
 _raw_spin_lock_flags(lock, flags)
|
 __raw_spin_lock_flags(lock, flags)
)

...+>


>From 5f2136195f7c345c7d68925029a66aa4e41ad4e8 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 29 Jul 2008 13:28:58 +0200
Subject: [PATCH] IB/ipath: use unsigned long for irqflags

This patch was generated using the Coccinelle framework.

Cc: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: Julia Lawall <julia@diku.dk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/infiniband/hw/ipath/ipath_verbs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 55c7188..b766e40 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1021,7 +1021,7 @@ static void sdma_complete(void *cookie, int status)
 	struct ipath_verbs_txreq *tx = cookie;
 	struct ipath_qp *qp = tx->qp;
 	struct ipath_ibdev *dev = to_idev(qp->ibqp.device);
-	unsigned int flags;
+	unsigned long flags;
 	enum ib_wc_status ibs = status == IPATH_SDMA_TXREQ_S_OK ?
 		IB_WC_SUCCESS : IB_WC_WR_FLUSH_ERR;
 
@@ -1051,7 +1051,7 @@ static void sdma_complete(void *cookie, int status)
 
 static void decrement_dma_busy(struct ipath_qp *qp)
 {
-	unsigned int flags;
+	unsigned long flags;
 
 	if (atomic_dec_and_test(&qp->s_dma_busy)) {
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -1221,7 +1221,7 @@ static int ipath_verbs_send_pio(struct ipath_qp *qp,
 	unsigned flush_wc;
 	u32 control;
 	int ret;
-	unsigned int flags;
+	unsigned long flags;
 
 	piobuf = ipath_getpiobuf(dd, plen, NULL);
 	if (unlikely(piobuf == NULL)) {
-- 
1.5.5.1

