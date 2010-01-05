Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681Ab0AEUOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0AEUOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429Ab0AEUOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:14:30 -0500
Received: from kroah.org ([198.145.64.141]:49960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab0AEUGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:00 2010
Message-Id: <20100105200300.124055854@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: NeilBrown <neilb@suse.de>
Subject: [09/39] md: Fix unfortunate interaction with evms
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -276,7 +276,9 @@ static void mddev_put(mddev_t *mddev)
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
@@ -5040,6 +5042,10 @@ static int set_array_info(mddev_t * mdde
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


