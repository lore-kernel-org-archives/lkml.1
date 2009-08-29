Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbZH2N67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbZH2N67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZH2N66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:58:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:36528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZH2N64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:58:56 -0400
Date: Sat, 29 Aug 2009 13:58:32 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A95C32D.5040605@kernel.org>
References: <4A95C32D.5040605@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] irq: Make sure irq_desc for legacy irq get correct node setting
Message-ID: <tip-372e24b0cb764ec55b4cf3408a95ae40a29e5b96@git.kernel.org>
Git-Commit-ID: 372e24b0cb764ec55b4cf3408a95ae40a29e5b96
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 29 Aug 2009 13:58:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  372e24b0cb764ec55b4cf3408a95ae40a29e5b96
Gitweb:     http://git.kernel.org/tip/372e24b0cb764ec55b4cf3408a95ae40a29e5b96
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 26 Aug 2009 16:20:13 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 29 Aug 2009 15:53:00 +0200

irq: Make sure irq_desc for legacy irq get correct node setting

when there is no ram on node 0.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <4A95C32D.5040605@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/handle.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 065205b..a81cf80 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -161,7 +161,7 @@ int __init early_irq_init(void)
 
 	desc = irq_desc_legacy;
 	legacy_count = ARRAY_SIZE(irq_desc_legacy);
- 	node = first_online_node;
+	node = first_online_node;
 
 	/* allocate irq_desc_ptrs array based on nr_irqs */
 	irq_desc_ptrs = kcalloc(nr_irqs, sizeof(void *), GFP_NOWAIT);
@@ -172,6 +172,9 @@ int __init early_irq_init(void)
 
 	for (i = 0; i < legacy_count; i++) {
 		desc[i].irq = i;
+#ifdef CONFIG_SMP
+		desc[i].node = node;
+#endif
 		desc[i].kstat_irqs = kstat_irqs_legacy + i * nr_cpu_ids;
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		alloc_desc_masks(&desc[i], node, true);
