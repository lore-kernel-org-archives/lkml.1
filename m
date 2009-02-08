Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbZBHQu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbZBHQu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZBHQus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:50:48 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34344 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbZBHQur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:50:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MZzxeIvAq8CS3eYlgiP3MOtJuGETL77hb4xwQASp2SpqBAkJUhvUOgdkdBK725Jmjp
         C/wXyT2eVL1IP4Pl2ocNy2r1Vqf1DPz0fTthubUh7jhwgvA4h9mNQ0RR9ks9/53nGE4J
         6qt9+MxeEeOe1XpwwqSztjb7Z42Fs01AMlVF0=
Message-ID: <498F0D64.4040909@gmail.com>
Date: Sun, 08 Feb 2009 17:50:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spi: limit reaches -1, tested 0
References: <498EE9C0.3010601@gmail.com> <200902080755.26241.david-b@pacbell.net> <200902080828.49036.david-b@pacbell.net>
In-Reply-To: <200902080828.49036.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> -			while ((read(drv_data) == 0) && limit--);
>>> +			while ((read(drv_data) == 0) && --limit);
> 
> ... although I wouldn't have resisted the urge to make the
> loop body be "cpu_relax();" instead of an empty statement.

Ok,
---------------------------->8-------------------8<-----------------------------
With a postfix decrement limit will reach -1 rather than 0, so the warning will
not be issued.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 269a55e..15abe61 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -779,7 +779,8 @@ static irqreturn_t interrupt_transfer(struct driver_data *drv_data)
 
 			/* Read trailing bytes */
 			limit = loops_per_jiffy << 1;
-			while ((read(drv_data) == 0) && limit--);
+			while ((read(drv_data) == 0) && limit--)
+				cpu_relax();
 
 			if (limit == 0)
 				dev_err(&drv_data->pdev->dev,
