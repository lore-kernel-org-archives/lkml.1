Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbXEKAw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbXEKAw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 20:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757441AbXEKAwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 20:52:51 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:51301 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbXEKAwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 20:52:50 -0400
Date: Fri, 11 May 2007 09:52:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <htejun@gmail.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: libata reset-seq merge broke sata_sil on sh
Message-ID: <20070511005217.GA23186@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, jeff@garzik.org,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4643196B.7070806@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:08:59PM +0200, Tejun Heo wrote:
> Paul Mundt wrote:
> > The detection is simply flaky after that point, however before the
> > current master it never hit the 35 second point (and thus never implied
> > that the link was down). I'll double check the bisect log to see if there
> > was anything beyond that that may have caused it.
> > 
> > The -ENODEV at least implies that the SRST fails, so at least that's a
> > starting point.
> 
> If prereset() fails to get the initial DRDY before 10secs, it assumes
> something went wrong and escalates to hardreset.  sil family of
> controllers report 0xff status while the link is broken and it seems
> that your particular drive needs more than the current 150ms to recover
> phy link.  It probably went unnoticed till now because the device was
> never hardreset before.  If the diagnosis is correct, increasing the
> delay in hardreset should fix the problem.  Well, let's see.  :-)
> 
Bumping the hardreset delay up does indeed fix it, I've had to bump it up
to 1200 before it started working (at 600 it still fails):

[    0.967379] scsi0 : sata_sil
[    0.970425] scsi1 : sata_sil
[    0.973298] ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
[    0.981331] ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
[    1.299353] ata1: device not ready (errno=-19), forcing hardreset
[    2.817893] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    2.826284] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
[    2.831052] ata1.00: ATA-5: HHD424020F7SV00, 00MLA0A5, max UDMA/100
[    2.837548] ata1.00: 39070080 sectors, multi 0: LBA
[    2.842702] ata1.00: applying bridge limits
[    2.854162] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
[    2.858938] ata1.00: configured for UDMA/100
[    3.172602] ata2: SATA link down (SStatus 0 SControl 310)
[    3.175736] scsi 0:0:0:0: Direct-Access     ATA      HHD424020F7SV00  00ML PQ: 0 ANSI: 5

I'm not sure if it matters or not, but this is an iVDR drive, so that
might also have additional implications.

--

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4595d1f..4dad3fd 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3518,7 +3518,7 @@ int sata_std_hardreset(struct ata_port *ap, unsigned int *class,
 	}
 
 	/* wait a while before checking status, see SRST for more info */
-	msleep(150);
+	msleep(1200);
 
 	rc = ata_wait_ready(ap, deadline);
 	/* link occupied, -ENODEV too is an error */
