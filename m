Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936449Ab0CMBZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:25:51 -0500
Received: from kroah.org ([198.145.64.141]:60784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934916Ab0CMAUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:10 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:09 2010
Message-Id: <20100313001509.629394760@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Daniel Mack <daniel@caiaq.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 051/123] ASoC: fix ak4104 register array access
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Daniel Mack <daniel@caiaq.de>

commit e555317c083fda01f516d2153589e82514e20e70 upstream.

Don't touch the variable 'reg' to construct the value for the actual SPI
transport. This variable is again used to access the driver's register
cache, and so random memory is overwritten.
Compute the value in-place instead.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ak4104.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/ak4104.c
+++ b/sound/soc/codecs/ak4104.c
@@ -90,12 +90,10 @@ static int ak4104_spi_write(struct snd_s
 	if (reg >= codec->reg_cache_size)
 		return -EINVAL;
 
-	reg &= AK4104_REG_MASK;
-	reg |= AK4104_WRITE;
-
 	/* only write to the hardware if value has changed */
 	if (cache[reg] != value) {
-		u8 tmp[2] = { reg, value };
+		u8 tmp[2] = { (reg & AK4104_REG_MASK) | AK4104_WRITE, value };
+
 		if (spi_write(spi, tmp, sizeof(tmp))) {
 			dev_err(&spi->dev, "SPI write failed\n");
 			return -EIO;


