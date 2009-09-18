Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZISAAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZISAAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 20:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbZIRX7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 19:59:05 -0400
Received: from mail.pxnet.com ([195.227.45.7]:35098 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZIRX6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 19:58:44 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 03/12] gigaset: linearize skb
To: Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, davem@davemloft.net,
       i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-ID: <20090919-patch-gigaset-03.tilman@imap.cc>
In-Reply-To: <20090919-patch-gigaset-00.tilman@imap.cc>
References: <20090919-patch-gigaset-00.tilman@imap.cc>
Date: Sat, 19 Sep 2009 01:57:43 +0200 (CEST)
X-Spam-Score: -2.212 () BAYES_00,RDNS_NONE
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

