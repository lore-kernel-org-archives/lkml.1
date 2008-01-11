Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbYAKJzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbYAKJzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:55:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758092AbYAKJyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:54:53 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:62504 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYAKJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QOaPU9qXur0J4zsHyrrwwbZxqH4N/ci0ic3N7x+xq+GwIgkRy0X+sZuP3WZWyiJAGE5EEi0n4p8axZ8kbzqyKqNGmyEQUBgVllARmB8ihjYyt0wE/6o8Z4bVYoANax0loCN0cevfHqXJ3qY+aMszZQIiSOGN64MA1ph7lRZg8Yg=
Message-ID: <9f00bd9d0801110154i3b2f9c1flf076823747950196@mail.gmail.com>
Date: Fri, 11 Jan 2008 11:54:50 +0200
From: "Filippos Papadopoulos" <psybases@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: INITIO scsi driver fails to work properly
Cc: linux-scsi@vger.kernel.org, "Chuck Ebbert" <cebbert@redhat.com>,
       "Boaz Harrosh" <bharrosh@panasas.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1200028577.5337.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
	 <1198271036.3130.60.camel@localhost.localdomain>
	 <476C4177.3030902@redhat.com>
	 <1198277391.3130.73.camel@localhost.localdomain>
	 <9f00bd9d0801031618l324e9078i56b0679a35e27f69@mail.gmail.com>
	 <1200028577.5337.8.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 11, 2008 7:16 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Fri, 2008-01-04 at 02:18 +0200, Filippos Papadopoulos wrote:
> > First of all let me wish a happy new year.
> > I come back from the vacations and i compiled the initio driver with
> >
> > #define DEBUG_INTERRUPT 1
> > #define DEBUG_QUEUE     1
> > #define DEBUG_STATE     1
> > #define INT_DISC        1
> >
> > I used the sources from 2.6.24-rc6-git9 kernel. At kernel boot time the initio
> > driver prints the following:
> >
> > " scsi: Initio INI-9X00U/UW SCSI device driver
> > Find scb at c0c00000
> > Append pend scb c0c00000;"
> >
> > After 3 seconds the whole system freezes there and i have to reboot.
> >
> >
> >
> > P.S  here is the info from 'lspci -vv' running 2.6.16.13 kernel:
> >
> > "00:08.0 SCSI storage controller: Initio Corporation 360P (rev 02)
> >         Subsystem: Unknown device 9292:0202
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > ParErr- Stepping- SERR- FastB2B-
> >         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> > >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> >         Latency: 32, Cache Line Size 08
> >         Interrupt: pin A routed to IRQ 11
> >         Region 0: I/O ports at d000 [size=256]
>
> This proves the BAR0 to be non zero, but I also take it from your report
> that the
>
> initio: I/O port range 0x0 is busy.
>
> message is also gone?
>


I havent reported "initio: I/O port range 0x0 is busy."


> >         Region 1: Memory at ef000000 (32-bit, non-prefetchable) [size=4K]
> >         [virtual] Expansion ROM at 50000000 [disabled] [size=128K]
> > "
>
> I think there's still one remaining bug from the sg_list conversion,
> namely that cblk->sglen is never set, but it is used to count the number
> of elements in the sg array.  Could you try this patch (on top of
> everything else) and see if the problem is finally fixed?
>

I applied the patch on 2.6.24-rc6-git9 but unfortunatelly same thing happens.


> Thanks,
>
> James
>
> ---
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 01bf018..d038459 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2603,6 +2603,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
>         nseg = scsi_dma_map(cmnd);
>         BUG_ON(nseg < 0);
>         if (nseg) {
> +               cblk->sglen = nseg;
>                 dma_addr = dma_map_single(&host->pci_dev->dev, &cblk->sglist[0],
>                                           sizeof(struct sg_entry) * TOTAL_SG_ENTRY,
>                                           DMA_BIDIRECTIONAL);
>
>
>
