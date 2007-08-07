Return-Path: <linux-kernel-owner+w=401wt.eu-S935608AbXHGUvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935608AbXHGUvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935117AbXHGUr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:47:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51463 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbXHGUr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:47:58 -0400
Date: Tue, 7 Aug 2007 13:44:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 14/84] Netpoll leak
Message-ID: <20070807204400.GO23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="netpoll-leak.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

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

---
 net/core/netpoll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -781,7 +781,6 @@ void netpoll_cleanup(struct netpoll *np)
 				spin_unlock_irqrestore(&npinfo->rx_lock, flags);
 			}
 
-			np->dev->npinfo = NULL;
 			if (atomic_dec_and_test(&npinfo->refcnt)) {
 				skb_queue_purge(&npinfo->arp_tx);
 				skb_queue_purge(&npinfo->txq);
@@ -794,6 +793,7 @@ void netpoll_cleanup(struct netpoll *np)
 					kfree_skb(skb);
 				}
 				kfree(npinfo);
+				np->dev->npinfo = NULL;
 			}
 		}
 

-- 
