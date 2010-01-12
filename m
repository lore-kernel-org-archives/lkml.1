Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067Ab0ALE7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0ALE7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 23:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224Ab0ALE7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 23:59:06 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34497 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab0ALE7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 23:59:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DKpRVnwmJZJ/7dxGHNPKXsfglY5qPz5BnMMAWpesyZvBLbpTqOHUBzoys4aCmHt/fT
         /+HMvHOwP9fxPAIeDgxovkhQwORR5PjF+I6ez7TIJBEHUUxS2GfR8ioWmroahjugUuI7
         Wtap1TtSHr5VtkGc0bMGPXH907bc1gbZSjp8A=
Subject: [PATCH] Fix reset of ramzswap
From: "minchan.kim" <minchan.kim@gmail.com>
To: Greg KH <greg@kroah.com>, Nitin Gupta <ngupta@vflare.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 13:36:58 +0900
Message-Id: <1263271018.23507.8.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl(cmd=reset)
	-> bd_holder check (if whoever hold bdev, return -EBUSY)
	-> ramzswap_ioctl_reset_device
		-> reset_device
			-> bd_release

bd_release is called by reset_device.
but ramzswap_ioctl always checks bd_holder before
reset_device. it means reset ioctl always fails.

This patch fixes it.

This patch is based on mmotm-2010-01-06-14-34 + 
[PATCH] Free memory when create_device is failed.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/ramzswap/ramzswap_drv.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap_drv.c b/drivers/staging/ramzswap/ramzswap_drv.c
index 18196f3..42531bd 100644
--- a/drivers/staging/ramzswap/ramzswap_drv.c
+++ b/drivers/staging/ramzswap/ramzswap_drv.c
@@ -1270,11 +1270,6 @@ static int ramzswap_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 
 	case RZSIO_RESET:
-		/* Do not reset an active device! */
-		if (bdev->bd_holders) {
-			ret = -EBUSY;
-			goto out;
-		}
 		ret = ramzswap_ioctl_reset_device(rzs);
 		break;
 
-- 
1.5.6.3


-- 
Kind regards,
Minchan Kim

