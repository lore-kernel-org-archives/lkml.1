Return-Path: <linux-kernel-owner+w=401wt.eu-S1764094AbXLMHOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764094AbXLMHOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762650AbXLMG57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55564 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762647AbXLMG55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:57 -0500
Date: Wed, 12 Dec 2007 22:53:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 44/60] TCP: Fix TCP header misalignment
Message-ID: <20071213065311.GT6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tcp-fix-tcp-header-misalignment.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Herbert Xu <herbert@gondor.apana.org.au>

[TCP]: Fix TCP header misalignment

[ Upstream commit: 21df56c6e2372e09c916111efb6c14c372a5ab2e ]

Indeed my previous change to alloc_pskb has made it possible
for the TCP header to be misaligned iff the MTU is not a multiple
of 4 (and less than a page).  So I suspect the optimised IPsec
MTU calculation is giving you just such an MTU :)

This patch fixes it by changing alloc_pskb to make sure that
the size is at least 32-bit aligned.  This does not cause the
problem fixed by the previous patch because max_header is always
32-bit aligned which means that in the SG/NOTSO case this will
be a no-op.

I thought about putting this in the callers but all the current
callers are from TCP.  If and when we get a non-TCP caller we
can always create a TCP wrapper for this function and move the
alignment over there.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/sock.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1200,6 +1200,9 @@ static inline struct sk_buff *sk_stream_
 {
 	struct sk_buff *skb;
 
+	/* The TCP header must be at least 32-bit aligned.  */
+	size = ALIGN(size, 4);
+
 	skb = alloc_skb_fclone(size + sk->sk_prot->max_header, gfp);
 	if (skb) {
 		skb->truesize += mem;

-- 
