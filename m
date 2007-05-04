Return-Path: <linux-kernel-owner+w=401wt.eu-S1031506AbXEDSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031506AbXEDSST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031504AbXEDSSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:18:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:40524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030890AbXEDSSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:18:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,493,1170662400"; 
   d="scan'208";a="242027920"
Date: Fri, 4 May 2007 11:15:40 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       akpm@linux-foundation.org
Subject: [patch 2/7] genhd: expose AN to user space - resend
Message-Id: <20070504111540.219ccfcd.kristen.c.accardi@intel.com>
In-Reply-To: <462DBA33.9060207@gmail.com>
References: <20070424074856.005152262@intel.com>
	<20070423165950.7d64bd8e.kristen.c.accardi@intel.com>
	<462DBA33.9060207@gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow user space to determine if a disk supports Asynchronous Notification
of media changes.  This is done by adding a new sysfs file "capability_flags",
which is documented in (insert file name).  This sysfs file will export all
disk capabilities flags to user space.  We also define a new flag to define
the media change notification capability.

Changed from last version:
* changed sysfs filename to "capability" from "capability_flags"

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/block/genhd.c
===================================================================
--- 2.6-git.orig/block/genhd.c
+++ 2.6-git/block/genhd.c
@@ -370,7 +370,10 @@ static ssize_t disk_size_read(struct gen
 {
 	return sprintf(page, "%llu\n", (unsigned long long)get_capacity(disk));
 }
-
+static ssize_t disk_capability_read(struct gendisk *disk, char *page)
+{
+	return sprintf(page, "%x\n", disk->flags);
+}
 static ssize_t disk_stats_read(struct gendisk * disk, char *page)
 {
 	preempt_disable();
@@ -413,6 +416,10 @@ static struct disk_attribute disk_attr_s
 	.attr = {.name = "size", .mode = S_IRUGO },
 	.show	= disk_size_read
 };
+static struct disk_attribute disk_attr_capability = {
+	.attr = {.name = "capability", .mode = S_IRUGO },
+	.show	= disk_capability_read
+};
 static struct disk_attribute disk_attr_stat = {
 	.attr = {.name = "stat", .mode = S_IRUGO },
 	.show	= disk_stats_read
@@ -453,6 +460,7 @@ static struct attribute * default_attrs[
 	&disk_attr_removable.attr,
 	&disk_attr_size.attr,
 	&disk_attr_stat.attr,
+	&disk_attr_capability.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&disk_attr_fail.attr,
 #endif
Index: 2.6-git/include/linux/genhd.h
===================================================================
--- 2.6-git.orig/include/linux/genhd.h
+++ 2.6-git/include/linux/genhd.h
@@ -94,6 +94,7 @@ struct hd_struct {
 
 #define GENHD_FL_REMOVABLE			1
 #define GENHD_FL_DRIVERFS			2
+#define GENHD_FL_MEDIA_CHANGE_NOTIFY		4
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
Index: 2.6-git/Documentation/block/capability.txt
===================================================================
--- /dev/null
+++ 2.6-git/Documentation/block/capability.txt
@@ -0,0 +1,15 @@
+Generic Block Device Capability
+===============================================================================
+This file documents the sysfs file block/<disk>/capability
+
+capability is a hex word indicating which capabilities a specific disk
+supports.  For more information on bits not listed here, see
+include/linux/genhd.h
+
+Capability				Value
+-------------------------------------------------------------------------------
+GENHD_FL_MEDIA_CHANGE_NOTIFY		4
+	When this bit is set, the disk supports Asynchronous Notification
+	of media change events.  These events will be broadcast to user
+	space via kernel uevent.
+
