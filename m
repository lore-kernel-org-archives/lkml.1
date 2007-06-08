Return-Path: <linux-kernel-owner+w=401wt.eu-S935529AbXFHBBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935529AbXFHBBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936763AbXFHBBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:01:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:43992 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936340AbXFHBBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:01:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,397,1175497200"; 
   d="scan'208";a="254552454"
Date: Thu, 7 Jun 2007 17:57:26 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070608005726.GO17143@linux-os.sc.intel.com>
References: <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com> <20070606013759.GI17143@linux-os.sc.intel.com> <20070606185829.GA26062@tree.beaverton.ibm.com> <20070606193514.GN17143@linux-os.sc.intel.com> <20070606231642.GH13751@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606231642.GH13751@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 04:16:42PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 06, 2007 at 12:35:14PM -0700, Siddha, Suresh B wrote:
> 
> > Weird. Then the bug can only happen if for some reason, "mask = map"
> > didn't happen in fixup_irqs(). Can you send us the disassembly of the
> > fixup_irqs()?
> 
> Attached.

hmm.. Darrick, can't find anything wrong in there.

I am very much puzzled and the main thing I am confused about is, that
how come "/proc/irq/<irq#-hung>/smp_affinity" is still pointing at the old
offlined cpu, while calls to set_affinity() with cpu_online_map mask
in fixup_irqs() don't show any failure..

As you have the failing system, you need to do more detective work and
help me out. Can you try this debug patch and send across the dmesg after the
bug happens and also can you try different compiler to see if something
changes..

diff --git a/arch/x86_64/kernel/irq.c b/arch/x86_64/kernel/irq.c
index 3eaceac..fc2a576 100644
--- a/arch/x86_64/kernel/irq.c
+++ b/arch/x86_64/kernel/irq.c
@@ -152,9 +152,11 @@ void fixup_irqs(cpumask_t map)
 			printk("Breaking affinity for irq %i\n", irq);
 			mask = map;
 		}
-		if (irq_desc[irq].chip->set_affinity)
+		if (irq_desc[irq].chip->set_affinity) {
+			printk("calling set affinity for %i, with mask %lx\n",
+				irq, cpus_addr(mask)[0]);
 			irq_desc[irq].chip->set_affinity(irq, mask);
-		else if (irq_desc[irq].action && !(warned++))
+		} else if (irq_desc[irq].action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
