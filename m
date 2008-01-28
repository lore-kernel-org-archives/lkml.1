Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbYA1LKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbYA1LKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYA1LK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:10:26 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49478 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751227AbYA1LKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:10:25 -0500
Date: Mon, 28 Jan 2008 22:10:18 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [AUDIT]: Increase skb->truesize in audit_expand
Message-ID: <20080128111018.GA6442@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

[AUDIT]: Increase skb->truesize in audit_expand

The recent UDP patch exposed this bug in the audit code.  It
was calling pskb_expand_head without increasing skb->truesize.
The caller of pskb_expand_head needs to do so because that function
is designed to be called in places where truesize is already fixed
and therefore it doesn't update its value.

Because the audit system is using it in a place where the truesize
has not yet been fixed, it needs to update its value manually.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/kernel/audit.c b/kernel/audit.c
index f93c271..801c946 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1200,13 +1200,17 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
 static inline int audit_expand(struct audit_buffer *ab, int extra)
 {
 	struct sk_buff *skb = ab->skb;
-	int ret = pskb_expand_head(skb, skb_headroom(skb), extra,
-				   ab->gfp_mask);
+	int oldtail = skb_tailroom(skb);
+	int ret = pskb_expand_head(skb, 0, extra, ab->gfp_mask);
+	int newtail = skb_tailroom(skb);
+
 	if (ret < 0) {
 		audit_log_lost("out of memory in audit_expand");
 		return 0;
 	}
-	return skb_tailroom(skb);
+
+	skb->truesize += newtail - oldtail;
+	return newtail;
 }
 
 /*
