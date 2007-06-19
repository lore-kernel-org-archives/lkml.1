Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbXFSWMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbXFSWMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXFSWM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:12:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:11157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbXFSWM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:12:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="256478207"
Date: Tue, 19 Jun 2007 15:08:12 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070619220812.GG7160@linux-os.sc.intel.com>
References: <20070606231642.GH13751@tree.beaverton.ibm.com> <20070608005726.GO17143@linux-os.sc.intel.com> <20070618223819.GD9751@tree.beaverton.ibm.com> <20070618235434.GB7160@linux-os.sc.intel.com> <20070619005136.GF9751@tree.beaverton.ibm.com> <m1sl8nn82i.fsf@ebiederm.dsl.xmission.com> <20070619180003.GE7160@linux-os.sc.intel.com> <20070619190637.GL9751@tree.beaverton.ibm.com> <20070619195927.GF7160@linux-os.sc.intel.com> <20070619204929.GM9751@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619204929.GM9751@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 01:49:30PM -0700, Darrick J. Wong wrote:
> 
> This fixes the problem!  Hurrah!

Great!  Andrew, please include the appended patch in -mm.

----
Subject: [patch] x86_64, irq: use mask/unmask and proper locking in fixup_irqs
From: Suresh Siddha <suresh.b.siddha@intel.com>

Force irq migration path during cpu offline, is not using proper
locks and irq_chip mask/unmask routines. This will result in
some races(especially the device generating the interrupt can see
some inconsistent state, resulting in issues like stuck irq,..).

Appended patch fixes the issue by taking proper lock and
encapsulating irq_chip set_affinity() with a mask() before and an
unmask() after.

This fixes a MSI irq stuck issue reported by Darrick Wong.

There are several more general bugs in this area(irq migration in the
process context). For example,

1. Possibility of missing edge triggered irq.
2. Reliable method of migrating level triggered irq in the process context.

We plan to look and close these in the near future.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Darrick Wong <djwong@us.ibm.com>
---

diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 3eaceac..55b2733 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -144,17 +144,41 @@ void fixup_irqs(cpumask_t map)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		cpumask_t mask;
+		int break_affinity = 0;
+		int set_affinity = 1;
+
 		if (irq == 2)
 			continue;
 
+		/* interrupt's are disabled at this point */
+		spin_lock(&irq_desc[irq].lock);
+
+		if (!irq_has_action(irq) ||
+		    cpus_equal(irq_desc[irq].affinity, map)) {
+			spin_unlock(&irq_desc[irq].lock);
+			continue;
+		}
+
 		cpus_and(mask, irq_desc[irq].affinity, map);
-		if (any_online_cpu(mask) == NR_CPUS) {
-			printk("Breaking affinity for irq %i\n", irq);
+		if (cpus_empty(mask)) {
+			break_affinity = 1;
 			mask = map;
 		}
+
+		irq_desc[irq].chip->mask(irq);
+
 		if (irq_desc[irq].chip->set_affinity)
 			irq_desc[irq].chip->set_affinity(irq, mask);
-		else if (irq_desc[irq].action && !(warned++))
+		else if (!(warned++))
+			set_affinity = 0;
+
+		irq_desc[irq].chip->unmask(irq);
+
+		spin_unlock(&irq_desc[irq].lock);
+
+		if (break_affinity && set_affinity)
+			printk("Broke affinity for irq %i\n", irq);
+		else if (!set_affinity)
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
