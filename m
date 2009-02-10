Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbZBJTGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbZBJTGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZBJTDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:33 -0500
Received: from kroah.org ([198.145.64.141]:53651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754802AbZBJTDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:32 -0500
Date: Tue, 10 Feb 2009 10:59:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [patch 08/53] md: Ensure an md array never has too many devices.
Message-ID: <20090210185956.GI14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="md-ensure-an-md-array-never-has-too-many-devices.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

commit de01dfadf25bf83cfe3d85c163005c4320532658 upstream.

Each different metadata format supported by md supports a
different maximum number of devices.
We really should be enforcing this maximum in the kernel, but
we aren't quite doing that properly.

We currently only enforce it at the 'hot_add' point, which is an
older interface which is not used by current userspace.

We need to also enforce it at 'add_new_disk' time for active arrays
and at 'do_md_run' time when starting a new array.

So move the test from 'hot_add' into 'bind_rdev_to_array' which is
called from both 'hot_add' and 'add_new_disk, and add a new
test in 'analyse_sbs' which is called from 'do_md_run'.

This bug (or missing feature) has been around "forever" and so
the patch is suitable for any -stable that is currently maintained.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1447,6 +1447,11 @@ static int bind_rdev_to_array(mdk_rdev_t
 		if (find_rdev_nr(mddev, rdev->desc_nr))
 			return -EBUSY;
 	}
+	if (mddev->max_disks && rdev->desc_nr >= mddev->max_disks) {
+		printk(KERN_WARNING "md: %s: array is limited to %d devices\n",
+		       mdname(mddev), mddev->max_disks);
+		return -EBUSY;
+	}
 	bdevname(rdev->bdev,b);
 	while ( (s=strchr(b, '/')) != NULL)
 		*s = '!';
@@ -2355,6 +2360,15 @@ static void analyze_sbs(mddev_t * mddev)
 
 	i = 0;
 	rdev_for_each(rdev, tmp, mddev) {
+		if (rdev->desc_nr >= mddev->max_disks ||
+		    i > mddev->max_disks) {
+			printk(KERN_WARNING
+			       "md: %s: %s: only %d devices permitted\n",
+			       mdname(mddev), bdevname(rdev->bdev, b),
+			       mddev->max_disks);
+			kick_rdev_from_array(rdev);
+			continue;
+		}
 		if (rdev != freshest)
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
@@ -4448,13 +4462,6 @@ static int hot_add_disk(mddev_t * mddev,
 	 * noticed in interrupt contexts ...
 	 */
 
-	if (rdev->desc_nr == mddev->max_disks) {
-		printk(KERN_WARNING "%s: can not hot-add to full array!\n",
-			mdname(mddev));
-		err = -EBUSY;
-		goto abort_unbind_export;
-	}
-
 	rdev->raid_disk = -1;
 
 	md_update_sb(mddev, 1);
@@ -4468,9 +4475,6 @@ static int hot_add_disk(mddev_t * mddev,
 	md_new_event(mddev);
 	return 0;
 
-abort_unbind_export:
-	unbind_rdev_from_array(rdev);
-
 abort_export:
 	export_rdev(rdev);
 	return err;

