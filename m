Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892Ab0AEAve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0AEAve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150Ab0AEAuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:50:55 -0500
Received: from kroah.org ([198.145.64.141]:34187 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab0AEAfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/97] md: Fix unfortunate interaction with evms
Date: Mon,  4 Jan 2010 16:32:42 -0800
Message-Id: <1262651630-7354-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

commit cbd1998377504df005302ac90d49db72a48552a6 upstream.

evms configures md arrays by:
  open device
  send ioctl
  close device

for each different ioctl needed.
Since 2.6.29, the device can disappear after the 'close'
unless a significant configuration has happened to the device.
The change made by "SET_ARRAY_INFO" can too minor to stop the device
from disappearing, but important enough that losing the change is bad.

So: make sure SET_ARRAY_INFO sets mddev->ctime, and keep the device
active as long as ctime is non-zero (it gets zeroed with lots of other
things when the array is stopped).

This is suitable for -stable kernels since 2.6.29.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/md/md.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 02e4551..c6a6685 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -282,7 +282,9 @@ static void mddev_put(mddev_t *mddev)
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
-	    !mddev->hold_active) {
+	    mddev->ctime == 0 && !mddev->hold_active) {
+		/* Array is not configured at all, and not held active,
+		 * so destroy it */
 		list_del(&mddev->all_mddevs);
 		if (mddev->gendisk) {
 			/* we did a probe so need to clean up.
@@ -5071,6 +5073,10 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 		mddev->minor_version = info->minor_version;
 		mddev->patch_version = info->patch_version;
 		mddev->persistent = !info->not_persistent;
+		/* ensure mddev_put doesn't delete this now that there
+		 * is some minimal configuration.
+		 */
+		mddev->ctime         = get_seconds();
 		return 0;
 	}
 	mddev->major_version = MD_MAJOR_VERSION;
-- 
1.6.6

