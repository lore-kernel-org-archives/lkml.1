Return-Path: <linux-kernel-owner+w=401wt.eu-S937236AbYBWAoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937236AbYBWAoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763764AbYBWAfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:35:16 -0500
Received: from mx1.suse.de ([195.135.220.2]:44883 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764051AbYBWAfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:35:13 -0500
Date: Fri, 22 Feb 2008 16:30:54 -0800
From: Greg KH <gregkh@suse.de>
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
       James Morris <jmorris@namei.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 22/38] AUDIT: Increase skb->truesize in audit_expand
Message-ID: <20080223003054.GW7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="audit-increase-skb-truesize-in-audit_expand.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: 406a1d868001423c85a3165288e566e65f424fe6

The recent UDP patch exposed this bug in the audit code.  It
was calling pskb_expand_head without increasing skb->truesize.
The caller of pskb_expand_head needs to do so because that function
is designed to be called in places where truesize is already fixed
and therefore it doesn't update its value.

Because the audit system is using it in a place where the truesize
has not yet been fixed, it needs to update its value manually.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/audit.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1200,13 +1200,17 @@ struct audit_buffer *audit_log_start(str
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

-- 
