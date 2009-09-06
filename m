Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbZIFTCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbZIFTCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 15:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758220AbZIFS7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:59:38 -0400
Received: from mail.pxnet.com ([195.227.45.7]:42882 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158AbZIFS7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:59:37 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 03/12] gigaset: linearize skb
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de
CC: Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090906-patch-gigaset-03.tilman@imap.cc>
In-Reply-To: <20090906-patch-gigaset-00.tilman@imap.cc>
References: <20090906-patch-gigaset-00.tilman@imap.cc>
Date: Sun,  6 Sep 2009 20:58:52 +0200 (CEST)
X-Spam-Score: -1.687 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code of the Gigaset driver assumes that sk_buff-s coming
from the ISDN4Linux subsystem are always linear. Explicitly
calling skb_linearize() is cheap if they are, but much more
robust in case they ever aren't.

Impact: robustness improvement
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/i4l.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/gigaset/i4l.c b/drivers/isdn/gigaset/i4l.c
index 9b22f9c..322f16e 100644
--- a/drivers/isdn/gigaset/i4l.c
+++ b/drivers/isdn/gigaset/i4l.c
@@ -51,6 +51,12 @@ static int writebuf_from_LL(int driverID, int channel, int ack,
 		return -ENODEV;
 	}
 	bcs = &cs->bcs[channel];
+
+	/* can only handle linear sk_buffs */
+	if (skb_linearize(skb) < 0) {
+		dev_err(cs->dev, "%s: skb_linearize failed\n", __func__);
+		return -ENOMEM;
+	}
 	len = skb->len;
 
 	gig_dbg(DEBUG_LLDATA,
-- 
1.6.2.1.214.ge986c

