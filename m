Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbZLIW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbZLIW3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbZLIW3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:29:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:33284 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbZLIW33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:29:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="220811850"
From: "Luck, Tony" <tony.luck@intel.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, luming.yu@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] avoid out of bounds array reference in save_trace()
Date: Wed, 09 Dec 2009 14:29:36 -0800
Message-Id: <4b2024d085302c2a2@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 found this the hard way (because we currently have a stub for
save_stack_trace() that does nothing). But it would be a good idea to 
be cautious in case a real save_stack_trace() bailed out with an
error before it set trace->nr_entries.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 03c06af..429540c 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -387,7 +387,8 @@ static int save_trace(struct stack_trace *trace)
 	 * complete trace that maxes out the entries provided will be reported
 	 * as incomplete, friggin useless </rant>
 	 */
-	if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
+	if (trace->nr_entries != 0 &&
+	    trace->entries[trace->nr_entries-1] == ULONG_MAX)
 		trace->nr_entries--;
 
 	trace->max_entries = trace->nr_entries;
