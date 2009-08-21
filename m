Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbZHURVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbZHURVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932621AbZHURVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:21:43 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:50972 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534AbZHURVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:21:42 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH RFC 1/6] gigaset: fix reject/hangup handling
To: i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090821-patch-01.tilman@imap.cc>
In-Reply-To: <20090821-patch-00.tilman@imap.cc>
References: <20090821-patch-00.tilman@imap.cc>
Date: Fri, 21 Aug 2009 19:21:34 +0200 (CEST)
X-Spam-Score: -1.128 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signal D channel disconnect in a few cases where it was missed,
including when an incoming call is disconnected before it was
accepted.

Impact: error handling improvement
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/ev-layer.c |   5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/isdn/gigaset/ev-layer.c b/drivers/isdn/gigaset/ev-layer.c
index 2d91049..31082a6 100644
--- a/drivers/isdn/gigaset/ev-layer.c
+++ b/drivers/isdn/gigaset/ev-layer.c
@@ -707,6 +707,11 @@ static void disconnect(struct at_state_t **at_state_p)
 	if (bcs) {
 		/* B channel assigned: invoke hardware specific handler */
 		cs->ops->close_bchannel(bcs);
+		/* notify LL */
+		if (bcs->chstate & (CHS_D_UP | CHS_NOTIFY_LL)) {
+			bcs->chstate &= ~(CHS_D_UP | CHS_NOTIFY_LL);
+			gigaset_i4l_channel_cmd(bcs, ISDN_STAT_DHUP);
+		}
 	} else {
 		/* no B channel assigned: just deallocate */
 		spin_lock_irqsave(&cs->lock, flags);
-- 
1.6.2.1.214.ge986c

