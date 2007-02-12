Return-Path: <linux-kernel-owner+w=401wt.eu-S964809AbXBLJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbXBLJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964797AbXBLJI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:57 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:33953 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:37:59 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 01/10] nfnetlink_log: don't count max(a,b) twice
Message-ID: <20070212003759.GB8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need local nlbufsiz (skb size) as nfulnl_alloc_skb() takes
the maximum anyway.

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.orig	2007-02-10 18:25:14.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:20:27.000000000 +0100
@@ -596,7 +596,6 @@ nfulnl_log_packet(unsigned int pf,
 	struct nfulnl_instance *inst;
 	const struct nf_loginfo *li;
 	unsigned int qthreshold;
-	unsigned int nlbufsiz;
 	unsigned int plen;
 
 	if (li_user && li_user->type == NF_LOG_TYPE_ULOG) 
@@ -672,13 +671,8 @@ nfulnl_log_packet(unsigned int pf,
 		return;
 	}
 
-	if (size > inst->nlbufsiz)
-		nlbufsiz = size;
-	else
-		nlbufsiz = inst->nlbufsiz;
-
 	if (!inst->skb) {
-		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {
+		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
 			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
 				inst->nlbufsiz, size);
 			goto alloc_failure;
@@ -691,7 +685,7 @@ nfulnl_log_packet(unsigned int pf,
 
 		__nfulnl_send(inst);
 
-		if (!(inst->skb = nfulnl_alloc_skb(nlbufsiz, size))) {
+		if (!(inst->skb = nfulnl_alloc_skb(inst->nlbufsiz, size))) {
 			UDEBUG("error in nfulnl_alloc_skb(%u, %u)\n",
 				inst->nlbufsiz, size);
 			goto alloc_failure;
