Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYKQIlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYKQIlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 03:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYKQIlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 03:41:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:35824 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbYKQIlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 03:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=O1maUoYF0bWDu5xq0qtoOfXj+Q2ruXYHJ9vUbzcK3ojZCkGL0pCMs1zsZfIpReN/bl
         5lXYNBF6b9FlKdYIetAjiRIvfyX+CDZ8P+Ostjf39wuKRwoLUGsU+m2WImD8LhyzEpTh
         pcVwlU7BTtRwgjvsrLSE1lntOKMTLmAUSTUYc=
Date: Mon, 17 Nov 2008 08:40:58 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Folkert van Heusden <folkert@vanheusden.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH] Re: [2.6.26] OOPS in __linkwatch_run_queue (unable to
	handle kernel NULL pointer dereference at 00000235)
Message-ID: <20081117084058.GA6345@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030020910.f97ee3fc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-10-2008 10:09, Andrew Morton wrote:
> (cc netdev)
> 
> On Mon, 27 Oct 2008 16:00:02 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
> 
>> Hi,                                                                                                                                                                                                
>>                                                                                                                                                                                                    
>> While running my http://vanheusden.com/pyk/ script (which randomly
>> inserts and removes modules) I triggered the folllowing oops in a 2.6.26
>> kernel on a pre-ht pentium 4 (hp pavillion laptop type zv5231ea):
>>
>> [ 1037.480097] BUG: unable to handle kernel NULL pointer dereference at 00000235
>> [ 1037.480188] IP: [<c0261078>] __linkwatch_run_queue+0x6d/0x15a
...

------------------->

net: link_watch: Don't add a linkwatch event before register_netdev()

b44 and some other network drivers run netif_carrier_off() before
register_netdev(). Then, if register fails, free_netdev() destruction
is done while dev is still referenced and held on the lweventlist.

Of course, it would be nice if all drivers could use some common order
of calling things like register_netdev() vs. netif_carrier_off(), but
since there is a lot of this I guess there is probably some reason,
so this patch doesn't change the order but assumes that such an early
netif_carrier_off() is only to set the __LINK_STATE_NOCARRIER flag,
and some netif_carrier_on()/_off() will still follow.

Reported-by: Folkert van Heusden <folkert@vanheusden.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index bf8f7af..393c2ba 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -216,8 +216,13 @@ void linkwatch_fire_event(struct net_device *dev)
 	bool urgent = linkwatch_urgent_event(dev);
 
 	if (!test_and_set_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state)) {
-		dev_hold(dev);
+		/* don't add an event before register_netdev(); it can fail */
+		if (!test_bit(__LINK_STATE_PRESENT, &dev->state)) {
+			WARN_ON(1);
+			return;
+		}
 
+		dev_hold(dev);
 		linkwatch_add_event(dev);
 	} else if (!urgent)
 		return;
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 80c8f3d..8f99c06 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -286,7 +286,8 @@ EXPORT_SYMBOL(netif_carrier_on);
 void netif_carrier_off(struct net_device *dev)
 {
 	if (!test_and_set_bit(__LINK_STATE_NOCARRIER, &dev->state))
-		linkwatch_fire_event(dev);
+		if (test_bit(__LINK_STATE_PRESENT, &dev->state))
+			linkwatch_fire_event(dev);
 }
 EXPORT_SYMBOL(netif_carrier_off);
 
