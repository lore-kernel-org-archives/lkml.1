Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZCFDOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZCFDOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZCFDOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:14:05 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:47224 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZCFDOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:14:04 -0500
X-IronPort-AV: E=Sophos;i="4.38,311,1233550800"; 
   d="scan'208";a="83876381"
From: Bryan Wu <cooloney@kernel.org>
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org, Cliff Cai <cliff.cai@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] mmc: align data size for host which only supports power-of-2 block
Date: Fri,  6 Mar 2009 11:15:21 +0800
Message-Id: <1236309321-23955-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mmc/core/core.c  |    8 +++++++-
 include/linux/mmc/host.h |    1 +
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index df6ce4a..15119df 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -321,7 +321,13 @@ unsigned int mmc_align_data_size(struct mmc_card *card, unsigned int sz)
 	 * the core about its problems yet, so for now we just 32-bit
 	 * align the size.
 	 */
-	sz = ((sz + 3) / 4) * 4;
+
+	/* Align size for host which only supports power-of-2 block */
+	if (card->host->powerof2_block) {
+		if (sz & (sz - 1))
+			sz = 1 << fls(sz);
+	} else
+		sz = ((sz + 3) / 4) * 4;
 
 	return sz;
 }
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 4e45725..7416ed1 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -162,6 +162,7 @@ struct mmc_host {
 	struct dentry		*debugfs_root;
 
 	unsigned long		private[0] ____cacheline_aligned;
+	unsigned int		powerof2_block;	/* host only supports power-of-2 block */
 };
 
 extern struct mmc_host *mmc_alloc_host(int extra, struct device *);
-- 
1.5.6.3
