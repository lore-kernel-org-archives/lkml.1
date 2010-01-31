Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894Ab0AaRKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0AaRKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624Ab0AaRKW
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:10:22 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:52249 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab0AaRKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fDsq3Ylt596Hd0l2hRozlKYyb5Ca50xvSaYTVJbPNVowJr1/iC3UNmjbFnBJ8j+wr/
         xY1uun/hmGSlGjl7A+7v3XlUh8Ml5/Od/CRFgKYnT0N69MFlbOg1uhuBJp3k+oQCnwvQ
         q/isbzoPT+SAFInPI2fnPxuGTUmpUmhIR4OFg=
MIME-Version: 1.0
In-Reply-To: <4B5FC213.1060601@gmail.com>
References: <4B5FC213.1060601@gmail.com>
Date: Sun, 31 Jan 2010 11:10:19 -0600
Message-ID: <51f3faa71001310910h1d810eebx392201ac4143bacf@mail.gmail.com>
Subject: Re: [PATCH] ahci: disable FPDMA auto-activate optimization on NVIDIA 
	AHCI
From: Robert Hancock <hancockrwd@gmail.com>
To: Mike Cui <cuicui@gmail.com>
Cc: Peer Chen <pchen@nvidia.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike, have you had a chance to try out this patch yet?

On Tue, Jan 26, 2010 at 10:33 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Mike Cui reported that his system with an NVIDIA MCP79 (aka MCP7A) chipset
> stopped working with 2.6.32. The problem appears to be that 2.6.32 now enables
> the FPDMA auto-activate optimization in the ahci driver. The drive works fine
> with this enabled on an Intel AHCI so this appears to be a chipset bug.
> Since MCP79 is a fairly recent NVIDIA chipset and we don't have any info on
> whether any other NVIDIA chipsets have this issue, disable FPDMA AA optimization
> on all NVIDIA AHCI controllers for now.
>
> Should address http://bugzilla.kernel.org/show_bug.cgi?id=14922
>
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>
>
> ---
>
> Mike, can you test this out and make sure this resolves the problem for you?
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index b8bea10..47e57dc 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -3067,8 +3067,16 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>        ahci_save_initial_config(pdev, hpriv);
>
>        /* prepare host */
> -       if (hpriv->cap & HOST_CAP_NCQ)
> -               pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
> +       if (hpriv->cap & HOST_CAP_NCQ) {
> +               pi.flags |= ATA_FLAG_NCQ;
> +               /* Auto-activate optimization is supposed to be supported on
> +                  all AHCI controllers indicating NCQ support, but it seems
> +                  to be broken at least on some NVIDIA MCP79 chipsets.
> +                  Until we get info on which NVIDIA chipsets don't have this
> +                  issue, if any, disable AA on all NVIDIA AHCIs. */
> +               if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)
> +                       pi.flags |= ATA_FLAG_FPDMA_AA;
> +       }
>
>        if (hpriv->cap & HOST_CAP_PMP)
>                pi.flags |= ATA_FLAG_PMP;
>
