Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab0BDR3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:29:12 -0500
Received: from kroah.org ([198.145.64.141]:34801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306Ab0BDRWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:11 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:15 2010
Message-Id: <20100204171515.390422663@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jarek Poplawski <jarkao2@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [48/74] ax25: netrom: rose: Fix timer oopses
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jarek Poplawski <jarkao2@gmail.com>

[ Upstream commit d00c362f1b0ff54161e0a42b4554ac621a9ef92d ]

Wrong ax25_cb refcounting in ax25_send_frame() and by its callers can
cause timer oopses (first reported with 2.6.29.6 kernel).

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=14905

Reported-by: Bernard Pidoux <bpidoux@free.fr>
Tested-by: Bernard Pidoux <bpidoux@free.fr>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/netrom.h  |    2 ++
 net/ax25/ax25_out.c   |    6 ++++++
 net/netrom/nr_route.c |   11 ++++++-----
 net/rose/rose_link.c  |    8 ++++++++
 net/rose/rose_route.c |    5 +++++
 5 files changed, 27 insertions(+), 5 deletions(-)

--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -132,6 +132,8 @@ static __inline__ void nr_node_put(struc
 static __inline__ void nr_neigh_put(struct nr_neigh *nr_neigh)
 {
 	if (atomic_dec_and_test(&nr_neigh->refcount)) {
+		if (nr_neigh->ax25)
+			ax25_cb_put(nr_neigh->ax25);
 		kfree(nr_neigh->digipeat);
 		kfree(nr_neigh);
 	}
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -92,6 +92,12 @@ ax25_cb *ax25_send_frame(struct sk_buff 
 #endif
 	}
 
+	/*
+	 * There is one ref for the state machine; a caller needs
+	 * one more to put it back, just like with the existing one.
+	 */
+	ax25_cb_hold(ax25);
+
 	ax25_cb_add(ax25);
 
 	ax25->state = AX25_STATE_1;
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -842,12 +842,13 @@ int nr_route_frame(struct sk_buff *skb, 
 	dptr  = skb_push(skb, 1);
 	*dptr = AX25_P_NETROM;
 
-	ax25s = ax25_send_frame(skb, 256, (ax25_address *)dev->dev_addr, &nr_neigh->callsign, nr_neigh->digipeat, nr_neigh->dev);
-	if (nr_neigh->ax25 && ax25s) {
-		/* We were already holding this ax25_cb */
+	ax25s = nr_neigh->ax25;
+	nr_neigh->ax25 = ax25_send_frame(skb, 256,
+					 (ax25_address *)dev->dev_addr,
+					 &nr_neigh->callsign,
+					 nr_neigh->digipeat, nr_neigh->dev);
+	if (ax25s)
 		ax25_cb_put(ax25s);
-	}
-	nr_neigh->ax25 = ax25s;
 
 	dev_put(dev);
 	ret = (nr_neigh->ax25 != NULL);
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -101,13 +101,17 @@ static void rose_t0timer_expiry(unsigned
 static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
 {
 	ax25_address *rose_call;
+	ax25_cb *ax25s;
 
 	if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
 		rose_call = (ax25_address *)neigh->dev->dev_addr;
 	else
 		rose_call = &rose_callsign;
 
+	ax25s = neigh->ax25;
 	neigh->ax25 = ax25_send_frame(skb, 260, rose_call, &neigh->callsign, neigh->digipeat, neigh->dev);
+	if (ax25s)
+		ax25_cb_put(ax25s);
 
 	return (neigh->ax25 != NULL);
 }
@@ -120,13 +124,17 @@ static int rose_send_frame(struct sk_buf
 static int rose_link_up(struct rose_neigh *neigh)
 {
 	ax25_address *rose_call;
+	ax25_cb *ax25s;
 
 	if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
 		rose_call = (ax25_address *)neigh->dev->dev_addr;
 	else
 		rose_call = &rose_callsign;
 
+	ax25s = neigh->ax25;
 	neigh->ax25 = ax25_find_cb(rose_call, &neigh->callsign, neigh->digipeat, neigh->dev);
+	if (ax25s)
+		ax25_cb_put(ax25s);
 
 	return (neigh->ax25 != NULL);
 }
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -234,6 +234,8 @@ static void rose_remove_neigh(struct ros
 
 	if ((s = rose_neigh_list) == rose_neigh) {
 		rose_neigh_list = rose_neigh->next;
+		if (rose_neigh->ax25)
+			ax25_cb_put(rose_neigh->ax25);
 		kfree(rose_neigh->digipeat);
 		kfree(rose_neigh);
 		return;
@@ -242,6 +244,8 @@ static void rose_remove_neigh(struct ros
 	while (s != NULL && s->next != NULL) {
 		if (s->next == rose_neigh) {
 			s->next = rose_neigh->next;
+			if (rose_neigh->ax25)
+				ax25_cb_put(rose_neigh->ax25);
 			kfree(rose_neigh->digipeat);
 			kfree(rose_neigh);
 			return;
@@ -810,6 +814,7 @@ void rose_link_failed(ax25_cb *ax25, int
 
 	if (rose_neigh != NULL) {
 		rose_neigh->ax25 = NULL;
+		ax25_cb_put(ax25);
 
 		rose_del_route_by_neigh(rose_neigh);
 		rose_kill_by_neigh(rose_neigh);


