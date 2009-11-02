Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZKBItW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZKBItW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 03:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZKBItV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 03:49:21 -0500
Received: from server1.wserver.cz ([82.113.45.157]:49650 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZKBItU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 03:49:20 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: npiggin@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 1/1] MM: slqb, fix per_cpu access
Date: Mon,  2 Nov 2009 09:49:23 +0100
Message-Id: <1257151763-11507-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4AEE5EA2.6010905@kernel.org>
References: <4AEE5EA2.6010905@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot use the same local variable name as the declared per_cpu
variable since commit "percpu: remove per_cpu__ prefix."

Otherwise we would see crashes like:
general protection fault: 0000 [#1] SMP
last sysfs file:
CPU 1
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W  2.6.32-rc5-mm1_64 #860
RIP: 0010:[<ffffffff8142ff94>]  [<ffffffff8142ff94>] start_cpu_timer+0x2b/0x87
...

Use slqb_ prefix for the global variable so that we don't collide
even with the rest of the kernel (s390 and alpha need this).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/slqb.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index e745d9a..e4bb53f 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -2766,11 +2766,12 @@ out:
 	schedule_delayed_work(work, round_jiffies_relative(3*HZ));
 }
 
-static DEFINE_PER_CPU(struct delayed_work, cache_trim_work);
+static DEFINE_PER_CPU(struct delayed_work, slqb_cache_trim_work);
 
 static void __cpuinit start_cpu_timer(int cpu)
 {
-	struct delayed_work *cache_trim_work = &per_cpu(cache_trim_work, cpu);
+	struct delayed_work *cache_trim_work = &per_cpu(slqb_cache_trim_work,
+			cpu);
 
 	/*
 	 * When this gets called from do_initcalls via cpucache_init(),
@@ -3136,8 +3137,9 @@ static int __cpuinit slab_cpuup_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		cancel_rearming_delayed_work(&per_cpu(cache_trim_work, cpu));
-		per_cpu(cache_trim_work, cpu).work.func = NULL;
+		cancel_rearming_delayed_work(&per_cpu(slqb_cache_trim_work,
+					cpu));
+		per_cpu(slqb_cache_trim_work, cpu).work.func = NULL;
 		break;
 
 	case CPU_UP_CANCELED:
-- 
1.6.4.2

