Return-Path: <linux-kernel-owner+w=401wt.eu-S933964AbXHWWe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964AbXHWWe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933125AbXHWW3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:29:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbXHWW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:29:00 -0400
Date: Thu, 23 Aug 2007 15:26:58 -0700
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
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/28] SNAP: Fix SNAP protocol header accesses.
Message-ID: <20070823222658.GN18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="snap-fix-snap-protocol-header-accesses.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

The snap_rcv code reads 5 bytes so we should make sure that
we have 5 bytes in the head before proceeding.

Based on diagnosis and fix by Evgeniy Polyakov, reported by
Alan J. Wylie.

Patch also kills the skb->sk assignment before kfree_skb
since it's redundant.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/802/psnap.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -55,6 +55,9 @@ static int snap_rcv(struct sk_buff *skb,
 		.type = __constant_htons(ETH_P_SNAP),
 	};
 
+	if (unlikely(!pskb_may_pull(skb, 5)))
+		goto drop;
+
 	rcu_read_lock();
 	proto = find_snap_client(skb_transport_header(skb));
 	if (proto) {
@@ -62,14 +65,18 @@ static int snap_rcv(struct sk_buff *skb,
 		skb->transport_header += 5;
 		skb_pull_rcsum(skb, 5);
 		rc = proto->rcvfunc(skb, dev, &snap_packet_type, orig_dev);
-	} else {
-		skb->sk = NULL;
-		kfree_skb(skb);
-		rc = 1;
 	}
-
 	rcu_read_unlock();
+
+	if (unlikely(!proto))
+		goto drop;
+
+out:
 	return rc;
+
+drop:
+	kfree_skb(skb);
+	goto out;
 }
 
 /*

-- 
