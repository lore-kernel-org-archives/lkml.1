Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbYBPBPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbYBPBPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757705AbYBPBPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:15:37 -0500
Received: from mailout11.yourhostingaccount.com ([65.254.253.90]:50192 "EHLO
	mailout11.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757598AbYBPBPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:15:36 -0500
X-Greylist: delayed 1930 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2008 20:15:36 EST
X-EN-OrigOutIP: 10.1.18.10
X-EN-IMPSID: pzxT1Y0010D2B7u0000000
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Message-Id: <DD1DA785-AD9C-4EFA-94E2-FA7154EECA9F@ngndg.com>
From: Tim Ellis <tim@ngndg.com>
To: benh@kernel.crashing.org
In-Reply-To: <1203111956.22915.24.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
Date: Fri, 15 Feb 2008 23:56:47 +0000
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com> <1202850129.7410.22.camel@pasglop> <Pine.LNX.4.64.0802151651340.27735@axis700.grange> <20080215155332.2b89c429@core> <1203111956.22915.24.camel@pasglop>
X-Mailer: Apple Mail (2.919.2)
X-EN-UserInfo: b8ae887d91300d60195f6ea73d56f3bc:43527cee0c82d0ab5dc2dc3726f6afdf
X-EN-AuthUser: tim@ngndg.com
X-EN-OrigIP: 82.34.50.106
X-EN-OrigHost: 82-34-50-106.cable.ubr02.chel.blueyonder.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 15 Feb 2008, at 21:45, Benjamin Herrenschmidt wrote:

>
> On Fri, 2008-02-15 at 15:53 +0000, Alan Cox wrote:
>>>> That's strange though. Somebody with knowledge of that HW (or  
>>>> specs) who
>>>> can spot something ? Could it be an issue with timing ?
>>>>
>>>> I don't have HW access to this machine. If somebody could send  
>>>> one to me
>>>> I could do more investigation.
>>>
>>> Ben, would an ssh access to such a machine and to a terminal server
>>> suffice?
>>
>> It says clearly in the code where to start. See the FIXME notes in  
>> both
>> libata-sff and libata-core about MMIO. Neither the DMA transfer  
>> start or
>> the probe SRST sequence are correct with MMIO posting and this hasn't
>> been fixed as I pointed out was needed when I originally NAKked the
>> change.
>>
>> Without those being fixed (especially SRST) on any device with  
>> heavy PCI
>> posting of mmio your controller *wont work*.
>
> The dbdma start is mostly harmless (things don't get posted for -that-
> long), though I suppose it's worth fixing. Would reading back dmactl  
> do
> in that case or do you foresee any kind of side effect ? (Maybe only
> doing it for MMIO ?)
>
> As for SRST, I'm not totally confident how safe it is to read back
> there while doing the reset sequence, so I'm tempted to really only
> do it for MMIO and use altstat rather than ctl/stat (the later tends
> to have side effects which we don't want here).
>
> What do you think ?
>
> The main problem from here is that I don't know whether we are using
> MMIO or PIO from libata-core. Maybe I can add a host flag indicate
> that such flushing is needed ?
>
> In the meantime, Guennadi, can you check if that patch helps for you
> (to see if that is indeed the problem):
>
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 004dae4..1451a52 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3461,10 +3461,13 @@ static int ata_bus_softreset(struct ata_port  
> *ap, unsigned int devmask,
>
> 	/* software reset.  causes dev0 to be selected */
> 	iowrite8(ap->ctl, ioaddr->ctl_addr);
> +	ioread16(ioaddr->nsect_addr);
> 	udelay(20);	/* FIXME: flush */
> 	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
> +	ioread16(ioaddr->nsect_addr);
> 	udelay(20);	/* FIXME: flush */
> 	iowrite8(ap->ctl, ioaddr->ctl_addr);
> +	ioread16(ioaddr->nsect_addr);
>
> 	/* wait a while before checking status */
> 	ata_wait_after_reset(ap, deadline);
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 60cd4b1..81d5828 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -273,6 +273,7 @@ void ata_bmdma_start(struct ata_queued_cmd *qc)
> 	 * FIXME: The posting of this write means I/O starts are
> 	 * unneccessarily delayed for MMIO
> 	 */
> +	ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
> }
>
> /**
>
> Cheers,
> Ben.


Unfortunately this patch appears to give same result as in the  
original post. Guennadi and I are looking into arranging access to a  
device. Thanks!

<7>pata_sil680 0000:00:0c.0: version 0.4.8
<6>sil680: 133MHz clock.
<6>scsi0 : pata_sil680
<6>scsi1 : pata_sil680
<6>ata1: PATA max UDMA/133 irq 18
<6>ata2: PATA max UDMA/133 irq 18

Tim
