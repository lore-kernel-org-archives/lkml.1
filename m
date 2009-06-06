Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZFFQgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZFFQgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 12:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZFFQfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 12:35:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34800 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZFFQfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 12:35:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 6 Jun 2009 18:35:27 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: add parent-of-unit accessor
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.a1d4ff29266e6074@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Retrieval of an fw_unit's parent is a common pattern in high-level code.
Wrap it up as device = fw_parent_device(unit).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |    4 ++--
 drivers/firewire/sbp2.c        |   37 +++++++++++++++++++++----------------
 include/linux/firewire.h       |    5 +++++
 3 files changed, 28 insertions(+), 18 deletions(-)

Index: linux/drivers/firewire/core-device.c
===================================================================
--- linux.orig/drivers/firewire/core-device.c
+++ linux/drivers/firewire/core-device.c
@@ -93,7 +93,7 @@ static int fw_unit_match(struct device *
 	if (!is_fw_unit(dev))
 		return 0;
 
-	device = fw_device(unit->device.parent);
+	device = fw_parent_device(unit);
 	id = container_of(drv, struct fw_driver, driver)->id_table;
 
 	for (; id->match_flags != 0; id++) {
@@ -114,7 +114,7 @@ static int fw_unit_match(struct device *
 
 static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)
 {
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct fw_device *device = fw_parent_device(unit);
 	struct fw_csr_iterator ci;
 
 	int key, value;
Index: linux/drivers/firewire/sbp2.c
===================================================================
--- linux.orig/drivers/firewire/sbp2.c
+++ linux/drivers/firewire/sbp2.c
@@ -180,6 +180,11 @@ struct sbp2_target {
 	int blocked;	/* ditto */
 };
 
+static struct fw_device *target_device(struct sbp2_target *tgt)
+{
+	return fw_parent_device(tgt->unit);
+}
+
 /* Impossible login_id, to detect logout attempt before successful login */
 #define INVALID_LOGIN_ID 0x10000
 
@@ -488,7 +493,7 @@ static void complete_transaction(struct 
 static void sbp2_send_orb(struct sbp2_orb *orb, struct sbp2_logical_unit *lu,
 			  int node_id, int generation, u64 offset)
 {
-	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(lu->tgt);
 	unsigned long flags;
 
 	orb->pointer.high = 0;
@@ -510,7 +515,7 @@ static void sbp2_send_orb(struct sbp2_or
 
 static int sbp2_cancel_orbs(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(lu->tgt);
 	struct sbp2_orb *orb, *next;
 	struct list_head list;
 	unsigned long flags;
@@ -548,7 +553,7 @@ static int sbp2_send_management_orb(stru
 				    int generation, int function,
 				    int lun_or_login_id, void *response)
 {
-	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(lu->tgt);
 	struct sbp2_management_orb *orb;
 	unsigned int timeout;
 	int retval = -ENOMEM;
@@ -644,7 +649,7 @@ static int sbp2_send_management_orb(stru
 
 static void sbp2_agent_reset(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(lu->tgt);
 	__be32 d = 0;
 
 	fw_run_transaction(device->card, TCODE_WRITE_QUADLET_REQUEST,
@@ -661,7 +666,7 @@ static void complete_agent_reset_write_n
 
 static void sbp2_agent_reset_no_wait(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(lu->tgt);
 	struct fw_transaction *t;
 	static __be32 d;
 
@@ -700,7 +705,7 @@ static inline void sbp2_allow_block(stru
 static void sbp2_conditionally_block(struct sbp2_logical_unit *lu)
 {
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_card *card = fw_device(tgt->unit->device.parent)->card;
+	struct fw_card *card = target_device(tgt)->card;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	unsigned long flags;
@@ -724,7 +729,7 @@ static void sbp2_conditionally_block(str
 static void sbp2_conditionally_unblock(struct sbp2_logical_unit *lu)
 {
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_card *card = fw_device(tgt->unit->device.parent)->card;
+	struct fw_card *card = target_device(tgt)->card;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	unsigned long flags;
@@ -749,7 +754,7 @@ static void sbp2_conditionally_unblock(s
  */
 static void sbp2_unblock(struct sbp2_target *tgt)
 {
-	struct fw_card *card = fw_device(tgt->unit->device.parent)->card;
+	struct fw_card *card = target_device(tgt)->card;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	unsigned long flags;
@@ -779,7 +784,7 @@ static void sbp2_release_target(struct k
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
 	struct scsi_device *sdev;
-	struct fw_device *device = fw_device(tgt->unit->device.parent);
+	struct fw_device *device = target_device(tgt);
 
 	/* prevent deadlocks */
 	sbp2_unblock(tgt);
@@ -852,7 +857,7 @@ static void sbp2_queue_work(struct sbp2_
  */
 static void sbp2_set_busy_timeout(struct sbp2_logical_unit *lu)
 {
-	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(lu->tgt);
 	__be32 d = cpu_to_be32(SBP2_CYCLE_LIMIT | SBP2_RETRY_LIMIT);
 
 	fw_run_transaction(device->card, TCODE_WRITE_QUADLET_REQUEST,
@@ -868,7 +873,7 @@ static void sbp2_login(struct work_struc
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_device *device = fw_device(tgt->unit->device.parent);
+	struct fw_device *device = target_device(tgt);
 	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
 	struct sbp2_login_response response;
@@ -1116,7 +1121,7 @@ static struct scsi_host_template scsi_dr
 static int sbp2_probe(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
-	struct fw_device *device = fw_device(unit->device.parent);
+	struct fw_device *device = fw_parent_device(unit);
 	struct sbp2_target *tgt;
 	struct sbp2_logical_unit *lu;
 	struct Scsi_Host *shost;
@@ -1197,7 +1202,7 @@ static void sbp2_reconnect(struct work_s
 	struct sbp2_logical_unit *lu =
 		container_of(work, struct sbp2_logical_unit, work.work);
 	struct sbp2_target *tgt = lu->tgt;
-	struct fw_device *device = fw_device(tgt->unit->device.parent);
+	struct fw_device *device = target_device(tgt);
 	int generation, node_id, local_node_id;
 
 	if (fw_device_is_shutdown(device))
@@ -1249,7 +1254,7 @@ static void sbp2_update(struct fw_unit *
 	struct sbp2_target *tgt = unit->device.driver_data;
 	struct sbp2_logical_unit *lu;
 
-	fw_device_enable_phys_dma(fw_device(unit->device.parent));
+	fw_device_enable_phys_dma(fw_parent_device(unit));
 
 	/*
 	 * Fw-core serializes sbp2_update() against sbp2_remove().
@@ -1342,7 +1347,7 @@ static void complete_command_orb(struct 
 {
 	struct sbp2_command_orb *orb =
 		container_of(base_orb, struct sbp2_command_orb, base);
-	struct fw_device *device = fw_device(orb->lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(orb->lu->tgt);
 	int result;
 
 	if (status != NULL) {
@@ -1449,7 +1454,7 @@ static int sbp2_map_scatterlist(struct s
 static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 {
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
-	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
+	struct fw_device *device = target_device(lu->tgt);
 	struct sbp2_command_orb *orb;
 	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 
Index: linux/include/linux/firewire.h
===================================================================
--- linux.orig/include/linux/firewire.h
+++ linux/include/linux/firewire.h
@@ -248,6 +248,11 @@ static inline void fw_unit_put(struct fw
 	put_device(&unit->device);
 }
 
+static inline struct fw_device *fw_parent_device(struct fw_unit *unit)
+{
+	return fw_device(unit->device.parent);
+}
+
 struct ieee1394_device_id;
 
 struct fw_driver {

-- 
Stefan Richter
-=====-==--= -==- --==-
http://arcgraph.de/sr/

