Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZFBOTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZFBOTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZFBOTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:19:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:44536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZFBOTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:19:15 -0400
Date: Tue, 2 Jun 2009 14:18:33 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18981.1900.792795.836858@cargo.ozlabs.ibm.com>
References: <18981.1900.792795.836858@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: Initialize per-cpu context earlier on cpu up
Message-ID: <tip-f38b082081bf69a06fffb8b32a175999e2320c5b@git.kernel.org>
Git-Commit-ID: f38b082081bf69a06fffb8b32a175999e2320c5b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 14:18:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f38b082081bf69a06fffb8b32a175999e2320c5b
Gitweb:     http://git.kernel.org/tip/f38b082081bf69a06fffb8b32a175999e2320c5b
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Tue, 2 Jun 2009 21:05:16 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 13:10:54 +0200

perf_counter: Initialize per-cpu context earlier on cpu up

This arranges for perf_counter's notifier for cpu hotplug
operations to be called earlier than the migration notifier in
sched.c by increasing its priority to 20, compared to the 10
for the migration notifier.  The reason for doing this is that
a subsequent commit to convert the cpu migration counter to use
the generic swcounter infrastructure will add a call into the
perf_counter subsystem when tasks get migrated.  Therefore the
perf_counter subsystem needs a chance to initialize its per-cpu
data for the new cpu before it can get called from the
migration code.

This also adds a comment to the migration notifier noting that
its priority needs to be lower than that of the perf_counter
notifier.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <18981.1900.792795.836858@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
