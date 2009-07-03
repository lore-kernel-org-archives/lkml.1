Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZGCIde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZGCIde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZGCIcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:32:47 -0400
Received: from sg2ehsobe003.messaging.microsoft.com ([207.46.51.77]:32107 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753309AbZGCIcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:32:43 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KM76EA-02-347-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] dma-debug: Put all hash-chain locks into the same lock class
Date: Fri, 3 Jul 2009 10:32:04 +0200
Message-ID: <1246609924-31217-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1246609924-31217-1-git-send-email-joerg.roedel@amd.com>
References: <1246609924-31217-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Jul 2009 08:32:08.0269 (UTC) FILETIME=[C0B93FD0:01C9FBB8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Alan Cox reported that lockdep runs out of its stack-trace entries
with certain configs:

 BUG: MAX_STACK_TRACE_ENTRIES too low

This happens because there are 1024 hash buckets, each with a
separate lock. Lockdep puts each lock into a separate lock class and
tracks them independently.

But in reality we never take more than one of the buckets, so they
really belong into a single lock-class. Annotate the has bucket lock
init accordingly.

[ Impact: reduce the lockdep footprint of dma-debug ]

Reported-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index a9b6b5c..c9187fe 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -716,7 +716,7 @@ void dma_debug_init(u32 num_entries)
 
 	for (i = 0; i < HASH_SIZE; ++i) {
 		INIT_LIST_HEAD(&dma_entry_hash[i].list);
-		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
+		spin_lock_init(&dma_entry_hash[i].lock);
 	}
 
 	if (dma_debug_fs_init() != 0) {
-- 
1.6.3.3


