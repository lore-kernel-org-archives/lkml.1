Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbZHMUFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbZHMUFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932294AbZHMUFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:05:00 -0400
Received: from kroah.org ([198.145.64.141]:41888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbZHMT76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:32 2009
Message-Id: <20090813195132.580843987@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 54/74] md: Handle growth of v1.x metadata correctly.
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=md-handle-growth-of-v1.x-metadata-correctly.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Brown <neilb@suse.de>

commit 70471dafe3390243c598a3165dfb86b8b8b3f4fe upstream.

The v1.x metadata does not have a fixed size and can grow
when devices are added.
If it grows enough to require an extra sector of storage,
we need to update the 'sb_size' to match.

Without this, md can write out an incomplete superblock with a
bad checksum, which will be rejected when trying to re-assemble
the array.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1410,8 +1410,14 @@ static void super_1_sync(mddev_t *mddev,
 		if (rdev2->desc_nr+1 > max_dev)
 			max_dev = rdev2->desc_nr+1;
 
-	if (max_dev > le32_to_cpu(sb->max_dev))
+	if (max_dev > le32_to_cpu(sb->max_dev)) {
+		int bmask;
 		sb->max_dev = cpu_to_le32(max_dev);
+		rdev->sb_size = max_dev * 2 + 256;
+		bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
+		if (rdev->sb_size & bmask)
+			rdev->sb_size = (rdev->sb_size | bmask) + 1;
+	}
 	for (i=0; i<max_dev;i++)
 		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	


