Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYF0Gvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYF0Gvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYF0Gtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:49:46 -0400
Received: from mail.suse.de ([195.135.220.2]:46663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbYF0Gto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:49:44 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:49:36 +1000
Message-Id: <1080627064936.10320@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>
Subject: [PATCH 003 of 29] md: Fix error paths if md_probe fails.
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


md_probe can fail (e.g. alloc_disk could fail) without
returning an error (as it alway returns NULL).
So when we call mddev_find immediately afterwards, we need
to check that md_probe actually succeeded.  This means checking
that mdev->gendisk is non-NULL.

cc: <stable@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:14:04.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:31:08.000000000 +1000
@@ -3897,8 +3897,10 @@ static void autorun_devices(int part)
 
 		md_probe(dev, NULL, NULL);
 		mddev = mddev_find(dev);
-		if (!mddev) {
-			printk(KERN_ERR 
+		if (!mddev || !mddev->gendisk) {
+			if (mddev)
+				mddev_put(mddev);
+			printk(KERN_ERR
 				"md: cannot allocate memory for md drive.\n");
 			break;
 		}
