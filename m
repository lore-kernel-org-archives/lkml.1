Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbXJ3QR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbXJ3QR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXJ3QOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:14:14 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45386 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbXJ3QOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:14:05 -0400
Date: Tue, 30 Oct 2007 17:13:50 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.23-mm1] Change the ida/idr_pre_get() return value to
 follow the kernel convention
Message-Id: <20071030171350.cd25b87c.pierre.peiffer@bull.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 30/10/2007 17:20:46,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 30/10/2007 17:20:47,
	Serialize complete at 30/10/2007 17:20:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ida_pre_get() and idr_pre_get() currently return 0 in case of error, and 1
in case of success, what is not the conventional way to handle error cases.

This patch makes both of them return 0 in case of success, and an errcode
otherwise, and then it changes each caller to let them return the error
reported instead of ENOMEM. This avoids to the callers to make any assumption
about the cause of the error.

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
---

 arch/powerpc/mm/mmu_context_64.c           |    5 +++--
 block/bsg.c                                |    4 +---
 drivers/char/drm/drm_context.c             |    5 +++--
 drivers/char/drm/drm_drawable.c            |    5 +++--
 drivers/char/tty_io.c                      |    5 +++--
 drivers/dca/dca-sysfs.c                    |    7 ++++---
 drivers/firewire/fw-device.c               |    4 ++--
 drivers/hwmon/hwmon.c                      |    5 +++--
 drivers/i2c/i2c-core.c                     |   10 ++++++----
 drivers/infiniband/core/cm.c               |    3 ++-
 drivers/infiniband/core/cma.c              |    4 ++--
 drivers/infiniband/core/sa_query.c         |    5 +++--
 drivers/infiniband/core/ucm.c              |    2 +-
 drivers/infiniband/core/ucma.c             |    4 ++--
 drivers/infiniband/core/uverbs_cmd.c       |    5 +++--
 drivers/infiniband/hw/amso1100/c2_qp.c     |    2 +-
 drivers/infiniband/hw/cxgb3/iwch.h         |    7 ++++---
 drivers/infiniband/hw/ehca/ehca_cq.c       |    5 +++--
 drivers/infiniband/hw/ehca/ehca_qp.c       |    4 ++--
 drivers/infiniband/hw/ipath/ipath_driver.c |   10 +++++-----
 drivers/md/dm.c                            |    8 ++++----
 drivers/misc/tifm_core.c                   |    5 +++--
 drivers/mmc/core/host.c                    |    5 +++--
 drivers/rtc/class.c                        |    5 ++---
 drivers/scsi/lpfc/lpfc_init.c              |    2 +-
 drivers/scsi/sd.c                          |    2 +-
 drivers/scsi/sg.c                          |    4 ++--
 drivers/uio/uio.c                          |    5 +++--
 drivers/usb/core/endpoint.c                |    5 +++--
 drivers/video/display/display-sysfs.c      |    2 +-
 drivers/w1/slaves/w1_ds2760.c              |    4 ++--
 fs/dlm/lowcomms.c                          |    2 +-
 fs/inotify.c                               |    2 +-
 fs/ocfs2/cluster/tcp.c                     |    6 +++---
 fs/proc/generic.c                          |    2 +-
 fs/super.c                                 |    5 +++--
 fs/sysfs/dir.c                             |    4 ++--
 ipc/util.c                                 |    6 ++----
 kernel/posix-timers.c                      |    2 +-
 lib/idr.c                                  |   20 ++++++++++----------
 net/9p/util.c                              |    2 +-
 net/sctp/associola.c                       |    5 +++--
 42 files changed, 109 insertions(+), 95 deletions(-)

Index: b/arch/powerpc/mm/mmu_context_64.c
===================================================================
--- a/arch/powerpc/mm/mmu_context_64.c
+++ b/arch/powerpc/mm/mmu_context_64.c
@@ -30,8 +30,9 @@ int init_new_context(struct task_struct 
 	int err;
 
 again:
-	if (!idr_pre_get(&mmu_context_idr, GFP_KERNEL))
-		return -ENOMEM;
+	err = idr_pre_get(&mmu_context_idr, GFP_KERNEL);
+	if (err)
+		return err;
 
 	spin_lock(&mmu_context_lock);
 	err = idr_get_new_above(&mmu_context_idr, NULL, 1, &index);
Index: b/block/bsg.c
===================================================================
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -962,10 +962,8 @@ int bsg_register_queue(struct request_qu
 	mutex_lock(&bsg_mutex);
 
 	ret = idr_pre_get(&bsg_minor_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
+	if (ret)
 		goto unlock;
-	}
 
 	ret = idr_get_new(&bsg_minor_idr, bcd, &minor);
 	if (ret < 0)
Index: b/drivers/char/drm/drm_context.c
===================================================================
--- a/drivers/char/drm/drm_context.c
+++ b/drivers/char/drm/drm_context.c
@@ -78,9 +78,10 @@ static int drm_ctxbitmap_next(struct drm
 	int ret;
 
 again:
-	if (idr_pre_get(&dev->ctx_idr, GFP_KERNEL) == 0) {
+	ret = idr_pre_get(&dev->ctx_idr, GFP_KERNEL);
+	if (ret) {
 		DRM_ERROR("Out of memory expanding drawable idr\n");
-		return -ENOMEM;
+		return ret;
 	}
 	mutex_lock(&dev->struct_mutex);
 	ret = idr_get_new_above(&dev->ctx_idr, NULL,
Index: b/drivers/char/drm/drm_drawable.c
===================================================================
--- a/drivers/char/drm/drm_drawable.c
+++ b/drivers/char/drm/drm_drawable.c
@@ -48,9 +48,10 @@ int drm_adddraw(struct drm_device *dev, 
 	int ret;
 
 again:
-	if (idr_pre_get(&dev->drw_idr, GFP_KERNEL) == 0) {
+	ret = idr_pre_get(&dev->drw_idr, GFP_KERNEL);
+	if (ret) {
 		DRM_ERROR("Out of memory expanding drawable idr\n");
-		return -ENOMEM;
+		return ret;
 	}
 
 	spin_lock_irqsave(&dev->drw_lock, irqflags);
Index: b/drivers/char/tty_io.c
===================================================================
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2738,9 +2738,10 @@ static int ptmx_open(struct inode * inod
 
 	/* find a device that is not in use. */
 	down(&allocated_ptys_lock);
-	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
+	retval = idr_pre_get(&allocated_ptys, GFP_KERNEL);
+	if (retval) {
 		up(&allocated_ptys_lock);
-		return -ENOMEM;
+		return retval;
 	}
 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
 	if (idr_ret < 0) {
Index: b/drivers/dca/dca-sysfs.c
===================================================================
--- a/drivers/dca/dca-sysfs.c
+++ b/drivers/dca/dca-sysfs.c
@@ -29,11 +29,12 @@ void dca_sysfs_remove_req(struct dca_pro
 int dca_sysfs_add_provider(struct dca_provider *dca, struct device *dev)
 {
 	struct class_device *cd;
-	int err = 0;
+	int err ;
 
 idr_try_again:
-	if (!idr_pre_get(&dca_idr, GFP_KERNEL))
-		return -ENOMEM;
+	err = idr_pre_get(&dca_idr, GFP_KERNEL);
+	if (err)
+		return err;
 	spin_lock(&dca_idr_lock);
 	err = idr_get_new(&dca_idr, dca, &dca->id);
 	spin_unlock(&dca_idr_lock);
Index: b/drivers/firewire/fw-device.c
===================================================================
--- a/drivers/firewire/fw-device.c
+++ b/drivers/firewire/fw-device.c
@@ -662,9 +662,9 @@ static void fw_device_init(struct work_s
 		return;
 	}
 
-	err = -ENOMEM;
 	down_write(&idr_rwsem);
-	if (idr_pre_get(&fw_device_idr, GFP_KERNEL))
+	err = idr_pre_get(&fw_device_idr, GFP_KERNEL);
+	if (err == 0)
 		err = idr_get_new(&fw_device_idr, device, &minor);
 	up_write(&idr_rwsem);
 	if (err < 0)
Index: b/drivers/hwmon/hwmon.c
===================================================================
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -42,8 +42,9 @@ struct device *hwmon_device_register(str
 	int id, err;
 
 again:
-	if (unlikely(idr_pre_get(&hwmon_idr, GFP_KERNEL) == 0))
-		return ERR_PTR(-ENOMEM);
+	err = idr_pre_get(&hwmon_idr, GFP_KERNEL);
+	if (unlikely(err))
+		return ERR_PTR(err);
 
 	spin_lock(&idr_lock);
 	err = idr_get_new(&hwmon_idr, NULL, &id);
Index: b/drivers/i2c/i2c-core.c
===================================================================
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -391,8 +391,9 @@ int i2c_add_adapter(struct i2c_adapter *
 	int	id, res = 0;
 
 retry:
-	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
+	res = idr_pre_get(&i2c_adapter_idr, GFP_KERNEL);
+	if (res)
+		return res;
 
 	mutex_lock(&core_lists);
 	/* "above" here means "above or equal to", sigh */
@@ -440,8 +441,9 @@ int i2c_add_numbered_adapter(struct i2c_
 		return -EINVAL;
 
 retry:
-	if (idr_pre_get(&i2c_adapter_idr, GFP_KERNEL) == 0)
-		return -ENOMEM;
+	status = idr_pre_get(&i2c_adapter_idr, GFP_KERNEL);
+	if (status)
+		return status;
 
 	mutex_lock(&core_lists);
 	/* "above" here means "above or equal to", sigh;
Index: b/drivers/infiniband/core/cm.c
===================================================================
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -312,7 +312,8 @@ static int cm_alloc_id(struct cm_id_priv
 		if (!ret)
 			next_id = ((unsigned) id + 1) & MAX_ID_MASK;
 		spin_unlock_irqrestore(&cm.lock, flags);
-	} while( (ret == -EAGAIN) && idr_pre_get(&cm.local_id_table, GFP_KERNEL) );
+	} while ((ret == -EAGAIN) &&
+		 !idr_pre_get(&cm.local_id_table, GFP_KERNEL));
 
 	cm_id_priv->id.local_id = (__force __be32) (id ^ cm.random_id_operand);
 	return ret;
Index: b/drivers/infiniband/core/cma.c
===================================================================
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1868,7 +1868,7 @@ static int cma_alloc_port(struct idr *ps
 
 	do {
 		ret = idr_get_new_above(ps, bind_list, snum, &port);
-	} while ((ret == -EAGAIN) && idr_pre_get(ps, GFP_KERNEL));
+	} while ((ret == -EAGAIN) && !idr_pre_get(ps, GFP_KERNEL));
 
 	if (ret)
 		goto err1;
@@ -1901,7 +1901,7 @@ static int cma_alloc_any_port(struct idr
 retry:
 	do {
 		ret = idr_get_new_above(ps, bind_list, next_port, &port);
-	} while ((ret == -EAGAIN) && idr_pre_get(ps, GFP_KERNEL));
+	} while ((ret == -EAGAIN) && !idr_pre_get(ps, GFP_KERNEL));
 
 	if (ret)
 		goto err1;
Index: b/drivers/infiniband/core/sa_query.c
===================================================================
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -565,8 +565,9 @@ static int send_mad(struct ib_sa_query *
 	int ret, id;
 
 retry:
-	if (!idr_pre_get(&query_idr, gfp_mask))
-		return -ENOMEM;
+	ret = idr_pre_get(&query_idr, gfp_mask);
+	if (ret)
+		return ret;
 	spin_lock_irqsave(&idr_lock, flags);
 	ret = idr_get_new(&query_idr, query, &id);
 	spin_unlock_irqrestore(&idr_lock, flags);
Index: b/drivers/infiniband/core/ucm.c
===================================================================
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -189,7 +189,7 @@ static struct ib_ucm_context *ib_ucm_ctx
 
 	do {
 		result = idr_pre_get(&ctx_id_table, GFP_KERNEL);
-		if (!result)
+		if (result)
 			goto error;
 
 		mutex_lock(&ctx_id_mutex);
Index: b/drivers/infiniband/core/ucma.c
===================================================================
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -144,7 +144,7 @@ static struct ucma_context *ucma_alloc_c
 
 	do {
 		ret = idr_pre_get(&ctx_idr, GFP_KERNEL);
-		if (!ret)
+		if (ret)
 			goto error;
 
 		mutex_lock(&mut);
@@ -174,7 +174,7 @@ static struct ucma_multicast* ucma_alloc
 
 	do {
 		ret = idr_pre_get(&multicast_idr, GFP_KERNEL);
-		if (!ret)
+		if (ret)
 			goto error;
 
 		mutex_lock(&mut);
Index: b/drivers/infiniband/core/uverbs_cmd.c
===================================================================
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -120,8 +120,9 @@ static int idr_add_uobj(struct idr *idr,
 	int ret;
 
 retry:
-	if (!idr_pre_get(idr, GFP_KERNEL))
-		return -ENOMEM;
+	ret = idr_pre_get(idr, GFP_KERNEL);
+	if (ret)
+		return ret;
 
 	spin_lock(&ib_uverbs_idr_lock);
 	ret = idr_get_new(idr, uobj, &uobj->id);
Index: b/drivers/infiniband/hw/amso1100/c2_qp.c
===================================================================
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -387,7 +387,7 @@ static int c2_alloc_qpn(struct c2_dev *c
 					c2dev->qp_table.last++, &qp->qpn);
 		spin_unlock_irq(&c2dev->qp_table.lock);
         } while ((ret == -EAGAIN) &&
-	 	 idr_pre_get(&c2dev->qp_table.idr, GFP_KERNEL));
+		 !idr_pre_get(&c2dev->qp_table.idr, GFP_KERNEL));
 	return ret;
 }
 
Index: b/drivers/infiniband/hw/cxgb3/iwch.h
===================================================================
--- a/drivers/infiniband/hw/cxgb3/iwch.h
+++ b/drivers/infiniband/hw/cxgb3/iwch.h
@@ -150,9 +150,10 @@ static inline int insert_handle(struct i
 	u32 newid;
 
 	do {
-		if (!idr_pre_get(idr, GFP_KERNEL)) {
-			return -ENOMEM;
-		}
+		ret = idr_pre_get(idr, GFP_KERNEL);
+		if (ret)
+			return ret;
+
 		spin_lock_irq(&rhp->lock);
 		ret = idr_get_new_above(idr, handle, id, &newid);
 		BUG_ON(newid != id);
Index: b/drivers/infiniband/hw/ehca/ehca_cq.c
===================================================================
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -156,8 +156,9 @@ struct ib_cq *ehca_create_cq(struct ib_d
 	param.eq_handle = shca->eq.ipz_eq_handle;
 
 	do {
-		if (!idr_pre_get(&ehca_cq_idr, GFP_KERNEL)) {
-			cq = ERR_PTR(-ENOMEM);
+		ret = idr_pre_get(&ehca_cq_idr, GFP_KERNEL);
+		if (ret) {
+			cq = ERR_PTR(ret);
 			ehca_err(device, "Can't reserve idr nr. device=%p",
 				 device);
 			goto create_cq_exit1;
Index: b/drivers/infiniband/hw/ehca/ehca_qp.c
===================================================================
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -560,8 +560,8 @@ static struct ehca_qp *internal_create_q
 			container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
 
 	do {
-		if (!idr_pre_get(&ehca_qp_idr, GFP_KERNEL)) {
-			ret = -ENOMEM;
+		ret = idr_pre_get(&ehca_qp_idr, GFP_KERNEL);
+		if (ret) {
 			ehca_err(pd->device, "Can't reserve idr resources.");
 			goto create_qp_exit0;
 		}
Index: b/drivers/infiniband/hw/ipath/ipath_driver.c
===================================================================
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -176,8 +176,9 @@ static struct ipath_devdata *ipath_alloc
 	struct ipath_devdata *dd;
 	int ret;
 
-	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
-		dd = ERR_PTR(-ENOMEM);
+	ret = idr_pre_get(&unit_table, GFP_KERNEL);
+	if (ret) {
+		dd = ERR_PTR(ret);
 		goto bail;
 	}
 
@@ -2205,10 +2206,9 @@ static int __init infinipath_init(void)
 	 * the PCI subsystem.
 	 */
 	idr_init(&unit_table);
-	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
-		ret = -ENOMEM;
+	ret = idr_pre_get(&unit_table, GFP_KERNEL);
+	if (ret)
 		goto bail;
-	}
 
 	ret = pci_register_driver(&ipath_driver);
 	if (ret < 0) {
Index: b/drivers/md/dm.c
===================================================================
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -887,8 +887,8 @@ static int specific_minor(struct mapped_
 		return -EINVAL;
 
 	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r)
-		return -ENOMEM;
+	if (r)
+		return r;
 
 	spin_lock(&_minor_lock);
 
@@ -917,8 +917,8 @@ static int next_free_minor(struct mapped
 	int r, m;
 
 	r = idr_pre_get(&_minor_idr, GFP_KERNEL);
-	if (!r)
-		return -ENOMEM;
+	if (r)
+		return r;
 
 	spin_lock(&_minor_lock);
 
Index: b/drivers/misc/tifm_core.c
===================================================================
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -194,8 +194,9 @@ int tifm_add_adapter(struct tifm_adapter
 {
 	int rc;
 
-	if (!idr_pre_get(&tifm_adapter_idr, GFP_KERNEL))
-		return -ENOMEM;
+	rc = idr_pre_get(&tifm_adapter_idr, GFP_KERNEL);
+	if (rc)
+		return rc;
 
 	spin_lock(&tifm_adapter_lock);
 	rc = idr_get_new(&tifm_adapter_idr, fm, &fm->id);
Index: b/drivers/mmc/core/host.c
===================================================================
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -100,8 +100,9 @@ int mmc_add_host(struct mmc_host *host)
 {
 	int err;
 
-	if (!idr_pre_get(&mmc_host_idr, GFP_KERNEL))
-		return -ENOMEM;
+	err = idr_pre_get(&mmc_host_idr, GFP_KERNEL);
+	if (err)
+		return err;
 
 	spin_lock(&mmc_host_lock);
 	err = idr_get_new(&mmc_host_idr, host, &host->index);
Index: b/drivers/rtc/class.c
===================================================================
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -121,10 +121,9 @@ struct rtc_device *rtc_device_register(c
 	struct rtc_device *rtc;
 	int id, err;
 
-	if (idr_pre_get(&rtc_idr, GFP_KERNEL) == 0) {
-		err = -ENOMEM;
+	err = idr_pre_get(&rtc_idr, GFP_KERNEL);
+	if (err)
 		goto exit;
-	}
 
 
 	mutex_lock(&idr_lock);
Index: b/drivers/scsi/lpfc/lpfc_init.c
===================================================================
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1596,7 +1596,7 @@ lpfc_get_instance(void)
 	int instance = 0;
 
 	/* Assign an unused number */
-	if (!idr_pre_get(&lpfc_hba_index, GFP_KERNEL))
+	if (idr_pre_get(&lpfc_hba_index, GFP_KERNEL))
 		return -1;
 	if (idr_get_new(&lpfc_hba_index, NULL, &instance))
 		return -1;
Index: b/drivers/scsi/sd.c
===================================================================
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1623,7 +1623,7 @@ static int sd_probe(struct device *dev)
 	if (!gd)
 		goto out_free;
 
-	if (!idr_pre_get(&sd_index_idr, GFP_KERNEL))
+	if (idr_pre_get(&sd_index_idr, GFP_KERNEL))
 		goto out_put;
 
 	spin_lock(&sd_index_lock);
Index: b/drivers/scsi/sg.c
===================================================================
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1341,8 +1341,8 @@ static Sg_device *sg_alloc(struct gendis
 		printk(KERN_WARNING "kmalloc Sg_device failure\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	error = -ENOMEM;
-	if (!idr_pre_get(&sg_index_idr, GFP_KERNEL)) {
+	error = idr_pre_get(&sg_index_idr, GFP_KERNEL);
+	if (error) {
 		printk(KERN_WARNING "idr expansion Sg_device failure\n");
 		goto out;
 	}
Index: b/drivers/uio/uio.c
===================================================================
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -207,11 +207,12 @@ static void uio_dev_del_attributes(struc
 static int uio_get_minor(struct uio_device *idev)
 {
 	static DEFINE_MUTEX(minor_lock);
-	int retval = -ENOMEM;
+	int retval;
 	int id;
 
 	mutex_lock(&minor_lock);
-	if (idr_pre_get(&uio_idr, GFP_KERNEL) == 0)
+	retval = idr_pre_get(&uio_idr, GFP_KERNEL);
+	if (retval)
 		goto exit;
 
 	retval = idr_get_new(&uio_idr, idev, &id);
Index: b/drivers/usb/core/endpoint.c
===================================================================
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -182,11 +182,12 @@ static void usb_endpoint_major_cleanup(v
 static int endpoint_get_minor(struct ep_device *ep_dev)
 {
 	static DEFINE_MUTEX(minor_lock);
-	int retval = -ENOMEM;
+	int retval;
 	int id;
 
 	mutex_lock(&minor_lock);
-	if (idr_pre_get(&endpoint_idr, GFP_KERNEL) == 0)
+	retval = idr_pre_get(&endpoint_idr, GFP_KERNEL);
+	if (retval)
 		goto exit;
 
 	retval = idr_get_new(&endpoint_idr, ep_dev, &id);
Index: b/drivers/video/display/display-sysfs.c
===================================================================
--- a/drivers/video/display/display-sysfs.c
+++ b/drivers/video/display/display-sysfs.c
@@ -141,7 +141,7 @@ struct display_device *display_device_re
 	mutex_lock(&allocated_dsp_lock);
 	ret = idr_pre_get(&allocated_dsp, GFP_KERNEL);
 	mutex_unlock(&allocated_dsp_lock);
-	if (!ret)
+	if (ret)
 		return ERR_PTR(ret);
 
 	new_dev = kzalloc(sizeof(struct display_device), GFP_KERNEL);
Index: b/drivers/w1/slaves/w1_ds2760.c
===================================================================
--- a/drivers/w1/slaves/w1_ds2760.c
+++ b/drivers/w1/slaves/w1_ds2760.c
@@ -97,8 +97,8 @@ static int new_bat_id(void)
 		int id;
 
 		ret = idr_pre_get(&bat_idr, GFP_KERNEL);
-		if (ret == 0)
-			return -ENOMEM;
+		if (ret)
+			return ret;
 
 		mutex_lock(&bat_idr_lock);
 		ret = idr_get_new(&bat_idr, NULL, &id);
Index: b/fs/dlm/lowcomms.c
===================================================================
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -160,7 +160,7 @@ static struct connection *__nodeid2con(i
 		return con;
 
 	r = idr_pre_get(&connections_idr, alloc);
-	if (!r)
+	if (r)
 		return NULL;
 
 	con = kmem_cache_zalloc(con_cache, alloc);
Index: b/fs/inotify.c
===================================================================
--- a/fs/inotify.c
+++ b/fs/inotify.c
@@ -135,7 +135,7 @@ static int inotify_handle_get_wd(struct 
 	int ret;
 
 	do {
-		if (unlikely(!idr_pre_get(&ih->idr, GFP_KERNEL)))
+		if (unlikely(idr_pre_get(&ih->idr, GFP_KERNEL)))
 			return -ENOSPC;
 		ret = idr_get_new_above(&ih->idr, watch, ih->last_wd+1, &watch->wd);
 	} while (ret == -EAGAIN);
Index: b/fs/ocfs2/cluster/tcp.c
===================================================================
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -200,10 +200,10 @@ static int o2net_prep_nsw(struct o2net_n
 	int ret = 0;
 
 	do {
-		if (!idr_pre_get(&nn->nn_status_idr, GFP_ATOMIC)) {
-			ret = -EAGAIN;
+		ret = idr_pre_get(&nn->nn_status_idr, GFP_ATOMIC);
+		if (ret)
 			break;
-		}
+
 		spin_lock(&nn->nn_lock);
 		ret = idr_get_new(&nn->nn_status_idr, nsw, &nsw->ns_id);
 		if (ret == 0)
Index: b/fs/proc/generic.c
===================================================================
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -323,7 +323,7 @@ static unsigned int get_inode_number(voi
 	int error;
 
 retry:
-	if (idr_pre_get(&proc_inum_idr, GFP_KERNEL) == 0)
+	if (idr_pre_get(&proc_inum_idr, GFP_KERNEL))
 		return 0;
 
 	spin_lock(&proc_inum_lock);
Index: b/fs/super.c
===================================================================
--- a/fs/super.c
+++ b/fs/super.c
@@ -661,8 +661,9 @@ int set_anon_super(struct super_block *s
 	int error;
 
  retry:
-	if (idr_pre_get(&unnamed_dev_idr, GFP_ATOMIC) == 0)
-		return -ENOMEM;
+	error = idr_pre_get(&unnamed_dev_idr, GFP_ATOMIC);
+	if (error)
+		return error;
 	spin_lock(&unnamed_dev_lock);
 	error = idr_get_new(&unnamed_dev_idr, NULL, &dev);
 	spin_unlock(&unnamed_dev_lock);
Index: b/fs/sysfs/dir.c
===================================================================
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -246,9 +246,9 @@ static int sysfs_alloc_ino(ino_t *pino)
 	spin_unlock(&sysfs_ino_lock);
 
 	if (rc == -EAGAIN) {
-		if (ida_pre_get(&sysfs_ino_ida, GFP_KERNEL))
+		rc = ida_pre_get(&sysfs_ino_ida, GFP_KERNEL);
+		if (rc == 0)
 			goto retry;
-		rc = -ENOMEM;
 	}
 
 	*pino = ino;
Index: b/ipc/util.c
===================================================================
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -314,8 +314,8 @@ int ipcget_new(struct ipc_namespace *ns,
 
 	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
-	if (!err)
-		return -ENOMEM;
+	if (err)
+		return err;
 
 	down_write(&ids->rw_mutex);
 	err = ops->getnew(ns, params);
@@ -388,8 +388,6 @@ int ipcget_public(struct ipc_namespace *
 		if (!(flg & IPC_CREAT))
 			err = -ENOENT;
 		else if (!err)
-			err = -ENOMEM;
-		else
 			err = ops->getnew(ns, params);
 	} else {
 		/* ipc object has been locked by ipc_findkey() */
Index: b/kernel/posix-timers.c
===================================================================
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -481,7 +481,7 @@ sys_timer_create(const clockid_t which_c
 
 	spin_lock_init(&new_timer->it_lock);
  retry:
-	if (unlikely(!idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
+	if (unlikely(idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
 		error = -EAGAIN;
 		goto out;
 	}
Index: b/lib/idr.c
===================================================================
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -99,8 +99,8 @@ static void idr_mark_full(struct idr_lay
  * following function.  It preallocates enough memory to satisfy
  * the worst possible allocation.
  *
- * If the system is REALLY out of memory this function returns 0,
- * otherwise 1.
+ * If the system is REALLY out of memory this function returns -ENOMEM,
+ * otherwise 0.
  */
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
@@ -108,10 +108,10 @@ int idr_pre_get(struct idr *idp, gfp_t g
 		struct idr_layer *new;
 		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
-			return (0);
+			return -ENOMEM;
 		free_layer(idp, new);
 	}
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL(idr_pre_get);
 
@@ -645,14 +645,14 @@ static void free_bitmap(struct ida *ida,
  * following function.  It preallocates enough memory to satisfy the
  * worst possible allocation.
  *
- * If the system is REALLY out of memory this function returns 0,
- * otherwise 1.
+ * If the system is REALLY out of memory this function returns -ENOMEM,
+ * otherwise 0.
  */
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask)
 {
 	/* allocate idr_layers */
-	if (!idr_pre_get(&ida->idr, gfp_mask))
-		return 0;
+	if (idr_pre_get(&ida->idr, gfp_mask))
+		return -ENOMEM;
 
 	/* allocate free_bitmap */
 	if (!ida->free_bitmap) {
@@ -660,12 +660,12 @@ int ida_pre_get(struct ida *ida, gfp_t g
 
 		bitmap = kmalloc(sizeof(struct ida_bitmap), gfp_mask);
 		if (!bitmap)
-			return 0;
+			return -ENOMEM;
 
 		free_bitmap(ida, bitmap);
 	}
 
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL(ida_pre_get);
 
Index: b/net/9p/util.c
===================================================================
--- a/net/9p/util.c
+++ b/net/9p/util.c
@@ -73,7 +73,7 @@ int p9_idpool_get(struct p9_idpool *p)
 	int error;
 
 retry:
-	if (idr_pre_get(&p->pool, GFP_KERNEL) == 0)
+	if (idr_pre_get(&p->pool, GFP_KERNEL))
 		return 0;
 
 	if (down_interruptible(&p->lock) == -EINTR) {
Index: b/net/sctp/associola.c
===================================================================
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1451,8 +1451,9 @@ int sctp_assoc_set_id(struct sctp_associ
 	int assoc_id;
 	int error = 0;
 retry:
-	if (unlikely(!idr_pre_get(&sctp_assocs_id, gfp)))
-		return -ENOMEM;
+	error = idr_pre_get(&sctp_assocs_id, gfp);
+	if (unlikely(error))
+		return error;
 
 	spin_lock_bh(&sctp_assocs_id_lock);
 	error = idr_get_new_above(&sctp_assocs_id, (void *)asoc,

-- 
Pierre Peiffer
