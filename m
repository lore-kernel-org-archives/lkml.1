Return-Path: <linux-kernel-owner+w=401wt.eu-S1759886AbYDQBLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759886AbYDQBLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbYDQBHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:11 -0400
Received: from sous-sol.org ([216.99.217.87]:58804 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758174AbYDQBHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:07 -0400
Message-Id: <20080417010342.602468537@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       David S Miller <davem@davemloft.net>
Subject: netpoll: zap_completion_queue: adjust skb->users counter
Content-Disposition: inline; filename=netpoll-zap_completion_queue-adjust-skb-users-counter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jarek Poplawski <jarkao2@gmail.com>

Upstream commit: 8a455b087c9629b3ae3b521b4f1ed16672f978cc

zap_completion_queue() retrieves skbs from completion_queue where they have
zero skb->users counter.  Before dev_kfree_skb_any() it should be non-zero
yet, so it's increased now.

Reported-and-tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/core/netpoll.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -219,10 +219,12 @@ static void zap_completion_queue(void)
 		while (clist != NULL) {
 			struct sk_buff *skb = clist;
 			clist = clist->next;
-			if (skb->destructor)
+			if (skb->destructor) {
+				atomic_inc(&skb->users);
 				dev_kfree_skb_any(skb); /* put this one back */
-			else
+			} else {
 				__kfree_skb(skb);
+			}
 		}
 	}
 

-- 
