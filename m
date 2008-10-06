Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYJFTUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYJFTUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYJFTT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:19:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:60464 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYJFTTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:19:55 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/2] kgdb: call touch_softlockup_watchdog on resume
Date: Mon,  6 Oct 2008 14:14:15 -0500
Message-Id: <1223320455-9266-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1223320455-9266-2-git-send-email-jason.wessel@windriver.com>
References: <1223320455-9266-1-git-send-email-jason.wessel@windriver.com>
 <1223320455-9266-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 06 Oct 2008 19:14:15.0979 (UTC) FILETIME=[B97EBFB0:01C927E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The softlockup watchdog needs to be touched when resuming the from the
kgdb stopped state to avoid the printk that a CPU is stuck if the
debugger was active for longer than the softlockup threshold.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 25d955d..e4dcfb2 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -590,6 +590,7 @@ static void kgdb_wait(struct pt_regs *regs)
 
 	/* Signal the primary CPU that we are done: */
 	atomic_set(&cpu_in_kgdb[cpu], 0);
+	touch_softlockup_watchdog();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
@@ -1432,6 +1433,7 @@ acquirelock:
 	    atomic_read(&kgdb_cpu_doing_single_step) != cpu) {
 
 		atomic_set(&kgdb_active, -1);
+		touch_softlockup_watchdog();
 		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 
@@ -1524,6 +1526,7 @@ acquirelock:
 kgdb_restore:
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
+	touch_softlockup_watchdog();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
-- 
1.6.0.2

