Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbXFZTGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbXFZTGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759483AbXFZTFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:34 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25145 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757506AbXFZTFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:32 -0400
Message-Id: <01fb45deb46a8b025306b99876227f626f5543db.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:11 -0400
Subject: [PATCH 06/12] user can ask driver to forget previously detected devices
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When an AoE device is detected, the kernel is informed, and a new
block device is created.  If the device is unused, the block device
corresponding to remote device that is no longer available may be
removed from the system by telling the aoe driver to "flush" its list
of devices.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 Documentation/aoe/mkdevs.sh |    2 +
 Documentation/aoe/udev.txt  |    1 +
 drivers/block/aoe/aoe.h     |    1 +
 drivers/block/aoe/aoechr.c  |    5 ++
 drivers/block/aoe/aoedev.c  |   87 +++++++++++++++++++++++++++++++++---------
 5 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/Documentation/aoe/mkdevs.sh b/Documentation/aoe/mkdevs.sh
index 97374aa..44c0ab7 100644
--- a/Documentation/aoe/mkdevs.sh
+++ b/Documentation/aoe/mkdevs.sh
@@ -29,6 +29,8 @@ rm -f $dir/interfaces
 mknod -m 0200 $dir/interfaces c $MAJOR 4
 rm -f $dir/revalidate
 mknod -m 0200 $dir/revalidate c $MAJOR 5
+rm -f $dir/flush
+mknod -m 0200 $dir/flush c $MAJOR 6
 
 export n_partitions
 mkshelf=`echo $0 | sed 's!mkdevs!mkshelf!'`
diff --git a/Documentation/aoe/udev.txt b/Documentation/aoe/udev.txt
index 17e76c4..8686e78 100644
--- a/Documentation/aoe/udev.txt
+++ b/Documentation/aoe/udev.txt
@@ -20,6 +20,7 @@ SUBSYSTEM=="aoe", KERNEL=="discover",	NAME="etherd/%k", GROUP="disk", MODE="0220
 SUBSYSTEM=="aoe", KERNEL=="err",	NAME="etherd/%k", GROUP="disk", MODE="0440"
 SUBSYSTEM=="aoe", KERNEL=="interfaces",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 SUBSYSTEM=="aoe", KERNEL=="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="flush",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 
 # aoe block devices     
 KERNEL=="etherd*",       NAME="%k", GROUP="disk"
diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index f085465..7fa86dd 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -201,6 +201,7 @@ struct aoedev *aoedev_by_aoeaddr(int maj, int min);
 struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
 int aoedev_isbusy(struct aoedev *d);
+int aoedev_flush(const char __user *str, size_t size);
 
 int aoenet_init(void);
 void aoenet_exit(void);
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 511f995..10b38a7 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -15,6 +15,7 @@ enum {
 	MINOR_DISCOVER,
 	MINOR_INTERFACES,
 	MINOR_REVALIDATE,
+	MINOR_FLUSH,
 	MSGSZ = 2048,
 	NMSG = 100,		/* message backlog to retain */
 };
@@ -43,6 +44,7 @@ static struct aoe_chardev chardevs[] = {
 	{ MINOR_DISCOVER, "discover" },
 	{ MINOR_INTERFACES, "interfaces" },
 	{ MINOR_REVALIDATE, "revalidate" },
+	{ MINOR_FLUSH, "flush" },
 };
 
 static int
@@ -155,6 +157,9 @@ aoechr_write(struct file *filp, const char __user *buf, size_t cnt, loff_t *offp
 		break;
 	case MINOR_REVALIDATE:
 		ret = revalidate(buf, cnt);
+		break;
+	case MINOR_FLUSH:
+		ret = aoedev_flush(buf, cnt);
 	}
 	if (ret == 0)
 		ret = cnt;
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 04c75b4..8659796 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -9,6 +9,10 @@
 #include <linux/netdevice.h>
 #include "aoe.h"
 
+static void dummy_timer(ulong);
+static void aoedev_freedev(struct aoedev *);
+static void freetgt(struct aoetgt *t);
+
 static struct aoedev *devlist;
 static spinlock_t devlist_lock;
 
@@ -108,6 +112,70 @@ aoedev_downdev(struct aoedev *d)
 	d->flags &= ~DEVFL_UP;
 }
 
+static void
+aoedev_freedev(struct aoedev *d)
+{
+	struct aoetgt **t, **e;
+
+	if (d->gd) {
+		aoedisk_rm_sysfs(d);
+		del_gendisk(d->gd);
+		put_disk(d->gd);
+	}
+	t = d->targets;
+	e = t + NTARGETS;
+	for (; t<e && *t; t++)
+		freetgt(*t);
+	if (d->bufpool)
+		mempool_destroy(d->bufpool);
+	kfree(d);
+}
+
+int
+aoedev_flush(const char __user *str, size_t cnt)
+{
+	ulong flags;
+	struct aoedev *d, **dd;
+	struct aoedev *rmd = NULL;
+	char buf[16];
+	int all = 0;
+
+	if (cnt >= 3) {
+		if (cnt > sizeof buf)
+			cnt = sizeof buf;
+		if (copy_from_user(buf, str, cnt))
+			return -EFAULT;
+		all = !strncmp(buf, "all", 3);
+	}
+
+	flush_scheduled_work();
+	spin_lock_irqsave(&devlist_lock, flags);
+	dd = &devlist;
+	while ((d=*dd)) {
+		spin_lock(&d->lock);
+		if ((!all && (d->flags & DEVFL_UP))
+		|| (d->flags & (DEVFL_GDALLOC|DEVFL_NEWSIZE))
+		|| d->nopen) {
+			spin_unlock(&d->lock);
+			dd = &d->next;
+			continue;
+		}
+		*dd = d->next;
+		aoedev_downdev(d);
+		d->flags |= DEVFL_TKILL;
+		spin_unlock(&d->lock);
+		d->next = rmd;
+		rmd = d;
+	}
+	spin_unlock_irqrestore(&devlist_lock, flags);
+	while ((d=rmd)) {
+		rmd = d->next;
+		del_timer_sync(&d->timer);
+		aoedev_freedev(d);	// must be able to sleep
+	}
+	return 0;
+}
+
 /* find it or malloc it */
 struct aoedev *
 aoedev_by_sysminor_m(ulong sysminor)
@@ -160,25 +228,6 @@ freetgt(struct aoetgt *t)
 	kfree(t);
 }
 
-static void
-aoedev_freedev(struct aoedev *d)
-{
-	struct aoetgt **t, **e;
-
-	if (d->gd) {
-		aoedisk_rm_sysfs(d);
-		del_gendisk(d->gd);
-		put_disk(d->gd);
-	}
-	t = d->targets;
-	e = t + NTARGETS;
-	for (; t<e && *t; t++)
-		freetgt(*t);
-	if (d->bufpool)
-		mempool_destroy(d->bufpool);
-	kfree(d);
-}
-
 void
 aoedev_exit(void)
 {
-- 
1.5.2.1

