Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbYFNAT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbYFNAT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760901AbYFNAOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:51897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761554AbYFNAOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:01 -0400
Date: Fri, 13 Jun 2008 17:11:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, James Chapman <jchapman@katalix.com>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 23/47] l2tp: avoid skb truesize bug if headroom is increased
Message-ID: <20080614001124.GW24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="l2tp-avoid-skb-truesize-bug-if-headroom-is-increased.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: James Chapman <jchapman@katalix.com>

[ upstream commit: 090c48d3dd5ea90b37350334aaed9a93b0c1e0a1 ]

A user reported seeing occasional bugs such as the following when
using the L2TP driver.

  SKB BUG: Invalid truesize (272) len=72, sizeof(sk_buff)=208

When L2TP adds its header in the transmit path, it might need to
increase the headroom of the skb. In some cases, the increased
headroom trips a kernel bug when the skb is freed because the skb has
grown beyond its truesize value. The fix is to increase the truesize
by the amount of headroom added, after orphaning the skb.

While here, fix a misleading comment.

Thanks to Iouri Kharon <bc-info@styx.cabel.net> for the initial
report and testing the fix.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/pppol2tp.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/net/pppol2tp.c
+++ b/drivers/net/pppol2tp.c
@@ -980,6 +980,8 @@ static int pppol2tp_xmit(struct ppp_chan
 	__wsum csum = 0;
 	struct udphdr *uh;
 	unsigned int len;
+	int old_headroom;
+	int new_headroom;
 
 	if (sock_flag(sk, SOCK_DEAD) || !(sk->sk_state & PPPOX_CONNECTED))
 		goto abort;
@@ -1001,16 +1003,18 @@ static int pppol2tp_xmit(struct ppp_chan
 
 	/* Check that there's enough headroom in the skb to insert IP,
 	 * UDP and L2TP and PPP headers. If not enough, expand it to
-	 * make room. Note that a new skb (or a clone) is
-	 * allocated. If we return an error from this point on, make
-	 * sure we free the new skb but do not free the original skb
-	 * since that is done by the caller for the error case.
+	 * make room. Adjust truesize.
 	 */
 	headroom = NET_SKB_PAD + sizeof(struct iphdr) +
 		sizeof(struct udphdr) + hdr_len + sizeof(ppph);
+	old_headroom = skb_headroom(skb);
 	if (skb_cow_head(skb, headroom))
 		goto abort;
 
+	new_headroom = skb_headroom(skb);
+	skb_orphan(skb);
+	skb->truesize += new_headroom - old_headroom;
+
 	/* Setup PPP header */
 	__skb_push(skb, sizeof(ppph));
 	skb->data[0] = ppph[0];
@@ -1065,7 +1069,6 @@ static int pppol2tp_xmit(struct ppp_chan
 	/* Get routing info from the tunnel socket */
 	dst_release(skb->dst);
 	skb->dst = dst_clone(__sk_dst_get(sk_tun));
-	skb_orphan(skb);
 	skb->sk = sk_tun;
 
 	/* Queue the packet to IP for output */

-- 
