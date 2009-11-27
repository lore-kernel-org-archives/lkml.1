Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbZK0OaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbZK0OaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZK0OaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:30:17 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59406 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZK0OaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:30:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=cNG5nFSq+XRxJQ/0VU2XfqsllN10M24UqpGzRtn227h1Oa7iS4u5O0Bo4zv+FRYQ+k
         kCwnzX2IiHM58NCKtG5hnw+/aaf50sno7bBGfvVD7CqpcCpnMYD162jGBScihnCdRY+5
         +PK0Kn87ubQ58mglxqGxvTKRXgkNp66v4hDVc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 5/5] pata_piccolo: Driver for old Toshiba chipsets
Date: Fri, 27 Nov 2009 15:28:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20091117144450.15430.83450.stgit@localhost.localdomain> <20091117145144.15430.55784.stgit@localhost.localdomain>
In-Reply-To: <20091117145144.15430.55784.stgit@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <200911271528.09697.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 November 2009 03:52:12 pm Alan Cox wrote:
> We were never able to get docs for this out of Toshiba for years. Dave
> Barnes produced a NetBSD driver however and from that we can fill in the
> needed tables
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/ata/Kconfig        |   25 +++++---
>  drivers/ata/Makefile       |    1 
>  drivers/ata/ata_generic.c  |    5 +-
>  drivers/ata/pata_piccolo.c |  140 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci_ids.h    |    7 +-
>  5 files changed, 166 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/ata/pata_piccolo.c

[...]

> --- a/drivers/ata/ata_generic.c
> +++ b/drivers/ata/ata_generic.c
> @@ -168,9 +168,12 @@ static struct pci_device_id ata_generic[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
> +#if !defined(CONFIG_PATA_TOSHIBA) && !defined(CONFIG_PATA_TOSHIBA_MODULE)
>  	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
> -	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),  },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),  },
> +#endif	

[...]

> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1496,9 +1496,10 @@
>  #define PCI_DEVICE_ID_SBE_WANXL400	0x0104
>  
>  #define PCI_VENDOR_ID_TOSHIBA		0x1179
> -#define PCI_DEVICE_ID_TOSHIBA_PICCOLO	0x0102
> -#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_1	0x0103
> -#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_2	0x0105
> +#define PCI_DEVICE_ID_TOSHIBA_PICCOLO	0x0101
> +#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_2	0x0102
> +#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_3	0x0103
> +#define PCI_DEVICE_ID_TOSHIBA_PICCOLO_5	0x0105
>  #define PCI_DEVICE_ID_TOSHIBA_TOPIC95	0x060a
>  #define PCI_DEVICE_ID_TOSHIBA_TOPIC97	0x060f
>  #define PCI_DEVICE_ID_TOSHIBA_TOPIC100	0x0617

This adds kernel regression and breaks kernel build (it is generally good to
grep kernel tree for the existing users before doing changes like the above):

drivers/ide/ide-pci-generic.c:

        { PCI_VDEVICE(TOSHIBA,  PCI_DEVICE_ID_TOSHIBA_PICCOLO),          4 },
        { PCI_VDEVICE(TOSHIBA,  PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),        4 },
        { PCI_VDEVICE(TOSHIBA,  PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),        4 },

Please fix your patch.

--
Bartlomiej Zolnierkiewicz
