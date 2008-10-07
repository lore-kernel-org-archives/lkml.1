Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYJGBAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYJGBAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbYJGApw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:52 -0400
Received: from ns.suse.de ([195.135.220.2]:47121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916AbYJGApv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:51 -0400
Date: Mon, 6 Oct 2008 17:39:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 56/71] ipsec: Fix pskb_expand_head corruption in
	xfrm_state_check_space
Message-ID: <20081007003957.GE3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0006-ipsec-Fix-pskb_expand_head-corruption-in-xfrm_state.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit d01dbeb6af7a0848063033f73c3d146fec7451f3 ]

We're never supposed to shrink the headroom or tailroom.  In fact,
shrinking the headroom is a fatal action.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/xfrm/xfrm_output.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -27,10 +27,14 @@ static int xfrm_state_check_space(struct
 		- skb_headroom(skb);
 	int ntail = dst->dev->needed_tailroom - skb_tailroom(skb);
 
-	if (nhead > 0 || ntail > 0)
-		return pskb_expand_head(skb, nhead, ntail, GFP_ATOMIC);
+	if (nhead <= 0) {
+		if (ntail <= 0)
+			return 0;
+		nhead = 0;
+	} else if (ntail < 0)
+		ntail = 0;
 
-	return 0;
+	return pskb_expand_head(skb, nhead, ntail, GFP_ATOMIC);
 }
 
 static int xfrm_output_one(struct sk_buff *skb, int err)

-- 
