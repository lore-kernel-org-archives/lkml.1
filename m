Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXC3VNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXC3VNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbXC3VNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:13:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbXC3VNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:13:07 -0400
Date: Fri, 30 Mar 2007 14:07:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jeff@garzik.org>
Subject: [patch 36/37] libata: sata_mv: Fix 50xx irq mask
Message-ID: <20070330210706.GM29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-sata_mv-fix-50xx-irq-mask.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Garzik <jeff@garzik.org>

[libata] sata_mv: Fix 50xx irq mask

IRQ mask bits assumed a 60xx or newer generation chip, which is very
wrong for the 50xx series.  Luckily both generations shared the per-port
interrupt mask bits, leaving only the "misc chip features" bits to be
completely mismatched.

Fix 50xx by ensuring we only program bits that exist.

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ata/sata_mv.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -139,14 +139,19 @@ enum {
 	PCI_ERR			= (1 << 18),
 	TRAN_LO_DONE		= (1 << 19),	/* 6xxx: IRQ coalescing */
 	TRAN_HI_DONE		= (1 << 20),	/* 6xxx: IRQ coalescing */
+	PORTS_0_3_COAL_DONE	= (1 << 8),
+	PORTS_4_7_COAL_DONE	= (1 << 17),
 	PORTS_0_7_COAL_DONE	= (1 << 21),	/* 6xxx: IRQ coalescing */
 	GPIO_INT		= (1 << 22),
 	SELF_INT		= (1 << 23),
 	TWSI_INT		= (1 << 24),
 	HC_MAIN_RSVD		= (0x7f << 25),	/* bits 31-25 */
+	HC_MAIN_RSVD_5		= (0x1fff << 19), /* bits 31-19 */
 	HC_MAIN_MASKED_IRQS	= (TRAN_LO_DONE | TRAN_HI_DONE |
 				   PORTS_0_7_COAL_DONE | GPIO_INT | TWSI_INT |
 				   HC_MAIN_RSVD),
+	HC_MAIN_MASKED_IRQS_5	= (PORTS_0_3_COAL_DONE | PORTS_4_7_COAL_DONE |
+				   HC_MAIN_RSVD_5),
 
 	/* SATAHC registers */
 	HC_CFG_OFS		= 0,
@@ -2287,7 +2292,11 @@ static int mv_init_host(struct pci_dev *
 
 	/* and unmask interrupt generation for host regs */
 	writelfl(PCI_UNMASK_ALL_IRQS, mmio + PCI_IRQ_MASK_OFS);
-	writelfl(~HC_MAIN_MASKED_IRQS, mmio + HC_MAIN_IRQ_MASK_OFS);
+
+	if (IS_50XX(hpriv))
+		writelfl(~HC_MAIN_MASKED_IRQS_5, mmio + HC_MAIN_IRQ_MASK_OFS);
+	else
+		writelfl(~HC_MAIN_MASKED_IRQS, mmio + HC_MAIN_IRQ_MASK_OFS);
 
 	VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x "
 		"PCI int cause/mask=0x%08x/0x%08x\n",

-- 
