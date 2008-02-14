Return-Path: <linux-kernel-owner+w=401wt.eu-S1761265AbYBNEns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265AbYBNEns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 23:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbYBNEni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 23:43:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52222 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756681AbYBNEnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 23:43:37 -0500
Message-ID: <47B3C6F5.6060809@garzik.org>
Date: Wed, 13 Feb 2008 23:43:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
       Sergio Luis <sergio@larces.uece.br>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [SCSI] gdth: update deprecated pci_find_device
References: <200802140059.m1E0xrID025375@hera.kernel.org>
In-Reply-To: <200802140059.m1E0xrID025375@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=99109301d103fbf0de43fc5a580a406c12a501e0
> Commit:     99109301d103fbf0de43fc5a580a406c12a501e0
> Parent:     61c92814dc324b541391757062ff02fbf3b08086
> Author:     Sergio Luis <sergio@larces.uece.br>
> AuthorDate: Tue Feb 12 20:48:03 2008 -0300
> Committer:  James Bottomley <James.Bottomley@HansenPartnership.com>
> CommitDate: Wed Feb 13 09:33:10 2008 -0600
> 
>     [SCSI] gdth: update deprecated pci_find_device
>     
>     Fix compilation warning in gdth.c, which was using the deprecated
>     pci_find_device.
>     
>     drivers/scsi/gdth.c:645: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)
>     
>     Changing it to use pci_get_device, instead.
>     
>     Signed-off-by: Sergio Luis <sergio@larces.uece.br>
>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/Kconfig |    2 +-
>  drivers/scsi/gdth.c  |    7 +++++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index a5f0aaa..a7a0813 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -722,7 +722,7 @@ config SCSI_FD_MCS
>  
>  config SCSI_GDTH
>  	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
> -	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API && PCI_LEGACY
> +	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
>  	---help---
>  	  Formerly called GDT SCSI Disk Array Controller Support.
>  
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 7079fef..6d67f5c 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -642,12 +642,15 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
>            *cnt, vendor, device));
>  
>      pdev = NULL;
> -    while ((pdev = pci_find_device(vendor, device, pdev)) 
> +    while ((pdev = pci_get_device(vendor, device, pdev))
>             != NULL) {
>          if (pci_enable_device(pdev))
>              continue;
> -        if (*cnt >= MAXHA)
> +        if (*cnt >= MAXHA) {
> +            pci_dev_put(pdev);
>              return;
> +        }
> +

Why no pci_dev_put() in the module cleanup path?

	Jeff



