Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbYEASH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbYEASH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYEASHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:07:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52579 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761558AbYEASHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:07:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 1 May 2008 20:06:30 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 update
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.482ea841bba43a82@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive a regression fix for ieee1394 and a trivial bit for firewire.

Stefan Richter (2):
      ieee1394: fix NULL pointer dereference in sysfs access
      firewire: fw-sbp2: log scsi_target ID at release

 drivers/firewire/fw-sbp2.c |    2 +-
 drivers/ieee1394/nodemgr.c |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

Thanks.


commit f32ddaddf95d8a30be5a41cf681bc8792bc42ec7
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Apr 24 23:17:47 2008 +0200

    firewire: fw-sbp2: log scsi_target ID at release
    
    Makes the good-by message more informative.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Signed-off-by: Jarod Wilson <jwilson@redhat.com>

diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 2a99937..62e3c91 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -784,7 +784,7 @@ static void sbp2_release_target(struct kref *kref)
 		kfree(lu);
 	}
 	scsi_remove_host(shost);
-	fw_notify("released %s\n", tgt->bus_id);
+	fw_notify("released %s, target %d:0:0\n", tgt->bus_id, shost->host_no);
 
 	fw_unit_put(tgt->unit);
 	scsi_host_put(shost);

commit 07c7224cf74c3977c69c7c9a0b0fba264f2df36a
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu May 1 10:43:04 2008 +0200

    ieee1394: fix NULL pointer dereference in sysfs access
    
    Regression since "ieee1394: prevent device binding of raw1394,
    video1394, dv1394", commit d2ace29fa44589da51fedc06a67b3f05301f3bfd:
    $ cat /sys/bus/ieee1394/drivers/raw1394/device_ids
    triggers a NULL pointer dereference in fw_show_drv_device_ids.
    Reported by Miles Lane.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
    Tested-by: Miles Lane <miles.lane@gmail.com>

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 70afa37..c6babe8 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -520,8 +520,11 @@ static ssize_t fw_show_drv_device_ids(struct device_driver *drv, char *buf)
 	char *scratch = buf;
 
 	driver = container_of(drv, struct hpsb_protocol_driver, driver);
+	id = driver->id_table;
+	if (!id)
+		return 0;
 
-	for (id = driver->id_table; id->match_flags != 0; id++) {
+	for (; id->match_flags != 0; id++) {
 		int need_coma = 0;
 
 		if (id->match_flags & IEEE1394_MATCH_VENDOR_ID) {
-- 
Stefan Richter
-=====-==--- -=-= ----=
http://arcgraph.de/sr/

