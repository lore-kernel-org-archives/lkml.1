Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705Ab0AIQnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0AIQnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 11:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986Ab0AIQnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 11:43:25 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46805 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab0AIQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 11:43:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Xp54WTS012s8yVCXGu9PnedozaRiztLPOW1JxZWS+qvLNXdPL2HgTrTqUANSLd4krU
         yqGyHSTG3dsIdklcTRklqJQVgi3Zys9+tczF6+a0IKQrn3/avBPigFSb8NsJbMcnMXbe
         WqOEcVvFa4d2US/geJyw4+kqm6XA20DcGhscA=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: akpm@linux-foundation.org, daniel@caiaq.de
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] rtc: mxc: fix memory leak
Date: Sat,  9 Jan 2010 19:43:07 +0300
Message-Id: <1263055387-31340-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free pdata before exit.
Found by cppcheck.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/rtc/rtc-mxc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 6bd5072..2642e6b 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -396,8 +396,10 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
 	pdata->ioaddr = ioremap(res->start, resource_size(res));
 
 	clk = clk_get(&pdev->dev, "ckil");
-	if (IS_ERR(clk))
-		return PTR_ERR(clk);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto exit_free_pdata;
+	}
 
 	rate = clk_get_rate(clk);
 	clk_put(clk);
-- 
1.6.6

