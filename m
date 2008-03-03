Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbYCCATG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbYCCATG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758770AbYCCARY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:24 -0500
Received: from ns2.suse.de ([195.135.220.15]:45678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337AbYCCARW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:22 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:17:30 +1100
Message-Id: <1080303001730.23637@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 005 of 9] md: Make sure a reshape is started when device switches to read-write.
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A resync/reshape/recovery thread will refuse to progress when the
array is marked read-only.  So whenever it mark it not read-only, it
is important to wake up thread resync thread.
There is one place we didn't do this.

The problem manifests if the start_ro module parameters is set, and a
raid5 array that is in the middle of a reshape (restripe) is started.
The array will initially be semi-read-only (meaning it acts like it is
readonly until the first write).  So the reshape will not proceed.

On the first write, the array will become read-write, but the reshape
will not be started, and there is no event which will ever restart
that thread.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-02-22 15:46:25.000000000 +1100
+++ ./drivers/md/md.c	2008-02-22 15:46:52.000000000 +1100
@@ -5356,6 +5356,7 @@ void md_write_start(mddev_t *mddev, stru
 		mddev->ro = 0;
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		md_wakeup_thread(mddev->thread);
+		md_wakeup_thread(mddev->sync_thread);
 	}
 	atomic_inc(&mddev->writes_pending);
 	if (mddev->in_sync) {
