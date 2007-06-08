Return-Path: <linux-kernel-owner+w=401wt.eu-S939281AbXFHHrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939281AbXFHHrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937970AbXFHHYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55280 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938380AbXFHHYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:47 -0400
Message-Id: <20070608072205.028590000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>,
       Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Jeff Garzik <jeff@garzik.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 21/54] ahci: disable 64bit dma on sb600
Content-Disposition: inline; filename=ahci-disable-64bit-dma-on-sb600.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tejun Heo <htejun@gmail.com>

SB600 claims it can do 64bit DMA but it can't.  Disable it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
This is backport of commit c7a42156d99bcea7f8173ba7a6034bbaa2ecb77c.
Due to initialization changes in devel branch, it looks a bit
different but does the same thing.  This problem makes sb600 ahci
controller malfunction if some memory is over 4G.  Please consider for
-stable.  Thanks.

 drivers/ata/ahci.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- linux-2.6.21.4.orig/drivers/ata/ahci.c
+++ linux-2.6.21.4/drivers/ata/ahci.c
@@ -170,6 +170,7 @@ enum {
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
 	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
+	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
 };
 
 struct ahci_cmd_hdr {
@@ -370,7 +371,8 @@ static const struct ata_port_info ahci_p
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
 				  ATA_FLAG_SKIP_D2H_BSY |
-				  AHCI_FLAG_IGN_SERR_INTERNAL,
+				  AHCI_FLAG_IGN_SERR_INTERNAL |
+				  AHCI_FLAG_32BIT_ONLY,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
@@ -1579,6 +1581,12 @@ static int ahci_host_init(struct ata_pro
 		probe_ent->n_ports = cap_n_ports;
 
 	using_dac = hpriv->cap & HOST_CAP_64;
+	if (using_dac && (probe_ent->port_flags & AHCI_FLAG_32BIT_ONLY)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do 64bit DMA, forcing 32bit\n");
+		using_dac = 0;
+	}
+
 	if (using_dac &&
 	    !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);

-- 
