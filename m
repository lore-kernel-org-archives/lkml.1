Return-Path: <linux-kernel-owner+w=401wt.eu-S1763709AbZBNBNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763709AbZBNBNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZBNBB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:56 -0500
Received: from kroah.org ([198.145.64.141]:39807 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761351AbZBNBBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:54 -0500
Date: Fri, 13 Feb 2009 16:59:08 -0800
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
Subject: [patch 32/47] net: Fix frag_list handling in skb_seq_read
Message-ID: <20090214005908.GG11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-frag_list-handling-in-skb_seq_read.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 95e3b24cfb4ec0479d2c42f7a1780d68063a542a ]

The frag_list handling was broken in skb_seq_read:

1) We didn't add the stepped offset when looking at the head
are of fragments other than the first.

2) We didn't take the stepped offset away when setting the data
pointer in the head area.

3) The frag index wasn't reset.

This patch fixes both issues.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/skbuff.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2001,10 +2001,10 @@ unsigned int skb_seq_read(unsigned int c
 		return 0;
 
 next_skb:
-	block_limit = skb_headlen(st->cur_skb);
+	block_limit = skb_headlen(st->cur_skb) + st->stepped_offset;
 
 	if (abs_offset < block_limit) {
-		*data = st->cur_skb->data + abs_offset;
+		*data = st->cur_skb->data + (abs_offset - st->stepped_offset);
 		return block_limit - abs_offset;
 	}
 
@@ -2046,6 +2046,7 @@ next_skb:
 	} else if (st->root_skb == st->cur_skb &&
 		   skb_shinfo(st->root_skb)->frag_list) {
 		st->cur_skb = skb_shinfo(st->root_skb)->frag_list;
+		st->frag_idx = 0;
 		goto next_skb;
 	}
 

