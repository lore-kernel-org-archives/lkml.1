Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYDKOLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYDKOLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759614AbYDKOLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:11:15 -0400
Received: from mail0.scram.de ([78.47.204.202]:42551 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759450AbYDKOLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:11:14 -0400
X-Spam-Score: -4.229
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47FF7177.3020000@scram.de>
Date: Fri, 11 Apr 2008 16:11:03 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Jean Delvare <khali@linux-fr.org>, Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux I2C <i2c@lm-sensors.org>, Jon Smirl <jonsmirl@gmail.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: [PATCH5/7] i2c: Kill the old driver matching scheme
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier work by Jon Smirl and Jean Delvare.

Remove the old driver_name/type scheme for i2c driver matching. Only the
standard aliasing model will be used from now on.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jon Smirl <jonsmirl@gmail.com>
---
 drivers/i2c/i2c-core.c |   35 +++++++++++++----------------------
 include/linux/i2c.h    |    9 ++-------
 2 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 8879acb..874638e 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -74,10 +74,7 @@ static int i2c_device_match(struct device *dev, struct device_driver *drv)
 	if (driver->id_table)
 		return i2c_match_id(driver->id_table, client) != NULL;
 
-	/* new style drivers use the same kind of driver matching policy
-	 * as platform devices or SPI:  compare device and driver IDs.
-	 */
-	return strcmp(client->driver_name, drv->name) == 0;
+	return 0;
 }
 
 #ifdef	CONFIG_HOTPLUG
@@ -91,14 +88,9 @@ static int i2c_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (dev->driver)
 		return 0;
 
-	if (client->driver_name[0]) {
-		if (add_uevent_var(env, "MODALIAS=%s", client->driver_name))
-			return -ENOMEM;
-	} else {
-		if (add_uevent_var(env, "MODALIAS=%s%s",
-				   I2C_MODULE_PREFIX, client->name))
-			return -ENOMEM;
-	}
+	if (add_uevent_var(env, "MODALIAS=%s%s",
+			   I2C_MODULE_PREFIX, client->name))
+		return -ENOMEM;
 	dev_dbg(dev, "uevent\n");
 	return 0;
 }
@@ -206,9 +198,7 @@ static ssize_t show_client_name(struct device *dev, struct device_attribute *att
 static ssize_t show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	return client->driver_name[0]
-		? sprintf(buf, "%s\n", client->driver_name)
-		: sprintf(buf, "%s%s\n", I2C_MODULE_PREFIX, client->name);
+	return sprintf(buf, "%s%s\n", I2C_MODULE_PREFIX, client->name);
 }
 
 static struct device_attribute i2c_dev_attrs[] = {
@@ -282,8 +272,6 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 	client->addr = info->addr;
 	client->irq = info->irq;
 
-	strlcpy(client->driver_name, info->driver_name,
-		sizeof(client->driver_name));
 	strlcpy(client->name, info->type, sizeof(client->name));
 
 	/* a new style driver may be bound to this device when we
@@ -326,6 +314,11 @@ void i2c_unregister_device(struct i2c_client *client)
 }
 EXPORT_SYMBOL_GPL(i2c_unregister_device);
 
+static const struct i2c_device_id dummy_id[] = {
+	{ "dummy", 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, dummy_id);
 
 static int dummy_probe(struct i2c_client *client,
 		       const struct i2c_device_id *id)
@@ -342,13 +335,13 @@ static struct i2c_driver dummy_driver = {
 	.driver.name	= "dummy",
 	.probe		= dummy_probe,
 	.remove		= dummy_remove,
+	.id_table	= dummy_id,
 };
 
 /**
  * i2c_new_dummy - return a new i2c device bound to a dummy driver
  * @adapter: the adapter managing the device
  * @address: seven bit address to be used
- * @type: optional label used for i2c_client.name
  * Context: can sleep
  *
  * This returns an I2C client bound to the "dummy" driver, intended for use
@@ -364,15 +357,13 @@ static struct i2c_driver dummy_driver = {
  * i2c_unregister_device(); or NULL to indicate an error.
  */
 struct i2c_client *
-i2c_new_dummy(struct i2c_adapter *adapter, u16 address, const char *type)
+i2c_new_dummy(struct i2c_adapter *adapter, u16 address)
 {
 	struct i2c_board_info info = {
-		.driver_name	= "dummy",
+		.type		= "dummy",
 		.addr		= address,
 	};
 
-	if (type)
-		strlcpy(info.type, type, sizeof info.type);
 	return i2c_new_device(adapter, &info);
 }
 EXPORT_SYMBOL_GPL(i2c_new_dummy);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 01ad5db..4eec279 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -155,8 +155,6 @@ struct i2c_driver {
  * @driver: device's driver, hence pointer to access routines
  * @dev: Driver model device node for the slave.
  * @irq: indicates the IRQ generated by this device (if any)
- * @driver_name: Identifies new-style driver used with this device; also
- *	used as the module name for hotplug/coldplug modprobe support.
  * @list: list of active/busy clients (DEPRECATED)
  * @released: used to synchronize client releases & detaches and references
  *
@@ -174,7 +172,6 @@ struct i2c_client {
 	struct i2c_driver *driver;	/* and our access routines	*/
 	struct device dev;		/* the device structure		*/
 	int irq;			/* irq issued by device (or -1) */
-	char driver_name[KOBJ_NAME_LEN];
 	struct list_head list;		/* DEPRECATED */
 	struct completion released;
 };
@@ -200,8 +197,7 @@ static inline void i2c_set_clientdata (struct i2c_client *dev, void *data)
 
 /**
  * struct i2c_board_info - template for device creation
- * @driver_name: identifies the driver to be bound to the device
- * @type: optional chip type information, to initialize i2c_client.name
+ * @type: chip type, to initialize i2c_client.name
  * @flags: to initialize i2c_client.flags
  * @addr: stored in i2c_client.addr
  * @platform_data: stored in i2c_client.dev.platform_data
@@ -220,7 +216,6 @@ static inline void i2c_set_clientdata (struct i2c_client *dev, void *data)
  * with the adapter already known.
  */
 struct i2c_board_info {
-	char		driver_name[KOBJ_NAME_LEN];
 	char		type[I2C_NAME_SIZE];
 	unsigned short	flags;
 	unsigned short	addr;
@@ -262,7 +257,7 @@ i2c_new_probed_device(struct i2c_adapter *adap,
  * client handles for the extra addresses.
  */
 extern struct i2c_client *
-i2c_new_dummy(struct i2c_adapter *adap, u16 address, const char *type);
+i2c_new_dummy(struct i2c_adapter *adap, u16 address);
 
 extern void i2c_unregister_device(struct i2c_client *);
 
-- 
1.5.4.5



