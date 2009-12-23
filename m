Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZLWVVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZLWVVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbZLWVVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:21:45 -0500
Received: from mail.windriver.com ([147.11.1.11]:45295 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZLWVVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 27/37] debug_core,kdb: Allow the debug core to process a recursive debug entry
Date: Wed, 23 Dec 2009 15:19:40 -0600
Message-Id: <1261603190-5036-28-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-27-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-26-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-27-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:28.0255 (UTC) FILETIME=[BFEB9EF0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows kdb to debug a crash with in the kms code with a
single level recursive re-entry.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index e44e693..e6c6f8a 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -443,6 +443,10 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 	}
 
 	printk(KERN_CRIT "KGDB: re-enter exception: ALL breakpoints killed\n");
+#ifdef CONFIG_KGDB_KDB
+	/* Allow kdb to debug itself one level */
+	return 0;
+#endif
 	dump_stack();
 	panic("Recursive entry to debugger");
 
@@ -487,6 +491,9 @@ acquirelock:
 	smp_wmb();
 	atomic_set(&cpu_in_kgdb[cpu], 1);
 
+	if (exception_level == 1)
+		goto cpu_master_loop;
+
 	/*
 	 * CPU will loop if it is a slave or request to become a kgdb
 	 * master cpu and acquire the kgdb_active lock:
-- 
1.6.4.rc1

