Return-Path: <linux-kernel-owner+w=401wt.eu-S2992740AbXCBXdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992740AbXCBXdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992745AbXCBXdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:33:07 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54714 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992740AbXCBXdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:33:04 -0500
Message-ID: <45E8B42E.7010900@garzik.org>
Date: Fri, 02 Mar 2007 18:33:02 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: warn if speed limited due to 40-wire cable (v2)
References: <45DA44B4.6000209@shaw.ca>
In-Reply-To: <45DA44B4.6000209@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Here's a revised version of my previous patch to warn the user if a
> drive's transfer rate is limited because of a 40-wire cable detection.
> This one hopefully addresses Alan's previous comments - we now do this
> at the very end of the function, and the ugly if condition has been
> cleaned up somewhat. Also, it's been inadvertently tested (it seems that
> pata_amd Nvidia cable detection is broken in current -git..)
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> --- linux-2.6.20-git6/drivers/ata/libata-core.c    2007-02-11 
> 17:31:19.000000000 -0600
> +++ linux-2.6.20-git6edit/drivers/ata/libata-core.c    2007-02-13 
> 19:15:58.000000000 -0600
> @@ -3305,19 +3305,7 @@ static void ata_dev_xfermask(struct ata_
>     xfer_mask = ata_pack_xfermask(ap->pio_mask,
>                       ap->mwdma_mask, ap->udma_mask);
> 
> -    /* Apply cable rule here.  Don't apply it early because when
> -     * we handle hot plug the cable type can itself change.
> -     */
> -    if (ap->cbl == ATA_CBL_PATA40)
> -        xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
> -    /* Apply drive side cable rule. Unknown or 80 pin cables reported
> -     * host side are checked drive side as well. Cases where we know a
> -     * 40wire cable is used safely for 80 are not checked here.
> -     */
> -        if (ata_drive_40wire(dev->id) && (ap->cbl == ATA_CBL_PATA_UNK 
> || ap->cbl == ATA_CBL_PATA80))
> -        xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
> -
> -
> +    /* drive modes available */
>     xfer_mask &= ata_pack_xfermask(dev->pio_mask,
>                        dev->mwdma_mask, dev->udma_mask);
>     xfer_mask &= ata_id_xfermask(dev->id);
> @@ -3348,6 +3336,25 @@ static void ata_dev_xfermask(struct ata_
>     if (ap->ops->mode_filter)
>         xfer_mask = ap->ops->mode_filter(ap, dev, xfer_mask);
> 
> +    /* Apply cable rule here.  Don't apply it early because when
> +     * we handle hot plug the cable type can itself change.
> +     * Check this last so that we know if the transfer rate was
> +     * solely limited by the cable.
> +     * Unknown or 80 wire cables reported host side are checked
> +     * drive side as well. Cases where we know a 40wire cable
> +     * is used safely for 80 are not checked here.
> +     */
> +    if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
> +        /* UDMA/44 or higher would be available */
> +        if((ap->cbl == ATA_CBL_PATA40) ||
> +               (ata_drive_40wire(dev->id) &&
> +             (ap->cbl == ATA_CBL_PATA_UNK ||
> +                     ap->cbl == ATA_CBL_PATA80))) {
> +                  ata_dev_printk(dev, KERN_WARNING,
> +                 "limited to UDMA/33 due to 40-wire cable\n");
> +            xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);
> +        }

it seems broken to manipulate xfer_mask after returning from the 
driver's ->mode_filter hook.

this patch is more than just a speed-limited warning printk, afaics


