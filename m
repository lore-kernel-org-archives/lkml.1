Return-Path: <linux-kernel-owner+w=401wt.eu-S1946284AbXBCCok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946284AbXBCCok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946287AbXBCCoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:44:22 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53578 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946291AbXBCCoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:44:01 -0500
Message-Id: <20070203024629.665418000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:56 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       "David S. Miller" <davem@sunset.davemloft.net>
Subject: [patch 52/59] AF_PACKET: Check device down state before hard header callbacks.
Content-Disposition: inline; filename=af_packet-check-device-down-state-before-hard-header-callbacks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: David S. Miller <davem@sunset.davemloft.net>

If the device is down, invoking the device hard header callbacks
is not legal, so check it early.

Based upon a shaper OOPS report from Frederik Deweerdt.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/packet/af_packet.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.19.2.orig/net/packet/af_packet.c
+++ linux-2.6.19.2/net/packet/af_packet.c
@@ -358,6 +358,10 @@ static int packet_sendmsg_spkt(struct ki
 	if (dev == NULL)
 		goto out_unlock;
 	
+	err = -ENETDOWN;
+	if (!(dev->flags & IFF_UP))
+		goto out_unlock;
+
 	/*
 	 *	You may not queue a frame bigger than the mtu. This is the lowest level
 	 *	raw protocol and you must do your own fragmentation at this level.
@@ -406,10 +410,6 @@ static int packet_sendmsg_spkt(struct ki
 	if (err)
 		goto out_free;
 
-	err = -ENETDOWN;
-	if (!(dev->flags & IFF_UP))
-		goto out_free;
-
 	/*
 	 *	Now send it
 	 */
@@ -737,6 +737,10 @@ static int packet_sendmsg(struct kiocb *
 	if (sock->type == SOCK_RAW)
 		reserve = dev->hard_header_len;
 
+	err = -ENETDOWN;
+	if (!(dev->flags & IFF_UP))
+		goto out_unlock;
+
 	err = -EMSGSIZE;
 	if (len > dev->mtu+reserve)
 		goto out_unlock;
@@ -769,10 +773,6 @@ static int packet_sendmsg(struct kiocb *
 	skb->dev = dev;
 	skb->priority = sk->sk_priority;
 
-	err = -ENETDOWN;
-	if (!(dev->flags & IFF_UP))
-		goto out_free;
-
 	/*
 	 *	Now send it
 	 */

--
