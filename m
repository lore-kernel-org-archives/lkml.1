Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYEVTaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYEVTaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYEVT35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:29:57 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47299 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYEVT34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:29:56 -0400
Date: Thu, 22 May 2008 14:31:55 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, prussell@au1.ibm.com, shaggy@us.ibm.com,
       sergeh@us.ibm.com
Subject: [PATCH] eCryptfs: Clean up kthread synchronization
Message-ID: <20080522193155.GB4057@halcrowt61p.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080520214610.GD32643@halcrowt61p.austin.ibm.com> <20080521160000.717fb1ef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521160000.717fb1ef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 03:59:59PM -0700, Andrew Morton wrote:
> On Tue, 20 May 2008 16:46:10 -0500
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +extern struct task_struct *ecryptfs_kthread;
> 
> This can be made static to fs/ecryptfs/kthread.c.

Done.

> > +extern struct ecryptfs_kthread_ctl ecryptfs_kthread_ctl;
> 
> I think this guy can be made static too.  As a result of which,
> entire data structure definitions could possibly be pushed down into
> kthread.c?

struct ecryptfs_kthread_ctl can be moved there.

> > +static int ecryptfs_threadfn(void *ignored)

...

> > +out:
> > +	do_exit(0);
> 
> A plain old `return 0;' will suffice here, and is more typical.  I'm
> moderately surprised that do_exit() is exported to modules,
> actually.

Done.

> > +	ecryptfs_kthread = kthread_create(&ecryptfs_threadfn, NULL,
> > +					  "ecryptfs-kthread");
> > +	if (IS_ERR(ecryptfs_kthread)) {
> > +		rc = PTR_ERR(ecryptfs_kthread);
> > +		printk(KERN_ERR "%s: Failed to create kernel thread; rc = [%d]"
> > +		       "\n", __func__, rc);
> > +	}
> > +	wake_up_process(ecryptfs_kthread);
> > +	return rc;
> > +}
> 
> kthread_run() does the kthread_create() and the wake_up_process()
> for you.

Okay.

> > +void ecryptfs_destroy_kthread(void)
> > +{
> > +	struct ecryptfs_open_req tmp_req;
> > +	struct ecryptfs_open_req *req;
> > +
> > +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> > +	ecryptfs_kthread_ctl.flags |= ECRYPTFS_KTHREAD_ZOMBIE;
> > +	list_for_each_entry(req, &ecryptfs_kthread_ctl.req_list,
> > +			    kthread_ctl_list) {
> > +		mutex_lock(&req->mux);
> > +		req->flags |= ECRYPTFS_REQ_ZOMBIE;
> > +		wake_up_process(req->requesting_task);
> > +		mutex_unlock(&req->mux);
> > +	}
> > +	memset(&tmp_req, 0, sizeof(tmp_req));
> > +	tmp_req.flags = ECRYPTFS_REQ_ZOMBIE;
> > +	list_add_tail(&tmp_req.kthread_ctl_list,
> > +		      &ecryptfs_kthread_ctl.req_list);
> > +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> > +	wake_up(&ecryptfs_kthread_ctl.wait);
> > +}
> 
> eh?  We attach a local variable to a global list and then return?
> That won't last very long.

Adding this dummy entry to the list is just my own way of getting the
kthread to wake up and shut down. This actually works, albeit a little
ugly. The list and its contents get dropped on the floor at this point
because (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE). The
only consumer of this list (the kthread) checks for this flag
immediately after getting the mux, and if it is there, it just
exits. The only producer on this list (ecryptfs_privileged_open())
checks for this flag immediately after getting the mux and bows out if
it is set. In other words, once this flag is set, the list and its
contents become untouchable by anything other than
ecryptfs_destroy_kthread().

> > +/**
> > + * ecryptfs_privileged_open
> > + * @lower_file: Result of dentry_open by root on lower dentry
> > + * @lower_dentry: Lower dentry for file to open
> > + * @lower_mnt: Lower vfsmount for file to open
> > + *
> > + * This function gets a r/w file opened againt the lower dentry.
> > + *
> > + * Returns zero on success; non-zero otherwise
> > + */
> > +int ecryptfs_privileged_open(struct file **lower_file,
> > +			     struct dentry *lower_dentry,
> > +			     struct vfsmount *lower_mnt)
> > +{
> > +	struct ecryptfs_open_req *req;
> > +	int rc = 0;
> > +
> > +	/* Corresponding dput() and mntput() are done when the
> > +	 * persistent file is fput() when the eCryptfs inode is
> > +	 * destroyed. */
> > +	dget(lower_dentry);
> > +	mntget(lower_mnt);
> > +	(*lower_file) = dentry_open(lower_dentry, lower_mnt,
> > +				    (O_RDWR | O_LARGEFILE));
> > +	if (!IS_ERR(*lower_file))
> > +		goto out;
> > +	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
> > +	if (!req) {
> > +		rc = -ENOMEM;
> > +		goto out;
> 
> Did we just leak the dentry_open() result?

Nope; IS_ERR(*lower_file) is true.

> > +	}
> > +	mutex_init(&req->mux);
> > +	req->lower_file = lower_file;
> > +	req->lower_dentry = lower_dentry;
> > +	req->lower_mnt = lower_mnt;
> > +	req->requesting_task = current;
> > +	req->flags = 0;
> > +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> > +	mutex_lock(&req->mux);
> > +	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
> > +		rc = -EIO;
> > +		mutex_unlock(&ecryptfs_kthread_ctl.mux);
> > +		printk(KERN_ERR "%s: We are in the middle of shutting down; "
> > +		       "aborting privileged request to open lower file\n",
> > +			__func__);
> > +		goto out_free;
> 
> ditto.

IS_ERR(*lower_file) is true here too.

> > +	}
> > +	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
> > +	mutex_unlock(&req->mux);
> > +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> > +	wake_up(&ecryptfs_kthread_ctl.wait);
> > +schedule:
> > +	set_current_state(TASK_INTERRUPTIBLE);
> > +	schedule();
> 
> This looks racy to me.  I assume we're waiting for ecryptfs_kthread
> to wake us up.  But that thread could have sent us its wakeup
> _before_ we did the set_current_state+schedule.  In which case we
> lost the wakeup and we'll get stuck.
> 
> > +	mutex_lock(&req->mux);
> > +	if (req->flags == 0) {
> > +		mutex_unlock(&req->mux);
> > +		goto schedule;
> > +	}
> > +	set_current_state(TASK_RUNNING);
> 
> This is unneeded.  schedule() always returns in state TASK_RUNNING.

How about just another wait queue then?

---

Replace the schedule/wake_up_process pair with a wait queue.  Just
return from the kthread rather than call do_exit(). Use kthread_run()
rather than kthread_create(). Move struct ecryptfs_kthread_ctl
definition into kthread.c. Remove ecryptfs_kthread reference from
ecryptfs_kernel.h.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |   14 +------------
 fs/ecryptfs/file.c            |    2 +-
 fs/ecryptfs/kthread.c         |   44 +++++++++++++++++++---------------------
 fs/ecryptfs/main.c            |    2 +-
 4 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 8ca910a..c1f4de1 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -561,8 +561,6 @@ extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
 extern struct kmem_cache *ecryptfs_key_tfm_cache;
 extern struct kmem_cache *ecryptfs_open_req_cache;
 
-extern struct task_struct *ecryptfs_kthread;
-
 struct ecryptfs_open_req {
 #define ECRYPTFS_REQ_PROCESSED 0x00000001
 #define ECRYPTFS_REQ_DROPPED   0x00000002
@@ -571,21 +569,11 @@ struct ecryptfs_open_req {
 	struct file **lower_file;
 	struct dentry *lower_dentry;
 	struct vfsmount *lower_mnt;
-	struct task_struct *requesting_task;
+	wait_queue_head_t wait;
 	struct mutex mux;
 	struct list_head kthread_ctl_list;
 };
 
-struct ecryptfs_kthread_ctl {
-#define ECRYPTFS_KTHREAD_ZOMBIE 0x00000001
-	u32 flags;
-	struct mutex mux;
-	struct list_head req_list;
-	wait_queue_head_t wait;
-};
-
-extern struct ecryptfs_kthread_ctl ecryptfs_kthread_ctl;
-
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
 		       int flag);
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index aced6f9..f2b3e56 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -195,7 +195,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	    && !(file->f_flags & O_RDONLY)) {
 		rc = -EPERM;
 		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
-		       "file must thus be opened RO\n", __func__);
+		       "file must hence be opened RO\n", __func__);
 		goto out;
 	}
 	ecryptfs_set_file_lower(
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index 3d34327..4295296 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -26,11 +26,18 @@
 #include <linux/mount.h>
 #include "ecryptfs_kernel.h"
 
-struct task_struct *ecryptfs_kthread;
-struct ecryptfs_kthread_ctl ecryptfs_kthread_ctl;
-
 struct kmem_cache *ecryptfs_open_req_cache;
 
+static struct ecryptfs_kthread_ctl {
+#define ECRYPTFS_KTHREAD_ZOMBIE 0x00000001
+	u32 flags;
+	struct mutex mux;
+	struct list_head req_list;
+	wait_queue_head_t wait;
+} ecryptfs_kthread_ctl;
+
+static struct task_struct *ecryptfs_kthread;
+
 /**
  * ecryptfs_threadfn
  * @ignored: ignored
@@ -58,26 +65,23 @@ static int ecryptfs_threadfn(void *ignored)
 			req = list_first_entry(&ecryptfs_kthread_ctl.req_list,
 					       struct ecryptfs_open_req,
 					       kthread_ctl_list);
-			BUG_ON(!req);
 			mutex_lock(&req->mux);
 			list_del(&req->kthread_ctl_list);
-			if (req->flags & ECRYPTFS_REQ_ZOMBIE)
-				mutex_unlock(&req->mux);
-			else {
+			if (!(req->flags & ECRYPTFS_REQ_ZOMBIE)) {
 				dget(req->lower_dentry);
 				mntget(req->lower_mnt);
 				(*req->lower_file) = dentry_open(
 					req->lower_dentry, req->lower_mnt,
 					(O_RDWR | O_LARGEFILE));
 				req->flags |= ECRYPTFS_REQ_PROCESSED;
-				wake_up_process(req->requesting_task);
-				mutex_unlock(&req->mux);
 			}
+			wake_up(&req->wait);
+			mutex_unlock(&req->mux);
 		}
 		mutex_unlock(&ecryptfs_kthread_ctl.mux);
 	}
 out:
-	do_exit(0);
+	return 0;
 }
 
 int ecryptfs_init_kthread(void)
@@ -87,14 +91,13 @@ int ecryptfs_init_kthread(void)
 	mutex_init(&ecryptfs_kthread_ctl.mux);
 	init_waitqueue_head(&ecryptfs_kthread_ctl.wait);
 	INIT_LIST_HEAD(&ecryptfs_kthread_ctl.req_list);
-	ecryptfs_kthread = kthread_create(&ecryptfs_threadfn, NULL,
-					  "ecryptfs-kthread");
+	ecryptfs_kthread = kthread_run(&ecryptfs_threadfn, NULL,
+				       "ecryptfs-kthread");
 	if (IS_ERR(ecryptfs_kthread)) {
 		rc = PTR_ERR(ecryptfs_kthread);
 		printk(KERN_ERR "%s: Failed to create kernel thread; rc = [%d]"
 		       "\n", __func__, rc);
 	}
-	wake_up_process(ecryptfs_kthread);
 	return rc;
 }
 
@@ -109,11 +112,12 @@ void ecryptfs_destroy_kthread(void)
 			    kthread_ctl_list) {
 		mutex_lock(&req->mux);
 		req->flags |= ECRYPTFS_REQ_ZOMBIE;
-		wake_up_process(req->requesting_task);
+		wake_up(&req->wait);
 		mutex_unlock(&req->mux);
 	}
 	memset(&tmp_req, 0, sizeof(tmp_req));
 	tmp_req.flags = ECRYPTFS_REQ_ZOMBIE;
+	/* Both the list and dummy entry are entirely defunct at this point */
 	list_add_tail(&tmp_req.kthread_ctl_list,
 		      &ecryptfs_kthread_ctl.req_list);
 	mutex_unlock(&ecryptfs_kthread_ctl.mux);
@@ -155,7 +159,7 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	req->lower_file = lower_file;
 	req->lower_dentry = lower_dentry;
 	req->lower_mnt = lower_mnt;
-	req->requesting_task = current;
+	init_waitqueue_head(&req->wait);
 	req->flags = 0;
 	mutex_lock(&ecryptfs_kthread_ctl.mux);
 	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
@@ -169,15 +173,9 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
 	mutex_unlock(&ecryptfs_kthread_ctl.mux);
 	wake_up(&ecryptfs_kthread_ctl.wait);
-schedule:
-	set_current_state(TASK_INTERRUPTIBLE);
-	schedule();
+	wait_event(req->wait, (req->flags != 0));
 	mutex_lock(&req->mux);
-	if (req->flags == 0) {
-		mutex_unlock(&req->mux);
-		goto schedule;
-	}
-	set_current_state(TASK_RUNNING);
+	BUG_ON(req->flags == 0);
 	if (req->flags & ECRYPTFS_REQ_DROPPED
 	    || req->flags & ECRYPTFS_REQ_ZOMBIE) {
 		rc = -EIO;
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 23f272f..f36ab2f 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -789,7 +789,7 @@ static int __init ecryptfs_init(void)
 	rc = ecryptfs_init_kthread();
 	if (rc) {
 		printk(KERN_ERR "%s: kthread initialization failed; "
-		       "rc = [%d]\n", __func__);
+		       "rc = [%d]\n", __func__, rc);
 		goto out_do_sysfs_unregistration;
 	}
 	rc = ecryptfs_init_messaging(ecryptfs_transport);
-- 
1.5.3.6

