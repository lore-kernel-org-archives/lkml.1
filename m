Return-Path: <linux-kernel-owner+w=401wt.eu-S965261AbXAWOvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965261AbXAWOvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965259AbXAWOvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:51:12 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:44769 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965302AbXAWOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:51:09 -0500
Message-ID: <45B620D7.3030501@ru.mvista.com>
Date: Tue, 23 Jan 2007 17:51:03 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	<20070119003226.14846.87052.sendpatchset@localhost.localdomain>	<45B4FFBD.40507@ru.mvista.com>	<20070122184620.1c8b87ac@localhost.localdomain>	<45B51E83.1010904@ru.mvista.com> <20070122213109.21e4e805@localhost.localdomain>
In-Reply-To: <20070122213109.21e4e805@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan wrote:
>>>>   Ugh, I'm not seeing any *actual* support for MW/SW DMA in this driver... 

>>>Thats long been broken. Should be correct in the libata driver

>>    Here's a surprise for you. pata_cmd64x copied the SW/MW DMA setup code 
>>from the IDE driver.  No way it could be working.  You may check against the 
>>PC64x datasheets (if you have them -- if you don't I think I may share) and 
>>see for yourself -- it's abolutely idiotic.

    I.e. MWDMA2 should be working due to the way the driver is written (it 
sets up PIO4 timings when auto-tuning DMA) but not the other modes since 
speedproc() method is brain-damaged in this part.

> Not a suprise to be honest. I fixed some of the ALi stuff when I did it
> and I think that was pushed back into drivers/ide. The CMD64x hasn't had
> much love really.

    Another buglet found by random glancing at this driver:

/**
  *      cmd648_dma_stop -       DMA stop callback
  *      @qc: Command in progress
  *
  *      DMA has completed.
  */

static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
{
         struct ata_port *ap = qc->ap;
         struct pci_dev *pdev = to_pci_dev(ap->host->dev);
         u8 dma_intr;
         int dma_reg = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
         int dma_mask = ap->port_no ? ARTTIM2 : CFR;

         ata_bmdma_stop(qc);

         pci_read_config_byte(pdev, dma_reg, &dma_intr);
         pci_write_config_byte(pdev, dma_reg, dma_intr | dma_mask);
}

    dma_reg and dma_mask initializers must have been swapped since ARTTIM2 and 
CFR are regster names.  So, the code reads/writes semi-random regs...

> Wouldn't mind the older 64x (not 640) data sheets if they are sharable.

    Sent what I had on this machine.  Will looks for newer revision of 
PCJ0646U2 spec elsewhere...

MBR, Sergei
