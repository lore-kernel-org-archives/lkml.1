Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZCBIrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZCBIrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbZCBIrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:47:39 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:33295 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbZCBIrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:47:39 -0500
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 19:47:37 +1100
Message-ID: <e51f4f550903020047m7f110039v48bcac6a345f1fd6@mail.gmail.com>
Subject: [PATCH] Fix kernel NULL pointer dereference in xen-blkfront
From: Kris Shannon <kris@shannon.id.au>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting Xen Dom0 on a pre-release 3.2.1 hypervisor the system Oopses on a
"Unable to handle kernel NULL pointer dereference" in xenwatch.

>From the backtrace it looks like backend_changed is calling bdget_disk
with a NULL pointer.  Checking for NULL and returning ENODEV instead
allows the kernel to boot.
---
 drivers/block/xen-blkfront.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index f2fff5799ddf0fe1b41909b64d606d..3e2ab6d53adaeb70efa12f0a1f33bb 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -905,6 +905,8 @@ static void backend_changed(struct xenbus_device *dev,
 		break;

 	case XenbusStateClosing:
+		if (info->gd == NULL)
+			xenbus_dev_fatal(dev, -ENODEV, "gd is NULL");
 		bd = bdget_disk(info->gd, 0);
 		if (bd == NULL)
 			xenbus_dev_fatal(dev, -ENODEV, "bdget failed");
-- 
1.6.1.3
