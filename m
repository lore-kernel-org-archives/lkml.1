Return-Path: <linux-kernel-owner+w=401wt.eu-S932964AbZJFQIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964AbZJFQIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932889AbZJFQIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:08:06 -0400
Received: from zmc.proxad.net ([212.27.53.206]:45431 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932823AbZJFQIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:08:05 -0400
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 12:08:04 EDT
X-Spam-Flag: NO
X-Spam-Score: -4.399
From: Florian Fainelli <ffainelli@freebox.fr>
To: spi-devel-general@lists.sourceforge.net
Subject: [PATCH] fix spidev compilation when VERBOSE is defined
Date: Tue, 6 Oct 2009 17:59:16 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-server; KDE/4.2.2; x86_64; ; )
Organization: Freebox
Cc: dbrownell@users.sourceforge.net, Maxime Bizon <mbizon@freebox.fr>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061759.17327.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please CC me as I am not subscribed to spi-devel-general).

When VERBOSE is defined in the spidev module, the compilation
will throw an error on 'spi' not being defined:

CC [M]  drivers/spi/spidev.o                   
drivers/spi/spidev.c: In function 'spidev_message':
drivers/spi/spidev.c:266: error: 'spi' undeclared (first use in this function)
drivers/spi/spidev.c:266: error: (Each undeclared identifier is reported only once
drivers/spi/spidev.c:266: error: for each function it appears in.) 

instead of using spi-> we should actually use spidev->spi.
This patch fixes the build failure.

CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
--
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 5d869c4..c80c31b 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -262,15 +262,15 @@ static int spidev_message(struct spidev_data *spidev,
 		k_tmp->delay_usecs = u_tmp->delay_usecs;
 		k_tmp->speed_hz = u_tmp->speed_hz;
 #ifdef VERBOSE
-		dev_dbg(&spi->dev,
+		dev_dbg(&spidev->spi->dev,
 			"  xfer len %zd %s%s%s%dbits %u usec %uHz\n",
 			u_tmp->len,
 			u_tmp->rx_buf ? "rx " : "",
 			u_tmp->tx_buf ? "tx " : "",
 			u_tmp->cs_change ? "cs " : "",
-			u_tmp->bits_per_word ? : spi->bits_per_word,
+			u_tmp->bits_per_word ? : spidev->spi->bits_per_word,
 			u_tmp->delay_usecs,
-			u_tmp->speed_hz ? : spi->max_speed_hz);
+			u_tmp->speed_hz ? : spidev->spi->max_speed_hz);
 #endif
 		spi_message_add_tail(k_tmp, &msg);
 	}

