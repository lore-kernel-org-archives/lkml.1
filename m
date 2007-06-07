Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbXFGPpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbXFGPpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764635AbXFGPpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:45:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764522AbXFGPpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:45:39 -0400
Date: Thu, 7 Jun 2007 08:45:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       david@dgreaves.com, jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling
 NODATA commands
Message-Id: <20070607084515.668ae621.akpm@linux-foundation.org>
In-Reply-To: <20070607151717.GA6653@havoc.gtf.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se>
	<20070605215256.GT31565@havoc.gtf.org>
	<46665AB5.6040508@gmail.com>
	<20070606102122.GD29122@htj.dyndns.org>
	<20070607151717.GA6653@havoc.gtf.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 11:17:17 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> On Wed, Jun 06, 2007 at 07:21:22PM +0900, Tejun Heo wrote:
> > sata_promise uses two different command modes - packet and TF.  Packet
> > mode is intelligent low-overhead mode while TF is the same old
> > taskfile interface.  As with other advanced interface (ahci/sil24),
> > ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands
> > are issued using TF interface in polling mode, so pdc_interrupt()
> > considers interrupts spurious if ATA_TFLAG_POLLING is set.
> > 
> > This is broken for polling NODATA commands because command is issued
> > using packet mode but the interrupt handler ignores it due to
> > ATA_TFLAG_POLLING.  Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA
> > commands are issued using TF interface if ATA_TFLAG_POLLING is set.
> > 
> > This patch fixes detection failure introduced by polling SETXFERMODE.
> > 
> > Signed-off-by: Tejun Heo <htejun@gmail.com>
> > ---
> > David, please verify this patch.  Mikael, does this look okay?  Please
> > push this upstream after David and Mikael's ack.
> > 
> > (This repost is identical to the previous posting but it's now on the
> >  correct thread.)
> 
> Acked-by: Jeff Garzik <jeff@garzik.org>
> 
> Tejun, would you mind pushing this upstream to Linus/Andrew?
> 
> I'm travelling this week, and my home firewall doesn't like me.
> It is probably easier for you than me.
> 

I added the below to my next batch:


From: Tejun Heo <htejun@gmail.com>

sata_promise uses two different command modes - packet and TF.  Packet mode
is intelligent low-overhead mode while TF is the same old taskfile
interface.  As with other advanced interface (ahci/sil24),
ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands are
issued using TF interface in polling mode, so pdc_interrupt() considers
interrupts spurious if ATA_TFLAG_POLLING is set.

This is broken for polling NODATA commands because command is issued using
packet mode but the interrupt handler ignores it due to ATA_TFLAG_POLLING. 
Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA commands are issued
using TF interface if ATA_TFLAG_POLLING is set.

This patch fixes detection failure introduced by polling SETXFERMODE.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Mikael Pettersson <mikpe@it.uu.se>
Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_promise.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/ata/sata_promise.c~sata_promise-use-tf-interface-for-polling-nodata-commands drivers/ata/sata_promise.c
--- a/drivers/ata/sata_promise.c~sata_promise-use-tf-interface-for-polling-nodata-commands
+++ a/drivers/ata/sata_promise.c
@@ -784,9 +784,12 @@ static unsigned int pdc_qc_issue_prot(st
 		if (qc->dev->flags & ATA_DFLAG_CDB_INTR)
 			break;
 		/*FALLTHROUGH*/
+	case ATA_PROT_NODATA:
+		if (qc->tf.flags & ATA_TFLAG_POLLING)
+			break;
+		/*FALLTHROUGH*/
 	case ATA_PROT_ATAPI_DMA:
 	case ATA_PROT_DMA:
-	case ATA_PROT_NODATA:
 		pdc_packet_start(qc);
 		return 0;
 
@@ -800,7 +803,7 @@ static unsigned int pdc_qc_issue_prot(st
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+		 tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_tf_load(ap, tf);
 }
 
@@ -808,7 +811,7 @@ static void pdc_tf_load_mmio(struct ata_
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+		 tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_exec_command(ap, tf);
 }
 
_

