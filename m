Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZFVLo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZFVLo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZFVLn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:43:29 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:40978 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbZFVLnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=o6wtRCbQUkQvqvj2x7nVkaemQrHB/ZnPrNVjayj05yOWWKN3WlUs9OokvPMjYAYJlj
         DzibwXbzYpgOa5B2gTBX4PubcjoUXom6qVfhph0mRW/nK7nMRtEZPLS3gDWHeyVH9oXn
         sNlK3VycieQnr5MdCPnplCrz0RSYk5rfrtb38=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
Date: Mon, 22 Jun 2009 13:21:37 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906211446.38598.elendil@planet.nl> <20090621.224510.96380426.davem@davemloft.net> <200906220843.14337.elendil@planet.nl>
In-Reply-To: <200906220843.14337.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906221321.44672.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009 08:43:13 Frans Pop wrote:
> On Monday 22 June 2009, David Miller wrote:
> > Some things other than the commit in question have changed in the area
> > of interrupt and chip initialization and I'll try to go through
> > the commits to get some clues.
> 
> Great.
> 
> JFTR, here's the full output of your debug print. All 32 prints are
> identical and the "nobody cared" is printed immediately after.
> No really new info I guess...

Frans, here is a draft fix (sorry for not being able to finish it yesterday
so we could potentially close the issue within 24h of the initial report).

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix handling of unexpected IRQs vs request_irq()

Add ide_host_enable_irqs() helper and use it in ide_host_register()
before registering ports.  Then remove no longer needed IRQ unmasking
from in init_irq().

This should fix the problem with "screaming" shared IRQ on the first
port (after request_irq() call while we have the unexpected IRQ pending
on the second port) which was uncovered by my rework of the serialized
interfaces support.

Cc: David Miller <davem@davemloft.net>
Reported-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
David, if it doesn't work I think that the next thing to look into is
the change of nIEN setting itself (some devices are just buggy and may
generate spurious IRQs on such operation).

Alternatively you can fix the issue quickly be extending the coverage of
the recently added IDE_PFLAG_PROBING port flag and testing for the flag
inside ide_intr().

 drivers/ide/ide-probe.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -818,6 +818,24 @@ static int ide_port_setup_devices(ide_hw
 	return j;
 }
 
+static void ide_host_enable_irqs(struct ide_host *host)
+{
+	ide_hwif_t *hwif;
+	int i;
+
+	ide_host_for_each_port(i, hwif, host) {
+		if (hwif == NULL)
+			continue;
+
+		/* clear any pending IRQs */
+		hwif->tp_ops->read_status(hwif);
+
+		/* unmask IRQs */
+		if (hwif->io_ports.ctl_addr)
+			hwif->tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
+	}
+}
+
 /*
  * This routine sets up the IRQ for an IDE interface.
  */
@@ -831,9 +849,6 @@ static int init_irq (ide_hwif_t *hwif)
 	if (irq_handler == NULL)
 		irq_handler = ide_intr;
 
-	if (io_ports->ctl_addr)
-		hwif->tp_ops->write_devctl(hwif, ATA_DEVCTL_OBS);
-
 	if (request_irq(hwif->irq, irq_handler, sa, hwif->name, hwif))
 		goto out_up;
 
@@ -1404,6 +1419,8 @@ int ide_host_register(struct ide_host *h
 			ide_port_tune_devices(hwif);
 	}
 
+	ide_host_enable_irqs(host);
+
 	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
