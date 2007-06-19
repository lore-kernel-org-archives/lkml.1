Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbXFSUDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbXFSUDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbXFSUDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:03:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:55822 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbXFSUDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:03:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="258791401"
Date: Tue, 19 Jun 2007 12:59:27 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070619195927.GF7160@linux-os.sc.intel.com>
References: <20070606185829.GA26062@tree.beaverton.ibm.com> <20070606193514.GN17143@linux-os.sc.intel.com> <20070606231642.GH13751@tree.beaverton.ibm.com> <20070608005726.GO17143@linux-os.sc.intel.com> <20070618223819.GD9751@tree.beaverton.ibm.com> <20070618235434.GB7160@linux-os.sc.intel.com> <20070619005136.GF9751@tree.beaverton.ibm.com> <m1sl8nn82i.fsf@ebiederm.dsl.xmission.com> <20070619180003.GE7160@linux-os.sc.intel.com> <20070619190637.GL9751@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619190637.GL9751@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 12:06:37PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 19, 2007 at 11:00:03AM -0700, Siddha, Suresh B wrote:
> > Anyhow, Darrick there is a general bug in this area, can you try this and
> > see if it helps?
> 
> Er... that instantly locked up the system.

hmm.. Please try this instead. This is intended only for debug. Based on your
test results, we can comeup with a more decent fix.

diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 3eaceac..3997679 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -144,17 +144,37 @@ void fixup_irqs(cpumask_t map)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		cpumask_t mask;
+		int break_affinity = 0;
+		int set_affinity = 1;
+
 		if (irq == 2)
 			continue;
 
+		/* irq's are disabled at this point */
+		spin_lock(&irq_desc[irq].lock);
+
 		cpus_and(mask, irq_desc[irq].affinity, map);
 		if (any_online_cpu(mask) == NR_CPUS) {
-			printk("Breaking affinity for irq %i\n", irq);
+			break_affinity = 1;
 			mask = map;
 		}
+
+		if (irq_desc[irq].chip->mask)
+			irq_desc[irq].chip->mask(irq);
+
 		if (irq_desc[irq].chip->set_affinity)
 			irq_desc[irq].chip->set_affinity(irq, mask);
 		else if (irq_desc[irq].action && !(warned++))
+			set_affinity = 0;
+
+		if (irq_desc[irq].chip->unmask)
+			irq_desc[irq].chip->unmask(irq);
+
+		spin_unlock(&irq_desc[irq].lock);
+
+		if (break_affinity && set_affinity)
+			printk("Broke affinity for irq %i\n", irq);
+		else if (!set_affinity)
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
