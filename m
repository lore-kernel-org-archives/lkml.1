Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYBOVqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYBOVqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbYBOVqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:46:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:35438 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757755AbYBOVqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:46:24 -0500
Subject: Re: [PATCH] libata: Add MMIO support to pata_sil680
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Tim Ellis <tim@ngndg.com>,
       linux-kernel@vger.kernel.org, jeff@garzik.org
In-Reply-To: <20080215155332.2b89c429@core>
References: <32334D99-DB01-4645-97DC-88D2E7BA2BE5@ngndg.com>
	 <1202850129.7410.22.camel@pasglop>
	 <Pine.LNX.4.64.0802151651340.27735@axis700.grange>
	 <20080215155332.2b89c429@core>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 08:45:56 +1100
Message-Id: <1203111956.22915.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 15:53 +0000, Alan Cox wrote:
> > > That's strange though. Somebody with knowledge of that HW (or specs) who
> > > can spot something ? Could it be an issue with timing ?
> > > 
> > > I don't have HW access to this machine. If somebody could send one to me
> > > I could do more investigation.
> > 
> > Ben, would an ssh access to such a machine and to a terminal server 
> > suffice?
> 
> It says clearly in the code where to start. See the FIXME notes in both
> libata-sff and libata-core about MMIO. Neither the DMA transfer start or
> the probe SRST sequence are correct with MMIO posting and this hasn't
> been fixed as I pointed out was needed when I originally NAKked the
> change.
> 
> Without those being fixed (especially SRST) on any device with heavy PCI
> posting of mmio your controller *wont work*.

The dbdma start is mostly harmless (things don't get posted for -that-
long), though I suppose it's worth fixing. Would reading back dmactl do
in that case or do you foresee any kind of side effect ? (Maybe only
doing it for MMIO ?)

As for SRST, I'm not totally confident how safe it is to read back
there while doing the reset sequence, so I'm tempted to really only
do it for MMIO and use altstat rather than ctl/stat (the later tends
to have side effects which we don't want here).

What do you think ?

The main problem from here is that I don't know whether we are using
MMIO or PIO from libata-core. Maybe I can add a host flag indicate
that such flushing is needed ?

In the meantime, Guennadi, can you check if that patch helps for you
(to see if that is indeed the problem):


diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 004dae4..1451a52 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3461,10 +3461,13 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
 
 	/* software reset.  causes dev0 to be selected */
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	ioread16(ioaddr->nsect_addr);
 	udelay(20);	/* FIXME: flush */
 	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
+	ioread16(ioaddr->nsect_addr);
 	udelay(20);	/* FIXME: flush */
 	iowrite8(ap->ctl, ioaddr->ctl_addr);
+	ioread16(ioaddr->nsect_addr);
 
 	/* wait a while before checking status */
 	ata_wait_after_reset(ap, deadline);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 60cd4b1..81d5828 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -273,6 +273,7 @@ void ata_bmdma_start(struct ata_queued_cmd *qc)
 	 * FIXME: The posting of this write means I/O starts are
 	 * unneccessarily delayed for MMIO
 	 */
+	ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
 }
 
 /**

Cheers,
Ben.


