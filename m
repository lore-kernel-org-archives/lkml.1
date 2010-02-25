Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0BYEEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:04:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075Ab0BYEEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:04:20 -0500
Date: Wed, 24 Feb 2010 20:03:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [git patch] libata bug fix
Message-Id: <20100224200335.32d43577.akpm@linux-foundation.org>
In-Reply-To: <20100225034937.GA26364@havoc.gtf.org>
References: <20100225034937.GA26364@havoc.gtf.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010 22:49:37 -0500 Jeff Garzik <jeff@garzik.org> wrote:

> 
> This is a fix that probably should have gone into 2.6.33.

It still can if we cc stable@kernel.org?

>  It never
> received an ack from the bug reporter, hence the delay,
> but NVIDIA ok'd it anyway.  It merely disables an optimization.
> 
> 
> 
> 
> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus
> 
> to receive the following updates:
> 
>  drivers/ata/ahci.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> Robert Hancock (1):
>       ahci: disable FPDMA auto-activate optimization on NVIDIA AHCI
> 
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index b343903..a6a736a 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -3082,8 +3082,16 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	ahci_save_initial_config(pdev, hpriv);
>  
>  	/* prepare host */
> -	if (hpriv->cap & HOST_CAP_NCQ)
> -		pi.flags |= ATA_FLAG_NCQ | ATA_FLAG_FPDMA_AA;
> +	if (hpriv->cap & HOST_CAP_NCQ) {
> +		pi.flags |= ATA_FLAG_NCQ;
> +		/* Auto-activate optimization is supposed to be supported on
> +		   all AHCI controllers indicating NCQ support, but it seems
> +		   to be broken at least on some NVIDIA MCP79 chipsets.
> +		   Until we get info on which NVIDIA chipsets don't have this
> +		   issue, if any, disable AA on all NVIDIA AHCIs. */
> +		if (pdev->vendor != PCI_VENDOR_ID_NVIDIA)
> +			pi.flags |= ATA_FLAG_FPDMA_AA;
> +	}
>  
>  	if (hpriv->cap & HOST_CAP_PMP)
>  		pi.flags |= ATA_FLAG_PMP;
