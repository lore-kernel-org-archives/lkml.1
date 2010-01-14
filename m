Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865Ab0ANPB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab0ANPB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767Ab0ANPBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:01:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:47760 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab0ANPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:16 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 27/40] debug_core,kdb: Allow the debug core to process a recursive debug entry
Date: Thu, 14 Jan 2010 08:59:23 -0600
Message-Id: <1263481176-1897-28-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:01.0007 (UTC) FILETIME=[62ABC5F0:01CA952A]
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
index e02c552..344e332 100644
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
1.6.3.1.9.g95405b

