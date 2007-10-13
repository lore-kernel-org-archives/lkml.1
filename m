Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbXJMWFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbXJMWFY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbXJMWFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:05:08 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:7229 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbXJMWFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NwpP83Rj9GYKNe2NMbDgpy5SRsUL74VmC+Ix95eieykftjDf/Xf/hYgpKokK3+kp3OpVQ4t0Pr9u8btbJyfUpMXtEPI+6tm5f1ctVJC6RtI6BwpDcuGnhcZC2EODWcp7D0CycQJZ8rU2/Gn7lfxCqqpwbNPh1okwFFB3uLtn3bg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] IDE updates (part 2)
Date: Sun, 14 Oct 2007 00:09:06 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710131825.24768.bzolnier@gmail.com> <200710132259.53574.bzolnier@gmail.com> <20071013224452.71d6f61f@the-village.bc.nu>
In-Reply-To: <20071013224452.71d6f61f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710140009.06260.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 October 2007, Alan Cox wrote:
> > Comment in pmac_ide_init_hwif_ports() is highly misleading as this function
> > returns early only for "normal" IDE PCI devices (pmac_ide_init_hwif_ports()
> > can be called outside ide-pmac driver through ppc_ide_md).
> 
> Follow the code you pasted
> 
> > 	pmif->regbase = (unsigned long) base + 0x2000;
> > ...
> > 	rc = pmac_ide_setup_device(pmif, hwif);
> 
> Ok so regbase is set
> 
> > ...
> > }
> > 
> > static int
> > pmac_ide_setup_device(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
> > {
> > ...
> > 	pmac_ide_init_hwif_ports(&hwif->hw, pmif->regbase, 0, &hwif->irq);
> 
> Now we pass a honking great zero for the ctrl_port
> > ...
> > }
> > 
> > void
> > pmac_ide_init_hwif_ports(hw_regs_t *hw,
> > 			      unsigned long data_port, unsigned long ctrl_port,
> > 			      int *irq)
> > {
> > ...
> > 	for (ix = 0; ix < MAX_HWIFS; ++ix)

this loop is a tricky part, regbase is set so we break out early

> > 		if (data_port == pmac_ide[ix].regbase)
> > 			break;
> > ---> since pmif->regbase was set earlier ix will be < MAX_HWIFS
                                             ^^^^^^^^^^^^^^^^^^^^^^
> > 	if (ix >= MAX_HWIFS) {
            ^^^^^^^^^^^^^^^
> > 		/* Probably a PCI interface... */
> > 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
> > 			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
> > 		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
> 
> Which is zero..
> 
> 
> See the problem ?
