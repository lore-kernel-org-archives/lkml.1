Return-Path: <linux-kernel-owner+w=401wt.eu-S1946278AbXBCCjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946278AbXBCCjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946263AbXBCCjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:39:48 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53265 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946264AbXBCCja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:39:30 -0500
Message-Id: <20070203024358.952345000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:44 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 40/59] md: fix a few problems with the interface (sysfs and ioctl) to md.
Content-Disposition: inline; filename=md-fix-a-few-problems-with-the-interface-to-md.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

While developing more functionality in mdadm I found some bugs in md...

- When we remove a device from an inactive array (write 'remove' to 
  the 'state' sysfs file - see 'state_store') would should not
  update the superblock information - as we may not have
  read and processed it all properly yet.

- initialise all raid_disk entries to '-1' else the 'slot sysfs file
  will claim '0' for all devices in an array before the array is
  started.

- all '\n' not to be present at the end of words written to
  sysfs files
- when we use SET_ARRAY_INFO to set the md metadata version,
  set the flag to say that there is persistant metadata.
- allow GET_BITMAP_FILE to be called on an array that hasn't
  been started yet.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/md/md.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- linux-2.6.19.2.orig/drivers/md/md.c
+++ linux-2.6.19.2/drivers/md/md.c
@@ -1792,7 +1792,8 @@ state_store(mdk_rdev_t *rdev, const char
 		else {
 			mddev_t *mddev = rdev->mddev;
 			kick_rdev_from_array(rdev);
-			md_update_sb(mddev, 1);
+			if (mddev->pers)
+				md_update_sb(mddev, 1);
 			md_new_event(mddev);
 			err = 0;
 		}
@@ -2004,6 +2005,7 @@ static mdk_rdev_t *md_import_device(dev_
 
 	rdev->desc_nr = -1;
 	rdev->saved_raid_disk = -1;
+	rdev->raid_disk = -1;
 	rdev->flags = 0;
 	rdev->data_offset = 0;
 	rdev->sb_events = 0;
@@ -2233,7 +2235,6 @@ static int update_raid_disks(mddev_t *md
 static ssize_t
 raid_disks_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	/* can only set raid_disks if array is not yet active */
 	char *e;
 	int rv = 0;
 	unsigned long n = simple_strtoul(buf, &e, 10);
@@ -2631,7 +2632,7 @@ metadata_store(mddev_t *mddev, const cha
 		return -EINVAL;
 	buf = e+1;
 	minor = simple_strtoul(buf, &e, 10);
-	if (e==buf || *e != '\n')
+	if (e==buf || (*e && *e != '\n') )
 		return -EINVAL;
 	if (major >= sizeof(super_types)/sizeof(super_types[0]) ||
 	    super_types[major].name == NULL)
@@ -3978,6 +3979,7 @@ static int set_array_info(mddev_t * mdde
 		mddev->major_version = info->major_version;
 		mddev->minor_version = info->minor_version;
 		mddev->patch_version = info->patch_version;
+		mddev->persistent = ! info->not_persistent;
 		return 0;
 	}
 	mddev->major_version = MD_MAJOR_VERSION;
@@ -4302,9 +4304,10 @@ static int md_ioctl(struct inode *inode,
 	 * Commands querying/configuring an existing array:
 	 */
 	/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
-	 * RUN_ARRAY, and SET_BITMAP_FILE are allowed */
+	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
 	if (!mddev->raid_disks && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
-			&& cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE) {
+			&& cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
+	    		&& cmd != GET_BITMAP_FILE) {
 		err = -ENODEV;
 		goto abort_unlock;
 	}

--
