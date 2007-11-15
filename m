Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbXKOGos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbXKOGos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761428AbXKOGmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55094 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760859AbXKOGmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:46 -0500
Date: Wed, 14 Nov 2007 22:40:22 -0800
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
       James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/16] Fix L2TP oopses.
Message-ID: <20071115064022.GG18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-l2tp-oopses.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: James Chapman <jchapman@katalix.com>

changeset 91781004b9c029ee55b7aa9ef950a373ba865dc6 in mainline.

[PPP]: L2TP: Fix oops in transmit and receive paths

Changes made on 18-sep to fix skb handling in the pppol2tp driver
broke the transmit and receive paths. Users are only running into this
now because distros are now using 2.6.23 and I must have messed up
when I tested the change.

For receive, we now do our own calculation of how much to pull from
the skb (variable length L2TP header) rather than using
skb_transport_offset(). Also, if the skb isn't a data packet, it must
be passed back to UDP with skb->data pointing to the UDP header.

For transmit, make sure skb->sk is set up because ip_queue_xmit()
needs it.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pppol2tp.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -487,7 +487,7 @@ static int pppol2tp_recv_core(struct soc
 {
 	struct pppol2tp_session *session = NULL;
 	struct pppol2tp_tunnel *tunnel;
-	unsigned char *ptr;
+	unsigned char *ptr, *optr;
 	u16 hdrflags;
 	u16 tunnel_id, session_id;
 	int length;
@@ -495,7 +495,7 @@ static int pppol2tp_recv_core(struct soc
 
 	tunnel = pppol2tp_sock_to_tunnel(sock);
 	if (tunnel == NULL)
-		goto error;
+		goto no_tunnel;
 
 	/* UDP always verifies the packet length. */
 	__skb_pull(skb, sizeof(struct udphdr));
@@ -508,7 +508,7 @@ static int pppol2tp_recv_core(struct soc
 	}
 
 	/* Point to L2TP header */
-	ptr = skb->data;
+	optr = ptr = skb->data;
 
 	/* Get L2TP header flags */
 	hdrflags = ntohs(*(__be16*)ptr);
@@ -636,12 +636,14 @@ static int pppol2tp_recv_core(struct soc
 	/* If offset bit set, skip it. */
 	if (hdrflags & L2TP_HDRFLAG_O) {
 		offset = ntohs(*(__be16 *)ptr);
-		skb->transport_header += 2 + offset;
-		if (!pskb_may_pull(skb, skb_transport_offset(skb) + 2))
-			goto discard;
+		ptr += 2 + offset;
 	}
 
-	__skb_pull(skb, skb_transport_offset(skb));
+	offset = ptr - optr;
+	if (!pskb_may_pull(skb, offset))
+		goto discard;
+
+	__skb_pull(skb, offset);
 
 	/* Skip PPP header, if present.	 In testing, Microsoft L2TP clients
 	 * don't send the PPP header (PPP header compression enabled), but
@@ -651,6 +653,9 @@ static int pppol2tp_recv_core(struct soc
 	 * Note that skb->data[] isn't dereferenced from a u16 ptr here since
 	 * the field may be unaligned.
 	 */
+	if (!pskb_may_pull(skb, 2))
+		goto discard;
+
 	if ((skb->data[0] == 0xff) && (skb->data[1] == 0x03))
 		skb_pull(skb, 2);
 
@@ -708,6 +713,10 @@ discard:
 	return 0;
 
 error:
+	/* Put UDP header back */
+	__skb_push(skb, sizeof(struct udphdr));
+
+no_tunnel:
 	return 1;
 }
 
@@ -1049,6 +1058,8 @@ static int pppol2tp_xmit(struct ppp_chan
 	/* Get routing info from the tunnel socket */
 	dst_release(skb->dst);
 	skb->dst = sk_dst_get(sk_tun);
+	skb_orphan(skb);
+	skb->sk = sk_tun;
 
 	/* Queue the packet to IP for output */
 	len = skb->len;

-- 
