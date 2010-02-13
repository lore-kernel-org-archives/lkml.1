Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab0BMNoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:44:01 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45945 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab0BMNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=em2PBj7Ld0xWw9TxUz6QQWWPKO+795guII0JBM68ERZb6pVnAxyGG5k5a5YSdANcfW
         pVRSNvEivRC4Lzn0ZZMGSyALfS+q94Lt5ERzRc27aLPLeIMW6wB07iX0LVi6b+LPnrz2
         286yLih1EtD5AxyzXrm/69eunB0Tlf+KNFAA8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Date: Sat, 13 Feb 2010 14:35:53 +0100
Message-Id: <20100213133553.11564.95723.sendpatchset@localhost>
In-Reply-To: <20100213133538.11564.94218.sendpatchset@localhost>
References: <20100213133538.11564.94218.sendpatchset@localhost>
Subject: [PATCH 1/3] pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards

On Monday 04 January 2010 02:30:24 pm Russell King wrote:

> Found the problem - getting rid of the read of the alt status register
> after the command has been written fixes the UDMA CRC errors on write:
> 
> @@ -676,7 +676,8 @@ void ata_sff_exec_command(struct ata_port *ap, const struct
> ata_taskfile *tf)
>         DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
> 
>         iowrite8(tf->command, ap->ioaddr.command_addr);
> -       ata_sff_pause(ap);
> +       ndelay(400);
> +//     ata_sff_pause(ap);
>  }
>  EXPORT_SYMBOL_GPL(ata_sff_exec_command);
> 
> 
> This rather makes sense.  The PDC20247 handles the UDMA part of the
> protocol.  It has no way to tell the PDC20246 to wait while it suspends
> UDMA, so that a normal register access can take place - the 246 ploughs
> on with the register access without any regard to the state of the 247.
> 
> If the drive immediately starts the UDMA protocol after a write to the
> command register (as it probably will for the DMA WRITE command), then
> we'll be accessing the taskfile in the middle of the UDMA setup, which
> can't be good.  It's certainly a violation of the ATA specs.

Fix it by adding custom ->sff_exec_command method for UDMA33 chipsets.

Debugged-by: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc202xx_old.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -2,7 +2,7 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
- *			  (C) 2007,2009 Bartlomiej Zolnierkiewicz
+ *			  (C) 2007,2009,2010 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
@@ -26,6 +26,15 @@
 
 #include "pata_pdc202xx_old.h"
 
+static void pdc20246_exec_command(struct ata_port *ap,
+				  const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+
+	iowrite8(tf->command, ap->ioaddr.command_addr);
+	ndelay(400);
+}
+
 /**
  *	pdc2026x_bmdma_start		-	DMA engine begin
  *	@qc: ATA command
@@ -171,6 +180,8 @@ static struct ata_port_operations pdc202
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= pdc202xx_set_piomode,
 	.set_dmamode		= pdc202xx_set_dmamode,
+
+	.sff_exec_command	= pdc20246_exec_command,
 };
 
 static struct ata_port_operations pdc2026x_port_ops = {
