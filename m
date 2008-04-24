Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYDXHfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYDXHfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYDXHfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:35:12 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:33976 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYDXHfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:35:11 -0400
Message-ID: <4810382D.8040405@tiscali.nl>
Date: Thu, 24 Apr 2008 09:35:09 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 v2] xilinx_spi: test below 0 on unsigned irq in xilinx_spi_probe()
References: <480F99D5.7070300@tiscali.nl> <480FA248.7080900@tiscali.nl>
In-Reply-To: <480FA248.7080900@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2008-04-23 at 22:55 +0200, Roel Kluin wrote:

>> -	xspi->irq = platform_get_irq(dev, 0);
>> -	if (xspi->irq < 0) {
>> -		ret = -ENXIO;
>> +	ret = platform_get_irq(dev, 0);
>> +	if (ret < 0)
>>  		goto unmap_io;
>> -	}
>> +
>> +	xspi->irq = ret;
>> +	ret = 0;
> 
> Is the only negative return from platform_get_irq ENXIO?
> I think you still need the ret = -ENXIO before the goto.
> 
> Also, you don't need the ret = 0 line, it's set again
> a few lines below.
> 
> I think you should end up with:
> 
> 	ret = platform_get_irq(dev, 0);
> 	if (ret < 0) {
> 		ret = -ENXIO;
> 		goto unmap_io;
> 	}
> 
> 	xspi->irq = ret;
> 
> cheers, Joe

In that case, this should suffice,

thanks again,

Roel
---
xilinx_spi->irq is unsigned, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/spi/xilinx_spi.c b/drivers/spi/xilinx_spi.c
index cf6aef3..2a471b3 100644
--- a/drivers/spi/xilinx_spi.c
+++ b/drivers/spi/xilinx_spi.c
@@ -353,11 +353,12 @@ static int __init xilinx_spi_probe(struct platform_device *dev)
 		goto put_master;
 	}
 
-	xspi->irq = platform_get_irq(dev, 0);
-	if (xspi->irq < 0) {
+	ret = platform_get_irq(dev, 0);
+	if (ret < 0) {
 		ret = -ENXIO;
 		goto unmap_io;
 	}
+	xspi->irq = ret;
 
 	master->bus_num = pdata->bus_num;
 	master->num_chipselect = pdata->num_chipselect;
