Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZI2RS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZI2RS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZI2RSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:18:24 -0400
Received: from ozlabs.org ([203.10.76.45]:59231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZI2RSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:18:22 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 30 Sep 2009 02:48:23 +0930
Subject: [PATCH 2/4] lguest: get rid of offset hack in example launcher
Cc: virtualization@lists.linux-foundation.org,
       john cooper <john.cooper@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909300248.24355.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We never supported the ATA VIRTIO_BLK_F_IDENTIFY anyway, but simply
including it in the struct definition broke us (see commit 8ef562d112
"lguest: fix descriptor corruption in example launcher").

Now we can acknowledge that it's deprecated, and get the struct without it.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -6,6 +6,7 @@
 :*/
 #define _LARGEFILE64_SOURCE
 #define _GNU_SOURCE
+#define VIRTIO_BLK_IDENTIFY_DEPRECATED
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
@@ -1750,8 +1751,21 @@ static void setup_block_file(const char 
 	add_feature(dev, VIRTIO_BLK_F_SEG_MAX);
 	conf.seg_max = cpu_to_le32(VIRTQUEUE_NUM - 2);
 
-	/* Don't try to put whole struct: we have 8 bit limit. */
-	set_config(dev, offsetof(struct virtio_blk_config, geometry), &conf);
+	/*
+	 * We only have 8 bits of configuration space for each device.  But a
+	 * new feature for virtio_blk added a 1k 'identify' field to struct
+	 * virtio_blk_config.  We figured that this was a bad idea, but too
+	 * late: the code was already in the wild.
+	 *
+	 * Normally, new features get added to the end of the config struct,
+	 * but that won't do in this case.  So now, if you define
+	 * VIRTIO_BLK_IDENTIFY_DEPRECATED (as we do at the top of this file),
+	 * it pretends that field doesn't exist at all, and we can add new ones
+	 * where it once was.
+	 *
+	 * This way, old code still compiles.  Bit of a mess, though.
+	 */
+	set_config(dev, sizeof(struct virtio_blk_config), &conf);
 
 	verbose("device %u: virtblock %llu sectors\n",
 		++devices.device_num, le64_to_cpu(conf.capacity));

