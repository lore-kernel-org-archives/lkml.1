Return-Path: <linux-kernel-owner+w=401wt.eu-S1760017AbZFOMGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017AbZFOMGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZFOMFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:05:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:45803 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783AbZFOMFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:05:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,222,1243839600"; 
   d="scan'208";a="466418794"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <pierre@ossman.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Date: Mon, 15 Jun 2009 20:05:17 +0800
Subject: [PATCH 1/1] MMC: SDIO driver for Intel Moorestown  platform
Thread-Topic: [PATCH 1/1] MMC: SDIO driver for Intel Moorestown  platform
Thread-Index: AcntsYwkr/Taa2vnTUWXdwSq///ItQ==
Message-ID: <95608CFE3D0C064B8468DB61F8403BE036C19F9C0E@PDSMSX501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch enables SDIO bus driver suspend/resume operation support
and supplies sysfs interface for user to call suspend/resume selectively.

Signed-off-by: JiebingLi <jiebing.li@intel.com>
---
 drivers/mmc/core/Kconfig      |    9 +
 drivers/mmc/core/sdio.c       |  497 +++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sdio_bus.c   |   26 +++
 include/linux/mmc/card.h      |   11 +
 include/linux/mmc/sdio_func.h |   14 ++
 5 files changed, 557 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index ab37a6d..eaa5fcf 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -14,3 +14,12 @@ config MMC_UNSAFE_RESUME
          This option is usually just for embedded systems which use
          a MMC/SD card for rootfs. Most people should say N here.

+config SDIO_SUSPEND
+       bool "SDIO selective suspend/resume"
+       depends on MMC && PM
+       help
+         If you say Y here, you can use driver calls or the sysfs
+         "power/level" file to suspend or resume the SDIO
+         peripherals.
+
+         If you are unsure about this, say N here.
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index fb99ccf..a44741d 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -24,6 +24,262 @@
 #include "sdio_ops.h"
 #include "sdio_cis.h"

+#define to_sdio_driver(d) container_of(d, struct sdio_driver, drv)
+
+#ifdef CONFIG_SDIO_SUSPEND
+
+static int sdio_suspend_func(struct mmc_card *card,
+        struct sdio_func *func, pm_message_t msg)
+{
+       struct device *dev;
+       int error = 0;
+
+       dev = &func->dev;
+       BUG_ON(!dev);
+
+       if (dev->bus)
+               if (dev->bus->suspend)
+                       error = dev->bus->suspend(dev, msg);
+
+       return error;
+}
+
+static int sdio_resume_func(struct mmc_card *card, struct sdio_func *func)
+{
+       struct device *dev;
+       int error = 0;
+
+       dev = &func->dev;
+       BUG_ON(!dev);
+
+       if (dev->bus)
+               if (dev->bus->resume)
+                       error = dev->bus->resume(dev);
+
+       return error;
+}
+
+int sdio_suspend_host(struct mmc_card *card, pm_message_t msg)
+{
+       int ret = 0;
+       int i = 0;
+
+       mutex_lock(&card->pm_mutex);
+
+       if (!mmc_card_present(card) ||
+               mmc_card_suspended(card))
+               goto done;
+
+       for (i = 0; i < card->sdio_funcs; i++)
+               if (!sdio_func_suspended(card->sdio_func[i])) {
+                       struct device *dev = &(card->sdio_func[i])->dev;
+                       BUG_ON(!dev);
+
+                       struct sdio_driver *drv = to_sdio_driver(dev->driver);
+
+                       if (dev->driver && drv->suspend)
+                               goto done;
+               }
+
+       ret = mmc_suspend_host(card->host, msg);
+
+       if (ret == 0)
+               mmc_card_set_suspended(card);
+
+done:
+       mutex_unlock(&card->pm_mutex);
+
+       return ret;
+}
+
+int sdio_resume_host(struct mmc_card *card)
+{
+       int ret = 0;
+
+       mutex_lock(&card->pm_mutex);
+
+       if (!mmc_card_present(card)) {
+               ret = -ENODEV;
+               goto done;
+       }
+
+       if (mmc_card_suspended(card)) {
+               ret = mmc_resume_host(card->host);
+
+               if (ret == 0)
+                       mmc_card_clear_suspended(card);
+               else
+                       goto done;
+       }
+
+done:
+       mutex_unlock(&card->pm_mutex);
+
+       return ret;
+}
+
+/*
+ * This routine handles external suspend request coming from sysfs:
+ * Selectively suspend a particular device(function) using sysfs interface
+ * for power management scheme (non-ACPI) if the device is not in use.
+ */
+int sdio_external_suspend_device(struct sdio_func *func, pm_message_t msg)
+{
+       int ret = 0;
+       struct mmc_card *card = func->card;
+
+       BUG_ON(!card);
+       BUG_ON(!card->host);
+
+       mutex_lock(&card->pm_mutex);
+
+       if (!sdio_func_present(func) ||
+               sdio_func_suspended(func)) {
+               mutex_unlock(&card->pm_mutex);
+               goto done;
+       }
+
+       /* suspend the function of the SDIO device */
+       ret = sdio_suspend_func(card, func, msg);
+
+       if (ret != 0) {
+               mutex_unlock(&card->pm_mutex);
+               goto done;
+       }
+
+       sdio_func_set_suspended(func);
+
+       mutex_unlock(&card->pm_mutex);
+
+       ret = sdio_suspend_host(card, msg);
+
+done:
+       return ret;
+}
+
+/*
+ * This routine handles external resume request coming from sysfs
+ */
+int sdio_external_resume_device(struct sdio_func *func)
+{
+       int ret = 0;
+       struct mmc_card *card = func->card;
+
+       BUG_ON(!card);
+       BUG_ON(!card->host);
+
+       ret = sdio_resume_host(card);
+       if (ret)
+               goto done;
+
+       mutex_lock(&card->pm_mutex);
+
+       if (sdio_func_suspended(func)) {
+               ret = sdio_resume_func(card, func);
+
+                       if (ret != 0) {
+                               mutex_unlock(&card->pm_mutex);
+                               goto done;
+                       } else
+                               sdio_func_clear_suspended(func);
+       }
+
+       mutex_unlock(&card->pm_mutex);
+done:
+
+       return ret;
+}
+
+static const char power_group[] = "power";
+
+static const char resume_string[] = "resume";
+static const char suspend_string[] = "suspend";
+
+static ssize_t
+show_level(struct device *dev, struct device_attribute *attr, char *buf)
+{
+       struct sdio_func *func = container_of(dev, struct sdio_func, dev);
+       const char *p = suspend_string;
+
+       BUG_ON(!func);
+
+       if (sdio_func_suspended(func))
+               p = suspend_string;
+       else
+               p = resume_string;
+
+       return sprintf(buf, "%s\n", p);
+}
+
+static ssize_t
+set_level(struct device *dev, struct device_attribute *attr,
+       const char *buf, size_t count)
+{
+       struct sdio_func *func = container_of(dev, struct sdio_func, dev);
+       int len = count;
+       char *cp;
+       int ret = 0;
+
+       BUG_ON(!func);
+
+       cp = memchr(buf, '\n', count);
+       if (cp)
+               len = cp - buf;
+
+       down(&dev->sem);
+
+       if (len == sizeof resume_string - 1 &&
+               strncmp(buf, resume_string, len) == 0) {
+               ret = sdio_external_resume_device(func);
+       } else if (len == sizeof suspend_string - 1 &&
+               strncmp(buf, suspend_string, len) == 0) {
+               ret = sdio_external_suspend_device(func, PMSG_SUSPEND);
+       } else {
+               ret = -EINVAL;
+       }
+
+       up(&dev->sem);
+
+       return (ret < 0 ? ret : count);
+}
+
+static DEVICE_ATTR(level, S_IRUGO | S_IWUSR, show_level, set_level);
+
+void sdio_remove_sysfs_file(struct sdio_func *func)
+{
+       struct device *dev = &func->dev;
+       struct sdio_driver *drv = to_sdio_driver(dev->driver);
+
+       if (dev->driver && drv->suspend)
+               sysfs_remove_file_from_group(&dev->kobj,
+                       &dev_attr_level.attr,
+                       power_group);
+}
+
+int sdio_create_sysfs_file(struct sdio_func *func)
+{
+       int ret;
+       struct device *dev = &func->dev;
+       struct sdio_driver *drv = to_sdio_driver(dev->driver);
+
+       if (dev->driver && drv->suspend) {
+               ret = sysfs_add_file_to_group(&dev->kobj,
+                       &dev_attr_level.attr,
+                       power_group);
+
+               if (ret)
+                       goto error;
+       }
+
+       return 0;
+
+error:
+       sdio_remove_sysfs_file(func);
+       return ret;
+}
+
+#endif /* CONFIG_SDIO_SUSPEND */
+
 static int sdio_read_fbr(struct sdio_func *func)
 {
        int ret;
@@ -195,6 +451,97 @@ static int sdio_enable_hs(struct mmc_card *card)
 }

 /*
+ * Handle the re-initialization of a SDIO card.
+ */
+static int mmc_sdio_reinit_card(struct mmc_host *host,
+       struct mmc_card *oldcard)
+{
+       int err = 0;
+       u16 funcs;
+       u32 ocr;
+       struct mmc_card *card;
+
+       BUG_ON(!host);
+       WARN_ON(!host->claimed);
+
+       if (!oldcard)
+               goto err;
+
+       card = oldcard;
+
+       err = mmc_send_io_op_cond(host, 0, &ocr);
+       if (err)
+               goto remove;
+
+       /*
+        * Inform the card of the voltage
+        */
+       err = mmc_send_io_op_cond(host, host->ocr, &ocr);
+       if (err)
+               goto remove;
+
+       /*
+        * For SPI, enable CRC as appropriate.
+        */
+       if (mmc_host_is_spi(host)) {
+               err = mmc_spi_set_crc(host, use_spi_crc);
+               if (err)
+                       goto remove;
+       }
+
+       funcs = (ocr & 0x70000000) >> 28;
+
+       if (funcs != card->sdio_funcs)
+               printk(KERN_INFO "funcs number is changed from OCR register after suspend!\n");
+
+       if (!mmc_host_is_spi(host)) {
+               err = mmc_send_relative_addr(host, &card->rca);
+               if (err)
+                       goto remove;
+
+               mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
+       }
+
+       /*
+        * Select card, as all following commands rely on that.
+        */
+       if (!mmc_host_is_spi(host)) {
+               err = mmc_select_card(card);
+               if (err)
+                       goto remove;
+       }
+
+       /*
+        * Read the common CIS tuples.
+        */
+       err = sdio_read_cccr(card);
+       if (err)
+               goto remove;
+
+#ifdef CONFIG_MRST_MMC_WR
+       /* restricting to 24MHz for Langwell A0 */
+       if (card->cis.max_dtr > 24000000)
+               card->cis.max_dtr = 24000000;
+#endif
+       mmc_set_clock(host, card->cis.max_dtr);
+
+       /*
+        * Switch to wider bus (if supported).
+        */
+       err = sdio_enable_wide(card);
+       if (err)
+               goto remove;
+
+       host->card = card;
+
+       return 0;
+
+remove:
+err:
+       return err;
+}
+
+/*
  * Host is being removed. Free up the current card.
  */
 static void mmc_sdio_remove(struct mmc_host *host)
@@ -206,6 +553,9 @@ static void mmc_sdio_remove(struct mmc_host *host)

        for (i = 0;i < host->card->sdio_funcs;i++) {
                if (host->card->sdio_func[i]) {
+#ifdef CONFIG_SDIO_SUSPEND
+                       sdio_remove_sysfs_file(host->card->sdio_func[i]);
+#endif
                        sdio_remove_func(host->card->sdio_func[i]);
                        host->card->sdio_func[i] = NULL;
                }
@@ -244,9 +594,58 @@ static void mmc_sdio_detect(struct mmc_host *host)
 }


+/*
+ * Suspend callback from host.
+ */
+static void mmc_sdio_suspend(struct mmc_host *host)
+{
+       BUG_ON(!host);
+       BUG_ON(!host->card);
+
+       mmc_claim_host(host);
+
+       if (!mmc_host_is_spi(host))
+               mmc_deselect_cards(host);
+
+       mmc_release_host(host);
+
+       printk(KERN_INFO "%s: SDIO device is suspended\n",
+               mmc_hostname(host));
+}
+
+/*
+ * Resume callback from host.
+ */
+static void mmc_sdio_resume(struct mmc_host *host)
+{
+       int err;
+
+       BUG_ON(!host);
+       BUG_ON(!host->card);
+
+       mmc_claim_host(host);
+
+       err = mmc_select_card(host->card);
+
+       mmc_release_host(host);
+
+       if (err) {
+               mmc_sdio_remove(host);
+
+               mmc_claim_host(host);
+               mmc_detach_bus(host);
+               mmc_release_host(host);
+       } else {
+               printk(KERN_INFO "%s: SDIO device is resumed\n",
+                       mmc_hostname(host));
+       }
+}
+
 static const struct mmc_bus_ops mmc_sdio_ops = {
        .remove = mmc_sdio_remove,
        .detect = mmc_sdio_detect,
+       .suspend = mmc_sdio_suspend,
+       .resume = mmc_sdio_resume,
 };


@@ -323,6 +722,10 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
                goto err;
        }

+#ifdef CONFIG_SDIO_SUSPEND
+       mutex_init(&card->pm_mutex);
+#endif
+
        card->type = MMC_TYPE_SDIO;
        card->sdio_funcs = funcs;

@@ -416,6 +819,13 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
                err = sdio_add_func(host->card->sdio_func[i]);
                if (err)
                        goto remove_added;
+               /*
+                * create the user interface to call suspend/resume
+                * from susfs
+                */
+#ifdef CONFIG_SDIO_SUSPEND
+               sdio_create_sysfs_file(host->card->sdio_func[i]);
+#endif
        }

        return 0;
@@ -439,3 +849,90 @@ err:
        return err;
 }

+/*
+ * Sometimes there is a hang in the host interface hardware,
+ * eg: the device driver can not access the device due to some error.
+ * This API is used by device driver to perform a SDIO device
+ * reset in order to solve such issues.
+ *
+ * Warn all device drivers using their pre_reset method,
+ * performs the whole SDIO card and then lets the drivers
+ * know that the reset is over using the post_reset method.
+ */
+int sdio_reset_device(struct mmc_card *card)
+{
+       int ret = 0;
+       int i = 0;
+       u8 reg = 0;
+
+       BUG_ON(!card);
+       BUG_ON(!card->host);
+       BUG_ON(!card->sdio_func);
+
+       if (!mmc_card_present(card) ||
+               mmc_card_suspended(card)) {
+               dev_dbg(&card->dev, "device reset not allowed\n");
+               return -EINVAL;
+       }
+
+       for (; i < card->sdio_funcs; i++) {
+               struct sdio_func *func = card->sdio_func[i];
+               struct sdio_driver *drv;
+
+               if (func && func->dev.driver) {
+                       drv = to_sdio_driver(func->dev.driver);
+                       if (drv->pre_reset) {
+                               ret = (drv->pre_reset)(func);
+                               if (ret)
+                                       break;
+                       }
+               }
+       }
+
+       if (ret)
+               goto err;
+
+       /* reset SDIO card via CMD52 */
+       mmc_claim_host(card->host);
+
+       ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_ABORT, 0, &reg);
+
+       if (ret)
+               reg = 0x08;
+       else
+               reg |= 0x08;
+
+       mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_ABORT, reg, NULL);
+
+       /* re-enumerate the device */
+       ret = mmc_sdio_reinit_card(card->host, card);
+
+       mmc_release_host(card->host);
+
+       if (ret)
+               goto err;
+
+       for (i = card->sdio_funcs - 1; i >= 0; i--) {
+               struct sdio_func *func = card->sdio_func[i];
+               struct sdio_driver *drv;
+
+               if (func && func->dev.driver) {
+                       drv = to_sdio_driver(func->dev.driver);
+                       if (drv->post_reset) {
+                               ret = (drv->post_reset)(func);
+                               if (ret)
+                                       break;
+                       }
+               }
+       }
+
+       if (ret)
+               goto err;
+
+       return 0;
+
+err:
+       return -EINVAL;
+
+}
+EXPORT_SYMBOL_GPL(sdio_reset_device);
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 46284b5..3f53bae 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -156,6 +156,30 @@ static int sdio_bus_remove(struct device *dev)
        return 0;
 }

+static int sdio_bus_suspend(struct device *dev, pm_message_t state)
+{
+       struct sdio_driver *drv = to_sdio_driver(dev->driver);
+       struct sdio_func *func = dev_to_sdio_func(dev);
+       int ret = 0;
+
+       if (dev->driver && drv->suspend)
+               ret = drv->suspend(func, state);
+
+       return ret;
+}
+
+static int sdio_bus_resume(struct device *dev)
+{
+       struct sdio_driver *drv = to_sdio_driver(dev->driver);
+       struct sdio_func *func = dev_to_sdio_func(dev);
+       int ret = 0;
+
+       if (dev->driver && drv->resume)
+               ret = drv->resume(func);
+
+       return ret;
+}
+
 static struct bus_type sdio_bus_type = {
        .name           = "sdio",
        .dev_attrs      = sdio_dev_attrs,
@@ -163,6 +187,8 @@ static struct bus_type sdio_bus_type = {
        .uevent         = sdio_bus_uevent,
        .probe          = sdio_bus_probe,
        .remove         = sdio_bus_remove,
+       .suspend                = sdio_bus_suspend,
+       .resume         = sdio_bus_resume,
 };

 int sdio_register_bus(void)
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 403aa50..c6b77b8 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -94,6 +94,7 @@ struct mmc_card {
 #define MMC_STATE_READONLY     (1<<1)          /* card is read-only */
 #define MMC_STATE_HIGHSPEED    (1<<2)          /* card is in high speed mode */
 #define MMC_STATE_BLOCKADDR    (1<<3)          /* card uses block-addressing */
+#define MMC_STATE_SUSPENDED    (1<<4)          /* card suspended */

        u32                     raw_cid[4];     /* raw card CID */
        u32                     raw_csd[4];     /* raw card CSD */
@@ -113,6 +114,10 @@ struct mmc_card {
        struct sdio_func_tuple  *tuples;        /* unknown common tuples */

        struct dentry           *debugfs_root;
+
+#ifdef CONFIG_SDIO_SUSPEND
+       struct mutex            pm_mutex;
+#endif
 };

 #define mmc_card_mmc(c)                ((c)->type == MMC_TYPE_MMC)
@@ -123,12 +128,18 @@ struct mmc_card {
 #define mmc_card_readonly(c)   ((c)->state & MMC_STATE_READONLY)
 #define mmc_card_highspeed(c)  ((c)->state & MMC_STATE_HIGHSPEED)
 #define mmc_card_blockaddr(c)  ((c)->state & MMC_STATE_BLOCKADDR)
+#define mmc_card_suspended(c)  ((c)->state & MMC_STATE_SUSPENDED)

 #define mmc_card_set_present(c)        ((c)->state |= MMC_STATE_PRESENT)
 #define mmc_card_set_readonly(c) ((c)->state |= MMC_STATE_READONLY)
 #define mmc_card_set_highspeed(c) ((c)->state |= MMC_STATE_HIGHSPEED)
 #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)

+#ifdef CONFIG_SDIO_SUSPEND
+#define mmc_card_set_suspended(c) ((c)->state |= MMC_STATE_SUSPENDED)
+#define mmc_card_clear_suspended(c) ((c)->state &= ~MMC_STATE_SUSPENDED)
+#endif
+
 #define mmc_card_name(c)       ((c)->cid.prod_name)
 #define mmc_card_id(c)         (dev_name(&(c)->dev))

diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/sdio_func.h
index 451bdfc..5c94b6b 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -50,6 +50,7 @@ struct sdio_func {

        unsigned int            state;          /* function state */
 #define SDIO_STATE_PRESENT     (1<<0)          /* present in sysfs */
+#define SDIO_STATE_SUSPENDED   (1<<1)          /* present in sysfs */

        u8                      tmpbuf[4];      /* DMA:able scratch buffer */

@@ -60,9 +61,13 @@ struct sdio_func {
 };

 #define sdio_func_present(f)   ((f)->state & SDIO_STATE_PRESENT)
+#define sdio_func_suspended(f)  ((f)->state & SDIO_STATE_SUSPENDED)

 #define sdio_func_set_present(f) ((f)->state |= SDIO_STATE_PRESENT)

+#define sdio_func_set_suspended(f)      ((f)->state |= SDIO_STATE_SUSPENDED)
+#define sdio_func_clear_suspended(f)    ((f)->state &= ~SDIO_STATE_SUSPENDED)
+
 #define sdio_func_id(f)                (dev_name(&(f)->dev))

 #define sdio_get_drvdata(f)    dev_get_drvdata(&(f)->dev)
@@ -77,6 +82,11 @@ struct sdio_driver {

        int (*probe)(struct sdio_func *, const struct sdio_device_id *);
        void (*remove)(struct sdio_func *);
+       int (*suspend)(struct sdio_func *, pm_message_t);
+       int (*resume)(struct sdio_func *);
+
+       int (*pre_reset)(struct sdio_func *);
+       int (*post_reset)(struct sdio_func *);

        struct device_driver drv;
 };
@@ -150,5 +160,9 @@ extern unsigned char sdio_f0_readb(struct sdio_func *func,
 extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
        unsigned int addr, int *err_ret);

+extern int sdio_reset_device(struct mmc_card *card);
+
+extern int sdio_suspend_host(struct mmc_card *card, pm_message_t msg);
+extern int sdio_resume_host(struct mmc_card *card);
 #endif

--
1.6.0
