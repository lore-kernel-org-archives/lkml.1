Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbZBHQCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbZBHQCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZBHQCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:02:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:4986 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZBHQCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:02:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d0S8dO93ompgpZnu7CKYdGi6ajZ7aniLXRqSQF9lgOUOY742ViamCBd5w7BwXlpWnp
         zfQLYRqn8l+fswix5RBU3yn9jqkKznRM1MEcK5ln6tAtCaCD6GJqTAYf55gkct8irL6j
         N2xtr/GlJ9nbETCJTbCezltyoJBzVBvwu1rD4=
Message-ID: <498F01FA.90900@gmail.com>
Date: Sun, 08 Feb 2009 17:02:02 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] pxa2xx_spi: spi_bfin5xx: limit reaches -1 rather than
 0
References: <498F0004.1030709@gmail.com>
In-Reply-To: <498F0004.1030709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi drivers/spi/pxa2xx_spi.c +919 
vi drivers/spi/spi_bfin5xx.c +645

        if (flush(drv_data) == 0) {
                dev_err(&drv_data->pdev->dev, "pump_transfers: flush failed\n");
                message->status = -EIO;
                giveback(drv_data);
                return;
        }

and:

drivers/spi/pxa2xx_spi.c:515:   if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
drivers/spi/pxa2xx_spi.c:569:           if (wait_ssp_rx_stall(drv_data->ioaddr) == 0)
drivers/spi/pxa2xx_spi.c:695:                   if (!wait_ssp_rx_stall(reg))
drivers/spi/pxa2xx_spi.c:511:   if (wait_dma_channel_stop(drv_data->rx_channel) == 0)

But with a postfix decrement limit reaches -1 rather than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Sorry, I didn't catch two the first time

 drivers/spi/pxa2xx_spi.c  |    6 +++---
 drivers/spi/spi_bfin5xx.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index d0fc4ca..318e568 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -185,7 +185,7 @@ static int flush(struct driver_data *drv_data)
 		while (read_SSSR(reg) & SSSR_RNE) {
 			read_SSDR(reg);
 		}
-	} while ((read_SSSR(reg) & SSSR_BSY) && limit--);
+	} while ((read_SSSR(reg) & SSSR_BSY) && --limit);
 	write_SSSR(SSSR_ROR, reg);
 
 	return limit;
@@ -459,7 +459,7 @@ static int wait_ssp_rx_stall(void const __iomem *ioaddr)
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
-	while ((read_SSSR(ioaddr) & SSSR_BSY) && limit--)
+	while ((read_SSSR(ioaddr) & SSSR_BSY) && --limit)
 		cpu_relax();
 
 	return limit;
@@ -469,7 +469,7 @@ static int wait_dma_channel_stop(int channel)
 {
 	unsigned long limit = loops_per_jiffy << 1;
 
-	while (!(DCSR(channel) & DCSR_STOPSTATE) && limit--)
+	while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)
 		cpu_relax();
 
 	return limit;
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 7fea3cf..ea94567 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -162,7 +162,7 @@ static int flush(struct driver_data *drv_data)
 	unsigned long limit = loops_per_jiffy << 1;
 
 	/* wait for stop and clear stat */
-	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && limit--)
+	while (!(read_STAT(drv_data) & BIT_STAT_SPIF) && --limit)
 		cpu_relax();
 
 	write_STAT(drv_data, BIT_STAT_CLR);
