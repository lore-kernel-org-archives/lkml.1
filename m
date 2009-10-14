Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbZJNWbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbZJNWbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZJNWbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:31:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:35613 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbZJNWbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,561,1249282800"; 
   d="scan'208";a="736444757"
Date: Wed, 14 Oct 2009 15:30:38 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Tejun Heo <tj@kernel.org>
cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Frans Pop <elendil@planet.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: bisect results of MSI-X related panic (help!)
In-Reply-To: <4AD3E875.5040800@kernel.org>
Message-ID: <alpine.WNT.2.00.0910141527550.3036@jbrandeb-desk1.amr.corp.intel.com>
References: <1252699744.3877.15.camel@jbrandeb-hc.jf.intel.com>  <200909120623.49764.elendil@planet.nl> <4AAE0F7B.5050203@kernel.org>  <4AAE105E.1080005@kernel.org> <4807377b0910091724k2a332e90i9941971f6032663c@mail.gmail.com> <4AD2E05A.6060700@kernel.org>
 <alpine.WNT.2.00.0910120907170.11804@jbrandeb-mobl2.amr.corp.intel.com> <4AD3E875.5040800@kernel.org>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Tejun Heo wrote:
> Can you please apply the following patch and try to retrigger the
> panic?
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index c166019..f5a1482 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -63,6 +63,9 @@ void dynamic_irq_cleanup(unsigned int irq)
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	unsigned long flags;
> 
> +	printk("XXX dynamic_irq_cleanup() called on %u\n", irq);
> +	dump_stack();
> +
>  	if (!desc) {
>  		WARN(1, KERN_ERR "Trying to cleanup invalid IRQ%d\n", irq);
>  		return;

I'm working on it, but now that I've added a bunch of debug including the 
above printk, my system panics (with a stack protector canary overwrite) 
when loading the first network adapter with 30+ MSI-X vectors.  I can boot 
single user mode and bring up netconsole, but then as soon as I brought up 
the first port with lots of MSI-X vectors, the system hard locks, no panic 
message.
 
I have a bit of a theory that the node = -1 (numa_node) stuff might be 
playing some havoc with the code in numa_migrate.c.  I'm not sure if that 
is contributing, but the code in there doesn't seem written to handle node 
= - 1 very well.  As in I never see it do an smp_processor_id at the 
bottom before accessing the node value.

Not sure if that is relevant, but I wanted to mention it before I went 
home.

What next?  I made it worse so I guess that is something.
