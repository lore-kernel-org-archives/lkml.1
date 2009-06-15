Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbZFOP0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbZFOP0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbZFOP0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:26:10 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40764 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761390AbZFOP0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:26:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=qVn4XwIt2letohY1EaXAEGGXtmq76hJSO1jOq7giAP6miq/K0oZ3iGj2FkNJQnqm9E
         1K1x/09fr8HdhyXHibsP6gkAoZ8+sHfSYuf7wecM0TrVMTiRdPbFSHm2fNWeaT6Hkh7U
         JFD2umyv74oP0KCIZboDA/X1uuxmGz1do9Vqo=
Date: Mon, 15 Jun 2009 17:25:42 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Robert Olsson <robert.olsson@its.uu.se>, Yan Zheng <zheng.yan@oracle.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/1] Re: [BUG] fib_tries related Oops in 2.6.30
Message-ID: <20090615152542.GB2767@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615065333.GA4378@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipv4: Fix fib_trie rebalancing, part 2

My previous patch, which explicitly delays freeing of tnodes by adding
them to the list to flushe them after the update is finished, isn't
strict enough. It treats exceptionally tnodes without parent, assuming
they are newly created, so "invisible" for the read side yet. But the
top tnode doesn't have parent as well, so we have to exclude all
exceptions (at least until a better way is found).

Reported-by: Yan Zheng <zheng.yan@oracle.com>
Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

 net/ipv4/fib_trie.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index d1a39b1..64395b0 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -391,13 +391,8 @@ static inline void tnode_free(struct tnode *tn)
 static void tnode_free_safe(struct tnode *tn)
 {
 	BUG_ON(IS_LEAF(tn));
-
-	if (node_parent((struct node *) tn)) {
-		tn->tnode_free = tnode_free_head;
-		tnode_free_head = tn;
-	} else {
-		tnode_free(tn);
-	}
+	tn->tnode_free = tnode_free_head;
+	tnode_free_head = tn;
 }
 
 static void tnode_free_flush(void)
