Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbYLWEgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbYLWEgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 23:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYLWEgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 23:36:04 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52845 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbYLWEgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 23:36:02 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=JhGnA44n8Rk2viDP1y4A:9 a=KI_jF8-ScsnsFFgwrl0A:7 a=uHPM_TBxy6SnVeCDXL47noSKrhIA:4 a=XTfWyP1RBmAA:10 a=IbQmg-3ORMcA:10
Message-ID: <49506AAF.3040400@shaw.ca>
Date: Mon, 22 Dec 2008 22:35:59 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_sil: add Large Block Transfer support
References: <4945BDED.7050205@shaw.ca> <494F69C4.2060708@kernel.org>
In-Reply-To: <494F69C4.2060708@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Robert Hancock wrote:
>> Obviously not 2.6.28 material, but could potentially head into .29.
>> I've done some testing with a DVD drive connected to this controller
>> and verified that reading off an entire DVD returns correct data
>> (and that the controller is actually getting requests that cross
>> 64K boundaries). More testing would certainly be useful..
> 
> Ah... nice.  It would be great to have this in -next for some time.
> 
>> +static void sil_bmdma_stop(struct ata_queued_cmd *qc)
>> +{
>> +    struct ata_port *ap = qc->ap;
>> +    void __iomem *mmio_base = ap->host->iomap[SIL_MMIO_BAR];
>> +    void __iomem *bmdma2 = mmio_base + sil_port[ap->port_no].bmdma2;
>> +
>> +    /* clear start/stop bit - can safely always write 0 */
>> +    writeb(0, bmdma2);
> 
> ioread/iowrite?

We know the register's always MMIO on this controller, so it's slightly 
more optimal to avoid the conditional in there.

> 
>> +    /* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
>> +    ata_sff_dma_pause(ap);
>> +}
>> +
>> +static void sil_bmdma_setup(struct ata_queued_cmd *qc)
>> +{
>> +    struct ata_port *ap = qc->ap;
>> +    void __iomem *bmdma = ap->ioaddr.bmdma_addr;
>> +
>> +    /* load PRD table addr. */
>> +    mb();    /* make sure PRD table writes are visible to controller */
> 
> I know it's not specific to this change but does mb() really make
> sense here?  I don't think we need any barrier here.

Not sure. Documentation/memory-barriers.txt seems rather unfortunately 
vague on whether MMIO writes are strongly ordered with respect to memory 
writes. I seem to recall some debate on this a while ago, did it ever 
get resolved?

> 
>> +    writel(ap->prd_dma, bmdma + ATA_DMA_TABLE_OFS);
>> +
>> +    /* issue r/w command */
>> +    ap->ops->sff_exec_command(ap, &qc->tf);
>> +}
> 
> Thanks.
> 
