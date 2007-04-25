Return-Path: <linux-kernel-owner+w=401wt.eu-S1161522AbXDYKZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161522AbXDYKZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161855AbXDYKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:25:19 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:20253 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161843AbXDYKZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FACvH+HiN64bgLptIpQY1F+7NKoiqZ+KnFUDkCJV8U6+tL7W13SojGqVsx4DQ567VE7dIdzkT5nSeOg2AXtHBVjO+MaCUXif1qzfuiUi/nswb+RjzX9BNPGnjz3fisxAGsJ69Sj3XKuoDUQgNZv6yHnhYZgAUc6LFaGyb/X1Vh8=
Message-ID: <462F2C86.7030009@gmail.com>
Date: Wed, 25 Apr 2007 19:25:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 BUG at kernel/sched-clock.c:175 init_sched_clock()
References: <462E4C4D.9020806@gmail.com>	<20070425011654.222a2b4b.akpm@linux-foundation.org>	<462F1481.8010807@gmail.com>	<20070425085432.GD17130@htj.dyndns.org> <20070425112533.19d4a1aa@the-village.bc.nu>
In-Reply-To: <20070425112533.19d4a1aa@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>> index 72c286e..a128717 100644
>> --- a/drivers/ata/ahci.c
>> +++ b/drivers/ata/ahci.c
>> @@ -1369,10 +1369,14 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
>>  
>>  static void ahci_freeze(struct ata_port *ap)
>>  {
>> +	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
>>  	void __iomem *port_mmio = ahci_port_base(ap);
>>  
>>  	/* turn IRQ off */
>>  	writel(0, port_mmio + PORT_IRQ_MASK);
>> +
>> +	/* clear IRQ pending bit */
>> +	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
>>  }
>>  
> 
> Actually now I think about it the problem is even worse. On older systems
> IRQ delivery for SMP machines is asynchronous. So the following can occur
> 
> 
> 		device raises IRQ line
> 		IRQ request hits APIC bus
> 
> 		We write IRQ off
> 		We clear IRQ pending
> 
> 		We read back to ensure the write took
> 	
> 
> 		IRQ arrives on CPU APIC
> 
> (and yes this happens on dual P3 boxes - NE2K has some fantastic bugs at
> one point due to this)

I think the second patch should work regardless of IRQ posting.  No?

-- 
tejun
