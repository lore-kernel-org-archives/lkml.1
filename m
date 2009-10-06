Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbZJFWTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbZJFWTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933674AbZJFWTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:19:46 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:41017 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbZJFWTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:19:44 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 02/11] gigaset: linearize skb
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <isdn@linux-pingi.de>,
       Karsten Keil <keil@b1-systems.de>, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091006-patch-gigaset-02.tilman@imap.cc>
In-Reply-To: <20091006-patch-gigaset-00.tilman@imap.cc>
References: <20091006-patch-gigaset-00.tilman@imap.cc>
Date: Wed,  7 Oct 2009 00:18:31 +0200 (CEST)
X-Spam-Score: -2.12 () AWL,BAYES_00,RDNS_NONE
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

