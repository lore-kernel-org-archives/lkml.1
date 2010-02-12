Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab0BLWjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:39:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:44151 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab0BLWgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 24/28] debug_core,kdb: Allow the debug core to process a recursive debug entry
Date: Fri, 12 Feb 2010 16:35:39 -0600
Message-Id: <1266014143-29444-25-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:25.0176 (UTC) FILETIME=[CF1FD580:01CAAC33]
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
index ef46af3..bfdba97 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -445,6 +445,10 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 	}
 
 	printk(KERN_CRIT "KGDB: re-enter exception: ALL breakpoints killed\n");
+#ifdef CONFIG_KGDB_KDB
+	/* Allow kdb to debug itself one level */
+	return 0;
+#endif
 	dump_stack();
 	panic("Recursive entry to debugger");
 
@@ -489,6 +493,9 @@ acquirelock:
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

