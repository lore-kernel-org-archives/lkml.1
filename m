Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbXIZEDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbXIZEDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 00:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXIZEDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 00:03:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41922 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbXIZEDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 00:03:22 -0400
Message-ID: <46F9DA07.4080201@garzik.org>
Date: Wed, 26 Sep 2007 00:03:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Peer Chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
References: <200709211327569648280@gmail.com>
In-Reply-To: <200709211327569648280@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010609090701050103000504"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609090701050103000504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Peer Chen wrote:
> According to the description of section 5.2.2.1 and 10.1.2 of AHCI specification rev1_1/rev1_2, GHC.HR shall only be set to ¡®1¡¯
> by software when GHC.AE is set to ¡®1¡¯.
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>
> ---
> --- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
> +++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-20 11:07:31.000000000 -0400
> @@ -834,6 +834,10 @@ static int ahci_reset_controller(struct 
>  	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
>  	u32 tmp;
>  
> +        /* turn on AHCI mode before controller reset*/
> +        writel(HOST_AHCI_EN, mmio + HOST_CTL);
> +        (void) readl(mmio + HOST_CTL);  /* flush */

applied the attached patch, inspired by yours.


--------------010609090701050103000504
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

commit 5fca365d6109b51cfeb3515ca660cd2dc6e8822c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Sep 26 00:02:41 2007 -0400

    [libata] AHCI: enable AHCI mode, before using AHCI reset
    
    AHCI spec says host-reset bit may only be set when the ahci-enable bit
    is also set.
    
    Noticed by Peer Chen <peerchen@gmail.com>
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/ata/ahci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

5fca365d6109b51cfeb3515ca660cd2dc6e8822c
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 9f3c591..b615390 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -827,8 +827,14 @@ static int ahci_reset_controller(struct ata_host *host)
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	u32 tmp;
 
-	/* global controller reset */
+	/* we must be in AHCI mode, before using anything
+	 * AHCI-specific, such as HOST_RESET.
+	 */
 	tmp = readl(mmio + HOST_CTL);
+	if (!(tmp & HOST_AHCI_EN))
+		writel(tmp | HOST_AHCI_EN, mmio + HOST_CTL);
+
+	/* global controller reset */
 	if ((tmp & HOST_RESET) == 0) {
 		writel(tmp | HOST_RESET, mmio + HOST_CTL);
 		readl(mmio + HOST_CTL); /* flush */

--------------010609090701050103000504--
