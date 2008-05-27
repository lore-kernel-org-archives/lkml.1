Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYE0Gcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYE0Gcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbYE0GcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:32:23 -0400
Received: from ns.suse.de ([195.135.220.2]:53178 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbYE0GcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:32:17 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 27 May 2008 16:32:10 +1000
Message-Id: <1080527063210.16432@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@kernel.org>
Subject: [PATCH 002 of 3] md: fix uninitialized use of mddev->recovery_wait
References: <20080527162558.16305.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Williams <dan.j.williams@intel.com>

If an array was created with --assume-clean we will oops when trying to set
->resync_max.

Fix this by initializing ->recovery_wait in mddev_find.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-27 16:24:02.000000000 +1000
+++ ./drivers/md/md.c	2008-05-27 16:24:34.000000000 +1000
@@ -276,6 +276,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
+	init_waitqueue_head(&new->recovery_wait);
 	new->reshape_position = MaxSector;
 	new->resync_max = MaxSector;
 	new->level = LEVEL_NONE;
@@ -5665,7 +5666,6 @@ void md_do_sync(mddev_t *mddev)
 		window/2,(unsigned long long) max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
-	init_waitqueue_head(&mddev->recovery_wait);
 	last_check = 0;
 
 	if (j>2) {
