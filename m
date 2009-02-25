Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZBYOkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZBYOkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZBYOkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:40:05 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:36719 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbZBYOkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:40:04 -0500
Message-ID: <49A5583D.5050502@f-seidel.de>
Date: Wed, 25 Feb 2009 15:39:57 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       akpm@linux-foundation.org, hannes@hanneseder.net,
       johannes@sipsolutions.net, "David S. Miller" <davem@davemloft.net>,
       Frank Seidel <fseidel@suse.de>, Frank Seidel <frank@f-seidel.de>,
       wangchen@cn.fujitsu.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH][trivial] airo: reduce stack memory footpring
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Applying kernel janitors todos (reduce stack
footprint where possible) to airo wireless driver.
(Before 1124 bytes on i386, now 876)

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/net/wireless/airo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -7031,11 +7031,15 @@ static int airo_get_aplist(struct net_de
 {
 	struct airo_info *local = dev->ml_priv;
 	struct sockaddr *address = (struct sockaddr *) extra;
-	struct iw_quality qual[IW_MAX_AP];
+	struct iw_quality *qual;
 	BSSListRid BSSList;
 	int i;
 	int loseSync = capable(CAP_NET_ADMIN) ? 1: -1;
 
+	qual = kmalloc(IW_MAX_AP * sizeof(*qual), GFP_KERNEL);
+	if (!qual)
+		return -ENOMEM;
+
 	for (i = 0; i < IW_MAX_AP; i++) {
 		u16 dBm;
 		if (readBSSListRid(local, loseSync, &BSSList))
@@ -7090,6 +7094,7 @@ static int airo_get_aplist(struct net_de
 	}
 	dwrq->length = i;
 
+	kfree(qual);
 	return 0;
 }
 
