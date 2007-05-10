Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXEJGXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXEJGXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757706AbXEJGXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:23:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:40825 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbXEJGXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:23:01 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 May 2007 16:22:31 +1000
Message-Id: <1070510062231.20403@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 002 of 2] md: Improve the is_mddev_idle test
References: <20070510161940.20204.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


During a 'resync' or similar activity, md checks if the devices in the
array are otherwise active and winds back resync activity when they
are.  This test in done in is_mddev_idle, and it is somewhat fragile -
it sometimes thinks there is non-sync io when there isn't.

The test compares the total sectors of io (disk_stat_read) with the sectors
of resync io (disk->sync_io).
This has problems because total sectors gets updated when a request completes,
while resync io gets updated when the request is submitted.  The time difference
can cause large differenced between the two which do not actually imply 
non-resync activity.  The test currently allows for some fuzz (+/- 4096)
but there are some cases when it is not enough.

The test currently looks for any (non-fuzz) difference, either
positive or negative.  This clearly is not needed.  Any non-sync
activity will cause the total sectors to grow faster than the sync_io
count (never slower) so we only need to look for a positive differences.

If we do this then the amount of in-flight sync io will never cause
the appearance of non-sync IO.  Once enough non-sync IO to worry about
starts happening, resync will be slowed down and the measurements will
thus be more precise (as there is less in-flight) and control of resync
will still be suitably responsive.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-05-10 15:51:54.000000000 +1000
+++ ./drivers/md/md.c	2007-05-10 16:05:10.000000000 +1000
@@ -5095,7 +5095,7 @@ static int is_mddev_idle(mddev_t *mddev)
 		 *
 		 * Note: the following is an unsigned comparison.
 		 */
-		if ((curr_events - rdev->last_events + 4096) > 8192) {
+		if ((long)curr_events - (long)rdev->last_events > 4096) {
 			rdev->last_events = curr_events;
 			idle = 0;
 		}
