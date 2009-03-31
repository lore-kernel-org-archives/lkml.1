Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbZCaTRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbZCaTRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZCaTRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:17:03 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:51565 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZCaTRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:17:01 -0400
Date: Tue, 31 Mar 2009 21:16:55 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] ide: Fix host drivers that need IRQF_SHARED
Message-ID: <Pine.LNX.4.64.0903312115050.29238@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 255115fb35f80735c21a1cbe9809e9795a3af26e ("ide: allow host drivers to
specify IRQ flags") added irq_flags fields to struct ide_port_info and struct
ide_host.  Drivers can now set ide_port_info.irq_flags = IRQF_SHARED, while
init_irq() passes ide_host.irq_flags to request_irq().

Unfortunately ide_host.irq_flags is never set, causing (on ARAnyM):

| Uniform Multi-Platform E-IDE driver
| ide: Falcon IDE controller
| Probing IDE interface ide0...
| hda: Sarge m68k, ATA DISK drive
| init_irq: sa = 0
| ide0: disabled, unable to get IRQ 15
| ide0: failed to initialize IDE interface
| ide0: disabling port

Solve this by copying ide_port_info.irq_flags to ide_host.irq_flags in
ide_host_alloc().

This bug probably affects the following IDE host drivers:
  - buddha
  - delkin_cb
  - falconide
  - gayle
  - ide-cs
  - macide
  - q40ide
  - scc_pata
  - sgiioc4

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/ide/ide-probe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 5488645..4ad37d6 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1317,6 +1317,7 @@ struct ide_host *ide_host_alloc(const struct ide_port_info *d, hw_regs_t **hws)
 		host->get_lock     = d->get_lock;
 		host->release_lock = d->release_lock;
 		host->host_flags = d->host_flags;
+		host->irq_flags = d->irq_flags;
 	}
 
 	return host;
-- 
1.6.2.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
