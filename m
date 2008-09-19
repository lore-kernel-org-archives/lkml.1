Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYISOv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYISOv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYISOvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:51:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbYISOvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:51:15 -0400
Date: Fri, 19 Sep 2008 10:48:54 -0400 (EDT)
Message-Id: <20080919.104854.71084447.k-ueda@ct.jp.nec.com>
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 1/2] lld busy status exporting interface
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to check lld's busy status
from the block layer.
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
---
 include/linux/backing-dev.h |    8 ++++++++
 mm/backing-dev.c            |   12 ++++++++++++
 2 files changed, 20 insertions(+)

Index: scsi-misc-2.6/include/linux/backing-dev.h
===================================================================
--- scsi-misc-2.6.orig/include/linux/backing-dev.h
+++ scsi-misc-2.6/include/linux/backing-dev.h
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
 
 
Index: scsi-misc-2.6/mm/backing-dev.c
===================================================================
--- scsi-misc-2.6.orig/mm/backing-dev.c
+++ scsi-misc-2.6/mm/backing-dev.c
@@ -279,6 +279,18 @@ void set_bdi_congested(struct backing_de
 }
 EXPORT_SYMBOL(set_bdi_congested);
 
+void clear_bdi_lld_congested(struct backing_dev_info *bdi)
+{
+	clear_bit(BDI_lld_congested, &bdi->state);
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
