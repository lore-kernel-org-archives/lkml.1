Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbYDQBOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbYDQBOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbYDQBHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:34 -0400
Received: from sous-sol.org ([216.99.217.87]:58853 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912AbYDQBHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:32 -0400
Message-Id: <20080417010348.780146429@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David S Miller <davem@davemloft.net>
Subject: TCP: Let skbs grow over a page on fast peers
Content-Disposition: inline; filename=tcp-let-skbs-grow-over-a-page-on-fast-peers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

Upstream commit: 69d1506731168d6845a76a303b2c45f7c05f3f2c

While testing the virtio-net driver on KVM with TSO I noticed
that TSO performance with a 1500 MTU is significantly worse
compared to the performance of non-TSO with a 16436 MTU.  The
packet dump shows that most of the packets sent are smaller
than a page.

Looking at the code this actually is quite obvious as it always
stop extending the packet if it's the first packet yet to be
sent and if it's larger than the MSS.  Since each extension is
bound by the page size, this means that (given a 1500 MTU) we're
very unlikely to construct packets greater than a page, provided
that the receiver and the path is fast enough so that packets can
always be sent immediately.

The fix is also quite obvious.  The push calls inside the loop
is just an optimisation so that we don't end up doing all the
sending at the end of the loop.  Therefore there is no specific
reason why it has to do so at MSS boundaries.  For TSO, the
most natural extension of this optimisation is to do the pushing
once the skb exceeds the TSO size goal.

This is what the patch does and testing with KVM shows that the
TSO performance with a 1500 MTU easily surpasses that of a 16436
MTU and indeed the packet sizes sent are generally larger than
16436.

I don't see any obvious downsides for slower peers or connections,
but it would be prudent to test this extensively to ensure that
those cases don't regress.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/ipv4/tcp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -583,7 +583,7 @@ new_segment:
 		if (!(psize -= copy))
 			goto out;
 
-		if (skb->len < mss_now || (flags & MSG_OOB))
+		if (skb->len < size_goal || (flags & MSG_OOB))
 			continue;
 
 		if (forced_push(tp)) {
@@ -829,7 +829,7 @@ new_segment:
 			if ((seglen -= copy) == 0 && iovlen == 0)
 				goto out;
 
-			if (skb->len < mss_now || (flags & MSG_OOB))
+			if (skb->len < size_goal || (flags & MSG_OOB))
 				continue;
 
 			if (forced_push(tp)) {

-- 
