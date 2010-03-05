Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0CETts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:49:48 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50430 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0CETtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:49:47 -0500
X-IronPort-AV: E=Sophos;i="4.49,588,1262581200"; 
   d="scan'208";a="86888161"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, Yinghai Lu <yinghai@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: do not free zero sized per cpu areas
Date: Fri,  5 Mar 2010 19:49:43 +0000
Message-Id: <1267818583-5627-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <4B914A61.20409@kernel.org>
References: <4B914A61.20409@kernel.org>
X-OriginalArrivalTime: 05 Mar 2010 19:49:46.0556 (UTC) FILETIME=[02283FC0:01CABC9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids an infinite loop in free_early_partial().

Add a warning to free_early_partial to catch future problems.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |    3 ++-
 kernel/early_res.c             |    5 +++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ef6370b..89a3205 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -140,7 +140,8 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
 #ifdef CONFIG_NO_BOOTMEM
 	u64 start = __pa(ptr);
 	u64 end = start + size;
-	free_early_partial(start, end);
+	if (start < end)
+		free_early_partial(start, end);
 #else
 	free_bootmem(__pa(ptr), size);
 #endif
diff --git a/kernel/early_res.c b/kernel/early_res.c
index 3cb2c66..f3a861b 100644
--- a/kernel/early_res.c
+++ b/kernel/early_res.c
@@ -333,6 +333,11 @@ void __init free_early_partial(u64 start, u64 end)
 	struct early_res *r;
 	int i;
 
+	if (WARN_ONCE(start >= end,
+		      "free_early_partial got wrong start/end %#llx/%#llx\n",
+		      start, end))
+		return;
+
 try_next:
 	i = find_overlapped_early(start, end);
 	if (i >= max_early_res)
-- 
1.5.6.5

