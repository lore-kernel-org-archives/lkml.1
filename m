Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbXJYIH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbXJYIH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 04:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbXJYIGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 04:06:20 -0400
Received: from havoc.gtf.org ([69.61.125.42]:39479 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbXJYIGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 04:06:16 -0400
To: LKML <linux-kernel@vger.kernel.org>, kkeil@suse.de
Message-Id: <42205df7291ce7109866f9dbb5d06e481337e776.1193299380.git.jeff@garzik.org>
In-Reply-To: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH] ISDN/capidrv: fix casting warning
Date: Thu, 25 Oct 2007 04:06:16 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/capi/capidrv.c: In function 'if_sendbuf':
drivers/isdn/capi/capidrv.c:1865: warning: cast from pointer to integer
of different size

We are passing a kernel pointer, skb->data, but the interface itself is
limited to 32 bits.  A future changeset may want to mark this code
32-bit only, if it turns out cmsg->Data value truncation on 64-bit
platforms is problematic in practice.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/isdn/capi/capidrv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 44f954d..a4814e1 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -1862,7 +1862,7 @@ static int if_sendbuf(int id, int channel, int doack, struct sk_buff *skb)
 	datahandle = nccip->datahandle;
 	capi_fill_DATA_B3_REQ(&sendcmsg, global.ap.applid, card->msgid++,
 			      nccip->ncci,	/* adr */
-			      (u32) skb->data,	/* Data */
+			      (unsigned long) skb->data, /* Data */
 			      skb->len,		/* DataLength */
 			      datahandle,	/* DataHandle */
 			      0	/* Flags */
-- 
1.5.2.4

