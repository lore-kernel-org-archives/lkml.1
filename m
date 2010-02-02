Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab0BBTME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:12:04 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:12114 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab0BBTIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:08:19 -0500
Subject: [PATCH v2 04/18] IB/uverbs: use stack variable 'base' in
	ib_uverbs_add_one
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:08:04 -0700
Message-ID: <20100202190804.28217.62413.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is not useful by itself, but sets us up for a future change
that allows us to support more than IB_UVERBS_MAX_DEVICES in a system.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index acae9ed..8c594cd 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -731,6 +731,7 @@ static CLASS_ATTR(abi_version, S_IRUGO, show_abi_version, NULL);
 static void ib_uverbs_add_one(struct ib_device *device)
 {
 	int devnum;
+	dev_t base;
 	struct ib_uverbs_device *uverbs_dev;
 
 	if (!device->alloc_ucontext)
@@ -750,6 +751,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		goto err;
 	}
 	uverbs_dev->devnum = devnum;
+	base = devnum + IB_UVERBS_BASE_DEV;
 	set_bit(devnum, dev_map);
 	spin_unlock(&map_lock);
 
@@ -760,7 +762,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	uverbs_dev->cdev.owner = THIS_MODULE;
 	uverbs_dev->cdev.ops = device->mmap ? &uverbs_mmap_fops : &uverbs_fops;
 	kobject_set_name(&uverbs_dev->cdev.kobj, "uverbs%d", uverbs_dev->devnum);
-	if (cdev_add(&uverbs_dev->cdev, IB_UVERBS_BASE_DEV + devnum, 1))
+	if (cdev_add(&uverbs_dev->cdev, base, 1))
 		goto err_cdev;
 
 	uverbs_dev->dev = device_create(uverbs_class, device->dma_device,

