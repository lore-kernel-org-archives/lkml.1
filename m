Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbYGKNx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbYGKNx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758208AbYGKNsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:10 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34989 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759417AbYGKNr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:57 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 26/30] W1: ds2490.c reset ds2490 in init
Date: Fri, 11 Jul 2008 17:51:41 +0400
Message-Id: <12157843072465-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset the device in init as it can be in a bad state.  This is
necessary because a block write will wait for data to be placed in the
output buffer and block any later commands which will keep
accumulating and the device will not be idle.  Another case is
removing the ds2490 module while a bus search is in progress, somehow
a few commands get through, but the input transfers fail leaving data
in the input buffer.  This will cause the next read to fail see the
note in ds_recv_data.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds2490.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index eb902ab..754a4bb 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -316,6 +316,15 @@ static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int size)
 	int count, err;
 	struct ds_status st;
 
+	/* Careful on size.  If size is less than what is available in
+	 * the input buffer, the device fails the bulk transfer and
+	 * clears the input buffer.  It could read the maximum size of
+	 * the data buffer, but then do you return the first, last, or
+	 * some set of the middle size bytes?  As long as the rest of
+	 * the code is correct there will be size bytes waiting.  A
+	 * call to ds_wait_status will wait until the device is idle
+	 * and any data to be received would have been available.
+	 */
 	count = 0;
 	err = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DATA_IN]),
 				buf, size, &count, 1000);
@@ -824,6 +833,18 @@ static int ds_w1_init(struct ds_device *dev)
 {
 	memset(&dev->master, 0, sizeof(struct w1_bus_master));
 
+	/* Reset the device as it can be in a bad state.
+	 * This is necessary because a block write will wait for data
+	 * to be placed in the output buffer and block any later
+	 * commands which will keep accumulating and the device will
+	 * not be idle.  Another case is removing the ds2490 module
+	 * while a bus search is in progress, somehow a few commands
+	 * get through, but the input transfers fail leaving data in
+	 * the input buffer.  This will cause the next read to fail
+	 * see the note in ds_recv_data.
+	 */
+	ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+
 	dev->master.data	= dev;
 	dev->master.touch_bit	= &ds9490r_touch_bit;
 	/* read_bit and write_bit in w1_bus_master are expected to set and
-- 
1.4.4.4

