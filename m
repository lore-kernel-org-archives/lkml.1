Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYILOmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYILOmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYILOlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:41:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbYILOlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:41:49 -0400
Date: Fri, 12 Sep 2008 10:42:28 -0400 (EDT)
Message-Id: <20080912.104228.30188313.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 03/13] mm: lld busy status exporting interface
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to check lld's busy status
from the block layer.  (scsi patch is also included.)
This resolves a performance problem on request stacking devices below.


Some drivers like scsi mid layer stop dispatching request when
they detect busy state on its low-level device like host/bus/device.
It allows other requests to stay in the I/O scheduler's queue
for a chance of merging.

Request stacking drivers like request-based dm should follow
the same logic.
However, there is no generic interface for the stacked device
to check if the underlying device(s) are busy.
If the request stacking driver dispatches and submits requests to
the busy underlying device, the requests will stay in
the underlying device's queue without a chance of merging.
This causes performance problem on burst I/O load.

With this patch, busy state of the underlying device is exported
via the state flag of queue's backing_dev_info.  So the request
stacking driver can check it and stop dispatching requests if busy.

The underlying device driver must set/clear the flag appropriately:
   ON:  when the device driver can't process requests immediately.
   OFF: when the device driver can process requests immediately,
        including abnormal situations where the device driver needs
        to kill all requests.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/backing-dev.h |    8 ++++++++
 mm/backing-dev.c            |   13 +++++++++++++
 2 files changed, 21 insertions(+)

Index: 2.6.27-rc6/include/linux/backing-dev.h
===================================================================
--- 2.6.27-rc6.orig/include/linux/backing-dev.h
+++ 2.6.27-rc6/include/linux/backing-dev.h
@@ -26,6 +26,7 @@ enum bdi_state {
 	BDI_pdflush,		/* A pdflush thread is working this device */
 	BDI_write_congested,	/* The write queue is getting full */
 	BDI_read_congested,	/* The read queue is getting full */
+	BDI_lld_congested,	/* The device/host is busy */
 	BDI_unused,		/* Available bits start here */
 };
 
@@ -226,8 +227,15 @@ static inline int bdi_rw_congested(struc
 				  (1 << BDI_write_congested));
 }
 
+static inline int bdi_lld_congested(struct backing_dev_info *bdi)
+{
+	return bdi_congested(bdi, 1 << BDI_lld_congested);
+}
+
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
+void clear_bdi_lld_congested(struct backing_dev_info *bdi);
+void set_bdi_lld_congested(struct backing_dev_info *bdi);
 long congestion_wait(int rw, long timeout);
 
 
Index: 2.6.27-rc6/mm/backing-dev.c
===================================================================
--- 2.6.27-rc6.orig/mm/backing-dev.c
+++ 2.6.27-rc6/mm/backing-dev.c
@@ -279,6 +279,19 @@ void set_bdi_congested(struct backing_de
 }
 EXPORT_SYMBOL(set_bdi_congested);
 
+void clear_bdi_lld_congested(struct backing_dev_info *bdi)
+{
+	clear_bit(BDI_lld_congested, &bdi->state);
+	smp_mb__after_clear_bit();
+}
+EXPORT_SYMBOL_GPL(clear_bdi_lld_congested);
+
+void set_bdi_lld_congested(struct backing_dev_info *bdi)
+{
+	set_bit(BDI_lld_congested, &bdi->state);
+}
+EXPORT_SYMBOL_GPL(set_bdi_lld_congested);
+
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
  * @rw: READ or WRITE
