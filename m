Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZBWQnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZBWQnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:43:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbZBWQmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:42:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38852 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbZBWQmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:42:49 -0500
Date: Mon, 23 Feb 2009 08:16:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: vegard.nossum@gmail.com, mingo@elte.hu, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: [PATCH] Teach RCU that idle task is not quiscent state at boot
Message-ID: <20090223161611.GA9563@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug located by Vegard Nossum with the aid of
kmemcheck.

The boot CPU runs in the context of its idle thread during boot-up.
During this time, idle_cpu(0) will always return nonzero, which will
fool Classic and Hierarchical RCU into deciding that a large chunk of
the boot-up sequence is a big long quiescent state.  This in turn causes
RCU to prematurely end grace periods during this time.

This patch changes the rcutree.c and rcuclassic.c rcu_check_callbacks()
function to ignore the idle tasks as a quiescent state until the
system_state is no longer SYSTEM_BOOTING.  After this point, the idle
task really does represent a quiescent state.

In addition, this patch takes Nick Piggin's suggestion to make the
system_state global variable be __read_mostly.

Located-by: Vegard Nossum <vegard.nossum@gmail.com>
Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 init/main.c         |    2 +-
 kernel/rcuclassic.c |    4 ++--
 kernel/rcutree.c    |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/init/main.c b/init/main.c
index 8442094..5067cfc 100644
--- a/init/main.c
+++ b/init/main.c
@@ -97,7 +97,7 @@ static inline void mark_rodata_ro(void) { }
 extern void tc_init(void);
 #endif
 
-enum system_states system_state;
+enum system_states system_state __read_mostly;
 EXPORT_SYMBOL(system_state);
 
 /*
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index bd5a900..909d04e 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -679,8 +679,8 @@ int rcu_needs_cpu(int cpu)
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	    (idle_cpu(cpu) && (system_state != SYSTEM_BOOTING) &&
+	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b2fd602..da685ea 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -948,8 +948,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
 void rcu_check_callbacks(int cpu, int user)
 {
 	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+	    (idle_cpu(cpu) && (system_state != SYSTEM_BOOTING) &&
+	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
