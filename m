Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYCJVXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYCJVXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbYCJVXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:23:13 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:50156
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754548AbYCJVXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:23:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] keep rd->online and cpu_online_map in sync
Cc: linux-kernel@vger.kernel.org, ghaskins@novell.com,
       Gregory Haskins <ghaskins@novell.com>
Date: Mon, 10 Mar 2008 16:52:46 -0400
Message-ID: <20080310205246.9571.2649.stgit@novell1.haskins.net>
In-Reply-To: <20080310205241.9571.38832.stgit@novell1.haskins.net>
References: <20080310205241.9571.38832.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to allow the root-domain cache of online cpus to
become out of sync with the global cpu_online_map.  This is because we
currently trigger removal of cpus too early in the notifier chain.
Other DOWN_PREPARE handlers may in fact run and reconfigure the
root-domain topology, thereby stomping on our own offline handling.

The end result is that rd->online may become out of sync with
cpu_online_map, which results in potential task misrouting.

So change the offline handling to be more tightly coupled with the
global offline process by triggering on CPU_DYING intead of
CPU_DOWN_PREPARE.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 52b9867..a616fa1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5881,7 +5881,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		spin_unlock_irq(&rq->lock);
 		break;
 
-	case CPU_DOWN_PREPARE:
+	case CPU_DYING:
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);

