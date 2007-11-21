Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXKUUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXKUUMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbXKUUL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:11:58 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:55109
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756970AbXKUUL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:11:57 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/4] SCHED: Track online cpus in the root-domain
To: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Date: Wed, 21 Nov 2007 14:52:06 -0500
Message-ID: <20071121195206.8226.71719.stgit@novell1.haskins.net>
In-Reply-To: <20071121194804.8226.1522.stgit@novell1.haskins.net>
References: <20071121194804.8226.1522.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We cache the subset of rd->span cpus that are online in rd->online to
reduce the need for runtime computation.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e5c902c..c58d1bf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -281,6 +281,7 @@ struct rt_rq {
 struct root_domain {
 	atomic_t refcount;
 	cpumask_t span;
+	cpumask_t online;
 };
 
 static struct root_domain def_root_domain;
@@ -5491,6 +5492,15 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	case CPU_ONLINE_FROZEN:
 		/* Strictly unnecessary, as first user will wake it. */
 		wake_up_process(cpu_rq(cpu)->migration_thread);
+
+		/* Update our root-domain */
+		rq = cpu_rq(cpu);
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_set(cpu, rq->rd->online);
+		}
+		spin_unlock_irqrestore(&rq->lock, flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -5539,6 +5549,17 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		}
 		spin_unlock_irq(&rq->lock);
 		break;
+
+	case CPU_DOWN_PREPARE:
+		/* Update our root-domain */
+		rq = cpu_rq(cpu);
+		spin_lock_irqsave(&rq->lock, flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			cpu_clear(cpu, rq->rd->online);
+		}
+		spin_unlock_irqrestore(&rq->lock, flags);	
+		break;
 #endif
 	case CPU_LOCK_RELEASE:
 		mutex_unlock(&sched_hotcpu_mutex);
@@ -5763,6 +5784,7 @@ static void init_rootdomain(struct root_domain *rd, cpumask_t *map)
 	memset(rd, 0, sizeof(*rd));
 
 	rd->span = *map;
+	cpus_and(rd->online, rd->span, cpu_online_map);
 }
 
 static void init_defrootdomain(void)

