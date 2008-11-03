Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYKCPyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYKCPyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbYKCPx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:53:56 -0500
Received: from gv-out-0910.google.com ([216.239.58.186]:50535 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbYKCPxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:53:55 -0500
Subject: bdi: register sysfs bdi device only once per queue
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Folkert van Heusden <folkert@vanheusden.com>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel <linux-kernel@vger.kernel.org>
X-Sieve: CMU Sieve 2.2
X-Spam-Score: -0.739
Content-Type: text/plain
Date: Mon, 03 Nov 2008 16:53:55 +0100
Message-Id: <1225727635.6009.9.camel@linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, can you pick this up this please?

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: bdi: register sysfs bdi device only once per queue

Devices which share the same queue, like floppies and mtd devices,
get registered multiple times in the bdi interface, but bdi accounts
only the last registered device of the devices sharing one queue.

On remove, all earlier registered devices leak, stay around in
sysfs, and cause "duplicate filename" errors if the devices are
re-created.

This prevents the creation of multiple bdi interfaces per queue,
and the bdi device will carry the dev_t name of the block device
which is the first one registered, of the pool of devices using
the same queue.

Tested-By: Peter Korsgaard <jacmet@sunsite.dk>
Acked-By: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f2e574d..e6676e5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	int ret = 0;
 	struct device *dev;
 
+	if (bdi->dev)
+		goto exit;
+
 	va_start(args, fmt);
 	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);


