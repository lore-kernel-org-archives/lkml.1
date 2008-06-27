Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbYF0Gyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbYF0Gyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbYF0Gue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:50:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:43186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbYF0Gua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:50:30 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:50:23 +1000
Message-Id: <1080627065023.10455@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 010 of 29] md: Enable setting of 'offset' and 'size' of a hot-added spare.
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


offset_store and rdev_size_store allow control of the region of a
device which is to be using in an md/raid array.
They only allow these values to be set when an array is being assembled,
as changing them on an active array could be dangerous.
However when adding a spare device to an array, we might need to
set the offset and size before starting recovery.  So allow
these values to be set also if "->raid_disk < 0" which indicates that
the device is still a spare.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:33:00.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:33:01.000000000 +1000
@@ -1984,7 +1984,7 @@ offset_store(mdk_rdev_t *rdev, const cha
 	unsigned long long offset = simple_strtoull(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
+	if (rdev->mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
 	if (rdev->size && rdev->mddev->external)
 		/* Must set offset before size, so overlap checks
@@ -2023,7 +2023,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (my_mddev->pers)
+	if (my_mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
 	rdev->size = size;
 	if (size > oldsize && rdev->mddev->external) {
