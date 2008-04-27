Return-Path: <linux-kernel-owner+w=401wt.eu-S1763518AbYD0T4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518AbYD0T4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762250AbYD0TyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:54:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24698 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763396AbYD0TyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=MAIQgRHMVT+dWVCbmiwisdSk7bHEdhirUJlw/QchnxaA6jjQalSMhAsS3d4w67fMnNhd40GyaD/o+hIG9HppSx7DxVqk9CPmYV/vpNDVyQwdrRR4/j9PNskwSZdjF7vnpqDQtSGDpo/XEGVF6jJn9AO+/HGefd27VjxiMIxmCcw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/3] siimage: add sil_* I/O ops
Date: Sun, 27 Apr 2008 21:48:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200804092051.33163.bzolnier@gmail.com> <480A2926.6050404@ru.mvista.com>
In-Reply-To: <480A2926.6050404@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804272148.29131.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008, Sergei Shtylyov wrote:

[...]

> > @@ -124,6 +124,54 @@ static inline unsigned long siimage_seld
> >  	return base;
> >  }
> >  
> > +static u8 sil_ioread8(struct pci_dev *dev, unsigned long addr)
> > +{
> > +	u8 tmp = 0;
> > +
> > +	if (pci_get_drvdata(dev))
> > +		tmp = readb((void __iomem *)addr);
> > +	else
> > +		pci_read_config_byte(dev, addr, &tmp);
> > +
> > +	return tmp;
> > +}
> > +
> > +static u16 sil_ioread16(struct pci_dev *dev, unsigned long addr)
> > +{
> > +	u16 tmp = 0;
> > +
> > +	if (pci_get_drvdata(dev))
> > +		tmp = readw((void __iomem *)addr);
> > +	else
> > +		pci_read_config_word(dev, addr, &tmp);
> > +
> > +	return tmp;
> > +}
> > +
> > +static void sil_iowrite8(struct pci_dev *dev, u8 val, unsigned long addr)
> > +{
> > +	if (pci_get_drvdata(dev))
> > +		writeb(val, (void __iomem *)addr);
> > +	else
> > +		pci_write_config_byte(dev, addr, val);
> > +}
> > +
> > +static void sil_iowrite16(struct pci_dev *dev, u16 val, unsigned long addr)
> > +{
> > +	if (pci_get_drvdata(dev))
> > +		writew(val, (void __iomem *)addr);
> > +	else
> > +		pci_write_config_word(dev, addr, val);
> > +}
> > +
> > +static void sil_iowrite32(struct pci_dev *dev, u32 val, unsigned long addr)
> > +{
> > +	if (pci_get_drvdata(dev))
> > +		writel(val, (void __iomem *)addr);
> > +	else
> > +		pci_write_config_dword(dev, addr, val);
> > +}
> > +
> 
>     I think this could be further imporoved -- since we have to call 
> pci_get_drvdata() in the accessors anyway, we could have used it to get the 
> MMIO base right there, and thus be freed from the necessity to add it to the 
> MMIO offset in the callers and also most probably from having it copied to 
> hwif->hwif_data.

[...]

Or maybe we can remove sil_io* and always use PCI access (on the second
look none of sil_io* users seems to be performance critical)...

> > @@ -557,50 +513,80 @@ static unsigned int setup_mmio_siimage (
> [...]
> > +	sil_iowrite8(dev,        0x72, base + 0xA1);
> > +	sil_iowrite16(dev,     0x328A, base + 0xA2);
> > +	sil_iowrite32(dev, 0x62DD62DD, base + 0xA4);
> > +	sil_iowrite32(dev, 0x43924392, base + 0xA8);
> > +	sil_iowrite32(dev, 0x40094009, base + 0xAC);
> > +	sil_iowrite8(dev,        0x72, base ? (base + 0xE1) : 0xB1);
> > +	sil_iowrite16(dev,     0x328A, base ? (base + 0xE2) : 0xB2);
> > +	sil_iowrite32(dev, 0x62DD62DD, base ? (base + 0xE4) : 0xB4);
> > +	sil_iowrite32(dev, 0x43924392, base ? (base + 0xE8) : 0xB8);
> > +	sil_iowrite32(dev, 0x40094009, base ? (base + 0xEC) : 0xBC);
> > +
> 
>     Sigh, I was going to send a patch getting rid of these writes altogether 
> last year -- there should be no point in setting PIO/DMA/UDMA timings here.

Heh, I know the feeling damn too well - I still have few low-prio patches
back from *2004* which need to be refreshed and pushed out...

> Maybe I'll submit it...

Just do it. ;)

Thanks,
Bart
