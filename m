Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbYFBVd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbYFBVd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYFBVdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:33:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35047 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbYFBVdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:33:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [RFC][PATCH] snapshot: Use pm_mutex for mutual exclusion
Date: Mon, 2 Jun 2008 23:33:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, pm list <linux-pm@lists.linux-foundation.org>
References: <20080522222500.0f5873ff@core> <20080523120452.6feefed0@core> <200805231322.33321.rjw@sisk.pl>
In-Reply-To: <200805231322.33321.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806022333.56939.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 23 of May 2008, Rafael J. Wysocki wrote:
> On Friday, 23 of May 2008, Alan Cox wrote:
> > > >  
> > > > +	lock_kernel();
> > > > +
> > > 
> > > Hm, well, I admit I'm a bit ignorant as far as the chardev locking is
> > > concerned, but can you please tell me why would that be wrong if we didn't call
> > > lock_kernel() here at all?
> > 
> > I've just been pushing the lock down. If the code already has enough
> > internal locking for things like multiple ioctls in parallel then you can
> > probably kill it entirely - but that needs someone who knows that driver
> > well to decide and evaluate.
> 
> Thanks, I'll have a look.

Appended is what I think we can do.

Thanks,
Rafael

---
We can avoid taking the BKL in snapshot_ioctl() if pm_mutex is used to prevent
the ioctls from being executed concurrently.

In addition, although it is only possible to open /dev/snapshot once, the task
which has done that may spawn a child that will inherit the open descriptor,
so in theory they can call snapshot_write(), snapshot_read() and
snapshot_release() concurrently.  pm_mutex can also be used for mutual
exclusion in such cases.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |   68 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 26 deletions(-)

Index: linux-2.6/kernel/power/user.c
===================================================================
--- linux-2.6.orig/kernel/power/user.c
+++ linux-2.6/kernel/power/user.c
@@ -70,16 +70,22 @@ static int snapshot_open(struct inode *i
 	struct snapshot_data *data;
 	int error;
 
-	if (!atomic_add_unless(&snapshot_device_available, -1, 0))
-		return -EBUSY;
+	mutex_lock(&pm_mutex);
+
+	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
+		error = -EBUSY;
+		goto Unlock;
+	}
 
 	if ((filp->f_flags & O_ACCMODE) == O_RDWR) {
 		atomic_inc(&snapshot_device_available);
-		return -ENOSYS;
+		error = -ENOSYS;
+		goto Unlock;
 	}
 	if(create_basic_memory_bitmaps()) {
 		atomic_inc(&snapshot_device_available);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto Unlock;
 	}
 	nonseekable_open(inode, filp);
 	data = &snapshot_state;
@@ -99,33 +105,36 @@ static int snapshot_open(struct inode *i
 		if (error)
 			pm_notifier_call_chain(PM_POST_HIBERNATION);
 	}
-	if (error) {
+	if (error)
 		atomic_inc(&snapshot_device_available);
-		return error;
-	}
 	data->frozen = 0;
 	data->ready = 0;
 	data->platform_support = 0;
 
-	return 0;
+ Unlock:
+	mutex_unlock(&pm_mutex);
+
+	return error;
 }
 
 static int snapshot_release(struct inode *inode, struct file *filp)
 {
 	struct snapshot_data *data;
 
+	mutex_lock(&pm_mutex);
+
 	swsusp_free();
 	free_basic_memory_bitmaps();
 	data = filp->private_data;
 	free_all_swap_pages(data->swap);
-	if (data->frozen) {
-		mutex_lock(&pm_mutex);
+	if (data->frozen)
 		thaw_processes();
-		mutex_unlock(&pm_mutex);
-	}
 	pm_notifier_call_chain(data->mode == O_WRONLY ?
 			PM_POST_HIBERNATION : PM_POST_RESTORE);
 	atomic_inc(&snapshot_device_available);
+
+	mutex_unlock(&pm_mutex);
+
 	return 0;
 }
 
@@ -135,9 +144,13 @@ static ssize_t snapshot_read(struct file
 	struct snapshot_data *data;
 	ssize_t res;
 
+	mutex_lock(&pm_mutex);
+
 	data = filp->private_data;
-	if (!data->ready)
-		return -ENODATA;
+	if (!data->ready) {
+		res = -ENODATA;
+		goto Unlock;
+	}
 	res = snapshot_read_next(&data->handle, count);
 	if (res > 0) {
 		if (copy_to_user(buf, data_of(data->handle), res))
@@ -145,6 +158,10 @@ static ssize_t snapshot_read(struct file
 		else
 			*offp = data->handle.offset;
 	}
+
+ Unlock:
+	mutex_unlock(&pm_mutex);
+
 	return res;
 }
 
@@ -154,6 +171,8 @@ static ssize_t snapshot_write(struct fil
 	struct snapshot_data *data;
 	ssize_t res;
 
+	mutex_lock(&pm_mutex);
+
 	data = filp->private_data;
 	res = snapshot_write_next(&data->handle, count);
 	if (res > 0) {
@@ -162,6 +181,9 @@ static ssize_t snapshot_write(struct fil
 		else
 			*offp = data->handle.offset;
 	}
+
+	mutex_unlock(&pm_mutex);
+
 	return res;
 }
 
@@ -180,16 +202,16 @@ static long snapshot_ioctl(struct file *
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	data = filp->private_data;
+	if (!mutex_trylock(&pm_mutex))
+		return -EBUSY;
 
-	lock_kernel();
+	data = filp->private_data;
 
 	switch (cmd) {
 
 	case SNAPSHOT_FREEZE:
 		if (data->frozen)
 			break;
-		mutex_lock(&pm_mutex);
 		printk("Syncing filesystems ... ");
 		sys_sync();
 		printk("done.\n");
@@ -197,7 +219,6 @@ static long snapshot_ioctl(struct file *
 		error = freeze_processes();
 		if (error)
 			thaw_processes();
-		mutex_unlock(&pm_mutex);
 		if (!error)
 			data->frozen = 1;
 		break;
@@ -205,9 +226,7 @@ static long snapshot_ioctl(struct file *
 	case SNAPSHOT_UNFREEZE:
 		if (!data->frozen || data->ready)
 			break;
-		mutex_lock(&pm_mutex);
 		thaw_processes();
-		mutex_unlock(&pm_mutex);
 		data->frozen = 0;
 		break;
 
@@ -310,16 +329,11 @@ static long snapshot_ioctl(struct file *
 			error = -EPERM;
 			break;
 		}
-		if (!mutex_trylock(&pm_mutex)) {
-			error = -EBUSY;
-			break;
-		}
 		/*
 		 * Tasks are frozen and the notifiers have been called with
 		 * PM_HIBERNATION_PREPARE
 		 */
 		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
-		mutex_unlock(&pm_mutex);
 		break;
 
 	case SNAPSHOT_PLATFORM_SUPPORT:
@@ -392,7 +406,9 @@ static long snapshot_ioctl(struct file *
 		error = -ENOTTY;
 
 	}
-	unlock_kernel();
+
+	mutex_unlock(&pm_mutex);
+
 	return error;
 }
 
