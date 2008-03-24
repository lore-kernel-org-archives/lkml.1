Return-Path: <linux-kernel-owner+w=401wt.eu-S1759607AbYCXQQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607AbYCXQQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYCXQQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:16:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:42813 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752687AbYCXQQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:16:10 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX18bos9OR8QbJvAciUde3zezK9dDiMOluVHwUyS9b9
	2W/ygSWwzQCrfG
From: Bernd Schubert <bernd-schubert@gmx.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: deadline unfairness
Date: Mon, 24 Mar 2008 17:16:05 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, bs@q-leap.de
References: <200803221225.26728.bernd-schubert@gmx.de> <alpine.LNX.1.00.0803230037240.28078@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.00.0803230037240.28078@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803241716.06049.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan,

On Sunday 23 March 2008, Jan Engelhardt wrote:
> On Mar 22 2008 12:25, Bernd Schubert wrote:
> > some it seems the deadline scheduler is rather unfair. Below is an
> > example of md-raid6 initialization of md3, md4 and md5. All three
> > md-devices do share the same blockdevices (we have patched md to allow
> > parallel rebuild of shared block devices, since for us the cpu is the
> > bottleneck and not the block device).
>
> Could you share this patch? It would be really intersting for use
> with fast based block devices (flash, ramdisk, and such)!

I already tried to push the patch to Neil, but I guess Neil was to busy to 
look at it. The patch below is for 2.6.22, but it applies to 2.6.25-git.


Signed-off-by: Bernd Schubert <bs@q-leap.de>

Index: linux-2.6.22/drivers/md/md.c
===================================================================
--- linux-2.6.22.orig/drivers/md/md.c	2007-12-06 19:51:55.000000000 +0100
+++ linux-2.6.22/drivers/md/md.c	2007-12-07 12:07:47.000000000 +0100
@@ -74,6 +74,8 @@ static DEFINE_SPINLOCK(pers_lock);
 
 static void md_print_devices(void);
 
+static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
+
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, 
__LINE__); md_print_devices(); }
 
 /*
@@ -2843,6 +2845,34 @@ __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, 
 
 
 static ssize_t
+sync_force_parallel_show(mddev_t *mddev, char *page)
+{
+        return sprintf(page, "%d\n", mddev->parallel_resync);
+}
+
+static ssize_t
+sync_force_parallel_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+
+	if (!*buf || (*e && *e != '\n') || (n != 0 && n != 1))
+		return -EINVAL;
+
+	mddev->parallel_resync = n;
+
+	if (mddev->sync_thread) {
+		wake_up(&resync_wait);
+	}
+	return len;
+}
+
+/* force parallel resync, even with shared block devices */
+static struct md_sysfs_entry md_sync_force_parallel =
+__ATTR(sync_force_parallel, S_IRUGO|S_IWUSR,
+       sync_force_parallel_show, sync_force_parallel_store);
+
+static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
 {
 	unsigned long resync, dt, db;
@@ -2980,6 +3010,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
+	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
@@ -5199,8 +5230,6 @@ void md_allow_write(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
-static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 void md_do_sync(mddev_t *mddev)
@@ -5264,8 +5293,9 @@ void md_do_sync(mddev_t *mddev)
 		ITERATE_MDDEV(mddev2,tmp) {
 			if (mddev2 == mddev)
 				continue;
-			if (mddev2->curr_resync && 
-			    match_mddev_units(mddev,mddev2)) {
+			if (!mddev->parallel_resync
+			&&  mddev2->curr_resync
+			&&  match_mddev_units(mddev,mddev2)) {
 				DEFINE_WAIT(wq);
 				if (mddev < mddev2 && mddev->curr_resync == 2) {
 					/* arbitrarily yield */
Index: linux-2.6.22/include/linux/raid/md_k.h
===================================================================
--- linux-2.6.22.orig/include/linux/raid/md_k.h	2007-12-06 19:51:55.000000000 
+0100
+++ linux-2.6.22/include/linux/raid/md_k.h	2007-12-06 19:52:33.000000000 +0100
@@ -170,6 +170,9 @@ struct mddev_s
 	int				sync_speed_min;
 	int				sync_speed_max;
 
+	/* resync even though the same disks are shared among md-devices */
+	int				parallel_resync;
+
 	int				ok_start_degraded;
 	/* recovery/resync flags 
 	 * NEEDED:   we might need to start a resync/recover

