Return-Path: <linux-kernel-owner+w=401wt.eu-S1752239AbXBDO3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbXBDO3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 09:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbXBDO3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 09:29:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:20566 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbXBDO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 09:29:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=eSmfbBlRtOr0h6fiPIs4Ky83xcyw5q6TNe19Y18/nfOP9xDWNC4ASkLu1/9P67oeYw4X+puYiIVprNzIGId89//xJWsygLLlYP0CD3awBNryCPanQ/WNPM4M757pOAVkS371+hZnPSy4W3g8Vh90pOwxh2oIrvM5GhiYGlj1xdQ=
Date: Sun, 4 Feb 2007 15:29:21 +0100
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH] ipv4: remove a call to skb_queue_len() in inet_diag.c
Message-ID: <20070204142921.GA5787@unknown-00-0d-60-79-ca-00.lan>
Mail-Followup-To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0612311547200.30821@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612311547200.30821@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
From: Thomas Hisch <t.hisch@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove unneeded call to skb_queue_len (skb_dequeue already checks queuelen) and
replace a sizeof() by a Netlink Macro

Signed-off-by: Thomas Hisch <t.hisch@gmail.com>
---
 net/ipv4/inet_diag.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 77761ac..ccd7fab 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -846,7 +846,7 @@ static inline void inet_diag_rcv_skb(struct sk_buff *skb)
 		int err;
 		struct nlmsghdr *nlh = (struct nlmsghdr *)skb->data;
 
-		if (nlh->nlmsg_len < sizeof(*nlh) ||
+		if (nlh->nlmsg_len < NLMSG_HDRLEN ||
 		    skb->len < nlh->nlmsg_len)
 			return;
 		err = inet_diag_rcv_msg(skb, nlh);
@@ -858,9 +858,8 @@ static inline void inet_diag_rcv_skb(struct sk_buff *skb)
 static void inet_diag_rcv(struct sock *sk, int len)
 {
 	struct sk_buff *skb;
-	unsigned int qlen = skb_queue_len(&sk->sk_receive_queue);
 
-	while (qlen-- && (skb = skb_dequeue(&sk->sk_receive_queue))) {
+	while (skb = skb_dequeue(&sk->sk_receive_queue)) {
 		inet_diag_rcv_skb(skb);
 		kfree_skb(skb);
 	}
-- 
1.5.0.rc3.22.g5057

