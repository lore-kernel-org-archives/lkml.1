Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZI2RS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZI2RS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZI2RSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:18:55 -0400
Received: from ozlabs.org ([203.10.76.45]:59248 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbZI2RSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:18:53 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 30 Sep 2009 02:48:54 +0930
Subject: [PATCH 4/4] lguest: GET_ID "support"
Cc: virtualization@lists.linux-foundation.org,
       john cooper <john.cooper@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909300248.55485.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We advertise the feature for testing, then promptly fail when the guest
uses it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1654,7 +1654,11 @@ static void blk_request(struct virtqueue
 	 * In general the virtio block driver is allowed to try SCSI commands.
 	 * It'd be nice if we supported eject, for example, but we don't.
 	 */
-	if (out->type & VIRTIO_BLK_T_SCSI_CMD) {
+	if (out->type == VIRTIO_BLK_T_GET_ID) {
+		fprintf(stderr, "GET ID command unsupported\n");
+		*in = VIRTIO_BLK_S_UNSUPP;
+		wlen = sizeof(*in);
+	} else if (out->type & VIRTIO_BLK_T_SCSI_CMD) {
 		fprintf(stderr, "Scsi commands unsupported\n");
 		*in = VIRTIO_BLK_S_UNSUPP;
 		wlen = sizeof(*in);
@@ -1751,6 +1755,9 @@ static void setup_block_file(const char 
 	add_feature(dev, VIRTIO_BLK_F_SEG_MAX);
 	conf.seg_max = cpu_to_le32(VIRTQUEUE_NUM - 2);
 
+	/* We have GET_ID, at least for testing! */
+	add_feature(dev, VIRTIO_BLK_F_GET_ID);
+
 	/*
 	 * We only have 8 bits of configuration space for each device.  But a
 	 * new feature for virtio_blk added a 1k 'identify' field to struct

