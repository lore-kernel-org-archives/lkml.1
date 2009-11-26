Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZKZJ4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZKZJ4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZKZJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:56:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:59927 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbZKZJ4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:56:07 -0500
Date: Thu, 26 Nov 2009 09:55:02 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       yhlu.kernel@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, rdunlap@xenotime.net,
       rdreier@cisco.com, steiner@sgi.com, tj@kernel.org, mingo@elte.hu
Reply-To: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       yhlu.kernel@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, rdunlap@xenotime.net,
       steiner@sgi.com, rdreier@cisco.com, tj@kernel.org, mingo@elte.hu
In-Reply-To: <20091118002221.489305000@alcatraz.americas.sgi.com>
References: <20091118002221.489305000@alcatraz.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Limit the number of scheduler debug messages
Message-ID: <tip-f6630114d9198aa959ac95c131334c020038f253@git.kernel.org>
Git-Commit-ID: f6630114d9198aa959ac95c131334c020038f253
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6630114d9198aa959ac95c131334c020038f253
Gitweb:     http://git.kernel.org/tip/f6630114d9198aa959ac95c131334c020038f253
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 17 Nov 2009 18:22:15 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:17:30 +0100

sched: Limit the number of scheduler debug messages

Remove the verbose scheduler debug messages unless kernel
parameter "sched_debug" set.  /proc/sched_debug unchanged.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091118002221.489305000@alcatraz.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    2 ++
 kernel/sched.c                      |   13 +++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9107b38..f2a9507 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2182,6 +2182,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	sbni=		[NET] Granch SBNI12 leased line adapter
 
+	sched_debug	[KNL] Enables verbose scheduler debug messages.
+
 	sc1200wdt=	[HW,WDT] SC1200 WDT (watchdog) driver
 			Format: <io>[,<timeout>[,<isapnp>]]
 
diff --git a/kernel/sched.c b/kernel/sched.c
index a57c6ae..48ff66a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7720,6 +7720,16 @@ early_initcall(migration_init);
 
 #ifdef CONFIG_SCHED_DEBUG
 
+static __read_mostly int sched_domain_debug_enabled;
+
+static int __init sched_domain_debug_setup(char *str)
+{
+	sched_domain_debug_enabled = 1;
+
+	return 0;
+}
+early_param("sched_debug", sched_domain_debug_setup);
+
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  struct cpumask *groupmask)
 {
@@ -7806,6 +7816,9 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 	cpumask_var_t groupmask;
 	int level = 0;
 
+	if (!sched_domain_debug_enabled)
+		return;
+
 	if (!sd) {
 		printk(KERN_DEBUG "CPU%d attaching NULL sched-domain.\n", cpu);
 		return;
