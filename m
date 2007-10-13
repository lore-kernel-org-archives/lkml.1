Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbXJMU4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbXJMU4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 16:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbXJMU4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 16:56:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:35840 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493AbXJMU4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 16:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hte3sesxqa/EiHc8LqReSc4LJcQwDc/npty5O5pFQQoWFi2vOhBR8wJxHHH8FuMc8JQ7ocBUZCnjAPrcXe1R82RRExFjuTU+6ZezH/ssKuYoIY+5fx5LQzO9WV6mrt/9ZbokFgXzGt1wz8s00tzX6GquIT68qGegxBSyTQXly5o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] IDE updates (part 2)
Date: Sat, 13 Oct 2007 22:59:53 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710131825.24768.bzolnier@gmail.com> <20071013205618.3ddc91e9@the-village.bc.nu>
In-Reply-To: <20071013205618.3ddc91e9@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710132259.53574.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 October 2007, Alan Cox wrote:
> On Sat, 13 Oct 2007 18:25:24 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > 
> > Hi,
> > 
> > highlights of this update:
> > 
> > * Rework of IDE PMAC host driver: bugfixes, removal of the code
> >   duplicated from the IDE core and conversion to use the generic
> >   DMA tuning code path (the rework cuts ide-pmac.c by ~200 LOC).
> 
> Reading the current driver from the git tree I don't see how the PCI
> driver ever sets the ctl register base. It seems to always be set to zero
> which means you can't issue SRST and reset sequences ?

Hi Alan,

Comment in pmac_ide_init_hwif_ports() is highly misleading as this function
returns early only for "normal" IDE PCI devices (pmac_ide_init_hwif_ports()
can be called outside ide-pmac driver through ppc_ide_md).

static int __devinit
pmac_ide_pci_attach(struct pci_dev *pdev, const struct pci_device_id *id)
{
...
	pmif = &pmac_ide[i];
...
	pmif->regbase = (unsigned long) base + 0x2000;
...
	rc = pmac_ide_setup_device(pmif, hwif);
...
}

static int
pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
{
...
	pmac_ide_init_hwif_ports(&hwif->hw, pmif->regbase, 0, &hwif->irq);
...
}

void
pmac_ide_init_hwif_ports(hw_regs_t *hw,
			      unsigned long data_port, unsigned long ctrl_port,
			      int *irq)
{
...
	for (ix = 0; ix < MAX_HWIFS; ++ix)
		if (data_port == pmac_ide[ix].regbase)
			break;
---> since pmif->regbase was set earlier ix will be < MAX_HWIFS
	if (ix >= MAX_HWIFS) {
		/* Probably a PCI interface... */
		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
		return;
	}

	for (i = 0; i < 8; ++i)
		hw->io_ports[i] = data_port + i * 0x10;
---> ctl register base will be set here
	hw->io_ports[8] = data_port + 0x160;
...
}

Bart
