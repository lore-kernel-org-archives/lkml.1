Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbXHVIz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbXHVIz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbXHVIwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:40 -0400
Received: from 1wt.eu ([62.212.114.60]:1912 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577AbXHVIwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:38 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083945.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:52 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 08/58] Netpoll leak
Content-Disposition: inline; filename=0008-Netpoll-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[NETPOLL]: Fix a leak-n-bug in netpoll_cleanup()

93ec2c723e3f8a216dde2899aeb85c648672bc6b applied excessive duct tape to
the netpoll beast's netpoll_cleanup(), thus substituting one leak with
another, and opening up a little buglet :-)

net_device->npinfo (netpoll_info) is a shared and refcounted object and
cannot simply be set NULL the first time netpoll_cleanup() is called.
Otherwise, further netpoll_cleanup()'s see np->dev->npinfo == NULL and
become no-ops, thus leaking. And it's a bug too: the first call to
netpoll_cleanup() would thus (annoyingly) "disable" other (still alive)
netpolls too. Maybe nobody noticed this because netconsole (only user
of netpoll) never supported multiple netpoll objects earlier.

This is a trivial and obvious one-line fixlet.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/netpoll.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 522e441..3431d48 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -776,7 +776,6 @@ void netpoll_cleanup(struct netpoll *np)
 				spin_unlock_irqrestore(&npinfo->rx_lock, flags);
 			}
 
-			np->dev->npinfo = NULL;
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
  				skb_queue_purge(&npinfo->txq);
@@ -784,6 +783,7 @@ void netpoll_cleanup(struct netpoll *np)
  				flush_scheduled_work();
 
 				kfree(npinfo);
+				np->dev->npinfo = NULL;
 			}
 		}
 
-- 
1.5.2.5

-- 
