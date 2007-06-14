Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbXFNGld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbXFNGld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXFNGkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:40:53 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:38600 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbXFNGkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:40:52 -0400
Date: Thu, 14 Jun 2007 15:40:46 +0900 (JST)
Message-Id: <20070614.154046.96688009.nemoto@toshiba-tops.co.jp>
To: khali@linux-fr.org
Cc: hskinnemoen@atmel.com, linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH] i2c-gpio: Add support for new-style clients
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070614082417.4be74afc@hyperion.delvare>
References: <20070613.004316.128619812.anemo@mba.ocn.ne.jp>
	<20070614082417.4be74afc@hyperion.delvare>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 08:24:17 +0200, Jean Delvare <khali@linux-fr.org> wrote:
> > +	if (pdev->id == -1)
> > +		ret = i2c_bit_add_bus(adap);
> > +	else
> > +		ret = i2c_bit_add_numbered_bus(adap);
> >  	if (ret)
> >  		goto err_add_bus;
> >  
> 
> This isn't sufficient. Before you call i2c_bit_add_numbered_bus(adap),
> you are supposed to set adap->nr to the desired i2c adapter number.

Oh, indeed.  That worked for me just I only used bus number 0.
Here is a revised patch.


Subject: [PATCH] i2c-gpio: Add support for new-style clients (take 2)

Use i2c_bit_add_numbered_bus() if platform_device id specified, so
that the i2c-gpio adapter works well with new-style pre-declared
devices.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index a7dd546..88c5735 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -142,7 +142,12 @@ static int __init i2c_gpio_probe(struct platform_device *pdev)
 	adap->algo_data = bit_data;
 	adap->dev.parent = &pdev->dev;
 
-	ret = i2c_bit_add_bus(adap);
+	if (pdev->id == -1)
+		ret = i2c_bit_add_bus(adap);
+	else {
+		adap->nr = pdev->id;
+		ret = i2c_bit_add_numbered_bus(adap);
+	}
 	if (ret)
 		goto err_add_bus;
 
