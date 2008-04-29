Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYD2DhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYD2DhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYD2DfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:35:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbYD2De6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:34:58 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 13:35:14 +1000
Message-Id: <1080429033514.20361@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 005 of 9] md: Fix up switching md arrays between read-only and read-write
References: <20080429133104.20146.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When setting an array to 'readonly' or to 'active' via sysfs, we must
make the appropriate set_disk_ro call too.
Also when switching to "read_auto" (which is like readonly, but blocks on the
first write so that metadata can be marked 'dirty') we need to be more careful
about what state we are changing from.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:56.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
@@ -2593,15 +2593,20 @@ array_state_store(mddev_t *mddev, const 
 			err = do_md_stop(mddev, 1);
 		else {
 			mddev->ro = 1;
+			set_disk_ro(mddev->gendisk, 1);
 			err = do_md_run(mddev);
 		}
 		break;
 	case read_auto:
-		/* stopping an active array */
 		if (mddev->pers) {
-			err = do_md_stop(mddev, 1);
-			if (err == 0)
-				mddev->ro = 2; /* FIXME mark devices writable */
+			if (mddev->ro != 1)
+				err = do_md_stop(mddev, 1);
+			else
+				err = restart_array(mddev);
+			if (err == 0) {
+				mddev->ro = 2;
+				set_disk_ro(mddev->gendisk, 0);
+			}
 		} else {
 			mddev->ro = 2;
 			err = do_md_run(mddev);
@@ -2639,6 +2644,7 @@ array_state_store(mddev_t *mddev, const 
 			err = 0;
 		} else {
 			mddev->ro = 0;
+			set_disk_ro(mddev->gendisk, 0);
 			err = do_md_run(mddev);
 		}
 		break;
