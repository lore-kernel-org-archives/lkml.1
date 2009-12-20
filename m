Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbZLTRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbZLTRTf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZLTRTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:19:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZLTRTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:19:20 -0500
Date: Sun, 20 Dec 2009 19:16:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3/3] vhost: make default mapping empty by default
Message-ID: <20091220171632.GD31713@redhat.com>
References: <cover.1261329297.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1261329297.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost now validates each region with access_ok in calling process
context before access.  Since this fails on a full 64 bit 1:1 mapping
that vhost had by default, we can't support such a mapping: users will
have to set up a table with real addresses that actually matches their
address space.
Make the default mapping empty.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 33e06bf..2b65d9b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -170,21 +170,14 @@ long vhost_dev_reset_owner(struct vhost_dev *dev)
 {
 	struct vhost_memory *memory;
 
-	/* Restore memory to default 1:1 mapping. */
-	memory = kmalloc(offsetof(struct vhost_memory, regions) +
-			 2 * sizeof *memory->regions, GFP_KERNEL);
+	/* Restore memory to default empty mapping. */
+	memory = kmalloc(offsetof(struct vhost_memory, regions), GFP_KERNEL);
 	if (!memory)
 		return -ENOMEM;
 
 	vhost_dev_cleanup(dev);
 
-	memory->nregions = 2;
-	memory->regions[0].guest_phys_addr = 1;
-	memory->regions[0].userspace_addr = 1;
-	memory->regions[0].memory_size = ~0ULL;
-	memory->regions[1].guest_phys_addr = 0;
-	memory->regions[1].userspace_addr = 0;
-	memory->regions[1].memory_size = 1;
+	memory->nregions = 0;
 	dev->memory = memory;
 	return 0;
 }
-- 
1.6.6.rc1.43.gf55cc
