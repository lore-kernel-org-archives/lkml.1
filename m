Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbXJ2Svs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbXJ2Svs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbXJ2Svk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:51:40 -0400
Received: from havoc.gtf.org ([69.61.125.42]:44684 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbXJ2Svj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:51:39 -0400
Date: Mon, 29 Oct 2007 14:51:38 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kkeil@suse.de
Subject: [git patch] remove long-standing ISDN warnings
Message-ID: <20071029185138.GA5126@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ack'd by maintainer.

Please pull from 'warnings-upstream' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings-upstream

to receive the following updates:

 drivers/isdn/capi/capidrv.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

Jeff Garzik (1):
      [ISDN] capidrv: address two longstanding warnings

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
