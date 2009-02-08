Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbZBHPxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbZBHPxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 10:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZBHPxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 10:53:44 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35695 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZBHPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 10:53:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=vHW44mhHipYIjIhzS4IMhJyD1682eJ0o6boUAngZJQmszZLkKO7P6uQH9tyHTXPovB
         re3L9y7EVoRGIT+ePEDVI9Cc85iiQ98giBkFVsY8KK6Eft8t1iLJyprgB24Xtn6dZVTS
         oHiiII0DYY/csjkOkHbHDDMIRZT7k2nMz9xic=
Message-ID: <498F0004.1030709@gmail.com>
Date: Sun, 08 Feb 2009 16:53:40 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: pxa2xx_spi: spi_bfin5xx: limit reaches -1 rather than 0
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

But with a postfix decrement limit reaches -1 rather than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/spi/pxa2xx_spi.c  |    2 +-
 drivers/spi/spi_bfin5xx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index d0fc4ca..3164741 100644
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
