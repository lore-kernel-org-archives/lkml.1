Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbXJ3XS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbXJ3XS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXJ3XSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:18:20 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:39085 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbXJ3XST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:18:19 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 19:18:19 EDT
Date: Wed, 31 Oct 2007 00:10:52 +0100
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: den@openvz.org, davem@davemloft.net, dex@dragonslave.de,
       johnpol@2ka.mipt.ru
Subject: [PATCH] Fix a spurious kfree_skb() call
Message-ID: <20071030231051.GA3636@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a spurious call to kfree_skb() in the connector rx_skb handler.

This fixes a regression introduced by the '[NET]: make netlink user ->
kernel interface synchronious' patch (cd40b7d3983c708aabe3d3008ec64ffce56d33b0)

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 0e328d3..6883fcb 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -218,7 +218,7 @@ static void cn_rx_skb(struct sk_buff *__skb)
 		    skb->len < nlh->nlmsg_len ||
 		    nlh->nlmsg_len > CONNECTOR_MAX_MSG_SIZE) {
 			kfree_skb(skb);
-			goto out;
+			return;
 		}
 
 		len = NLMSG_ALIGN(nlh->nlmsg_len);
@@ -229,9 +229,6 @@ static void cn_rx_skb(struct sk_buff *__skb)
 		if (err < 0)
 			kfree_skb(skb);
 	}
-
-out:
-	kfree_skb(__skb);
 }
 
 /*

