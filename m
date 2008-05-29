Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYE2VOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYE2VOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYE2VOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:14:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59105 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYE2VOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:14:07 -0400
Date: Thu, 29 May 2008 14:13:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
In-Reply-To: <20080529191920.12609c32@core>
Message-ID: <alpine.LFD.1.10.0805291403030.3873@woody.linux-foundation.org>
References: <20080529161453.24735.805.stgit@core> <alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org> <483EEBE5.5030708@garzik.org> <20080529191920.12609c32@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, Alan Cox wrote:
>
> And this is how a revised one would look.

Ok, this looks nicer, but how about:

> +static u8 ata_sff_irq_status(struct ata_port *ap)
> +{
> +	u8 status;
> +
> +	if (ap->ops->sff_check_altstatus || ap->ioaddr.altstatus_addr) {
> +		status = ata_sff_altstatus(ap);

This here is all about not oopsing in ata_sff_altstatus(), ie just knowing 
about the bug.

Why not just fix ata_sff_altstatus(), instead of causing these kinds of 
problems downstream?

If you don't want to read the status register, fine. But at least do 
something like

 - make ata_sff_altstatus static, since it's useless and dangerous to call 
   otherwise (ie make the exported interfaces be the nicer higher-level 
   ones that are sane)

 - and make it just return 0 if the altstatus register doesn't exist.

At that point, both 'ata_sff_irq_status()' and 'ata_sff_sync()' can just 
use ata_sff_altstatus() directly, *without* having to check that altstatus 
setup by hand, or re-implement the function just because it was buggy and 
broken to begin with.

So now ata_sff_irq_status() just becomes

	static u8 ata_sff_irq_status(struct ata_port *ap)
	{
		u8 status;

		status = ata_sff_altstatus(ap);
		if (status & ATA_BUSY)
			return status;

		/* Clear INTRQ latch */
		status = ata_sff_check_status(ap);
		return status;
	}

and if there was no altstatus register, everything is fine because 
"ata_sff_altstatus()" was safe and returned 0 (and not ATA_BUSY).

Or feel free and make it return ATA_INVALID, which has a value of 0x100, 
or something - it still won't be busy, and it will clearly not be a byte 
read, so people *can* check for "no altstatus existed" if they want to.

Similarly, 'ata_sff_sync()' just becomes

	void ata_sff_sync(struct ata_port *ap)
	{
		ata_sff_altstatus();
	}

and 'ata_sff_pause()' becomes

	void ata_sff_pause(struct ata_port *ap)
	{
		ata_sff_altstatus();
		ndelay(400);
	}

and again, if there is no altstatus register, that's a low-level driver 
issue.

		Linus
