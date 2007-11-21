Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbXKUMpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbXKUMpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 07:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbXKUMpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 07:45:33 -0500
Received: from havoc.gtf.org ([69.61.125.42]:38634 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbXKUMpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 07:45:33 -0500
Date: Wed, 21 Nov 2007 07:45:32 -0500
From: Jeff Garzik <jeff@garzik.org>
To: netdev@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC/PATCH] SO_NO_CHECK for IPv6
Message-ID: <20071121124532.GA17263@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


SO_NO_CHECK support for IPv6 appeared to be missing. This is presented,
based on a reading of net/ipv4/udp.c.

I wonder if IPv4's CHECKSUM_PARTIAL check from udp_push_pending_frames()
also needs to be copied to IPv6?

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 net/ipv6/udp.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ee1cc3f..7927e69 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -538,9 +538,14 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 	uh->len = htons(up->len);
 	uh->check = 0;
 
-	if (up->pcflag)
+	if (up->pcflag)					/*     UDP-Lite      */
 		csum = udplite_csum_outgoing(sk, skb);
-	 else
+
+	else if (sk->sk_no_check == UDP_CSUM_NOXMIT) {	/* UDP csum disabled */
+		skb->ip_summed = CHECKSUM_NONE;
+		goto send;
+
+	} else
 		csum = udp_csum_outgoing(sk, skb);
 
 	/* add protocol-dependent pseudo-header */
@@ -549,6 +554,7 @@ static int udp_v6_push_pending_frames(struct sock *sk)
 	if (uh->check == 0)
 		uh->check = CSUM_MANGLED_0;
 
+send:
 	err = ip6_push_pending_frames(sk);
 out:
 	up->len = 0;
