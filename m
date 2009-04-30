Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbZD3JUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbZD3JUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbZD3JUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:20:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:13296 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZD3JUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:20:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,271,1239001200"; 
   d="scan'208";a="686286530"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Pasrija, Geeta" <geeta.pasrija@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Date: Thu, 30 Apr 2009 17:19:06 +0800
Subject: RE: [PATCH 2/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown
  platform
Thread-Topic: [PATCH 2/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel
 Moorestown  platform
Thread-Index: AcnJdA7l9tu2mvkrS8+4WTSkeCAZpAAAFfLg
Message-ID: <95608CFE3D0C064B8468DB61F8403BE029D298B1FF@PDSMSX501.ccr.corp.intel.com>
References: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com>
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com>
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


This patch enables support of SDIO bus driver suspend/resume operation and supply sysfs interface for user
to call suspend/resume selectively.Remind that this function should work together with SDIO device driver's
suspend/resume function.

And Moorestown's specific code is added into this patch to enable the second SDIO slot of the host controller.

Signed-off-by: JiebingLi <jiebing.li@intel.com>

---

 drivers/mmc/core/Kconfig      |    9 +
 drivers/mmc/core/sdio.c       |  467 ++++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/core/sdio_bus.c   |   26 +++
 drivers/mmc/host/Kconfig      |    8 +
 drivers/mmc/host/sdhci-pci.c  |   20 ++-
 drivers/mmc/host/sdhci.c      |   14 ++-
 drivers/mmc/host/sdhci.h      |    2 +
 include/linux/mmc/card.h      |   11 +
 include/linux/mmc/sdio_func.h |    6 +
 9 files changed, 551 insertions(+), 12 deletions(-)

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
index 3f31f67..1d1d785 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -24,6 +24,215 @@
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
+       if (!func)
+               return -EINVAL;
+
+       dev = &func->dev;
+       BUG_ON(!dev);
+
+       down(&dev->sem);
+
+       if (dev->bus)
+               if (dev->bus->suspend)
+                       error = dev->bus->suspend(dev, msg);
+
+       up(&dev->sem);
+
+       return error;
+}
+
+static int sdio_resume_func(struct mmc_card *card, struct sdio_func *func)
+{
+       struct device *dev;
+       int error = 0;
+
+       if (!func)
+               return -EINVAL;
+
+       dev = &func->dev;
+       BUG_ON(!dev);
+
+       down(&dev->sem);
+
+       if (dev->bus)
+               if (dev->bus->resume)
+                       error = dev->bus->resume(dev);
+
+       up(&dev->sem);
+
+       return error;
+}
+
+/*
+ * This routine handles external suspend request coming from sysfs
+ */
+int sdio_external_suspend_device(struct mmc_card *card, pm_message_t msg)
+{
+       int ret = 0;
+       int i = 0;
+
+       BUG_ON(!card->host);
+       BUG_ON(!card->sdio_func);
+
+       mutex_lock(&card->pm_mutex);
+       if (!mmc_card_present(card) ||
+               mmc_card_suspended(card))
+               goto done;
+
+       /* suspend all funcs of the SDIO device */
+       for (; i < card->sdio_funcs; i++) {
+               ret = sdio_suspend_func(card, card->sdio_func[i], msg);
+               if (ret != 0)
+                       break;
+       }
+
+       if (ret == 0)
+               ret = mmc_suspend_host(card->host, msg);
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
+/*
+ * This routine handles external resume request coming from sysfs
+ */
+int sdio_external_resume_device(struct mmc_card *card)
+{
+       int ret = 0;
+       int i = 0;
+
+       BUG_ON(!card->host);
+       BUG_ON(!card->sdio_func);
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
+               if (ret == 0) {
+                       for (i = 0; i < card->sdio_funcs; i++) {
+                               ret = sdio_resume_func(card,
+                                        card->sdio_func[i]);
+                               if (ret != 0)
+                                       break;
+                       }
+               }
+
+               if (ret == 0)
+                       mmc_card_clear_suspended(card);
+       }
+
+done:
+       mutex_unlock(&card->pm_mutex);
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
+       struct mmc_card *card = container_of(dev, struct mmc_card, dev);
+       const char *p = suspend_string;
+
+       BUG_ON(!card);
+
+       if (mmc_card_suspended(card))
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
+       struct mmc_card *card = container_of(dev, struct mmc_card, dev);
+       int len = count;
+       char *cp;
+       int ret = 0;
+
+       BUG_ON(!card);
+
+       cp = memchr(buf, '\n', count);
+       if (cp)
+               len = cp - buf;
+
+       down(&dev->sem);
+
+       if (len == sizeof resume_string - 1 &&
+               strncmp(buf, resume_string, len) == 0) {
+               ret = sdio_external_resume_device(card);
+       } else if (len == sizeof suspend_string - 1 &&
+               strncmp(buf, suspend_string, len) == 0) {
+               ret = sdio_external_suspend_device(card, PMSG_SUSPEND);
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
+void sdio_remove_sysfs_file(struct mmc_card *card)
+{
+       struct device *dev = &card->dev;
+
+       sysfs_remove_file_from_group(&dev->kobj,
+               &dev_attr_level.attr,
+               power_group);
+}
+
+int sdio_create_sysfs_file(struct mmc_card *card)
+{
+       int ret;
+       struct device *dev = &card->dev;
+
+       ret = sysfs_add_file_to_group(&dev->kobj,
+               &dev_attr_level.attr,
+               power_group);
+
+       if (ret)
+               goto error;
+
+       return 0;
+
+error:
+       sdio_remove_sysfs_file(card);
+       return ret;
+}
+
+#endif /* CONFIG_SDIO_SUSPEND */
+
 static int sdio_read_fbr(struct sdio_func *func)
 {
        int ret;
@@ -197,6 +406,97 @@ static int sdio_enable_hs(struct mmc_card *card)
 #endif

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
@@ -213,6 +513,10 @@ static void mmc_sdio_remove(struct mmc_host *host)
                }
        }

+#ifdef CONFIG_SDIO_SUSPEND
+       sdio_remove_sysfs_file(host->card);
+#endif
+
        mmc_remove_card(host->card);
        host->card = NULL;
 }
@@ -246,9 +550,73 @@ static void mmc_sdio_detect(struct mmc_host *host)
 }


+/*
+ * Suspend callback from host.
+ */
+static void mmc_sdio_suspend(struct mmc_host *host)
+{
+       int err;
+       u8 reg = 0;
+
+       BUG_ON(!host);
+       BUG_ON(!host->card);
+
+       mmc_claim_host(host);
+
+       if (!mmc_host_is_spi(host)) {
+               /*
+                * I/O reset to go back to the Initialization state
+                */
+               err = mmc_io_rw_direct(host->card, 0, 0,
+                        SDIO_CCCR_ABORT, 0, &reg);
+
+               if (err)
+                       reg = 0x08;
+               else
+                       reg |= 0x08;
+
+               mmc_io_rw_direct(host->card, 1, 0, SDIO_CCCR_ABORT, reg, NULL);
+       }
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
+       err = mmc_sdio_reinit_card(host, host->card);
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


@@ -325,6 +693,10 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
                goto err;
        }

+#ifdef CONFIG_SDIO_SUSPEND
+       mutex_init(&card->pm_mutex);
+#endif
+
        card->type = MMC_TYPE_SDIO;
        card->sdio_funcs = funcs;

@@ -364,10 +736,6 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
        if (err)
                goto remove;

-/*
- * temporarily avoiding SDIO cards to switch to HS timing
- * which doesn't work yet due to existing Silicon bug
- */
 #ifndef CONFIG_MRST_MMC_WR
        /*
         * Switch to high-speed (if supported).
@@ -391,12 +759,12 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
                mmc_set_clock(host, card->cis.max_dtr);
        }
 #else
+       /* restricting to 24MHz for Langwell A0 */
        if (card->cis.max_dtr > 24000000)
                card->cis.max_dtr = 24000000;

        mmc_set_clock(host, card->cis.max_dtr);
 #endif
-
        /*
         * Switch to wider bus (if supported).
         */
@@ -423,6 +791,14 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
                goto remove_added;

        /*
+        * create the user interface to call suspend/resume
+        * from susfs
+        */
+#ifdef CONFIG_SDIO_SUSPEND
+       sdio_create_sysfs_file(host->card);
+#endif
+
+       /*
         * ...then the SDIO functions.
         */
        for (i = 0;i < funcs;i++) {
@@ -452,3 +828,84 @@ err:
        return err;
 }

+/*
+ * warn device driver and perform a SDIO device reset.
+ * Assume that device driver knows hot to handle resets.
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
+       .suspend        = sdio_bus_suspend,
+       .resume         = sdio_bus_resume,
 };

 int sdio_register_bus(void)
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index b4cf691..0c9d2eb 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -44,6 +44,14 @@ config MMC_SDHCI_IO_ACCESSORS
          This is silent Kconfig symbol that is selected by the drivers that
          need to overwrite SDHCI IO memory accessors.

+config MMC_SDHCI_MRST_SDIO1
+       bool
+       depends on MMC_SDHCI
+       help
+         This enables Moorestown SD host controller's 2nd SDIO slot.
+
+         If unsure, say N.
+
 config MMC_SDHCI_PCI
        tristate "SDHCI support on PCI bus"
        depends on MMC_SDHCI && PCI
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 312ec69..2debbcd 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -288,7 +288,8 @@ static const struct sdhci_pci_fixes sdhci_jmicron = {
  * ADMA operation is disabled for Moorestown platform.
  */
 static const struct sdhci_pci_fixes sdhci_intel_mrst = {
-       .quirks         = SDHCI_QUIRK_BROKEN_ADMA,
+       .quirks         = SDHCI_QUIRK_BROKEN_ADMA |
+                        SDHCI_QUIRK_MRST_RESTRICTION,
 };

 static const struct pci_device_id pci_ids[] __devinitdata = {
@@ -396,11 +397,14 @@ static int sdhci_pci_enable_dma(struct sdhci_host *host)
        slot = sdhci_priv(host);
        pdev = slot->chip->pdev;

-       if (((pdev->class & 0xFFFF00) == (PCI_CLASS_SYSTEM_SDHCI << 8)) &&
-               ((pdev->class & 0x0000FF) != PCI_SDHCI_IFDMA) &&
-               (host->flags & SDHCI_USE_DMA)) {
-               dev_warn(&pdev->dev, "Will use DMA mode even though HW "
-                       "doesn't fully claim to support it.\n");
+       if (!(host->quirks & SDHCI_QUIRK_MRST_RESTRICTION)) {
+               if (((pdev->class & 0xFFFF00) ==
+                        (PCI_CLASS_SYSTEM_SDHCI << 8)) &&
+                       ((pdev->class & 0x0000FF) != PCI_SDHCI_IFDMA) &&
+                       (host->flags & SDHCI_USE_DMA)) {
+                       dev_warn(&pdev->dev, "Will use DMA mode even though HW "
+                               "doesn't fully claim to support it.\n");
+               }
        }

        ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -642,7 +646,11 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
         */
        if (pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD0 ||
                pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD1) {
+#ifndef CONFIG_MMC_SDHCI_MRST_SDIO1
                slots = 1;
+#else
+               slots = 2;
+#endif
        } else {
                ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &slots);

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a2804f1..4d4ad6d 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -914,6 +914,17 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
        if (cmd->data)
                flags |= SDHCI_CMD_DATA;

+#ifdef CONFIG_MMC_SDHCI_MRST_SDIO1
+       if (host->quirks & SDHCI_QUIRK_MRST_RESTRICTION) {
+               u16 clk;
+
+               clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL);
+
+               clk |= SDHCI_CLOCK_CARD_EN;
+               sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
+       }
+#endif
+
        sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags), SDHCI_COMMAND);
 }

@@ -1788,7 +1799,8 @@ int sdhci_add_host(struct sdhci_host *host)
        } else {
                mmc->max_blk_size = (caps & SDHCI_MAX_BLOCK_MASK) >>
                                SDHCI_MAX_BLOCK_SHIFT;
-               if (mmc->max_blk_size >= 3) {
+               if ((mmc->max_blk_size >= 3) &&
+                       !(host->quirks & SDHCI_QUIRK_MRST_RESTRICTION)) {
                        printk(KERN_WARNING "%s: Invalid maximum block size, "
                                "assuming 512 bytes\n", mmc_hostname(mmc));
                        mmc->max_blk_size = 0;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index fa87b8b..50be698 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -227,6 +227,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET           (1<<19)
 /* Controller has to be forced to use block size of 2048 bytes */
 #define SDHCI_QUIRK_FORCE_BLK_SZ_2048                  (1<<20)
+/* Controller of Moorestown specific restriction */
+#define SDHCI_QUIRK_MRST_RESTRICTION                   (1<<21)

        int                     irq;            /* Device IRQ */
        void __iomem *          ioaddr;         /* Mapped address */
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index e5d8a9e..d4adc6a 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -109,6 +109,7 @@ struct mmc_card {
 #define MMC_STATE_READONLY     (1<<1)          /* card is read-only */
 #define MMC_STATE_HIGHSPEED    (1<<2)          /* card is in high speed mode */
 #define MMC_STATE_BLOCKADDR    (1<<3)          /* card uses block-addressing */
+#define MMC_STATE_SUSPENDED    (1<<4)          /* card suspended */

        u32                     raw_cid[4];     /* raw card CID */
        u32                     raw_csd[4];     /* raw card CSD */
@@ -132,6 +133,10 @@ struct mmc_card {
        struct sdio_func_tuple  *tuples;        /* unknown common tuples */

        struct dentry           *debugfs_root;
+
+#ifdef CONFIG_SDIO_SUSPEND
+       struct mutex            pm_mutex;
+#endif
 };

 #define mmc_card_mmc(c)                ((c)->type == MMC_TYPE_MMC)
@@ -143,12 +148,18 @@ struct mmc_card {
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
index 451bdfc..a733fa5 100644
--- a/include/linux/mmc/sdio_func.h
+++ b/include/linux/mmc/sdio_func.h
@@ -77,6 +77,11 @@ struct sdio_driver {

        int (*probe)(struct sdio_func *, const struct sdio_device_id *);
        void (*remove)(struct sdio_func *);
+       int (*suspend)(struct sdio_func *, pm_message_t);
+       int (*resume)(struct sdio_func *);
+
+       int (*pre_reset)(struct sdio_func *);
+       int (*post_reset)(struct sdio_func *);

        struct device_driver drv;
 };
@@ -150,5 +155,6 @@ extern unsigned char sdio_f0_readb(struct sdio_func *func,
 extern void sdio_f0_writeb(struct sdio_func *func, unsigned char b,
        unsigned int addr, int *err_ret);

+extern int sdio_reset_device(struct mmc_card *card);
 #endif

--
1.6.0

-----Original Message-----
From: Li, Jiebing
Sent: Thursday, April 30, 2009 5:14 PM
To: Pierre Ossman
Cc: linux-kernel@vger.kernel.org; Johnson, Charles F; Zhu, Daniel; Yuan, Hang; Pasrija, Geeta; Li, Jiebing
Subject: [PATCH 0/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown platform

Hi Pierre,

I wish to submit two patches for Intel low power platform "Moorestown". The below is the description of the patches:

1. Patch 1 enables CE-ATA device support on Moorestown platform.
2. Patch 2 enables SDIO OSPM suspend/resume support for SDIO devices applied on Moorestown.
3. Added some silicon/hardware specific restrictions.

This is the first time Moorestown related patches are submitted, so I'm ready for code review and will try my best to do updates before the code can be finally accepted.

Thanks a lot!

Regards,
Jiebing Li
