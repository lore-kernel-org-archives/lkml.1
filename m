Return-Path: <linux-kernel-owner+w=401wt.eu-S1762828AbXJMVku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828AbXJMVku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 17:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXJMVkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 17:40:41 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41053 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752863AbXJMVkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 17:40:40 -0400
Date: Sat, 13 Oct 2007 22:44:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE updates (part 2)
Message-ID: <20071013224452.71d6f61f@the-village.bc.nu>
In-Reply-To: <200710132259.53574.bzolnier@gmail.com>
References: <200710131825.24768.bzolnier@gmail.com>
	<20071013205618.3ddc91e9@the-village.bc.nu>
	<200710132259.53574.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Comment in pmac_ide_init_hwif_ports() is highly misleading as this function
> returns early only for "normal" IDE PCI devices (pmac_ide_init_hwif_ports()
> can be called outside ide-pmac driver through ppc_ide_md).

Follow the code you pasted

> 	pmif->regbase = (unsigned long) base + 0x2000;
> ...
> 	rc = pmac_ide_setup_device(pmif, hwif);

Ok so regbase is set

> ...
> }
> 
> static int
> pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
> {
> ...
> 	pmac_ide_init_hwif_ports(&hwif->hw, pmif->regbase, 0, &hwif->irq);

Now we pass a honking great zero for the ctrl_port
> ...
> }
> 
> void
> pmac_ide_init_hwif_ports(hw_regs_t *hw,
> 			      unsigned long data_port, unsigned long ctrl_port,
> 			      int *irq)
> {
> ...
> 	for (ix = 0; ix < MAX_HWIFS; ++ix)
> 		if (data_port == pmac_ide[ix].regbase)
> 			break;
> ---> since pmif->regbase was set earlier ix will be < MAX_HWIFS

> 	if (ix >= MAX_HWIFS) {
> 		/* Probably a PCI interface... */
> 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
> 			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
> 		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;

Which is zero..


See the problem ?

Alan
