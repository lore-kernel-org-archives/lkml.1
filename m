Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0BKLIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:08:06 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:60174 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0BKLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:08:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=CHVP2nLPyr6Eyo4Fj/vIMsBu0hjOJ+/uVtJeviGp4WbLKcLzBdShKhYgLlYdr7ccoK
         dglQ6Pm23jCDJW2dZsip1W1pZUzYMfLJ9aZuBLUoBmGc5Fl9yZSkmYbq0caXW3wmZOd1
         vFoR3G6OEB1frL1umbho9qF24l8KSv8sI6kiU=
Subject: [PATCH] drivers/media/radio/si470x/radio-si470x-usb.c fix use
 after free
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tobias Lorenz <tobias.lorenz@gmx.net>,
       Tobias Lorenz <tobias.lorenz@gmx.net>,
       Douglas Schilling Landgraf <dougsland@redhat.com>,
       linux-media@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 22:07:53 +1100
Message-ID: <1265886473.27789.6.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In si470x_usb_driver_disconnect() radio->disconnect_lock is accessed
after it is freed. This fixes the problem.

Coverity CID: 2530

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
---
 drivers/media/radio/si470x/radio-si470x-usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index a96e1b9..1588a9d 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -842,9 +842,11 @@ static void si470x_usb_driver_disconnect(struct usb_interface *intf)
 		kfree(radio->int_in_buffer);
 		video_unregister_device(radio->videodev);
 		kfree(radio->buffer);
+		mutex_unlock(&radio->disconnect_lock);
 		kfree(radio);
+	} else {
+		mutex_unlock(&radio->disconnect_lock);
 	}
-	mutex_unlock(&radio->disconnect_lock);
 }
 
 
-- 
1.6.3.3



