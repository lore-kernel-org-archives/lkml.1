Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbXFFKSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbXFFKSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbXFFKSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:18:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:13008 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608AbXFFKSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=j8PyBB4Wplqq0GaWavWUCxz5vtZKbVJKPyQhufZ1VSaQxa8gkd+G9htR3Vq/yUiBUdrm8c2wlre4b8gFIvJosgImAnCSdLPtZMfVUSciRXlgAEB4Wa2TjHuFqhSQbzFlpyDXsdapSEV8dd5DMvUg1xPsC1s2AGW3G9cba09D3MI=
Date: Wed, 6 Jun 2007 19:18:37 +0900
From: Tejun Heo <htejun@gmail.com>
To: David Greaves <david@dgreaves.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       Neil Brown <neilb@suse.de>, mikpe@it.uu.se
Subject: [PATCH] sata_promise: use TF interface for polling NODATA commands
Message-ID: <20070606101837.GC29122@htj.dyndns.org>
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46667160.80905@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sata_promise uses two different command modes - packet and TF.  Packet
mode is intelligent low-overhead mode while TF is the same old
taskfile interface.  As with other advanced interface (ahci/sil24),
ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands
are issued using TF interface in polling mode, so pdc_interrupt()
considers interrupts spurious if ATA_TFLAG_POLLING is set.

This is broken for polling NODATA commands because command is issued
using packet mode but the interrupt handler ignores it due to
ATA_TFLAG_POLLING.  Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA
commands are issued using TF interface if ATA_TFLAG_POLLING is set.

This patch fixes detection failure introduced by polling SETXFERMODE.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
David, please verify this patch.  Mikael, does this look okay?  Please
push this upstream after David and Mikael's ack.

Thanks.

 drivers/ata/sata_promise.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 2b924a6..6dc0b01 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -784,9 +784,12 @@ static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
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
 
@@ -800,7 +803,7 @@ static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+		 tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_tf_load(ap, tf);
 }
 
@@ -808,7 +811,7 @@ static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
 	WARN_ON (tf->protocol == ATA_PROT_DMA ||
-		 tf->protocol == ATA_PROT_NODATA);
+		 tf->protocol == ATA_PROT_ATAPI_DMA);
 	ata_exec_command(ap, tf);
 }
 
