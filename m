Return-Path: <linux-kernel-owner+w=401wt.eu-S932549AbXHIVFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549AbXHIVFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932421AbXHIVEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:04:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:44249 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbXHIVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Z78VLqxqWKqhWFrxUP+rvkjIEyrAeKb/pFYH5eAFxYx4sqZAYMKhj3sagTvx+stZMUjdz9hnbUwhx6PVIrktugU6t1GOalGYWNFIsHmg5Q/hjkqoHx/LlDhc0AYL6hYiOdZhUelOX7Tc37tNtitrdaTkqAG52OTAbfMnAxz76KA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix a memory leak in em28xx_usb_probe()
Date: Thu, 9 Aug 2007 23:02:36 +0200
User-Agent: KMail/1.9.7
Cc: Luca Risolia <luca.risolia@studio.unibo.it>,
       Ludovico Cavedon <cavedon@sssup.it>,
       Markus Rechberger <mrechberger@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Sascha Sommer <saschasommer@freenet.de>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Greg Kroah-Hartman <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708092302.36705.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EHLO,

If, in em28xx_usb_probe() the memory allocation
	dev->alt_max_pkt_size = kmalloc(32*
						dev->num_alt,GFP_KERNEL);
fails, then we'll bail out and return -ENOMEM.
The problem is that in that case we don't free the storage allocated 
to 'dev', thus causing a memory leak.

This patch fixes the leak by freeing 'dev' before we return -ENOMEM.
This fixes Coverity bug #647.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/media/video/em28xx/em28xx-video.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 2c7b158..40307f3 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1772,6 +1772,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (dev->alt_max_pkt_size == NULL) {
 		em28xx_errdev("out of memory!\n");
 		em28xx_devused&=~(1<<nr);
+		kfree(dev);
 		return -ENOMEM;
 	}
 



