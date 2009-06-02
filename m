Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbZFBLGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbZFBLGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 07:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbZFBLFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 07:05:23 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35331 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759445AbZFBLFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:05:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18981.1900.792795.836858@cargo.ozlabs.ibm.com>
Date: Tue, 2 Jun 2009 21:05:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: Initialize per-cpu context earlier on
   cpu up
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This arranges for perf_counter's notifier for cpu hotplug operations
to be called earlier than the migration notifier in sched.c by
increasing its priority to 20, compared to the 10 for the migration
notifier.  The reason for doing this is that a subsequent commit to
convert the cpu migration counter to use the generic swcounter
infrastructure will add a call into the perf_counter subsystem when
tasks get migrated.  Therefore the perf_counter subsystem needs a
chance to initialize its per-cpu data for the new cpu before it can
get called from the migration code.

This also adds a comment to the migration notifier noting that its
priority needs to be lower than that of the perf_counter notifier.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_counter.c |    4 ++++
 kernel/sched.c        |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index df319c4..8d2653f 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3902,8 +3902,12 @@ perf_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
+/*
+ * This has to have a higher priority than migration_notifier in sched.c.
+ */
 static struct notifier_block __cpuinitdata perf_cpu_nb = {
 	.notifier_call		= perf_cpu_notify,
+	.priority		= 20,
 };
 
 void __init perf_counter_init(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index ad079f0..3226cc1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7319,8 +7319,10 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-/* Register at highest priority so that task migration (migrate_all_tasks)
- * happens before everything else.
+/*
+ * Register at high priority so that task migration (migrate_all_tasks)
+ * happens before everything else.  This has to be lower priority than
+ * the notifier in the perf_counter subsystem, though.
  */
 static struct notifier_block __cpuinitdata migration_notifier = {
 	.notifier_call = migration_call,
-- 
1.6.0.4

