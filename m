Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYIESqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYIESqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbYIESqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:46:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:18685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYIESqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:46:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,340,1217833200"; 
   d="scan'208";a="377176541"
Subject: [git pull] async_tx fix for 2.6.27-rc
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Yuri Tikhonov <yur@emcraft.com>, wd@denx.de, yanok@emcraft.com
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Sep 2008 11:46:23 -0700
Message-Id: <1220640383.12562.6.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
X-OriginalArrivalTime: 05 Sep 2008 18:46:24.0170 (UTC) FILETIME=[B236B0A0:01C90F87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git fixes

...to receive:

commit de24125dd0a452bfd4502fc448e3534c5d2e87aa
Author: Yuri Tikhonov <yur@emcraft.com>
Date:   Fri Sep 5 08:15:47 2008 -0700

    async_tx: fix the bug in async_tx_run_dependencies
    
    Should clear the next pointer of the TX if we are sure that the
    next TX (say NXT) will be submitted to the channel too. Overwise,
    we break the chain of descriptors, because we lose the information
    about the next descriptor to run. So next time, when invoke
    async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
    NXT will be never submitted.
    
    Cc: <stable@kernel.org>		[2.6.26]
    Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
    Signed-off-by: Ilya Yanok <yanok@emcraft.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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

