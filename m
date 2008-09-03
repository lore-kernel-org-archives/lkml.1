Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbYICWPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbYICWPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYICWOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:14:40 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:37780 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbYICWOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:14:38 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 18:14:38 EDT
From: Ilya Yanok <yanok@emcraft.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, wd@denx.de, Yuri Tikhonov <yur@emcraft.com>
Subject: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Thu,  4 Sep 2008 01:43:51 +0400
Message-Id: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
X-Mailer: git-send-email 1.5.6.3
X-Spam-Score: -4.4 (----)
X-Spam-Report: Spam detection software, running on the system "ocean.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  From: Yuri Tikhonov <yur@emcraft.com> Should clear the
	next pointer of the TX if we are sure that the next TX (say NXT) will be
	submitted to the channel too. Overwise, we break the chain of
	descriptors, because we lose the information about the next descriptor
	to run. So next time, when invoke async_tx_run_dependencies() with TX,
	it's TX->next will be NULL, and NXT will be never submitted. [...] 
	Content analysis details:   (-4.4 points, 2.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuri Tikhonov <yur@emcraft.com>

Should clear the next pointer of the TX if we are sure that the
next TX (say NXT) will be submitted to the channel too. Overwise,
we break the chain of descriptors, because we lose the information
about the next descriptor to run. So next time, when invoke
async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
NXT will be never submitted.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
---
 crypto/async_tx/async_tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index 85eaf7b..e8362c1 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -137,7 +137,8 @@ async_tx_run_dependencies(struct dma_async_tx_descriptor *tx)
 		spin_lock_bh(&next->lock);
 		next->parent = NULL;
 		_next = next->next;
-		next->next = NULL;
+		if (_next && _next->chan == chan)
+			next->next = NULL;
 		spin_unlock_bh(&next->lock);
 
 		next->tx_submit(next);
-- 
1.5.6.3

