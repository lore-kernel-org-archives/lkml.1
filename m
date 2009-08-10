Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZHJL46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZHJL46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 07:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZHJL45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 07:56:57 -0400
Received: from hermes.mlbassoc.com ([76.76.67.137]:2138 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZHJL45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 07:56:57 -0400
Message-ID: <4A800B08.4020708@mlbassoc.com>
Date: Mon, 10 Aug 2009 05:56:56 -0600
From: Gary Thomas <gary@mlbassoc.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Wolfram Sang <w.sang@pengutronix.de>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/14] powerpc: use printk_once
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>	<1249847649-11631-4-git-send-email-marcin.slusarz@gmail.com>	<20090810080049.GA3132@pengutronix.de> <1249904809.4958.4.camel@concordia>
In-Reply-To: <1249904809.4958.4.camel@concordia>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Mon, 2009-08-10 at 10:00 +0200, Wolfram Sang wrote:
>> On Sun, Aug 09, 2009 at 09:53:58PM +0200, Marcin Slusarz wrote:
>>> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> Cc: Paul Mackerras <paulus@samba.org>
>>> Cc: linuxppc-dev@ozlabs.org
>>> ---
>>>  arch/powerpc/kernel/iommu.c      |    6 +-----
>>>  arch/powerpc/kernel/irq.c        |    5 ++---
>>>  arch/powerpc/sysdev/ppc4xx_pci.c |    9 ++-------
>>>  3 files changed, 5 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
>>> index fd51578..c7fa258 100644
>>> --- a/arch/powerpc/kernel/iommu.c
>>> +++ b/arch/powerpc/kernel/iommu.c
>>> @@ -502,7 +502,6 @@ static void iommu_table_clear(struct iommu_table *tbl)
>>>  struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
>>>  {
>>>  	unsigned long sz;
>>> -	static int welcomed = 0;
>>>  	struct page *page;
>>>  
>>>  	/* Set aside 1/4 of the table for large allocations. */
>>> @@ -523,11 +522,8 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
>>>  
>>>  	iommu_table_clear(tbl);
>>>  
>>> -	if (!welcomed) {
>>> -		printk(KERN_INFO "IOMMU table initialized, virtual merging %s\n",
>>> +	printk_once(KERN_INFO "IOMMU table initialized, virtual merging %s\n",
>>>  		       novmerge ? "disabled" : "enabled");
>>> -		welcomed = 1;
>>> -	}
>>>  
>>>  	return tbl;
>>>  }
>>> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
>>> index f7f376e..05ebd21 100644
>>> --- a/arch/powerpc/kernel/irq.c
>>> +++ b/arch/powerpc/kernel/irq.c
>>> @@ -231,7 +231,6 @@ skip:
>>>  void fixup_irqs(cpumask_t map)
>>>  {
>>>  	unsigned int irq;
>>> -	static int warned;
>>>  
>>>  	for_each_irq(irq) {
>>>  		cpumask_t mask;
>>> @@ -246,8 +245,8 @@ void fixup_irqs(cpumask_t map)
>>>  		}
>>>  		if (irq_desc[irq].chip->set_affinity)
>>>  			irq_desc[irq].chip->set_affinity(irq, &mask);
>>> -		else if (irq_desc[irq].action && !(warned++))
>>> -			printk("Cannot set affinity for irq %i\n", irq);
>>> +		else if (irq_desc[irq].action)
>>> +			printk_once("Cannot set affinity for irq %i\n", irq);
>> Maybe we should add a loglevel to this printk (and the other one in fix_irqs)
>> while we are here?
> 
> I think you should drop it, it's stupid. If we actually care about irqs
> that don't have a set affinity we should keep a count and report that at
> the end of the loop.

In addition, this change would prevent reporting missing
affinity on more than one IRQ if there were such.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
