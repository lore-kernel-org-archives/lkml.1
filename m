Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0CCGOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:14:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52581 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0CCGOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:14:34 -0500
Date: Wed, 3 Mar 2010 17:14:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100303171432.bee7ae0c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/net/wireless/ath/ar9170/usb.c: In function 'ar9170_usb_firmware_failed':
drivers/net/wireless/ath/ar9170/usb.c:729: error: 'struct device' has no member named 'sem'
drivers/net/wireless/ath/ar9170/usb.c:732: error: 'struct device' has no member named 'sem'

Caused by commit 535765179fd4e8af26b69d2240d7ec33702a370a ("ar9170: load
firmware asynchronously") from the wireless tree interacting with
commitf989226577d096eb9ebbf95da1d0e8303ecc660c ("drivers/base: Convert
dev->sem to mutex") from the driver-core tree.

I applied the following patch for today.

John, Johannes, device_lock/unlock() already exist in Linus' tree, so you
should be able to apply this to the wireless tree already.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 3 Mar 2010 17:08:11 +1100
Subject: [PATCH] ar9170: fix for driver-core ABI change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/wireless/ath/ar9170/usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 4e30197..7fc1034 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -41,6 +41,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
+#include <linux/mutex.h>
 #include <net/mac80211.h>
 #include "ar9170.h"
 #include "cmd.h"
@@ -726,10 +727,10 @@ static void ar9170_usb_firmware_failed(struct ar9170_usb *aru)
 
 	/* unbind anything failed */
 	if (parent)
-		down(&parent->sem);
+		device_lock(parent);
 	device_release_driver(&aru->udev->dev);
 	if (parent)
-		up(&parent->sem);
+		device_unlock(parent);
 }
 
 static void ar9170_usb_firmware_finish(const struct firmware *fw, void *context)
-- 
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
