Return-Path: <linux-kernel-owner+w=401wt.eu-S1759027AbYCCAUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027AbYCCAUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbYCCARs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:17:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:45726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760335AbYCCARn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:17:43 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:17:53 +1100
Message-Id: <1080303001753.23683@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: [PATCH 008 of 9] md: Fix possible raid1/raid10 deadlock on read error during resync.
References: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks to K.Tanaka and the scsi fault injection framework, here is
a fix for another possible deadlock in raid1/raid10 error handing.

If a read request returns an error while a resync is happening and
a resync request is pending, the attempt to fix the error will block
until the resync progresses, and the resync will block until the
read request completes.  Thus a deadlock.

This patch fixes the problem.

Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c  |   11 +++++++++--
 ./drivers/md/raid10.c |   11 +++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-03-03 11:03:39.000000000 +1100
+++ ./drivers/md/raid10.c	2008-03-03 09:56:53.000000000 +1100
@@ -747,13 +747,20 @@ static void freeze_array(conf_t *conf)
 	/* stop syncio and normal IO and wait for everything to
 	 * go quiet.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until barrier+nr_pending match nr_queued+2
+	 * wait until nr_pending match nr_queued+1
+	 * This is called in the context of one normal IO request
+	 * that has failed. Thus any sync request that might be pending
+	 * will be blocked by nr_pending, and we need to wait for
+	 * pending IO requests to complete or be queued for re-try.
+	 * Thus the number queued (nr_queued) plus this request (1)
+	 * must match the number of pending IOs (nr_pending) before
+	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
+			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
 			       raid10_unplug(conf->mddev->queue); }));

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-03-03 11:03:39.000000000 +1100
+++ ./drivers/md/raid1.c	2008-03-03 09:56:52.000000000 +1100
@@ -704,13 +704,20 @@ static void freeze_array(conf_t *conf)
 	/* stop syncio and normal IO and wait for everything to
 	 * go quite.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until barrier+nr_pending match nr_queued+2
+	 * wait until nr_pending match nr_queued+1
+	 * This is called in the context of one normal IO request
+	 * that has failed. Thus any sync request that might be pending
+	 * will be blocked by nr_pending, and we need to wait for
+	 * pending IO requests to complete or be queued for re-try.
+	 * Thus the number queued (nr_queued) plus this request (1)
+	 * must match the number of pending IOs (nr_pending) before
+	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
+			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
 			       raid1_unplug(conf->mddev->queue); }));
