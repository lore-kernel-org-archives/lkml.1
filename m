Return-Path: <linux-kernel-owner+w=401wt.eu-S934508AbXFFBlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508AbXFFBlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXFFBlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:41:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:12288 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993AbXFFBlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:41:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,387,1175497200"; 
   d="scan'208";a="251267391"
Date: Tue, 5 Jun 2007 18:37:59 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070606013759.GI17143@linux-os.sc.intel.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com> <20070605235707.GB16074@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605235707.GB16074@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 04:57:07PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 05, 2007 at 02:14:51PM -0700, Siddha, Suresh B wrote:
>  
> > Can you send us your system's dmesg aswell as output of /proc/interrupts?
> 
> http://sweaglesw.net/~djwong/docs/dmesg
> http://sweaglesw.net/~djwong/docs/interrupts

Didn't find anything wrong in that information. Can you try this
appended debug patch and see if you see this error msg in dmesg, when you
hit the bug? Thanks.

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index d8bfe31..3409c1f 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -720,10 +720,13 @@ static int assign_irq_vector(int irq, cpumask_t mask)
 {
 	int err;
 	unsigned long flags;
+	int cpu = smp_processor_id();
 
 	spin_lock_irqsave(&vector_lock, flags);
 	err = __assign_irq_vector(irq, mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
+	if (err && !cpu_isset(cpu, cpu_online_map))
+		printk("assigning irq to a vector failed : %d\n", err);
 	return err;
 }
 
