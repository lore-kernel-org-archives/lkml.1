Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbZGIVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbZGIVkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbZGIVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:40:33 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:18696 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbZGIVkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:40:32 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David =?utf-8?q?H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 2/2] Winbond: convert from ACPI to PNP driver
Date: Thu, 9 Jul 2009 15:40:27 -0600
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, "Len Brown" <lenb@kernel.org>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu> <200907081052.20142.bjorn.helgaas@hp.com> <200907091538.21685.bjorn.helgaas@hp.com>
In-Reply-To: <200907091538.21685.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907091540.28283.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index f97271b..9b5c985 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -45,7 +45,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/acpi.h>
+#include <linux/pnp.h>
 #include <linux/interrupt.h>
 #include <linux/timer.h>
 #include <linux/input.h>
@@ -161,7 +161,6 @@ enum wbcir_protocol {
 
 /* Misc */
 #define WBCIR_ACPI_NAME	"Winbond CIR"
-#define WBCIR_ACPI_CLASS	"CIR"
 #define WBCIR_ID_FAMILY          0xF1 /* Family ID for the WPCD376I	*/
 #define	WBCIR_ID_CHIP            0x04 /* Chip ID for the WPCD376I	*/
 #define IR_KEYPRESS_TIMEOUT       250 /* FIXME: should be per-protocol? */
@@ -937,8 +936,8 @@ wbcir_parse_nec(struct device *dev, struct wbcir_data *data)
 static irqreturn_t
 wbcir_irq_handler(int irqno, void *cookie)
 {
-	struct acpi_device *device = cookie;
-	struct wbcir_data *data = acpi_driver_data(device);
+	struct pnp_dev *device = cookie;
+	struct wbcir_data *data = pnp_get_drvdata(device);
 	struct device *dev = &device->dev;
 	u8 status;
 	unsigned long flags;
@@ -1021,11 +1020,11 @@ out:
  *
  *****************************************************************************/
 
-static int
-wbcir_shutdown(struct acpi_device *device)
+static void
+wbcir_shutdown(struct pnp_dev *device)
 {
 	struct device *dev = &device->dev;
-	struct wbcir_data *data = acpi_driver_data(device);
+	struct wbcir_data *data = pnp_get_drvdata(device);
 	int do_wake = 1;
 	u8 match[11];
 	u8 mask[11];
@@ -1197,20 +1196,19 @@ finish:
 
 	/* Disable interrupts */
 	outb(WBCIR_IRQ_NONE, data->sbase + WBCIR_REG_SP3_IER);
-
-	return 0;
 }
 
 static int
-wbcir_suspend(struct acpi_device *device, pm_message_t state)
+wbcir_suspend(struct pnp_dev *device, pm_message_t state)
 {
-	return wbcir_shutdown(device);
+	wbcir_shutdown(device);
+	return 0;
 }
 
 static int
-wbcir_resume(struct acpi_device *device)
+wbcir_resume(struct pnp_dev *device)
 {
-	struct wbcir_data *data = acpi_driver_data(device);
+	struct wbcir_data *data = pnp_get_drvdata(device);
 
 	/* Clear BUFF_EN, Clear END_EN, Clear MATCH_EN */
 	wbcir_set_bits(data->wbase + WBCIR_REG_WCEIR_EV_EN, 0x00, 0x07);
@@ -1237,8 +1235,8 @@ static ssize_t
 wbcir_show_last_scancode(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	struct acpi_device *device = container_of(dev, struct acpi_device, dev);
-	struct wbcir_data *data = acpi_driver_data(device);
+	struct pnp_dev *device = container_of(dev, struct pnp_dev, dev);
+	struct wbcir_data *data = pnp_get_drvdata(device);
 	return sprintf(buf, "0x%08X\n", data->last_scancode);
 }
 
@@ -1261,56 +1259,6 @@ static struct attribute_group wbcir_attribute_group = {
 	.attrs = wbcir_attributes,
 };
 
-static acpi_status
-wbcir_walk_resources(struct acpi_resource *resource, void *context)
-{
-	struct wbcir_data *data = context;
-
-	switch (resource->type) {
-
-	case ACPI_RESOURCE_TYPE_IO:
-		if (!data->ebase) {
-			if (resource->data.io.address_length !=
-			    EHFUNC_IOMEM_LEN)
-				goto error;
-			data->ebase = resource->data.io.minimum;
-		} else if (!data->wbase) {
-			if (resource->data.io.address_length !=
-			    WAKEUP_IOMEM_LEN)
-				goto error;
-			data->wbase = resource->data.io.minimum;
-		} else if (!data->sbase) {
-			if (resource->data.io.address_length !=
-			    SP_IOMEM_LEN)
-				goto error;
-			data->sbase = resource->data.io.minimum;
-		} else {
-			goto error;
-		}
-		break;
-
-	case ACPI_RESOURCE_TYPE_IRQ:
-		if (resource->data.irq.interrupt_count != 1)
-			goto error;
-		else if (!data->irq)
-			data->irq = resource->data.irq.interrupts[0];
-		else
-			goto error;
-		break;
-
-	case ACPI_RESOURCE_TYPE_END_TAG:
-		break;
-
-	default:
-		goto error;
-	}
-
-	return AE_OK;
-
-error:
-	return AE_ERROR;
-}
-
 static void
 wbcir_cfg_ceir(struct wbcir_data *data)
 {
@@ -1345,28 +1293,36 @@ wbcir_cfg_ceir(struct wbcir_data *data)
 }
 
 static int
-wbcir_add(struct acpi_device *device)
+wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 {
 	struct device *dev = &device->dev;
 	struct wbcir_data *data;
-	acpi_status status;
 	int err;
 
+	if (!(pnp_port_len(device, 0) == EHFUNC_IOMEM_LEN &&
+	      pnp_port_len(device, 1) == WAKEUP_IOMEM_LEN &&
+	      pnp_port_len(device, 2) == SP_IOMEM_LEN)) {
+		dev_err(dev, "Invalid resources\n");
+		return -ENODEV;
+	}
+
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		err = -ENOMEM;
 		goto exit;
 	}
 
-	device->driver_data = data;
+	pnp_set_drvdata(device, data);
 
-	status = acpi_walk_resources(device->handle, METHOD_NAME__CRS,
-				     wbcir_walk_resources, data);
+	data->ebase = pnp_port_start(device, 0);
+	data->wbase = pnp_port_start(device, 1);
+	data->sbase = pnp_port_start(device, 2);
+	data->irq = pnp_irq(device, 0);
 
-	if (ACPI_FAILURE(status) || data->wbase == 0 || data->ebase == 0 ||
+	if (data->wbase == 0 || data->ebase == 0 ||
 	    data->sbase == 0 || data->irq == 0) {
 		err = -ENODEV;
-		dev_err(dev, "Invalid ACPI resources\n");
+		dev_err(dev, "Invalid resources\n");
 		goto exit_free_data;
 	}
 
@@ -1579,15 +1535,15 @@ exit_release_wbase:
 	release_region(data->wbase, WAKEUP_IOMEM_LEN);
 exit_free_data:
 	kfree(data);
-	device->driver_data = NULL;
+	pnp_set_drvdata(device, NULL);
 exit:
 	return err;
 }
 
-static int
-wbcir_remove(struct acpi_device *device, int type)
+static void
+wbcir_remove(struct pnp_dev *device)
 {
-	struct wbcir_data *data = acpi_driver_data(device);
+	struct wbcir_data *data = pnp_get_drvdata(device);
 	struct wbcir_keyentry *key;
 	struct wbcir_keyentry *keytmp;
 
@@ -1631,29 +1587,23 @@ wbcir_remove(struct acpi_device *device, int type)
 
 	kfree(data);
 
-	device->driver_data = NULL;
-
-	return 0;
+	pnp_set_drvdata(device, NULL);
 }
 
-static const struct acpi_device_id wbcir_ids[] = {
+static const struct pnp_device_id wbcir_ids[] = {
 	{ "WEC1022", 0 },
 	{ "", 0 }
 };
-MODULE_DEVICE_TABLE(acpi, wbcir_ids);
-
-static struct acpi_driver wbcir_driver = {
-	.name  = WBCIR_ACPI_NAME,
-	.class = WBCIR_ACPI_CLASS,
-	.ids   = wbcir_ids,
-	.ops = {
-		.add      = wbcir_add,
-		.remove   = wbcir_remove,
-		.suspend  = wbcir_suspend,
-		.resume   = wbcir_resume,
-		.shutdown = wbcir_shutdown
-	},
-	.owner = THIS_MODULE
+MODULE_DEVICE_TABLE(pnp, wbcir_ids);
+
+static struct pnp_driver wbcir_driver = {
+	.name     = WBCIR_ACPI_NAME,
+	.id_table = wbcir_ids,
+	.probe    = wbcir_probe,
+	.remove   = wbcir_remove,
+	.suspend  = wbcir_suspend,
+	.resume   = wbcir_resume,
+	.shutdown = wbcir_shutdown
 };
 
 static int __init
@@ -1671,7 +1621,7 @@ wbcir_init(void)
 		return -EINVAL;
 	}
 
-	ret = acpi_bus_register_driver(&wbcir_driver);
+	ret = pnp_register_driver(&wbcir_driver);
 	if (ret)
 		printk(KERN_ERR DRVNAME ": Unable to register driver\n");
 
@@ -1681,7 +1631,7 @@ wbcir_init(void)
 static void __exit
 wbcir_exit(void)
 {
-	acpi_bus_unregister_driver(&wbcir_driver);
+	pnp_unregister_driver(&wbcir_driver);
 }
 
 MODULE_AUTHOR("David Härdeman <david@hardeman.nu>");
