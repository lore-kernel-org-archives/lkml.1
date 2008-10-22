Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbYJVScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbYJVScc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYJVScX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:32:23 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:32252 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753685AbYJVScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:32:23 -0400
Date: Wed, 22 Oct 2008 22:32:18 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081022183218.GA19025@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <20081022014243.GA19362@oksana.dev.rtsoft.ru> <1224642497.7654.319.camel@pasglop> <200810212122.49121.david-b@pacbell.net> <20081022103641.GB24757@oksana.dev.rtsoft.ru> <20081022104606.GA510@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081022104606.GA510@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 02:46:06PM +0400, Anton Vorontsov wrote:
> On Wed, Oct 22, 2008 at 02:36:41PM +0400, Anton Vorontsov wrote:
> > On Tue, Oct 21, 2008 at 09:22:48PM -0700, David Brownell wrote:
> > > On Tuesday 21 October 2008, Benjamin Herrenschmidt wrote:
> > > > The notifier can be registered before the devices, though it's a little
> > > > bit fishy and fragile.
> > > > 
> > > > Easier I suppose to just have OF specific hooks in the bus code.
> > > 
> > > Like what I suggested:  "chip-aware OF glue drivers".  The relevant
> > > bus code being the "of_platform_bus_type" infrastructure.
> > > 
> > > Example:  instead of Anton's patch #6 modifying the existing pca953x
> > > driver, an of_pca953x driver that knows how to poke around in the OF
> > > device attributes to (a) create the pca953x_platform_data, (b) call
> > > i2c_register_board_info() to make that available later, and then
> > > finally (c) vanish, since it's not needed any longer.
> > 
> > Heh. You tell me my first approach:
> > 
> > http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056730.html (mmc_spi)
> > 
> > The OF people didn't like the patch which was used to support this
> > approach:
> > http://ozlabs.org/pipermail/linuxppc-dev/2008-May/056728.html
> 
> Though, I think I'll able to persuade Grant that two registration paths
> are inevitable (i.e. for simple devices we should use
> drivers/of/of_{i2c,spi}.c and for complex cases we'll have to have
> another method of registration).
> 
> > The board info has another problem though. We can't remove it, thus
> > we can't implement module_exit() for the 'OF glue'.
> 
> And try to solve this problem... maybe then things will begin to
> move forward.

There is another problem: board infos are scanned at the controller
registration time only. So if we register the board infos after
the controller registered, then nobody will probe the board infos.

This is all solvable by hacking the i2c core code though. I started
it, but it turned out to be ugly. I'll finish it though, just to show
it someday.

But now I'm not sure if it worth the efforts. Maybe we could just
modify the drivers to do something like this?

This is not exactly "transparently" to the drivers, but well..

diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 01b4bbd..b1dfa7b 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -9,4 +9,7 @@ obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
+ifeq ($(CONFIG_OF),y)
+obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x_of.o
+endif
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
diff --git a/drivers/gpio/pcf857x.c b/drivers/gpio/pcf857x.c
index 4bc2070..f8057d2 100644
--- a/drivers/gpio/pcf857x.c
+++ b/drivers/gpio/pcf857x.c
@@ -187,7 +187,7 @@ static int pcf857x_probe(struct i2c_client *client,
 	struct pcf857x			*gpio;
 	int				status;
 
-	pdata = client->dev.platform_data;
+	pdata = pcf857x_get_pdata(client);
 	if (!pdata)
 		return -ENODEV;
 
@@ -314,7 +314,7 @@ fail:
 
 static int pcf857x_remove(struct i2c_client *client)
 {
-	struct pcf857x_platform_data	*pdata = client->dev.platform_data;
+	struct pcf857x_platform_data	*pdata = pcf857x_get_pdata(client);
 	struct pcf857x			*gpio = i2c_get_clientdata(client);
 	int				status = 0;
 
@@ -334,6 +334,8 @@ static int pcf857x_remove(struct i2c_client *client)
 		kfree(gpio);
 	else
 		dev_err(&client->dev, "%s --> %d\n", "remove", status);
+
+	pcf857x_put_pdata(client);
 	return status;
 }
 
diff --git a/drivers/gpio/pcf857x_of.c b/drivers/gpio/pcf857x_of.c
new file mode 100644
index 0000000..414943b
--- /dev/null
+++ b/drivers/gpio/pcf857x_of.c
@@ -0,0 +1,36 @@
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pcf857x.h>
+#include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+
+struct pcf857x_platform_data *pcf857x_get_pdata(struct i2c_client *client)
+{
+	struct pcf857x_platform_data *pdata = client->dev.platform_data;
+
+	if (pdata)
+		return pdata;
+
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	/*
+	 * Do the OF-specific setup here.
+	 */
+
+	client->dev.platform_data = pdata;
+}
+
+void pcf857x_put_pdata(struct i2c_client *client)
+{
+	struct pcf857x_platform_data *pdata = client->dev.platform_data;
+
+	/*
+	 * Do the OF-specific cleanup here.
+	 */
+
+	kfree(pdata);
+}
diff --git a/include/linux/i2c/pcf857x.h b/include/linux/i2c/pcf857x.h
index 0767a2a..bdc1aba 100644
--- a/include/linux/i2c/pcf857x.h
+++ b/include/linux/i2c/pcf857x.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_PCF857X_H
 #define __LINUX_PCF857X_H
 
+struct i2c_client;
+
 /**
  * struct pcf857x_platform_data - data to set up pcf857x driver
  * @gpio_base: number of the chip's first GPIO
@@ -41,4 +43,13 @@ struct pcf857x_platform_data {
 	void		*context;
 };
 
+#ifdef CONFIG_OF
+extern struct pcf857x_platform_data *
+	pcf857x_get_pdata(struct i2c_client *client);
+extern void pcf857x_put_pdata(struct i2c_client *client);
+#else
+#define pcf857x_get_pdata(client) ((client)->dev.platform_data)
+#define pcf857x_put_pdata(client)
+#endif
+
 #endif /* __LINUX_PCF857X_H */
