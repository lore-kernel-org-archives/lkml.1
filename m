Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbYAaOxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbYAaOxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 09:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYAaOxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 09:53:46 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60063 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969AbYAaOxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 09:53:45 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: linux@bohmer.net, linux@maxim.org.za, michael <trimarchi@gandalf.sssup.it>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm] atmel_serial: Fix broken RX buffer allocation
Date: Thu, 31 Jan 2008 15:52:21 +0100
Message-Id: <1201791141-12545-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced by atmel_serial-split-the-interrupt-handler.patch.

Thanks to michael <trimarchi@gandalf.sssup.it> for spotting it.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
It was surprisingly difficult to actually provoke a crash without this
patch, but the system did start to behave rather funny after
transferring a lot of data.

 drivers/serial/atmel_serial.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 62654ab..477950f 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1477,7 +1477,8 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 
 	if (!atmel_use_dma_rx(&port->uart)) {
 		ret = -ENOMEM;
-		data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
+		data = kmalloc(sizeof(struct atmel_uart_char)
+				* ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
 		if (!data)
 			goto err_alloc_ring;
 		port->rx_ring.buf = data;
-- 
1.5.3.8

