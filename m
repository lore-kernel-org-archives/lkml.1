Return-Path: <linux-kernel-owner+w=401wt.eu-S934768AbXFFR5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768AbXFFR5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbXFFR5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:57:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757916AbXFFR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:57:01 -0400
Date: Wed, 6 Jun 2007 10:56:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, htejun@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606105650.bebf1c95.akpm@linux-foundation.org>
In-Reply-To: <4666D3F8.4010002@gmail.com>
References: <200706061421.l56ELDfB004305@harpo.it.uu.se>
	<4666D3F8.4010002@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 17:34:16 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> Mikael Pettersson napsal(a):
> > On Wed, 06 Jun 2007 15:04:00 +0200, Jiri Slaby wrote:
> >> Andrew Morton napsal(a):
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> >> It freezes during bootup while searching for sata drives on sata_promise. There
> >> were 2 issues with sata_promise in -rc4 IIRC, one was fixed, the latter remains
> >> unresolved. Or, should be this solved too, Mikael, Tejun and is this yet
> >> eanother problem? (In this case I'll post dmesg and co.)
> > 
> > I know of only one sata_promise-specific issue in 2.6.22-rc4.
> > Tejun's "sata_promise: use TF interface for polling NODATA commands"
> > patch posted today fixes it.
> 
> It's in that -mm, so I think, this seems to be another problem.

No, it wasn't in 2.6.22-rc4-mm1.

Here it is - please test?


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

