Return-Path: <linux-kernel-owner+w=401wt.eu-S1030214AbXAYPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214AbXAYPka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 10:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030215AbXAYPka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 10:40:30 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:1619 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030214AbXAYPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 10:40:29 -0500
Message-ID: <45B8CF67.2070401@ru.mvista.com>
Date: Thu, 25 Jan 2007 18:40:23 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	<20070119003226.14846.87052.sendpatchset@localhost.localdomain>	<45B4FFBD.40507@ru.mvista.com>	<20070122184620.1c8b87ac@localhost.localdomain>	<45B51E83.1010904@ru.mvista.com> <20070122213109.21e4e805@localhost.localdomain> <45B620D7.3030501@ru.mvista.com>
In-Reply-To: <45B620D7.3030501@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Sergei Shtylyov wrote:

>> Not a suprise to be honest. I fixed some of the ALi stuff when I did it
>> and I think that was pushed back into drivers/ide. The CMD64x hasn't had
>> much love really.

>    Another buglet found by random glancing at this driver:

> /**
>  *      cmd648_dma_stop -       DMA stop callback
>  *      @qc: Command in progress
>  *
>  *      DMA has completed.
>  */

> static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
> {
>         struct ata_port *ap = qc->ap;
>         struct pci_dev *pdev = to_pci_dev(ap->host->dev);
>         u8 dma_intr;
>         int dma_reg = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
>         int dma_mask = ap->port_no ? ARTTIM2 : CFR;
> 
>         ata_bmdma_stop(qc);
> 
>         pci_read_config_byte(pdev, dma_reg, &dma_intr);
>         pci_write_config_byte(pdev, dma_reg, dma_intr | dma_mask);
> }

>    dma_reg and dma_mask initializers must have been swapped since 
> ARTTIM2 and CFR are regster names.  So, the code reads/writes 
> semi-random regs...

    BTW, on PCI0646U2 and later chips, the interrupt status (it's not really 
DMA interrupt status but a latched INTRQ signal not "coupled" with DMA logic, 
according to the datasheets) can be read from MRDMODE reg. which is accessible 
in I/O space at BMIDE base + 1 which is certainly faster.  That's what 
drivers/ide/cmd64x.c is doing in its test_dma_irq() method (however, it's 
doign this on PCI0643 and early revs of PCI0646 which don't have these bits).
The driver's dma_end() method is acting really strange: it checks if the cjip 
is PCI-648/9 and reads the PCI config space to clear those interrupt bits 
while these chips have them in I/O mapped MRDMODE; OTOH, it ignores these bits 
on earlier chips which have them in oonfig. space only (CFR/ARTTIM23 regs)... 
go figure.  I'm going to clean this up but don't heve the h/w handy... :-/

>> Wouldn't mind the older 64x (not 640) data sheets if they are sharable.

>    Sent what I had on this machine.  Will looks for newer revision of 
> PCJ0646U2 spec elsewhere...

    Sent rev. 1.3... Hopefully gkernel.sourceforge.net/specs/ will be updated.

MBR, Sergei
