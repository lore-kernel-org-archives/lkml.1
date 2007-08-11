Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbXHKJwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbXHKJwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 05:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbXHKJwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 05:52:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35071 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbXHKJwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 05:52:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 11 Aug 2007 11:52:08 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: fix unsafe iteration over list of devices
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Olaf Hering <olh@suse.de>
In-Reply-To: <tkrat.123975b91520704c@s5r6.in-berlin.de>
Message-ID: <tkrat.9f3765ec1bf7cc44@s5r6.in-berlin.de>
References: <20070806122059.GA1951@suse.de>
 <tkrat.743d7d7e44325432@s5r6.in-berlin.de>
 <tkrat.123975b91520704c@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sbp2_host_reset and sbp2_handle_status_write are not serialized against
sbp2_alloc_device and sbp2_remove_device.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -242,6 +242,8 @@ static int sbp2_max_speed_and_size(struc
 
 static const u8 sbp2_speedto_max_payload[] = { 0x7, 0x8, 0x9, 0xA, 0xB, 0xC };
 
+static DEFINE_RWLOCK(sbp2_hi_logical_units_lock);
+
 static struct hpsb_highlevel sbp2_highlevel = {
 	.name		= SBP2_DEVICE_NAME,
 	.host_reset	= sbp2_host_reset,
@@ -732,6 +734,7 @@ static struct sbp2_lu *sbp2_alloc_device
 	struct sbp2_fwhost_info *hi;
 	struct Scsi_Host *shost = NULL;
 	struct sbp2_lu *lu = NULL;
+	unsigned long flags;
 
 	lu = kzalloc(sizeof(*lu), GFP_KERNEL);
 	if (!lu) {
@@ -784,7 +787,9 @@ static struct sbp2_lu *sbp2_alloc_device
 
 	lu->hi = hi;
 
+	write_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_add_tail(&lu->lu_list, &hi->logical_units);
+	write_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 
 	/* Register the status FIFO address range. We could use the same FIFO
 	 * for targets at different nodes. However we need different FIFOs per
@@ -828,16 +833,20 @@ static void sbp2_host_reset(struct hpsb_
 {
 	struct sbp2_fwhost_info *hi;
 	struct sbp2_lu *lu;
+	unsigned long flags;
 
 	hi = hpsb_get_hostinfo(&sbp2_highlevel, host);
 	if (!hi)
 		return;
+
+	read_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_for_each_entry(lu, &hi->logical_units, lu_list)
 		if (likely(atomic_read(&lu->state) !=
 			   SBP2LU_STATE_IN_SHUTDOWN)) {
 			atomic_set(&lu->state, SBP2LU_STATE_IN_RESET);
 			scsi_block_requests(lu->shost);
 		}
+	read_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 }
 
 static int sbp2_start_device(struct sbp2_lu *lu)
@@ -919,6 +928,7 @@ alloc_fail:
 static void sbp2_remove_device(struct sbp2_lu *lu)
 {
 	struct sbp2_fwhost_info *hi;
+	unsigned long flags;
 
 	if (!lu)
 		return;
@@ -933,7 +943,9 @@ static void sbp2_remove_device(struct sb
 	flush_scheduled_work();
 	sbp2util_remove_command_orb_pool(lu, hi->host);
 
+	write_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_del(&lu->lu_list);
+	write_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
 
 	if (lu->login_response)
 		dma_free_coherent(hi->host->device.parent,
@@ -1707,6 +1719,7 @@ static int sbp2_handle_status_write(stru
 	}
 
 	/* Find the unit which wrote the status. */
+	read_lock_irqsave(&sbp2_hi_logical_units_lock, flags);
 	list_for_each_entry(lu_tmp, &hi->logical_units, lu_list) {
 		if (lu_tmp->ne->nodeid == nodeid &&
 		    lu_tmp->status_fifo_addr == addr) {
@@ -1714,6 +1727,8 @@ static int sbp2_handle_status_write(stru
 			break;
 		}
 	}
+	read_unlock_irqrestore(&sbp2_hi_logical_units_lock, flags);
+
 	if (unlikely(!lu)) {
 		SBP2_ERR("lu is NULL - device is gone?");
 		return RCODE_ADDRESS_ERROR;

-- 
Stefan Richter
-=====-=-=== =--- -=-==
http://arcgraph.de/sr/

