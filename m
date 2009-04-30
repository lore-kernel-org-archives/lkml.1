Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbZD3JT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbZD3JT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZD3JTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:19:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:22868 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbZD3JTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:19:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,271,1239001200"; 
   d="scan'208";a="137651091"
From: "Li, Jiebing" <jiebing.li@intel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Pasrija, Geeta" <geeta.pasrija@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Date: Thu, 30 Apr 2009 17:16:47 +0800
Subject: RE: [PATCH 1/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown
  platform
Thread-Topic: [PATCH 1/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel
 Moorestown  platform
Thread-Index: AcnJdA7l9tu2mvkrS8+4WTSkeCAZpAAAAdpg
Message-ID: <95608CFE3D0C064B8468DB61F8403BE029D298B1FC@PDSMSX501.ccr.corp.intel.com>
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


This patch enables CE-ATA HDD support including device initialization and  data read/write.
Validation has been passed with TOSHIBA, SAMSUNG and HITACHI devices.

And this patch also works for Moorestown platform by dealing with slicon/hardware limitations:
1. Slot number and first BAR values are fixed instead of reading from PCI configuration space.
2. Clock speed is restricted to normal-speed.
3. ADMA operation is disabled by adding quirks.

Signed-off-by: JiebingLi <jiebing.li@intel.com>
Signed-off-by: FengTang <feng.tang@intel.com>
Signed-off-by: GermanMonroy (german.monroy@intel.com>

---

 drivers/mmc/Kconfig          |   19 ++
 drivers/mmc/card/block.c     |  117 +++++++++++-
 drivers/mmc/core/Makefile    |    3 +-
 drivers/mmc/core/bus.c       |   10 +
 drivers/mmc/core/ceata.c     |  449 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/ceata.h     |   29 +++
 drivers/mmc/core/core.c      |   25 +++-
 drivers/mmc/core/mmc.c       |   56 +++++-
 drivers/mmc/core/mmc_ops.c   |   33 +++
 drivers/mmc/core/mmc_ops.h   |    2 +-
 drivers/mmc/core/sd.c        |    8 +
 drivers/mmc/core/sdio.c      |   13 ++
 drivers/mmc/host/sdhci-pci.c |   57 +++++-
 drivers/mmc/host/sdhci.c     |   14 +-
 drivers/mmc/host/sdhci.h     |    1 +
 include/linux/mmc/card.h     |   26 +++
 include/linux/mmc/mmc.h      |  111 +++++++++++
 17 files changed, 951 insertions(+), 22 deletions(-)
 create mode 100644 drivers/mmc/core/ceata.c
 create mode 100644 drivers/mmc/core/ceata.h

diff --git a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
index f2eeb38..3d1c83b 100644
--- a/drivers/mmc/Kconfig
+++ b/drivers/mmc/Kconfig
@@ -19,6 +19,25 @@ config MMC_DEBUG
          This is an option for use by developers; most people should
          say N here.  This enables MMC core and driver debugging.

+config MRST_MMC_WR
+       bool "MMC/SD/CEATA workaround for Moorestown"
+       depends on MMC
+       help
+         This is an option for Moorestown developers to add workaround
+         in the code due to Silicon issues.
+
+config MMC_CEATA_WR
+       bool "disable SDIO device search to support CEATA"
+       depends on MMC
+       help
+         This disables SDIO device search process to support various
+         brands of CE-ATA devices as some CE-ATA devices may pretends
+         itself as a SDIO device.
+
+         If you want SDIO support, you should say N here and if you
+         want to support as many as kinds of CE-ATA devices,you should
+         say Y. If you want to support both SDIO and CE-ATA, just say N.
+
 if MMC

 source "drivers/mmc/core/Kconfig"
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index fe8041e..022a9db 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -226,6 +226,98 @@ static u32 get_card_status(struct mmc_card *card, struct request *req)
        return cmd.resp[0];
 }

+static int ceata_blk_issue_rq(struct mmc_queue *mq, struct request *req)
+{
+       struct mmc_blk_data *md = mq->data;
+       struct mmc_card *card = md->queue.card;
+       struct mmc_blk_request brq;
+       int ret = 1;
+       int rw, err;
+
+       rw = rq_data_dir(req) == READ ? 0 : 1;
+
+       mmc_claim_host(card->host);
+
+       do {
+               /* 1. Send ATA command via ceata's mmc cmd 60*/
+               err = ceata_read_write_cmd(card,
+                       rw, req->sector, req->nr_sectors);
+
+               if (err)
+                       goto cmd_err;
+
+               /* 2. Transfer data via DMA using ceata's mmc cmd 61 */
+               memset(&brq, 0, sizeof(struct mmc_blk_request));
+
+               brq.mrq.cmd = &brq.cmd;
+               brq.mrq.data = &brq.data;
+               /* No stop command required for CEATA transfers */
+               brq.mrq.stop = NULL;
+
+               /*
+                * New controllers claim to support 4k mmc block transfers,
+                * but no known CEATA hdd supports it.
+                * Playing it safe at 512 for now
+                */
+               brq.data.blksz = 512;
+               brq.data.blocks = req->nr_sectors;
+               brq.data.flags = rw ? MMC_DATA_WRITE : MMC_DATA_READ;
+
+               if (brq.data.blocks > card->host->max_blk_count)
+                       brq.data.blocks = card->host->max_blk_count;
+
+               brq.cmd.opcode = MMC_CEATA_RW_MULTI_BLK;
+               brq.cmd.arg = (rw << 31) | req->nr_sectors;
+               brq.cmd.flags = MMC_CMD_ADTC | (rw ? MMC_RSP_R1B : MMC_RSP_R1);
+
+               mmc_set_data_timeout(&brq.data, card);
+
+               brq.data.sg = mq->sg;
+               brq.data.sg_len = mmc_queue_map_sg(mq);
+
+               mmc_queue_bounce_pre(mq);
+
+               mmc_wait_for_req(card->host, &brq.mrq);
+
+               mmc_queue_bounce_post(mq);
+
+               if (brq.cmd.error) {
+                       printk(KERN_ERR "%s: error %d sending read/write command\n",
+                       req->rq_disk->disk_name, brq.cmd.error);
+                       goto cmd_err;
+               }
+
+               if (brq.data.error) {
+                       printk(KERN_ERR "%s: error %d transferring data\n",
+                       req->rq_disk->disk_name, brq.data.error);
+                       goto cmd_err;
+               }
+
+               /*
+                * A block was successfully transferred.
+                */
+               spin_lock_irq(&md->lock);
+               ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
+               spin_unlock_irq(&md->lock);
+       } while (ret);
+
+       mmc_release_host(card->host);
+       return 1;
+
+cmd_err:
+       mmc_release_host(card->host);
+
+       spin_lock_irq(&md->lock);
+       while (ret)
+               ret = __blk_end_request(req, -EIO,
+                       req->current_nr_sectors << 9);
+
+       spin_unlock_irq(&md->lock);
+
+       return 0;
+
+}
+
 static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 {
        struct mmc_blk_data *md = mq->data;
@@ -449,6 +541,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)

 static inline int mmc_blk_readonly(struct mmc_card *card)
 {
+       if (mmc_card_ceata(card))
+               return 0;
+
        return mmc_card_readonly(card) ||
               !(card->csd.cmdclass & CCC_BLOCK_WRITE);
 }
@@ -489,7 +584,11 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
        if (ret)
                goto err_putdisk;

-       md->queue.issue_fn = mmc_blk_issue_rq;
+       if (mmc_card_ceata(card))
+               md->queue.issue_fn = ceata_blk_issue_rq;
+       else
+               md->queue.issue_fn = mmc_blk_issue_rq;
+
        md->queue.data = md;

        md->disk->major = MMC_BLOCK_MAJOR;
@@ -511,11 +610,20 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
         * messages to tell when the card is present.
         */

-       sprintf(md->disk->disk_name, "mmcblk%d", devidx);
+       snprintf(md->disk->disk_name, sizeof(md->disk->disk_name),
+               "mmcblk%d", devidx);

        blk_queue_hardsect_size(md->queue.queue, 512);

-       if (!mmc_card_sd(card) && mmc_card_blockaddr(card)) {
+       if (mmc_card_ceata(card)) {
+               /* max_lba[0] covers all current ceata devices */
+               WARN_ON(card->ceata_info->max_lba[1]);
+               /*
+                * Capacity from IDENTIFY_DEVICE comes in 512 byte
+                * sectors.
+                */
+               set_capacity(md->disk, card->ceata_info->max_lba[0]);
+       } else if (!mmc_card_sd(card) && mmc_card_blockaddr(card)) {
                /*
                 * The EXT_CSD sector count is in number or 512 byte
                 * sectors.
@@ -575,7 +683,8 @@ static int mmc_blk_probe(struct mmc_card *card)
        /*
         * Check that the card supports the command class(es) we need.
         */
-       if (!(card->csd.cmdclass & CCC_BLOCK_READ))
+       if (!(card->csd.cmdclass & CCC_BLOCK_READ) &&
+       !mmc_card_ceata(card))
                return -ENODEV;

        md = mmc_blk_alloc(card);
diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 889e5f8..3c31f32 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_MMC)             += mmc_core.o
 mmc_core-y                     := core.o bus.o host.o \
                                   mmc.o mmc_ops.o sd.o sd_ops.o \
                                   sdio.o sdio_ops.o sdio_bus.o \
-                                  sdio_cis.o sdio_io.o sdio_irq.o
+                                  sdio_cis.o sdio_io.o sdio_irq.o \
+                                  ceata.o

 mmc_core-$(CONFIG_DEBUG_FS)    += debugfs.o
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index bdb165f..5f66c5a 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -36,6 +36,8 @@ static ssize_t mmc_type_show(struct device *dev,
                return sprintf(buf, "SD\n");
        case MMC_TYPE_SDIO:
                return sprintf(buf, "SDIO\n");
+       case MMC_TYPE_CEATA:
+               return snprintf(buf, sizeof(buf), "CEATA\n");
        default:
                return -EFAULT;
        }
@@ -73,6 +75,9 @@ mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
        case MMC_TYPE_SDIO:
                type = "SDIO";
                break;
+       case MMC_TYPE_CEATA:
+               type = "CEATA";
+               break;
        default:
                type = NULL;
        }
@@ -190,6 +195,8 @@ static void mmc_release_card(struct device *dev)
        if (card->info)
                kfree(card->info);

+       kfree(card->ceata_info);
+
        kfree(card);
 }

@@ -238,6 +245,9 @@ int mmc_add_card(struct mmc_card *card)
        case MMC_TYPE_SDIO:
                type = "SDIO";
                break;
+       case MMC_TYPE_CEATA:
+               type = "CEATA";
+               break;
        default:
                type = "?";
                break;
diff --git a/drivers/mmc/core/ceata.c b/drivers/mmc/core/ceata.c
new file mode 100644
index 0000000..49fb80c
--- /dev/null
+++ b/drivers/mmc/core/ceata.c
@@ -0,0 +1,449 @@
+/*
+ * Intel MMC/SD/CEATA driver
+ * Copyright (C) 2008, Intel Corporation.
+ * Author: Li Jiebing (jiebing.li@intel.com)
+ *        Tang Feng  (feng.tang@intel.com)
+ *        Monroy German (german.monroy@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/mmc.h>
+#include <linux/scatterlist.h>
+
+#include "core.h"
+#include "mmc_ops.h"
+
+/*
+ * Poll ATA status register until the device is ready for the next
+ * ATA command (command completion)
+ */
+static int ceata_wait_until_ready(struct mmc_card *card)
+{
+       u8 status;
+       u8 error;
+       char *type;
+       /*
+        * Almost all the time this function will return immediately
+        * or within a few milliseconds.  However the Toshiba and
+        * Samsung hdds have been known to take up to 1.5 s to clear
+        * their ATA busy bit, either when the hdd is used for the first
+        * time or sporadically during normal use.  Leaving 30 s for
+        * a corner case.
+        */
+       int limit = 30000;
+       int wait = 0;
+
+       for (wait = 0; wait < limit; wait++) {
+               mmc_fast_io(card, 0, CEATA_REG_STATUS, &status, 0x0);
+
+               if (status & CEATA_STATUS_ERR) {
+                       mmc_fast_io(card, 0, CEATA_REG_ERROR, &error, 0x0);
+
+                       switch (error) {
+                       case CEATA_ERROR_ICRC:
+                               type = "Interface CRC";
+                               break;
+                       case CEATA_ERROR_UNC:
+                               type = "Uncorrectable data";
+                               break;
+                       case CEATA_ERROR_IDNF:
+                               type = "Sector not found";
+                               break;
+                       case CEATA_ERROR_ABRT:
+                               type = "Command Aborted";
+                               break;
+                       default:
+                               type = "Unknown";
+                       }
+                       printk(KERN_ERR "%s: CE-ATA device error: %s\n",
+                                       mmc_hostname(card->host), type);
+                       return -EIO;
+
+               }
+
+               if (!(status & CEATA_STATUS_BSY) &&
+                               (status & CEATA_STATUS_DRDY))
+                       goto exit;
+               mmc_delay(1);
+       }
+
+       printk(KERN_ERR "%s: after %d ms wait, CE-ATA still busy\n",
+                       mmc_hostname(card->host), wait);
+       return -ETIMEDOUT;
+
+exit:
+       if (wait > 0)
+               pr_debug("%s: polled CE-ATA status during %d ms\n",
+                               mmc_hostname(card->host), wait);
+       return 0;
+}
+
+/*
+ * Transfer multiple ATA registers (task file) in one MMC operation
+ */
+static int ceata_cmd60(struct mmc_card *card, u8 rw, void *ptaskfile,
+               u8 reg_addr, u8 bytelen)
+{
+       struct mmc_request mrq;
+       struct mmc_command cmd;
+       struct mmc_data data;
+       struct scatterlist sg;
+
+       BUG_ON(!card);
+       BUG_ON(!card->host);
+       BUG_ON(!ptaskfile);
+
+       memset(&mrq, 0, sizeof(struct mmc_request));
+       memset(&cmd, 0, sizeof(struct mmc_command));
+       memset(&data, 0, sizeof(struct mmc_data));
+
+       mrq.cmd = &cmd;
+       mrq.data = &data;
+
+       cmd.opcode = MMC_CEATA_RW_MULTI_REG;
+       cmd.arg = (rw << 31) | (reg_addr << 16) | (bytelen);
+       cmd.flags = MMC_CMD_ADTC | (rw ? MMC_RSP_R1B : MMC_RSP_R1);
+
+       data.blksz = bytelen;
+       data.blocks = 1;
+       data.flags = rw ? MMC_DATA_WRITE : MMC_DATA_READ;
+       data.sg = &sg;
+       data.sg_len = 1;
+
+       sg_init_one(&sg, ptaskfile, bytelen);
+
+       mmc_set_data_timeout(&data, card);
+
+       mmc_wait_for_req(card->host, &mrq);
+
+       if (cmd.error)
+               return cmd.error;
+       if (data.error)
+               return data.error;
+
+       return 0;
+}
+
+/*
+ * Transfer the data for a previously issued ATA taskfile
+ */
+static int ceata_cmd61(struct mmc_card *card, u8 rw, void *buffer,
+               u16 bytelen)
+{
+       struct mmc_request mrq;
+       struct mmc_command cmd;
+       struct mmc_data data;
+       struct scatterlist sg;
+
+       BUG_ON(!card);
+       BUG_ON(!card->host);
+       BUG_ON(bytelen % 512);
+
+       memset(&mrq, 0, sizeof(struct mmc_request));
+       memset(&cmd, 0, sizeof(struct mmc_command));
+       memset(&data, 0, sizeof(struct mmc_data));
+
+
+       mrq.cmd = &cmd;
+       mrq.data = &data;
+       mrq.stop = NULL;
+
+       /* MMC transfer size currently fixed at 512 */
+       data.blksz = 512;
+       data.blocks = bytelen / 512;
+       data.flags = rw ? MMC_DATA_WRITE : MMC_DATA_READ;
+       data.sg = &sg;
+       data.sg_len = 1;
+
+       cmd.opcode = MMC_CEATA_RW_MULTI_BLK;
+       cmd.arg = (rw << 31) | data.blocks;
+       cmd.flags = MMC_CMD_ADTC | (rw ? MMC_RSP_R1B : MMC_RSP_R1);
+
+       sg_init_one(&sg, buffer, bytelen);
+
+       mmc_set_data_timeout(&data, card);
+
+       mmc_wait_for_req(card->host, &mrq);
+
+       if (cmd.error)
+               return cmd.error;
+       if (data.error)
+               return data.error;
+
+       return 0;
+}
+
+/*
+ * Check the CEATA reset signature
+ */
+static int ceata_check_signature(struct mmc_card *card)
+{
+       u8      *buffer;
+       u8      reg_addr;
+       int     ret = 0;
+
+       ret = ceata_wait_until_ready(card);
+       if (ret)
+               return ret;
+
+       buffer = kzalloc(CEATA_TASKFILE_BYTELEN, GFP_KERNEL);
+       if (!buffer) {
+               printk(KERN_ERR "%s: could not allocate a buffer to hold "
+                       "the CE-ATA signature.\n", mmc_hostname(card->host));
+               return -ENOMEM;
+       }
+
+       reg_addr = 0;
+       ret = ceata_cmd60(card, 0, buffer, reg_addr, CEATA_TASKFILE_BYTELEN);
+       if (ret)
+               goto err;
+
+       if (buffer[12] != CEATA_SIGNATURE_BYTE_12 ||
+                       buffer[13] != CEATA_SIGNATURE_BYTE_13)
+               printk(KERN_WARNING "%s: device missing CE-ATA signature\n",
+                               mmc_hostname(card->host));
+
+err:
+       kfree(buffer);
+       return ret;
+}
+
+/*
+ * Retrieve device information and capabilities
+ */
+static int ceata_identify_dev(struct mmc_card *card)
+{
+       u8      *cmd_buf;
+       u32     *data_buf;
+       u8      reg_addr = 0;
+
+       struct  ceata_card_info *info;
+       struct  ceata_task *ptask;
+       int     ret = 0;
+
+       u16     *ptemp;
+
+       /* Issue identify_dev cmd through cmd 60 */
+       cmd_buf = kzalloc(CEATA_TASKFILE_BYTELEN, GFP_KERNEL);
+       data_buf = kzalloc(CEATA_IDENTIFY_DEV_BYTELEN, GFP_KERNEL);
+       if (!cmd_buf | !data_buf) {
+               printk(KERN_ERR "%s: could not allocate buffers to "
+                       "identify CE-ATA device.\n", mmc_hostname(card->host));
+               return -ENOMEM;
+       }
+
+       ptask = (struct ceata_task *)cmd_buf;
+       ptask->cmd_status = CEATA_CMD_IDENTIFY_DEV;
+
+       ret = ceata_wait_until_ready(card);
+       if (ret)
+               goto exit;
+
+       ret = ceata_cmd60(card, 1, cmd_buf, reg_addr, CEATA_TASKFILE_BYTELEN);
+       if (ret) {
+               printk(KERN_ERR "%s: Unable to send identify command to "
+                               "CE-ATA device\n", mmc_hostname(card->host));
+               goto exit;
+       }
+
+       ret = ceata_cmd61(card, 0, data_buf, CEATA_IDENTIFY_DEV_BYTELEN);
+       if (ret) {
+               printk(KERN_ERR "%s: Unable to receive identify data from "
+                              "CE-ATA device\n", mmc_hostname(card->host));
+               goto exit;
+       }
+
+       info = kzalloc(sizeof(*info), GFP_KERNEL);
+       if (!info) {
+               printk(KERN_ERR "%s: could not allocate a buffer to hold "
+                       "the CE-ATA dev info.\n", mmc_hostname(card->host));
+               return -ENOMEM;
+       }
+       card->ceata_info = info;
+
+       ptemp = (u16 *)data_buf;
+
+       memcpy(info->serialnum, ptemp + 10, 20);
+       info->serialnum[20] = 0;
+       memcpy(info->fw_ver, ptemp + 23, 8);
+       info->fw_ver[8] = 0;
+       memcpy(info->model_num, ptemp + 27, 40);
+       info->model_num[40] = 0;
+
+       info->major = ptemp[80];
+       info->max_lba[0] = data_buf[50];    /* units are 512-byte sectors */
+       info->max_lba[1] = data_buf[51];
+
+       info->seclen = ptemp[106]; /* power of 2 */
+
+       memcpy(info->global_id, ptemp + 108, 4);
+       info->features = ptemp[206];
+       info->max_writes = ptemp[207];
+
+       pr_debug("%s: CE-ATA identify device output:\n",
+                       mmc_hostname(card->host));
+       pr_debug(" serial: %s\n", info->serialnum);
+       pr_debug(" firmware: %s\n", info->fw_ver);
+       pr_debug(" model: %s\n", info->model_num);
+       pr_debug(" major = 0x%x, secsize = 0x%x, features = 0x%04x\n",
+                       info->major, info->seclen, info->features);
+       pr_debug(" max_writes = %d, max_lba = 0x%08x%08x\n",
+                       info->max_writes, info->max_lba[1], info->max_lba[0]);
+
+       BUG_ON(info->seclen >= 32);
+
+exit:
+       kfree(cmd_buf);
+       kfree(data_buf);
+
+       return ret;
+}
+
+static int ceata_sw_reset(struct mmc_card *card)
+{
+       int ret = 0;
+
+       mmc_fast_io(card, 1, CEATA_REG_CONTROL, NULL,
+                       CEATA_CONTROL_SRST | CEATA_CONTROL_NIEN);
+       mmc_fast_io(card, 1, CEATA_REG_CONTROL, NULL,
+                       ~CEATA_CONTROL_SRST | CEATA_CONTROL_NIEN);
+
+       ret = ceata_wait_until_ready(card);
+
+       return ret;
+}
+
+int ceata_flush_cache(struct mmc_card *card)
+{
+       u8      *cmd_buf;
+       u8      reg_addr = 0;
+
+       struct  ceata_task *ptask;
+       int     ret = 0;
+
+       cmd_buf = kzalloc(CEATA_TASKFILE_BYTELEN, GFP_KERNEL);
+       if (!cmd_buf) {
+               printk(KERN_ERR "%s: could not allocate a buffer for the "
+                       "flush cache command.\n", mmc_hostname(card->host));
+               return -ENOMEM;
+       }
+       ptask = (struct ceata_task *)cmd_buf;
+       ptask->cmd_status = CEATA_CMD_FLUSH_CACHE_EXT;
+
+       ret = ceata_wait_until_ready(card);
+       if (ret)
+               return ret;
+
+       ret = ceata_cmd60(card, 1, cmd_buf, reg_addr, CEATA_TASKFILE_BYTELEN);
+       if (ret)
+               printk(KERN_ERR "%s: Error issuing CE-ATA flush cache "
+                               "command\n", mmc_hostname(card->host));
+
+       return ret;
+}
+
+int ceata_init_card(struct mmc_card *card, struct device_type *type)
+{
+       int ret = 0;
+
+       card->type = MMC_TYPE_CEATA;
+
+#ifdef CONFIG_MRST_MMC_WR
+       ret = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+               EXT_CSD_BUS_WIDTH, EXT_CSD_BUS_WIDTH_1);
+       if (ret)
+               return ret;
+
+       mmc_set_bus_width(card->host, MMC_BUS_WIDTH_1);
+#endif
+
+       ret = mmc_switch(card, 0, EXT_CSD_CMD_SET, EXT_CSD_CMD_SET_CEATA);
+       if (ret)
+               return ret;
+
+       ret = ceata_sw_reset(card);
+       if (ret)
+               return ret;
+
+       ret = ceata_check_signature(card);
+       if (ret)
+               return ret;
+
+       ret = ceata_identify_dev(card);
+       if (ret)
+               return ret;
+
+       card->dev.type = type;
+
+       mmc_card_set_blockaddr(card);
+
+       return ret;
+}
+
+int ceata_read_write_cmd(struct mmc_card *card, int rw,
+       sector_t lba, u32 secs)
+{
+       u8      *cmd_buf, *plba;
+       u8      reg_addr = 0;
+       struct  ceata_task *ptask;
+       int     ret;
+
+
+       if (secs == 0) {
+               printk(KERN_ERR "%s: received a NULL length request\n",
+               mmc_hostname(card->host));
+               return -EINVAL;
+       }
+
+       ret = ceata_wait_until_ready(card);
+       if (ret)
+               return ret;
+
+       cmd_buf = kzalloc(CEATA_TASKFILE_BYTELEN, GFP_KERNEL);
+       if (!cmd_buf) {
+               printk(KERN_ERR "%s: could not allocate a buffer for the "
+                       "read/write dma command.\n", mmc_hostname(card->host));
+               return -ENOMEM;
+       }
+       ptask = (struct ceata_task *)cmd_buf;
+       ptask->cmd_status = rw ?
+               CEATA_CMD_WRITE_DMA_EXT :
+               CEATA_CMD_READ_DMA_EXT;
+       ptask->sec = (u8)(secs & 0xff);
+       ptask->sec_exp = (u8)(secs & 0xff00) >> 8;
+
+       plba = (u8 *)&lba;
+       ptask->lba_low      = plba[0];
+       ptask->lba_mid      = plba[1];
+       ptask->lba_high     = plba[2];
+       ptask->lba_low_exp  = plba[3];
+#ifdef CONFIG_LBD
+       ptask->lba_mid_exp  = plba[4];
+       ptask->lba_high_exp = plba[5];
+#endif
+
+       ret = ceata_cmd60(card, 1, cmd_buf, reg_addr, CEATA_TASKFILE_BYTELEN);
+       if (ret)
+               printk(KERN_ERR "%s: error during CE-ATA %s dma command\n",
+                               mmc_hostname(card->host),
+                               rw ? "write" : "read");
+
+       kfree(cmd_buf);
+       return ret;
+}
+EXPORT_SYMBOL_GPL(ceata_read_write_cmd);
diff --git a/drivers/mmc/core/ceata.h b/drivers/mmc/core/ceata.h
new file mode 100644
index 0000000..b685497
--- /dev/null
+++ b/drivers/mmc/core/ceata.h
@@ -0,0 +1,29 @@
+/*
+ * Intel MMC/SD/CEATA driver
+ * Copyright (C) 2008, Intel Corporation.
+ * Author: Li Jiebing (jiebing.li@intel.com)
+ *        Tang Feng  (feng.tang@intel.com)
+ *        Monroy German (german.monroy@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef _MMC_CORE_CEATA_H
+#define _MMC_CORE_CEATA_H
+
+int ceata_init_card(struct mmc_card *card, struct device_type *type);
+int ceata_flush_cache(struct mmc_card *card);
+
+#endif
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index fa073ab..2aa638d 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -248,6 +248,18 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
        unsigned int mult;

        /*
+        * CEATA hdds could take as long as 35 s in corner cases,
+        * according to at least one datasheet.
+        * TODO: implement longer timeout in SW, since max HW timeout
+        * is just ~2 s (2^27 / 48MHz)
+        */
+       if (mmc_card_ceata(card)) {
+               data->timeout_ns = 2000000000;
+               data->timeout_clks = 0;
+               return;
+       }
+
+       /*
         * SDIO cards only define an upper 1 s limit on access.
         */
        if (mmc_card_sdio(card)) {
@@ -715,8 +727,12 @@ static void mmc_power_up(struct mmc_host *host)
        /*
         * This delay must be at least 74 clock sizes, or 1 ms, or the
         * time required to reach a stable voltage.
+        *
+        * Three different CEATA hdds from Toshiba, Samsung
+        * and Hitachi fail when the delay is less than 20 ms, but
+        * work with 40 ms (doubling just in case).
         */
-       mmc_delay(2);
+       mmc_delay(80);
 }

 static void mmc_power_off(struct mmc_host *host)
@@ -870,6 +886,11 @@ void mmc_rescan(struct work_struct *work)
                mmc_power_up(host);
                mmc_go_idle(host);

+/*
+ * TOSHIBA HDD is supported by disabling SDIO device search. As TOSHIBA
+ * HDD pretends itself as a SDIO device and then initialization fails.
+ */
+#ifndef CONFIG_MMC_CEATA_WR
                mmc_send_if_cond(host, host->ocr_avail);

                /*
@@ -881,7 +902,7 @@ void mmc_rescan(struct work_struct *work)
                                mmc_power_off(host);
                        goto out;
                }
-
+#endif
                /*
                 * ...then normal SD...
                 */
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 06084db..6920fbd 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -19,6 +19,7 @@
 #include "core.h"
 #include "bus.h"
 #include "mmc_ops.h"
+#include "ceata.h"

 static const unsigned int tran_exp[] = {
        10000,          100000,         1000000,        10000000,
@@ -121,7 +122,7 @@ static int mmc_decode_csd(struct mmc_card *card)
         * v1.2 has extra information in bits 15, 11 and 10.
         */
        csd_struct = UNSTUFF_BITS(resp, 126, 2);
-       if (csd_struct != 1 && csd_struct != 2) {
+       if (csd_struct != 1 && csd_struct != 2 && csd_struct != 3) {
                printk(KERN_ERR "%s: unrecognised CSD structure version %d\n",
                        mmc_hostname(card->host), csd_struct);
                return -EINVAL;
@@ -241,6 +242,8 @@ static int mmc_read_ext_csd(struct mmc_card *card)
                goto out;
        }

+       card->ext_csd.s_cmd_set = ext_csd[EXT_CSD_S_CMD_SET];
+
 out:
        kfree(ext_csd);

@@ -285,6 +288,39 @@ static struct device_type mmc_type = {
        .groups = mmc_attr_groups,
 };

+MMC_DEV_ATTR(capacity, "%d KB\n", card->ceata_info->max_lba[0] / 2);
+MMC_DEV_ATTR(seclen, "%d bytes\n", 1 << card->ceata_info->seclen);
+MMC_DEV_ATTR(globalid, "%08x%08x\n", card->ceata_info->global_id[1],
+       card->ceata_info->global_id[0]);
+MMC_DEV_ATTR(serial2, "%s\n", card->ceata_info->serialnum);
+MMC_DEV_ATTR(fwrev2, "%s\n", card->ceata_info->fw_ver);
+MMC_DEV_ATTR(model, "%s\n", card->ceata_info->model_num);
+
+
+static struct attribute *mmc_ceata_attrs[] = {
+       &dev_attr_capacity.attr,
+       &dev_attr_seclen.attr,
+       &dev_attr_globalid.attr,
+       &dev_attr_serial2.attr,
+       &dev_attr_fwrev2.attr,
+       &dev_attr_model.attr,
+       NULL,
+};
+
+static struct attribute_group mmc_ceata_attr_group = {
+       .attrs = mmc_ceata_attrs,
+};
+
+static struct attribute_group *ceata_attr_groups[] = {
+       &mmc_std_attr_group,
+       &mmc_ceata_attr_group,
+       NULL,
+};
+
+static struct device_type ceata_type = {
+       .groups = ceata_attr_groups,
+};
+
 /*
  * Handle the detection and initialisation of a card.
  *
@@ -401,6 +437,11 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
                        goto free_card;
        }

+/*
+ * temporaily avoid MMC cards to switch to HS timing
+ * which doesn't work yet due to existing Silicon bug
+ */
+#ifndef CONFIG_MRST_MMC_WR
        /*
         * Activate high speed (if supported)
         */
@@ -415,7 +456,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,

                mmc_set_timing(card->host, MMC_TIMING_MMC_HS);
        }
-
+#endif
        /*
         * Compute bus speed.
         */
@@ -454,6 +495,15 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
                mmc_set_bus_width(card->host, bus_width);
        }

+       /*
+        * CEATA hdds are a subset of MMC cards
+        */
+       if (card->ext_csd.s_cmd_set & EXT_CSD_CMD_SET_CEATA) {
+               err = ceata_init_card(card, &ceata_type);
+               if (err)
+                       goto free_card;
+       }
+
        if (!oldcard)
                host->card = card;

@@ -518,6 +568,8 @@ static void mmc_suspend(struct mmc_host *host)
        BUG_ON(!host->card);

        mmc_claim_host(host);
+       if (mmc_card_ceata(host->card))
+               ceata_flush_cache(host->card);
        if (!mmc_host_is_spi(host))
                mmc_deselect_cards(host);
        host->card->state &= ~MMC_STATE_HIGHSPEED;
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 34ce270..64906e4 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -402,3 +402,36 @@ int mmc_send_status(struct mmc_card *card, u32 *status)
        return 0;
 }

+/*
+ * use to issue FAST_IO cmd
+ * READ: pdata points to buffer to receive data
+ * WRITE: data contains the data to be written to the card
+ * rw: 0 for read, 1 for write
+ */
+int mmc_fast_io(struct mmc_card *card, u8 rw, u8 reg_addr, u8 *read, u8 write)
+{
+       int err;
+       struct mmc_command cmd;
+
+       BUG_ON(!card);
+       BUG_ON(!card->host);
+       WARN_ON(reg_addr >= 128);   /* reg_addr only contains 7 bits */
+
+       memset(&cmd, 0, sizeof(struct mmc_command));
+
+       cmd.opcode = MMC_FAST_IO;
+       cmd.arg = (card->rca << 16) |
+               (rw << 15)|
+               (reg_addr << 8) | write;
+       cmd.flags = MMC_RSP_R4 | MMC_CMD_AC;
+
+       err = mmc_wait_for_cmd(card->host, &cmd, MMC_CMD_RETRIES);
+       if (err)
+               return err;
+
+       if ((!rw) && read)
+               *read = cmd.resp[0];
+
+       return 0;
+}
+
diff --git a/drivers/mmc/core/mmc_ops.h b/drivers/mmc/core/mmc_ops.h
index 17854bf..af584f6 100644
--- a/drivers/mmc/core/mmc_ops.h
+++ b/drivers/mmc/core/mmc_ops.h
@@ -25,6 +25,6 @@ int mmc_send_status(struct mmc_card *card, u32 *status);
 int mmc_send_cid(struct mmc_host *host, u32 *cid);
 int mmc_spi_read_ocr(struct mmc_host *host, int highcap, u32 *ocrp);
 int mmc_spi_set_crc(struct mmc_host *host, int use_crc);
-
+int mmc_fast_io(struct mmc_card *card, u8 rw, u8 reg_addr, u8 *read, u8 write);
 #endif

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index cd81c39..56336ce 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -234,6 +234,7 @@ out:
        return err;
 }

+#ifndef CONFIG_MRST_MMC_WR
 /*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
@@ -281,6 +282,7 @@ out:

        return err;
 }
+#endif

 MMC_DEV_ATTR(cid, "%08x%08x%08x%08x\n", card->raw_cid[0], card->raw_cid[1],
        card->raw_cid[2], card->raw_cid[3]);
@@ -460,12 +462,18 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
                        goto free_card;
        }

+/*
+ * temporarily avoiding SD cards to switch to HS timing
+ * which doesn't work yet due to existing Silicon bug
+ */
+#ifndef CONFIG_MRST_MMC_WR
        /*
         * Attempt to change to high-speed (if supported)
         */
        err = mmc_switch_hs(card);
        if (err)
                goto free_card;
+#endif

        /*
         * Compute bus speed.
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index fb99ccf..3f31f67 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -164,6 +164,7 @@ static int sdio_enable_wide(struct mmc_card *card)
        return 0;
 }

+#ifndef CONFIG_MRST_MMC_WR
 /*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
@@ -193,6 +194,7 @@ static int sdio_enable_hs(struct mmc_card *card)

        return 0;
 }
+#endif

 /*
  * Host is being removed. Free up the current card.
@@ -362,6 +364,11 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
        if (err)
                goto remove;

+/*
+ * temporarily avoiding SDIO cards to switch to HS timing
+ * which doesn't work yet due to existing Silicon bug
+ */
+#ifndef CONFIG_MRST_MMC_WR
        /*
         * Switch to high-speed (if supported).
         */
@@ -383,6 +390,12 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
        } else {
                mmc_set_clock(host, card->cis.max_dtr);
        }
+#else
+       if (card->cis.max_dtr > 24000000)
+               card->cis.max_dtr = 24000000;
+
+       mmc_set_clock(host, card->cis.max_dtr);
+#endif

        /*
         * Switch to wider bus (if supported).
diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index cd37962..312ec69 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -284,6 +284,13 @@ static const struct sdhci_pci_fixes sdhci_jmicron = {
        .resume         = jmicron_resume,
 };

+/*
+ * ADMA operation is disabled for Moorestown platform.
+ */
+static const struct sdhci_pci_fixes sdhci_intel_mrst = {
+       .quirks         = SDHCI_QUIRK_BROKEN_ADMA,
+};
+
 static const struct pci_device_id pci_ids[] __devinitdata = {
        {
                .vendor         = PCI_VENDOR_ID_RICOH,
@@ -349,6 +356,22 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
                .driver_data    = (kernel_ulong_t)&sdhci_jmicron,
        },

+       {
+               .vendor         = PCI_VENDOR_ID_INTEL,
+               .device         = PCI_DEVICE_ID_INTEL_MRST_SD0,
+               .subvendor      = PCI_ANY_ID,
+               .subdevice      = PCI_ANY_ID,
+               .driver_data    = (kernel_ulong_t)&sdhci_intel_mrst,
+       },
+
+       {
+               .vendor         = PCI_VENDOR_ID_INTEL,
+               .device         = PCI_DEVICE_ID_INTEL_MRST_SD1,
+               .subvendor      = PCI_ANY_ID,
+               .subdevice      = PCI_ANY_ID,
+               .driver_data    = (kernel_ulong_t)&sdhci_intel_mrst,
+       },
+
        {       /* Generic SD host controller */
                PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
        },
@@ -614,22 +637,40 @@ static int __devinit sdhci_pci_probe(struct pci_dev *pdev,
        dev_info(&pdev->dev, "SDHCI controller found [%04x:%04x] (rev %x)\n",
                 (int)pdev->vendor, (int)pdev->device, (int)rev);

-       ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &slots);
-       if (ret)
-               return ret;
+       /*
+        * slots number is fixed to 2 by Moorestown architecture
+        */
+       if (pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD0 ||
+               pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD1) {
+               slots = 1;
+       } else {
+               ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &slots);
+
+               if (ret)
+                       return ret;
+
+               slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
+       }

-       slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
        dev_dbg(&pdev->dev, "found %d slot(s)\n", slots);
        if (slots == 0)
                return -ENODEV;

        BUG_ON(slots > MAX_SLOTS);

-       ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &first_bar);
-       if (ret)
-               return ret;
+       /*
+        * first BAR is fixed to 0 by Moorestown architecture
+        */
+       if (pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD0 ||
+               pdev->device == PCI_DEVICE_ID_INTEL_MRST_SD1) {
+               first_bar = 0;
+       } else {
+               ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &first_bar);
+               if (ret)
+                       return ret;

-       first_bar &= PCI_SLOT_INFO_FIRST_BAR_MASK;
+               first_bar &= PCI_SLOT_INFO_FIRST_BAR_MASK;
+       }

        if (first_bar > 5) {
                dev_err(&pdev->dev, "Invalid first BAR. Aborting.\n");
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9234be2..a2804f1 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1123,12 +1123,18 @@ static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)

        ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);

-       if (ios->bus_width == MMC_BUS_WIDTH_4)
+       if (ios->bus_width == MMC_BUS_WIDTH_8) {
+               ctrl |= SDHCI_CTRL_8BITBUS;
                ctrl |= SDHCI_CTRL_4BITBUS;
-       else
+       } else if (ios->bus_width == MMC_BUS_WIDTH_4) {
+               ctrl &= ~SDHCI_CTRL_8BITBUS;
+               ctrl |= SDHCI_CTRL_4BITBUS;
+       } else {
+               ctrl &= ~SDHCI_CTRL_8BITBUS;
                ctrl &= ~SDHCI_CTRL_4BITBUS;
+       }

-       if (ios->timing == MMC_TIMING_SD_HS)
+       if (ios->timing == MMC_TIMING_SD_HS || ios->timing == MMC_TIMING_MMC_HS)
                ctrl |= SDHCI_CTRL_HISPD;
        else
                ctrl &= ~SDHCI_CTRL_HISPD;
@@ -1724,7 +1730,7 @@ int sdhci_add_host(struct sdhci_host *host)
        mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;

        if (caps & SDHCI_CAN_DO_HISPD)
-               mmc->caps |= MMC_CAP_SD_HIGHSPEED;
+               mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;

        if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
                mmc->caps |= MMC_CAP_NEEDS_POLL;
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index f20a834..fa87b8b 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -65,6 +65,7 @@
 #define  SDHCI_CTRL_LED                0x01
 #define  SDHCI_CTRL_4BITBUS    0x02
 #define  SDHCI_CTRL_HISPD      0x04
+#define  SDHCI_CTRL_8BITBUS    0x20
 #define  SDHCI_CTRL_DMA_MASK   0x18
 #define   SDHCI_CTRL_SDMA      0x00
 #define   SDHCI_CTRL_ADMA1     0x08
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 403aa50..e5d8a9e 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -42,6 +42,7 @@ struct mmc_csd {
 struct mmc_ext_csd {
        unsigned int            hs_max_dtr;
        unsigned int            sectors;
+       unsigned char           s_cmd_set;
 };

 struct sd_scr {
@@ -72,6 +73,19 @@ struct sdio_cis {
        unsigned int            max_dtr;
 };

+struct ceata_card_info {
+       u8  serialnum[21];
+       u8  fw_ver[9];
+       u8  model_num[41];
+       u16 major;
+       u16 seclen;         /* power of 2, 12 means 4096 */
+       u32 max_lba[2];
+       u32 global_id[2];
+       u16 features;
+       u16 max_writes;
+       u16 integrity;
+};
+
 struct mmc_host;
 struct sdio_func;
 struct sdio_func_tuple;
@@ -89,6 +103,7 @@ struct mmc_card {
 #define MMC_TYPE_MMC           0               /* MMC card */
 #define MMC_TYPE_SD            1               /* SD card */
 #define MMC_TYPE_SDIO          2               /* SDIO card */
+#define MMC_TYPE_CEATA         3               /* CEATA card */
        unsigned int            state;          /* (our) card state */
 #define MMC_STATE_PRESENT      (1<<0)          /* present in sysfs */
 #define MMC_STATE_READONLY     (1<<1)          /* card is read-only */
@@ -104,6 +119,10 @@ struct mmc_card {
        struct sd_scr           scr;            /* extra SD information */
        struct sd_switch_caps   sw_caps;        /* switch (CMD6) caps */

+       /* ceata info */
+       struct ceata_card_info  *ceata_info;
+
+       /* sdio related info */
        unsigned int            sdio_funcs;     /* number of SDIO functions */
        struct sdio_cccr        cccr;           /* common card info */
        struct sdio_cis         cis;            /* common tuple info */
@@ -118,6 +137,7 @@ struct mmc_card {
 #define mmc_card_mmc(c)                ((c)->type == MMC_TYPE_MMC)
 #define mmc_card_sd(c)         ((c)->type == MMC_TYPE_SD)
 #define mmc_card_sdio(c)       ((c)->type == MMC_TYPE_SDIO)
+#define mmc_card_ceata(c)      ((c)->type == MMC_TYPE_CEATA)

 #define mmc_card_present(c)    ((c)->state & MMC_STATE_PRESENT)
 #define mmc_card_readonly(c)   ((c)->state & MMC_STATE_READONLY)
@@ -136,6 +156,12 @@ struct mmc_card {
 #define mmc_get_drvdata(c)     dev_get_drvdata(&(c)->dev)
 #define mmc_set_drvdata(c,d)   dev_set_drvdata(&(c)->dev, d)

+/**
+ * CE-ATA taskfile access
+ */
+extern int ceata_read_write_cmd(struct mmc_card *card, int rw,
+       sector_t lba, u32 secs);
+
 /*
  * MMC device driver (e.g., Flash card, I/O card...)
  */
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 14b81f3..399e195 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -254,6 +254,8 @@ struct _mmc_csd {
 #define EXT_CSD_CARD_TYPE      196     /* RO */
 #define EXT_CSD_REV            192     /* RO */
 #define EXT_CSD_SEC_CNT                212     /* RO, 4 bytes */
+#define EXT_CSD_CMD_SET                191     /* RW */
+#define EXT_CSD_S_CMD_SET      504     /* RO */

 /*
  * EXT_CSD field definitions
@@ -262,6 +264,8 @@ struct _mmc_csd {
 #define EXT_CSD_CMD_SET_NORMAL         (1<<0)
 #define EXT_CSD_CMD_SET_SECURE         (1<<1)
 #define EXT_CSD_CMD_SET_CPSECURE       (1<<2)
+#define EXT_CSD_CMD_SET_SECURE_2_0     (1<<3)
+#define EXT_CSD_CMD_SET_CEATA          (1<<4)

 #define EXT_CSD_CARD_TYPE_26   (1<<0)  /* Card can run at 26MHz */
 #define EXT_CSD_CARD_TYPE_52   (1<<1)  /* Card can run at 52MHz */
@@ -279,5 +283,112 @@ struct _mmc_csd {
 #define MMC_SWITCH_MODE_CLEAR_BITS     0x02    /* Clear bits which are 1 in value */
 #define MMC_SWITCH_MODE_WRITE_BYTE     0x03    /* Set target to value */

+struct ceata_task {
+       u8  resv1;
+       u8  fexp;       /* feature exp */
+       u8  sec_exp;
+       u8  lba_low_exp;
+       u8  lba_mid_exp;
+       u8  lba_high_exp;
+       u8  control;
+       u8  resv2[2];
+       u8  feature_err;
+       u8  sec;
+       u8  lba_low;
+       u8  lba_mid;
+       u8  lba_high;
+       u8  dev_head;
+       u8  cmd_status;
+} __attribute__((packed));
+
+/*
+ * CE-ATA MMC commands
+ */
+
+#define MMC_CEATA_RW_MULTI_REG         60 /* adtc     R1/R1b for R/W */
+#define MMC_CEATA_RW_MULTI_BLK         61 /* adtc     R1/R1b for R/W */
+
+/*
+ * CE-ATA definitions
+ */
+#define CEATA_SIGNATURE_BYTE_12                0xCE
+#define CEATA_SIGNATURE_BYTE_13                0xAA
+
+#define CEATA_TASKFILE_BYTELEN         16
+#define CEATA_IDENTIFY_DEV_BYTELEN     512
+
+/*
+ * CE-ATA registers
+ */
+#define CEATA_REG_FEATURES_EXP         1
+#define CEATA_REG_SEC_COUNT_EXP                2
+#define CEATA_REG_LBALOW_EXP           3
+#define CEATA_REG_LBAMID_EXP           4
+#define CEATA_REG_LBAHIGH_EXP          5
+#define CEATA_REG_CONTROL              6
+#define CEATA_REG_FEATURES             9   /* write */
+#define CEATA_REG_ERROR                        9   /* read */
+#define CEATA_REG_SEC_COUNT            10
+#define CEATA_REG_LBALOW               11
+#define CEATA_REG_LBAMID               12
+#define CEATA_REG_LBAHIGH              13
+#define CEATA_REG_DEVICE_HEAD          14
+#define CEATA_REG_CMD                  15  /* write */
+#define CEATA_REG_STATUS               15  /* read */
+
+/*
+ * CE-ATA register fields
+ */
+#define CEATA_STATUS_BSY               (1<<7)  /* Busy */
+#define CEATA_STATUS_DRDY              (1<<6)  /* Device Ready */
+#define CEATA_STATUS_DRQ               (1<<3)  /* Data Request */
+#define CEATA_STATUS_ERR               (1<<0)  /* Error */
+
+#define CEATA_ERROR_ICRC               (1<<7)  /* Interface CRC error (w) */
+#define CEATA_ERROR_UNC                (1<<6)  /* Uncorrectable data error (r) */
+#define CEATA_ERROR_IDNF               (1<<4)  /* ID (sector) not found */
+#define CEATA_ERROR_ABRT               (1<<2)  /* Aborted Command */
+
+#define CEATA_CONTROL_SRST             (1<<2)  /* ATA software reset */
+#define CEATA_CONTROL_NIEN             (1<<1)  /* Neg cmd comp int enable */
+
+/*
+ * CE-ATA commands
+ */
+#define CEATA_CMD_IDENTIFY_DEV         0xec    /* data in */
+#define CEATA_CMD_READ_DMA_EXT         0x25    /* data in */
+#define CEATA_CMD_WRITE_DMA_EXT                0x35    /* data out */
+#define CEATA_CMD_STANDBY_IMME         0xe0    /* No data */
+#define CEATA_CMD_FLUSH_CACHE_EXT      0xea    /* No data */
+
+/*
+ * CE-ATA status and control registers
+ *  M = mandatory   O = optional
+ *  RO = read-only  RW = read-write
+ */
+#define CEATA_REG_SCRTEMPC             0x80    /* O, RO */
+#define CEATA_REG_SCRTEMPMAXP          0x84    /* O, RO */
+#define CEATA_REG_SCRTEMPMINP          0x88    /* O, RO */
+#define CEATA_REG_SCRSTATUS            0x8C    /* O, RO */
+#define CEATA_REG_SCRREALLOCSA         0x90    /* O, RO */
+#define CEATA_REG_SCRERETRACTSA                0x94    /* O, RO */
+#define CEATA_REG_SCRCAPABILITIES      0x98    /* M, RO */
+#define CEATA_REG_SCRCONTROL           0xC0    /* M, RW */
+
+/*
+ * Identify Device data structure.  16-bit word addresses
+ */
+#define CEATA_CAP_SERIAL_NUMBER                10  /* 20 B */
+#define CEATA_CAP_FIRMWARE_REV         23  /* 8 B */
+#define CEATA_CAP_MODEL_NUMBER         27  /* 40 B */
+#define CEATA_CAP_MAJOR_VER            80
+#define CEATA_CAP_MAX_LBA              100 /* 4 B */
+#define CEATA_CAP_SECTOR_SIZE          106
+#define CEATA_CAP_GLOBAL_UNIQUE_ID     108 /* optional, 4 B */
+#define CEATA_CAP_FEATURES             206
+#define CEATA_CAP_MAX_WRITE_PER_ADDR   207 /* optional */
+#define CEATA_CAP_INTEGRITY_WORD       255
+
+
 #endif  /* MMC_MMC_PROTOCOL_H */

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
