Return-Path: <linux-kernel-owner+w=401wt.eu-S1765192AbYBGAEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765192AbYBGAEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763802AbYBFX4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:56:47 -0500
Received: from ns.suse.de ([195.135.220.2]:45820 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764265AbYBFX4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:56:45 -0500
Date: Wed, 6 Feb 2008 15:52:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/73] ATM: Check IP header validity in mpc_send_packet
Message-ID: <20080206235210.GW13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atm-check-ip-header-validity-in-mpc_send_packet.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ATM]: Check IP header validity in mpc_send_packet

[ Upstream commit: 1c9b7aa1eb40ab708ef3242f74b9a61487623168 ]

Al went through the ip_fast_csum callers and found this piece of code
that did not validate the IP header.  While root crashing the machine
by sending bogus packets through raw or AF_PACKET sockets isn't that
serious, it is still nice to react gracefully.

This patch ensures that the skb has enough data for an IP header and
that the header length field is valid.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/atm/mpc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -542,6 +542,13 @@ static int mpc_send_packet(struct sk_buf
 	if (eth->h_proto != htons(ETH_P_IP))
 		goto non_ip; /* Multi-Protocol Over ATM :-) */
 
+	/* Weed out funny packets (e.g., AF_PACKET or raw). */
+	if (skb->len < ETH_HLEN + sizeof(struct iphdr))
+		goto non_ip;
+	skb_set_network_header(skb, ETH_HLEN);
+	if (skb->len < ETH_HLEN + ip_hdr(skb)->ihl * 4 || ip_hdr(skb)->ihl < 5)
+		goto non_ip;
+
 	while (i < mpc->number_of_mps_macs) {
 		if (!compare_ether_addr(eth->h_dest, (mpc->mps_macs + i*ETH_ALEN)))
 			if ( send_via_shortcut(skb, mpc) == 0 )           /* try shortcut */

-- 
