Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbXCOMAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbXCOMAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 08:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933513AbXCOMAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 08:00:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:46083 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504AbXCOMAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 08:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gj5NCphLEqU0EnzjfylPSznjsp6YRO2x29BgzvbhRUVXcD7JSLFkis4k3e79sT283sb3rsevlgXxpAo32WbMAzSbX6jDfrVEl6iU8CcQrwwsy3wSJTrK2Q8CaXZh8pxT6bY01Vu1U6SRdQjupq/8PrT6od7NdBlhE5Q+g530yEs=
Message-ID: <5767b9100703150500t1c34dfb0kc6a199b5374a8d78@mail.gmail.com>
Date: Thu, 15 Mar 2007 20:00:47 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
Cc: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45F7E7E9.6010703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>
	 <45F7E7E9.6010703@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> Conke Hu wrote:
> >    When there is no media in SATA CD/DVD drive or media is not ready,
> > AHCI controller fails to execute the ATAPI commands TEST_UNIT_READY,
> > READ_CAPACITY or READ_TOC and reports PORT_IRQ_TF_ERR. But ATI SB600
> > SATA controller sets SERR_INTERNAL bit in the error register at the
> > same time, which is not necessary. This patch is just to ignore the
> > INTERNAL ERROR in such case. Without this patch, ahci error handler
> > will report many errors as below:
>
> Whoa, SERR_INTERNAL on ATAPI check condition?  Just for fun, here's what
> the spec says about SERR_INTERNAL.
>

When media is not ready, command TEST_UNIT_READY fails with ahci irq
status == 0x40000001(IRQ_TF_ERROR) and serror == SERR_INTERNEL, then
ahci error handler calls atapi_eh_request_sense() and sets
ATA_QCFLAG_SENSE_VALID. Command REQUEST_SENSE executes successfully
and atapi_qc_complete() sets result = SAM_STAT_CHECK_CONDITION, and
now the whole TEST_UNIT_READY request is done and returns .


> E  Internal error: The host bus adapter experienced an internal error
> that caused the operation to fail and may have put the host bus adapter
> into an error state. Host software should reset the interface before
> re-trying the operation. If the condition persists, the host bus adapter
> may suffer from a design issue rendering it incompatible with the
> attached device.
>

Yes, I saw this too :) and I am contacting the hardware engineers to
check if there is any hardware bug.
But, even though this were a hardware bug and could be fixed, we would
still need this patch since many SB600 boards have already come into
the market and those ASICs can never be fixed :(
So, if no errors in this patch, could Jeff please apply it ASAP?


> Anyways thanks for fixing this.  Just a few comments.
>
> > --- linux-2.6.21-rc3-git8/drivers/ata/ahci.c.orig    2007-03-25
> > 20:57:31.000000000 +0800
> > +++ linux-2.6.21-rc3-git8/drivers/ata/ahci.c    2007-03-25
> > 21:03:54.000000000 +0800
> > @@ -80,6 +80,7 @@ enum {
> >     board_ahci_pi        = 1,
> >     board_ahci_vt8251    = 2,
> >     board_ahci_ign_iferr    = 3,
> > +    board_ahci_ati    = 4,
> >
> >     /* global controller registers */
> >     HOST_CAP        = 0x00, /* host capabilities */
> > @@ -168,6 +169,7 @@ enum {
> >     AHCI_FLAG_NO_NCQ        = (1 << 24),
> >     AHCI_FLAG_IGN_IRQ_IF_ERR    = (1 << 25), /* ignore IRQ_IF_ERR */
> >     AHCI_FLAG_HONOR_PI        = (1 << 26), /* honor PORTS_IMPL */
> > +    AHCI_FLAG_TF_ERR_FIX    = (1 << 27), /* ignore INTERNAL ERROR on
> > IRQ_TF_ERROR */
>
> Can we use board_ahci_ign_interr and AHCI_FLAG_IGN_SERR_INTERNAL to keep
> it more consistent with the other IGN flag?
>
> > -    { PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
> > +    { PCI_VDEVICE(ATI, 0x4380), board_ahci_ati }, /* ATI SB600 non-raid */
> >     { PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */
>
> 4381 isn't affected while 4380 is?

I never see such an ID, and plan to remove 0x4381.
The patch which added the PCI IDs was not sent out by myself. I
checked all SB600 boards, and not found any 0x4381 controller, only
0x4380 instead. In fact, SB600 RAID and Non-RAID share the same PCI
device ID, only with class code different.


>
> Hmmm... Okay, this is weird.  I'm feeling very strong deja vu.
>
> Well, I must be getting alzheimer.  I did almost the same patch a month
> ago and was waiting for verification to properly submit the patch.
>
>   http://thread.gmane.org/gmane.linux.ide/16049/focus=16437
>
> Anyways, Conke Hu, can you please take a look at my patch from a month
> ago?  It's almost identical but SERR_INTERNAL is always ignored on both
> SB600 PCI IDs, which I think is safer.  Does this fix what you're seeing?
>

I just read your patch. Another difference is that my patch ignores
SERR_INTERNAL only when the command is ATAPI and IRQ_TF_ERR occurs. In
other cases, I think, we'd better not ignore the SERR_INTERNEL. Right?
The following is some detail:
// your patch:
+	if (ap->flags & AHCI_FLAG_IGN_SERR_INTERNAL)
+		serr &= ~SERR_INTERNAL;

// mine:
-       if (irq_stat & PORT_IRQ_TF_ERR)
+       if (irq_stat & PORT_IRQ_TF_ERR) {
               err_mask |= AC_ERR_DEV;
+
+               /* some controllers set INTERNAL ERROR on ATAPI
IRQ_TF_ERROR, ignore it */
+               if ((serror & SERR_INTERNAL) &&
+                    (ap->flags & AHCI_FLAG_TF_ERR_FIX) &&
+                     qc && qc->dev->class == ATA_DEV_ATAPI) {
+                       serror &= ~SERR_INTERNAL;
+               }
+       }

Tejun, you do me a great favor, thank you so much! for your previous
help, too :)

Conke
