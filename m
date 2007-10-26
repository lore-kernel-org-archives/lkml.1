Return-Path: <linux-kernel-owner+w=401wt.eu-S1762834AbXJZJoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762834AbXJZJoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbXJZJnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:43:40 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55655 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762335AbXJZJnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:43:39 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH v2] ISDN/capidrv: address two longstanding warnings
Message-Id: <20071026094323.B9CBD1F8138@havoc.gtf.org>
Date: Fri, 26 Oct 2007 05:43:23 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* change #warning to a code comment

* add comment and special ifdef'd 64-bit code for a situation where
  we must store a pointer into a CAPI field 'Data', which is fixed by
  the interface at 32 bits.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/capi/capidrv.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 476012b..48c1775 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -1843,6 +1843,7 @@ static int if_sendbuf(int id, int channel, int doack, struct sk_buff *skb)
 	int msglen;
 	u16 errcode;
 	u16 datahandle;
+	u32 data;
 
 	if (!card) {
 		printk(KERN_ERR "capidrv: if_sendbuf called with invalid driverId %d!\n",
@@ -1860,9 +1861,26 @@ static int if_sendbuf(int id, int channel, int doack, struct sk_buff *skb)
 		return 0;
 	}
 	datahandle = nccip->datahandle;
+
+	/*
+	 * Here we copy pointer skb->data into the 32-bit 'Data' field.
+	 * The 'Data' field is not used in practice in linux kernel
+	 * (neither in 32 or 64 bit), but should have some value,
+	 * since a CAPI message trace will display it.
+	 *
+	 * The correct value in the 32 bit case is the address of the
+	 * data, in 64 bit it makes no sense, we use 0 there.
+	 */
+
+#ifdef CONFIG_64BIT
+	data = 0;
+#else
+	data = (unsigned long) skb->data;
+#endif
+
 	capi_fill_DATA_B3_REQ(&sendcmsg, global.ap.applid, card->msgid++,
 			      nccip->ncci,	/* adr */
-			      (u32) skb->data,	/* Data */
+			      data,		/* Data */
 			      skb->len,		/* DataLength */
 			      datahandle,	/* DataHandle */
 			      0	/* Flags */
@@ -2123,7 +2141,10 @@ static int capidrv_delcontr(u16 contr)
 		printk(KERN_ERR "capidrv: delcontr: no contr %u\n", contr);
 		return -1;
 	}
-	#warning FIXME: maybe a race condition the card should be removed here from global list /kkeil
+
+	/* FIXME: maybe a race condition the card should be removed
+	 * here from global list /kkeil
+	 */
 	spin_unlock_irqrestore(&global_lock, flags);
 
 	del_timer(&card->listentimer);
-- 
1.5.2.4

