Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbXC3VNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbXC3VNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbXC3VNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:13:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51806 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbXC3VMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:12:52 -0400
Date: Fri, 30 Mar 2007 14:07:02 -0700
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
Subject: [patch 35/37] libata: sata_mv: dont touch reserved bits in EDMA
	config register
Message-ID: <20070330210702.GL29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-sata_mv-don-t-touch-reserved-bits-in-edma-config-register.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Garzik <jeff@garzik.org>

[libata] sata_mv: don't touch reserved bits in EDMA config register

The code in mv_edma_cfg() reflected its 60xx origins, by doing things
[slightly] incorrectly on the older 50xx and newer 6042/7042 chips.

Clean up the EDMA configuration setup such that, each chip family
carefully initializes its own EDMA setup.

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/ata/sata_mv.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -843,23 +843,27 @@ static void mv_edma_cfg(struct mv_host_p
 	u32 cfg = readl(port_mmio + EDMA_CFG_OFS);
 
 	/* set up non-NCQ EDMA configuration */
-	cfg &= ~0x1f;		/* clear queue depth */
-	cfg &= ~EDMA_CFG_NCQ;	/* clear NCQ mode */
 	cfg &= ~(1 << 9);	/* disable equeue */
 
-	if (IS_GEN_I(hpriv))
+	if (IS_GEN_I(hpriv)) {
+		cfg &= ~0x1f;		/* clear queue depth */
 		cfg |= (1 << 8);	/* enab config burst size mask */
+	}
 
-	else if (IS_GEN_II(hpriv))
+	else if (IS_GEN_II(hpriv)) {
+		cfg &= ~0x1f;		/* clear queue depth */
 		cfg |= EDMA_CFG_RD_BRST_EXT | EDMA_CFG_WR_BUFF_LEN;
+		cfg &= ~(EDMA_CFG_NCQ | EDMA_CFG_NCQ_GO_ON_ERR); /* clear NCQ */
+	}
 
 	else if (IS_GEN_IIE(hpriv)) {
-		cfg |= (1 << 23);	/* dis RX PM port mask */
-		cfg &= ~(1 << 16);	/* dis FIS-based switching (for now) */
+		cfg |= (1 << 23);	/* do not mask PM field in rx'd FIS */
+		cfg |= (1 << 22);	/* enab 4-entry host queue cache */
 		cfg &= ~(1 << 19);	/* dis 128-entry queue (for now?) */
 		cfg |= (1 << 18);	/* enab early completion */
-		cfg |= (1 << 17);	/* enab host q cache */
-		cfg |= (1 << 22);	/* enab cutthrough */
+		cfg |= (1 << 17);	/* enab cut-through (dis stor&forwrd) */
+		cfg &= ~(1 << 16);	/* dis FIS-based switching (for now) */
+		cfg &= ~(EDMA_CFG_NCQ | EDMA_CFG_NCQ_GO_ON_ERR); /* clear NCQ */
 	}
 
 	writelfl(cfg, port_mmio + EDMA_CFG_OFS);

-- 
