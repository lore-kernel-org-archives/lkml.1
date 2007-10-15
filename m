Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXJOP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXJOP7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXJOP7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 11:59:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:59895 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbXJOP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:59:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=jj015UZe4gT/xdxWv+EetdLjapqqm9TeN+7127ahHwMmsH98O5aCiGi+euAdCpzBdr8AtKNTu1nVHS2aTuQ2JfRtMbDdbtEk0TicnOoct/E5vsdh9oMpXj1HXLdtGYoWaD2oQ21WGKhOrhOlnIppiOX2JXmjP/15/KUfrkUhyGM=
Message-ID: <47138E56.2040903@gmail.com>
Date: Mon, 15 Oct 2007 11:59:18 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070813)
MIME-Version: 1.0
To: mchehab@infradead.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L: possible leak in em28xx_init_isoc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Coverity (CID 1929) spotted the following: if a transfer buffer 
allocation fails, the last allocated urb is leaked (it hasn't been 
stored in dev->urb[] yet so em28xx_uninit_isoc misses it). The patch 
also includes a small typo fix.

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 drivers/media/video/em28xx/em28xx-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index d3282ec..d56484f 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -648,7 +648,7 @@ void em28xx_uninit_isoc(struct em28xx *dev)
  */
 int em28xx_init_isoc(struct em28xx *dev)
 {
-	/* change interface to 3 which allowes the biggest packet sizes */
+	/* change interface to 3 which allows the biggest packet sizes */
 	int i, errCode;
 	const int sb_size = EM28XX_NUM_PACKETS * dev->max_pkt_size;
 
@@ -673,6 +673,7 @@ int em28xx_init_isoc(struct em28xx *dev)
 					("unable to allocate %i bytes for transfer buffer %i\n",
 					 sb_size, i);
 			em28xx_uninit_isoc(dev);
+			usb_free_urb(urb);
 			return -ENOMEM;
 		}
 		memset(dev->transfer_buffer[i], 0, sb_size);

