Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZCKUsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZCKUsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZCKUrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:47:51 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:51009 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZCKUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:47:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: [PATCH 5/5] USB: wusbcore/wa-xfer, fix lock imbalance
Date: Wed, 11 Mar 2009 21:47:40 +0100
Message-Id: <1236804460-1432-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
References: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix locking on one wa_urb_enqueue_b's fail path. There was omitted unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
---
 drivers/usb/wusbcore/wa-xfer.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 238a96a..613a5fc 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -921,8 +921,10 @@ static void wa_urb_enqueue_b(struct wa_xfer *xfer)
 	result = -ENODEV;
 	/* FIXME: segmentation broken -- kills DWA */
 	mutex_lock(&wusbhc->mutex);		/* get a WUSB dev */
-	if (urb->dev == NULL)
+	if (urb->dev == NULL) {
+		mutex_unlock(&wusbhc->mutex);
 		goto error_dev_gone;
+	}
 	wusb_dev = __wusb_dev_get_by_usb_dev(wusbhc, urb->dev);
 	if (wusb_dev == NULL) {
 		mutex_unlock(&wusbhc->mutex);
-- 
1.6.2
caught by stanse

