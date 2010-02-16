Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab0BPGjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 01:39:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57147 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab0BPGj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 01:39:29 -0500
Date: Tue, 16 Feb 2010 17:39:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Jean Delvare <khali@linux-fr.org>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100216173926.b7a4d25c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/i2c/i2c-smbus.c:58: error: 'struct device' has no member named 'sem'
drivers/i2c/i2c-smbus.c:66: error: 'struct device' has no member named 'sem'

Caused by commit 0819a881db29059d113fc5f019f7c489dea5937d from the
driver-core tree interacting with commit
38f1e8aedf0a238d56fbcd3660fc140b50dbc89a ("i2c: Add SMBus alert support")
from the i2c tree.

I have applied the following patch for today and will use it as a merge
fixup for the driver-core tree while necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 16 Feb 2010 17:28:56 +1100
Subject: [PATCH] i2c: update for semaphore to mutex conversion of devices

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
+	mutex_lock(&dev->mutex);
 	if (client->driver) {
 		if (client->driver->alert)
 			client->driver->alert(client, data->flag);
@@ -63,7 +64,7 @@ static int smbus_do_alert(struct device *dev, void *addrp)
 			dev_warn(&client->dev, "no driver alert()!\n");
 	} else
 		dev_dbg(&client->dev, "alert with no driver\n");
-	up(&dev->sem);
+	mutex_unlock(&dev->mutex);
 
 	/* Stop iterating after we find the device */
 	return -EBUSY;
-- 
1.6.6.2

