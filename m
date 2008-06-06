Return-Path: <linux-kernel-owner+w=401wt.eu-S1765150AbYFFUns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765150AbYFFUns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932914AbYFFUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:42:42 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:53146 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933128AbYFFUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:42:28 -0400
Date: Sat, 7 Jun 2008 00:39:18 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: Tilmann Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>
Cc: gigaset307x-common@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] gigaset: fix module reference counting
Message-ID: <20080606223918.GA10348@kodscha>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bas_gigaset can't be unloaded due to wrong module reference counting.
Ensure that module_put is called whenever a channel is freed.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/isdn/gigaset/common.c  |    5 +----
 drivers/isdn/gigaset/gigaset.h |    1 -
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index 827c32c..8498317 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -184,7 +184,6 @@ int gigaset_get_channel(struct bc_state *bcs)
 		return 0;
 	}
 	++bcs->use_count;
-	bcs->busy = 1;
 	gig_dbg(DEBUG_ANY, "allocated channel %d", bcs->channel);
 	spin_unlock_irqrestore(&bcs->cs->lock, flags);
 	return 1;
@@ -195,13 +194,12 @@ void gigaset_free_channel(struct bc_state *bcs)
 	unsigned long flags;
 
 	spin_lock_irqsave(&bcs->cs->lock, flags);
-	if (!bcs->busy) {
+	if (!bcs->use_count) {
 		gig_dbg(DEBUG_ANY, "could not free channel %d", bcs->channel);
 		spin_unlock_irqrestore(&bcs->cs->lock, flags);
 		return;
 	}
 	--bcs->use_count;
-	bcs->busy = 0;
 	module_put(bcs->cs->driver->owner);
 	gig_dbg(DEBUG_ANY, "freed channel %d", bcs->channel);
 	spin_unlock_irqrestore(&bcs->cs->lock, flags);
@@ -589,7 +587,6 @@ static struct bc_state *gigaset_initbcs(struct bc_state *bcs,
 
 	bcs->chstate = 0;
 	bcs->use_count = 1;
-	bcs->busy = 0;
 	bcs->ignore = cs->ignoreframes;
 
 	for (i = 0; i < AT_NUM; ++i)
diff --git a/drivers/isdn/gigaset/gigaset.h b/drivers/isdn/gigaset/gigaset.h
index f365993..ef1bc17 100644
--- a/drivers/isdn/gigaset/gigaset.h
+++ b/drivers/isdn/gigaset/gigaset.h
@@ -419,7 +419,6 @@ struct bc_state {
 #ifdef CONFIG_GIGASET_DEBUG
 	int emptycount;
 #endif
-	int busy;
 	int use_count;
 
 	/* private data of hardware drivers */
-- 
1.5.3.7


