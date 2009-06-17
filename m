Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbZFQQIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbZFQQIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbZFQQHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:07:52 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:11580
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754355AbZFQQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:07:51 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Jeff Garzik <jeff@garzik.org>, open-osd <osd-dev@open-osd.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] osdblk: Adjust queue limits to lower device's limits
Date: Wed, 17 Jun 2009 19:07:52 +0300
Message-Id: <1245254872-8717-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <4A391373.3050301@panasas.com>
References: <4A391373.3050301@panasas.com>
X-OriginalArrivalTime: 17 Jun 2009 16:07:54.0528 (UTC) FILETIME=[C5C13A00:01C9EF65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call blk_queue_stack_limits() to copy queue limits from
the underline osd scsi_device. This is absolutely needed
because osdblk cannot sleep when allocating a lower-request and
therefore cannot be bouncing.

TODO: Dynamic changes of limits to the lower device queue
will not reflect in the upper driver

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/block/osdblk.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index e829360..b07e154 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -66,6 +66,7 @@
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_attributes.h>
 #include <scsi/osd_sec.h>
+#include <scsi/scsi_device.h>
 
 #define DRV_NAME "osdblk"
 #define PFX DRV_NAME ": "
@@ -410,6 +411,12 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
 		return rc;
 	}
 
+	/* Set our limits to the lower device limits, because osdblk cannot
+	 * sleep when allocating a lower-request and therefore cannot be
+	 * bouncing.
+	 */
+	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
+
 	blk_queue_prep_rq(q, blk_queue_start_tag);
 	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH, osdblk_prepare_flush);
 
-- 
1.6.2.1

