Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZKAWM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZKAWM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbZKAWM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:12:56 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60287 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbZKAWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:12:56 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: npiggin@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 1/1] MM: slqb, fix per_cpu access
Date: Sun,  1 Nov 2009 23:12:58 +0100
Message-Id: <1257113578-1584-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
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

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
 mm/slqb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index e745d9a..27f5025 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -2770,16 +2770,16 @@ static DEFINE_PER_CPU(struct delayed_work, cache_trim_work);
 
 static void __cpuinit start_cpu_timer(int cpu)
 {
-	struct delayed_work *cache_trim_work = &per_cpu(cache_trim_work, cpu);
+	struct delayed_work *_cache_trim_work = &per_cpu(cache_trim_work, cpu);
 
 	/*
 	 * When this gets called from do_initcalls via cpucache_init(),
 	 * init_workqueues() has already run, so keventd will be setup
 	 * at that time.
 	 */
-	if (keventd_up() && cache_trim_work->work.func == NULL) {
-		INIT_DELAYED_WORK(cache_trim_work, cache_trim_worker);
-		schedule_delayed_work_on(cpu, cache_trim_work,
+	if (keventd_up() && _cache_trim_work->work.func == NULL) {
+		INIT_DELAYED_WORK(_cache_trim_work, cache_trim_worker);
+		schedule_delayed_work_on(cpu, _cache_trim_work,
 					__round_jiffies_relative(HZ, cpu));
 	}
 }
-- 
1.6.4.2

