Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbXLMOn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbXLMOn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761483AbXLMOnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:43:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761303AbXLMOnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:43:31 -0500
Date: Thu, 13 Dec 2007 14:43:26 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Scott James Remnant <scott@ubuntu.com>
Subject: [2.6.24 PATCH 04/06] dm: trigger change uevent on rename
Message-ID: <20071213144326.GW24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Scott James Remnant <scott@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alasdair G Kergon <agk@redhat.com>

Insert a missing KOBJ_CHANGE notification when a device is renamed.

Cc: Scott James Remnant <scott@ubuntu.com> 
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |    2 ++
 drivers/md/dm.c       |    7 ++++++-
 drivers/md/dm.h       |    2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc5/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-ioctl.c	2007-12-12 15:43:06.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-ioctl.c	2007-12-12 15:43:13.000000000 +0000
@@ -332,6 +332,8 @@ static int dm_hash_rename(const char *ol
 		dm_table_put(table);
 	}
 
+	dm_kobject_uevent(hc->md);
+
 	dm_put(hc->md);
 	up_write(&_hash_lock);
 	kfree(old_name);
Index: linux-2.6.24-rc5/drivers/md/dm.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm.c	2007-12-12 15:43:06.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm.c	2007-12-12 15:43:13.000000000 +0000
@@ -1514,7 +1514,7 @@ int dm_resume(struct mapped_device *md)
 
 	dm_table_unplug_all(map);
 
-	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
+	dm_kobject_uevent(md);
 
 	r = 0;
 
@@ -1528,6 +1528,11 @@ out:
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
+void dm_kobject_uevent(struct mapped_device *md)
+{
+	kobject_uevent(&md->disk->kobj, KOBJ_CHANGE);
+}
+
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
 {
 	return atomic_add_return(1, &md->uevent_seq);
Index: linux-2.6.24-rc5/drivers/md/dm.h
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm.h	2007-12-12 15:43:06.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm.h	2007-12-12 15:43:13.000000000 +0000
@@ -187,4 +187,6 @@ union map_info *dm_get_mapinfo(struct bi
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
 
+void dm_kobject_uevent(struct mapped_device *md);
+
 #endif
