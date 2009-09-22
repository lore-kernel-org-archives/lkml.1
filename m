Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZIVLvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZIVLvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZIVLvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:51:21 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:65520 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbZIVLvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=nHQujzteJ1m9oNDwEzKJtqZL2BBrcvuHe4SSC2xiclh01/A8vY77NKr0LdtBGNBqhN
         GGVlpLe2+vhQm0UX5EajRJV0pb3nwfwSYOngyh4W0Vt64SO9qQ3SxvRcVPpHuQnMh18U
         ZR61NjInZsJ61na6dMzjDzmFkgDYl1rxlCmGc=
MIME-Version: 1.0
Date: Tue, 22 Sep 2009 13:51:22 +0200
Message-ID: <c4e36d110909220451s5c58a10esc00c1c1d01f6c3a4@mail.gmail.com>
Subject: [PATCH] Make a basic error check for failure in register_disk()
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a basic error check for failure in register_disk() to avoid kernel BUG
when sysfs entry could not be created (i.e. duplicate filename).
Fix is not perfect as register_disk() and add_disk() should probably return
error code in this case but avoids this BUG message:

kernel BUG at fs/sysfs/group.c:65!
 [<ffffffff812d6eac>] ? device_add+0x3c/0x5a0
 [<ffffffff811767c3>] sysfs_create_group+0x13/0x20
 [<ffffffff810c6c14>] blk_trace_init_sysfs+0x14/0x20
 [<ffffffff8121e3b0>] blk_register_queue+0x40/0x100
 [<ffffffff81223438>] add_disk+0xf8/0x170
 [<ffffffffa00bb3aa>] dm_create+0x37a/0x5b0 [dm_mod]
 ...

Problem has been noticed during check of some dm error code path.

Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>

---
 block/genhd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index f4c64c2..317f961 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -544,6 +544,10 @@ void add_disk(struct gendisk *disk)
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
 	register_disk(disk);
+	if (!disk_to_dev(disk)->kobj.parent) {
+		WARN_ON(1);
+		return;
+	}
 	blk_register_queue(disk);

 	bdi = &disk->queue->backing_dev_info;
