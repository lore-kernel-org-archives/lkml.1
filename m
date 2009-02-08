Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZBHRq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZBHRq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 12:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZBHRqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 12:46:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:24208 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZBHRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 12:46:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Olja7cGuazBrxTft1OKulMqMl++9QDN3NUeGwbYiyitCfV3v+lycveFLXNUDjYjSDP
         SztAGHkI2HOFF0ZfDACZcFaq+v4IkuoI9E8z8LrrbZt3Monoag++DdEDh72uVDIQ+k7k
         mkLblkfy6e0Po5364ITC+/eZGhFW367P4Ds3s=
Message-ID: <498F1A87.8060403@gmail.com>
Date: Sun, 08 Feb 2009 18:46:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Mariusz Ceier <mceier@gmail.com>
CC: David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spi: limit reaches -1, tested 0
References: <498EE9C0.3010601@gmail.com> <200902080755.26241.david-b@pacbell.net> <200902080828.49036.david-b@pacbell.net> <498F0D64.4040909@gmail.com> <498F1979.1030104@gmail.com>
In-Reply-To: <498F1979.1030104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Ceier wrote:
> Roel Kluin writes in first post:
>> -			while ((read(drv_data) == 0) && limit--);
>> +			while ((read(drv_data) == 0) && --limit);
> 
> Roel Kluin writes in last post:
>> -			while ((read(drv_data) == 0) && limit--);
>> +			while ((read(drv_data) == 0) && limit--)
>> +				cpu_relax();
> 
> so should there be postfix or prefix decrement ? :)

Thanks for spotting, I took the liberty to add David Brownell's Acked-by
in this case.
----------------------->8------------------8<---------------------------
With a postfix decrement limit will reach -1 rather than 0,
so the warning will not be issued.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 269a55e..b143e8c 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -779,7 +779,8 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 
 			/* Read trailing bytes */
 			limit = loops_per_jiffy << 1;
-			while ((read(drv_data) == 0) && limit--);
+			while ((read(drv_data) == 0) && --limit)
+				cpu_relax();
 
 			if (limit == 0)
 				dev_err(&drv_data->pdev->dev,
