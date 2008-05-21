Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbYEUAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbYEUAao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYEUAae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:30:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45290 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbYEUAad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:30:33 -0400
To: mchehab@infradead.org
Subject: [PATCH] cinergyT2: endianness annotations, endianness and race fixes
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycDv-0004jN-RP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:30:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Endianness annotations and fixes + fixing the handling of
->uncorrected_block_count

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/cinergyT2/cinergyT2.c |   46 ++++++++++++++++---------------
 1 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/cinergyT2/cinergyT2.c b/drivers/media/dvb/cinergyT2/cinergyT2.c
index f5010e8..a824f37 100644
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c
+++ b/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -82,22 +82,22 @@ enum cinergyt2_ep1_cmd {
 
 struct dvbt_set_parameters_msg {
 	uint8_t cmd;
-	uint32_t freq;
+	__le32 freq;
 	uint8_t bandwidth;
-	uint16_t tps;
+	__le16 tps;
 	uint8_t flags;
 } __attribute__((packed));
 
 struct dvbt_get_status_msg {
-	uint32_t freq;
+	__le32 freq;
 	uint8_t bandwidth;
-	uint16_t tps;
+	__le16 tps;
 	uint8_t flags;
-	uint16_t gain;
+	__le16 gain;
 	uint8_t snr;
-	uint32_t viterbi_error_rate;
-	uint32_t rs_error_rate;
-	uint32_t uncorrected_block_count;
+	__le32 viterbi_error_rate;
+	__le32 rs_error_rate;
+	__le32 uncorrected_block_count;
 	uint8_t lock_bits;
 	uint8_t prev_lock_bits;
 } __attribute__((packed));
@@ -136,6 +136,7 @@ struct cinergyt2 {
 	wait_queue_head_t poll_wq;
 	int pending_fe_events;
 	int disconnect_pending;
+	unsigned int uncorrected_block_count;
 	atomic_t inuse;
 
 	void *streambuf;
@@ -147,7 +148,7 @@ struct cinergyt2 {
 	char phys[64];
 	struct delayed_work rc_query_work;
 	int rc_input_event;
-	u32 rc_last_code;
+	__le32 rc_last_code;
 	unsigned long last_event_jiffies;
 #endif
 };
@@ -160,7 +161,7 @@ enum {
 
 struct cinergyt2_rc_event {
 	char type;
-	uint32_t value;
+	__le32 value;
 } __attribute__((packed));
 
 static const uint32_t rc_keys[] = {
@@ -619,8 +620,11 @@ static int cinergyt2_ioctl (struct inode *inode, struct file *file,
 	{
 		uint32_t unc_count;
 
-		unc_count = stat->uncorrected_block_count;
-		stat->uncorrected_block_count = 0;
+		if (mutex_lock_interruptible(&cinergyt2->sem))
+			return -ERESTARTSYS;
+		unc_count = cinergyt2->uncorrected_block_count;
+		cinergyt2->uncorrected_block_count = 0;
+		mutex_unlock(&cinergyt2->sem);
 
 		/* UNC are already converted to host byte order... */
 		return put_user(unc_count,(__u32 __user *) arg);
@@ -769,7 +773,7 @@ static void cinergyt2_query_rc (struct work_struct *work)
 				input_sync(cinergyt2->rc_input_dev);
 				cinergyt2->rc_input_event = KEY_MAX;
 			}
-			cinergyt2->rc_last_code = ~0;
+			cinergyt2->rc_last_code = cpu_to_le32(~0);
 		}
 		goto out;
 	}
@@ -780,7 +784,7 @@ static void cinergyt2_query_rc (struct work_struct *work)
 			n, le32_to_cpu(rc_events[n].value), rc_events[n].type);
 
 		if (rc_events[n].type == CINERGYT2_RC_EVENT_TYPE_NEC &&
-		    rc_events[n].value == ~0) {
+		    rc_events[n].value == cpu_to_le32(~0)) {
 			/* keyrepeat bit -> just repeat last rc_input_event */
 		} else {
 			cinergyt2->rc_input_event = KEY_MAX;
@@ -795,7 +799,7 @@ static void cinergyt2_query_rc (struct work_struct *work)
 
 		if (cinergyt2->rc_input_event != KEY_MAX) {
 			if (rc_events[n].value == cinergyt2->rc_last_code &&
-			    cinergyt2->rc_last_code != ~0) {
+			    cinergyt2->rc_last_code != cpu_to_le32(~0)) {
 				/* emit a key-up so the double event is recognized */
 				dprintk(1, "rc_input_event=%d UP\n", cinergyt2->rc_input_event);
 				input_report_key(cinergyt2->rc_input_dev,
@@ -829,7 +833,7 @@ static int cinergyt2_register_rc(struct cinergyt2 *cinergyt2)
 	usb_make_path(cinergyt2->udev, cinergyt2->phys, sizeof(cinergyt2->phys));
 	strlcat(cinergyt2->phys, "/input0", sizeof(cinergyt2->phys));
 	cinergyt2->rc_input_event = KEY_MAX;
-	cinergyt2->rc_last_code = ~0;
+	cinergyt2->rc_last_code = cpu_to_le32(~0);
 	INIT_DELAYED_WORK(&cinergyt2->rc_query_work, cinergyt2_query_rc);
 
 	input_dev->name = DRIVER_NAME " remote control";
@@ -840,8 +844,8 @@ static int cinergyt2_register_rc(struct cinergyt2 *cinergyt2)
 	input_dev->keycodesize = 0;
 	input_dev->keycodemax = 0;
 	input_dev->id.bustype = BUS_USB;
-	input_dev->id.vendor = cinergyt2->udev->descriptor.idVendor;
-	input_dev->id.product = cinergyt2->udev->descriptor.idProduct;
+	input_dev->id.vendor = le16_to_cpu(cinergyt2->udev->descriptor.idVendor);
+	input_dev->id.product = le16_to_cpu(cinergyt2->udev->descriptor.idProduct);
 	input_dev->id.version = 1;
 	input_dev->dev.parent = &cinergyt2->udev->dev;
 
@@ -889,18 +893,16 @@ static void cinergyt2_query (struct work_struct *work)
 	char cmd [] = { CINERGYT2_EP1_GET_TUNER_STATUS };
 	struct dvbt_get_status_msg *s = &cinergyt2->status;
 	uint8_t lock_bits;
-	uint32_t unc;
 
 	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
 		return;
 
-	unc = s->uncorrected_block_count;
 	lock_bits = s->lock_bits;
 
 	cinergyt2_command(cinergyt2, cmd, sizeof(cmd), (char *) s, sizeof(*s));
 
-	unc += le32_to_cpu(s->uncorrected_block_count);
-	s->uncorrected_block_count = unc;
+	cinergyt2->uncorrected_block_count +=
+		le32_to_cpu(s->uncorrected_block_count);
 
 	if (lock_bits != s->lock_bits) {
 		wake_up_interruptible(&cinergyt2->poll_wq);
-- 
1.5.3.GIT


