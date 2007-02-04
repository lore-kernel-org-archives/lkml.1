Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXBDPfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXBDPfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 10:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXBDPfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 10:35:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:4440 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbXBDPfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 10:35:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent:from;
        b=crjfD+FAjjCk6KPA3Tv7FaxulStJFdqWnTFuVrJM03ONhQkMsweGrO85si7kXLBZfNHa3AtsDtM5iQbdoMF+VWDqIeXaMtUlSFGK/syVjznDfpk9jxXTgCgrdJJR9PqDfsk8bmX5CjP/2OcKBXlm+6Oj6waKqdkAFDo1J7UT89E=
Date: Sun, 4 Feb 2007 16:34:54 +0100
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Subject: [PATCH] ipv4: remove a call to skb_queue_len() in inet_diag.c
Message-ID: <20070204153454.GA6098@unknown-00-0d-60-79-ca-00.lan>
Mail-Followup-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
From: Thomas Hisch <t.hisch@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


remove unneeded call to skb_queue_len (skb_dequeue already checks queuelen) and
replace a sizeof() by a Netlink Macro

Signed-off-by: Thomas Hisch <t.hisch@gmail.com>
---

sorry, my previous version of this patch didn't conform to the Codingstyle document.
now everything should be fine.

 net/ipv4/inet_diag.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 77761ac..9cf27c7 100644
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
+	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
 		inet_diag_rcv_skb(skb);
 		kfree_skb(skb);
 	}
-- 
1.5.0.rc3.22.g5057
