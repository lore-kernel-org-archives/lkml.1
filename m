Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbZKIAtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbZKIAtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZKIAtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:49:15 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37901 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZKIAtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:49:15 -0500
Date: Sun, 8 Nov 2009 16:49:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org, anton@samba.org,
       paulus@samba.org, mingo@elte.hu
Subject: [PATCH] Silence warning in rtas_event_scan()
Message-ID: <20091109004924.GA28481@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtas_event_scan() function uses smp_processor_id() without having
disabled preemption, which results in a warning as follows:

	BUG: using smp_processor_id() in preemptible [00000000] code: events/0/9677
	caller is .rtas_event_scan+0x9c/0x1ac
	Call Trace:
	[c00000001bb9fc20] [c0000000000102c8] .show_stack+0x70/0x184 (unreliable)
	[c00000001bb9fcd0] [c0000000002ebecc] .debug_smp_processor_id+0xe8/0x11c
	[c00000001bb9fd60] [c0000000000434f8] .rtas_event_scan+0x9c/0x1ac
	[c00000001bb9fdf0] [c000000000087494] .worker_thread+0x1d8/0x2a8
	[c00000001bb9fed0] [c00000000008c41c] .kthread+0xa8/0xb4
	[c00000001bb9ff90] [c0000000000272b0] .kernel_thread+0x54/0x70

However, this code is simply chosing a starting point for a traversal
of all online CPUs, and under get_online_cpus() protection.  Therefore,
unprotected use of smp_processor_id() is permissible here.  Change the
smp_processor_id() to raw_smp_processor_id() to silence the warning.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/rtasd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index b3cbac8..64394a6 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -405,7 +405,7 @@ static void rtas_event_scan(struct work_struct *w)
 
 	get_online_cpus();
 
-	cpu = next_cpu(smp_processor_id(), cpu_online_map);
+	cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
 	if (cpu == NR_CPUS) {
 		cpu = first_cpu(cpu_online_map);
 
-- 
1.5.2.5

