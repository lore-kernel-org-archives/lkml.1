Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZKSShr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZKSShr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbZKSShq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:37:46 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:39351 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753052AbZKSShp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:37:45 -0500
Message-ID: <4B0590A2.9050306@ru.mvista.com>
Date: Thu, 19 Nov 2009 21:38:26 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 4/5] pata: Update experimental tags
References: <20091117144450.15430.83450.stgit@localhost.localdomain>	<200911191838.11791.bzolnier@gmail.com>	<20091119175051.6a91d160@lxorguk.ukuu.org.uk>	<200911191852.23061.bzolnier@gmail.com> <20091119182132.5155f819@lxorguk.ukuu.org.uk>
In-Reply-To: <20091119182132.5155f819@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>Fixed where?  I posted the patch as soon as I noticed the problem.

> Its not posted because unlike you I don't post patches as soon as I
> notice them. I test them first. Which is why for example I discovered the
> bug in the drivers/ide one. Did you check the vendor driver and then
> stick 40 and 80 wire cables on the system to check the bits on a 3x2N ?

> No I didn't think so. You see if you had you'd have discovered something
> else. You'd have discovered another bug in the old IDE one. The driver
> code for these chips isn't reliable and doesn't work at all in some cases.

>>Told me about it?  

> Yes - or do you only write replies not read them ?

> NAK - the patch is inadequate.

    No, it was. And yours isn't quite.

> The procedure in the vendor driver does
> appear to work on the newer chips however.

> Probably worth double checking
> the HPT37x and seeing if it needs the same debounce delays.

    All vendor drivers I have do call StallExec(10) when detecting cable 
type, so need to add the delay to pata_hpt37x too.

> Give the patch below a test on your HPT3x2N series device. The PCI -> io
> access change doesn't appear to matter but is used by the vendor driver.

    We should then switch all the driver to I/O access across all the 
driver, not just here.

> I've switched to it because we've been burned before with only some of the
> I/O space being visible both ways (eg on the 371N).

    This is not the case anyway. The change is pointless.

> The critical bit other
> than get the bits the right way around appears to be the 10uS delay.

    That's *another* issue.
    BTW I did seem to *not* need the delay on HPT371N. Though worth retesting...

> Alan
> --
> 
> commit d27660f440b516f58385649f705b07f10b24da94
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Thu Nov 19 17:59:26 2009 +0000
> 
>     pata_hpt3x2n: Fix cable detection
>     
>     The version inherited from drivers/ide doesn't work on the newer chipsets
>     at least not reliably.

    Please don't call it inherited when you have a bug the drivers/ide/ code 
doesn't have.

> The vendors own driver uses a different process and
>     that one appears to produce plausible numbers.

    I don't consider such description adequate. It doesn't mention the 
original bug with reversed bits at all.

>     Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
> index 3d59fe0..d92ad5b 100644
> --- a/drivers/ata/pata_hpt3x2n.c
> +++ b/drivers/ata/pata_hpt3x2n.c
> @@ -124,16 +124,15 @@ static u32 hpt3x2n_find_mode(struct ata_port *ap, int speed)
>  static int hpt3x2n_cable_detect(struct ata_port *ap)
>  {
>  	u8 scr2, ata66;
> -	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
> +	void __iomem *base = ap->ioaddr.bmdma_addr;
>  
> -	pci_read_config_byte(pdev, 0x5B, &scr2);
> -	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
> -	/* Cable register now active */
> -	pci_read_config_byte(pdev, 0x5A, &ata66);
> -	/* Restore state */
> -	pci_write_config_byte(pdev, 0x5B, scr2);
> +	scr2 = ioread8(base + 0x7B);
> +	iowrite8(scr2 & ~0x01, base + 0x7B);
> +	udelay(10);	/* Debounce */
> +	ata66 = ioread8(base + 0x7A);
> +	iowrite8(scr2, base + 0x7B);
>  
> -	if (ata66 & (1 << ap->port_no))
> +	if (ata66 & (2 >> ap->port_no))
>  		return ATA_CBL_PATA40;
>  	else
>  		return ATA_CBL_PATA80;

    I'd suggest to address the delay by another, separate patch to both 
pata_hpt37x and pata_hpt3x2n drivers, and accept Bart's original patch for 
bit reversing...

WBR, Sergei
