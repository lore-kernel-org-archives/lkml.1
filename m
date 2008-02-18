Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYBRLm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYBRLm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbYBRLmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:42:50 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59937 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757001AbYBRLmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:42:50 -0500
Date: Mon, 18 Feb 2008 12:42:37 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: atmel_spi clock polarity
Message-ID: <20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080216.223252.25909396.anemo@mba.ocn.ne.jp>
References: <20080216.223252.25909396.anemo@mba.ocn.ne.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 22:32:52 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Here is my quick workaround for this problem.  It makes all CSRn.CPOL
> match for the transfer before activating chipselect.  I'm not quite
> sure my analysis is correct, and there might be better solution.
> Could you give me any comments?

I'm not sure if I fully understand what problem you're seeing. Is the
clock state wrong when the chip select is activated? If so, does the
patch below help?

Haavard

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index 293b7ca..4f19b82 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -90,6 +90,7 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 
 	mr = spi_readl(as, MR);
 	mr = SPI_BFINS(PCS, ~(1 << spi->chip_select), mr);
+	spi_writel(as, MR, mr);
 
 	dev_dbg(&spi->dev, "activate %u%s, mr %08x\n",
 			gpio, active ? " (high)" : "",
@@ -97,7 +98,6 @@ static void cs_activate(struct atmel_spi *as, struct spi_device *spi)
 
 	if (!(cpu_is_at91rm9200() && spi->chip_select == 0))
 		gpio_set_value(gpio, active);
-	spi_writel(as, MR, mr);
 }
 
 static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
