Return-Path: <linux-kernel-owner+w=401wt.eu-S1760584AbZJIJb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584AbZJIJb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbZJIJb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:31:27 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52675 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760574AbZJIJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:31:26 -0400
Subject: [PATCH 2/2] kmemleak: Check for NULL pointer returned by
	create_object()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 09 Oct 2009 10:30:34 +0100
Message-ID: <20091009093034.4365.34259.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091009093028.4365.4391.stgit@pc1117.cambridge.arm.com>
References: <20091009093028.4365.4391.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc3-10-g00be
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Oct 2009 09:30:34.0543 (UTC) FILETIME=[271BB3F0:01CA48C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds NULL pointer checking in the early_alloc() function.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index a617518..8bf765c 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -834,11 +834,14 @@ static void early_alloc(struct early_log *log)
 	rcu_read_lock();
 	object = create_object((unsigned long)log->ptr, log->size,
 			       log->min_count, GFP_ATOMIC);
+	if (!object)
+		goto out;
 	spin_lock_irqsave(&object->lock, flags);
 	for (i = 0; i < log->trace_len; i++)
 		object->trace[i] = log->trace[i];
 	object->trace_len = log->trace_len;
 	spin_unlock_irqrestore(&object->lock, flags);
+out:
 	rcu_read_unlock();
 }
 

