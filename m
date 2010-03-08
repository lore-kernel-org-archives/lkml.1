Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab0CHX2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:28:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42077 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0CHX2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:28:32 -0500
Date: Tue, 9 Mar 2010 10:28:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] i2c: update for semaphore to mutex conversion of devices
Message-Id: <20100309102828.18351564.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been carrying this patch in linux-next for some time and now
mainline needs it.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/i2c/i2c-smbus.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 333527c..52aa775 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -27,6 +27,7 @@
 #include <linux/workqueue.h>
 #include <linux/i2c.h>
 #include <linux/i2c-smbus.h>
+#include <linux/mutex.h>
 
 struct i2c_smbus_alert {
 	unsigned int		alert_edge_triggered:1;
@@ -55,7 +56,7 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 	 * Drivers should either disable alerts, or provide at least
 	 * a minimal handler.  Lock so client->driver won't change.
 	 */
-	down(&dev->sem);
+	device_lock(dev);
 	if (client->driver) {
 		if (client->driver->alert)
 			client->driver->alert(client, data->flag);
@@ -63,7 +64,7 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 			dev_warn(&client->dev, "no driver alert()!\n");
 	} else
 		dev_dbg(&client->dev, "alert with no driver\n");
-	up(&dev->sem);
+	device_unlock(dev);
 
 	/* Stop iterating after we find the device */
 	return -EBUSY;
-- 
1.6.6.2


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
