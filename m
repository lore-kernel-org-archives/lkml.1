Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbYEUXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbYEUXAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbYEUXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:00:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbYEUXAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:00:21 -0400
Date: Wed, 21 May 2008 15:59:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, prussell@au1.ibm.com, shaggy@us.ibm.com,
       sergeh@us.ibm.com
Subject: Re: [PATCH] eCryptfs: Privileged kthread for lower file opens
Message-Id: <20080521160000.717fb1ef.akpm@linux-foundation.org>
In-Reply-To: <20080520214610.GD32643@halcrowt61p.austin.ibm.com>
References: <20080520214610.GD32643@halcrowt61p.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 16:46:10 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> eCryptfs would really like to have read-write access to all files in
> the lower filesystem. Right now, the persistent lower file may be
> opened read-only if the attempt to open it read-write fails. One way
> to keep from having to do that is to have a privileged kthread that
> can open the lower persistent file on behalf of the user opening the
> eCryptfs file; this patch implements this functionality.
> 
> This patch will properly allow a less-privileged user to open the
> eCryptfs file, followed by a more-privileged user opening the eCryptfs
> file, with the first user only being able to read and the second user
> being able to both read and write. eCryptfs currently does this wrong;
> it will wind up calling vfs_write() on a file that was opened
> read-only.  This is fixed in this patch.
> 

hm, interesting.  A bit scary though.

>  fs/ecryptfs/main.c            |   42 ++++----
>  5 files changed, 271 insertions(+), 22 deletions(-)
>  create mode 100644 fs/ecryptfs/kthread.c
> 
> diff --git a/fs/ecryptfs/Makefile b/fs/ecryptfs/Makefile
> index 1e34a7f..b4755a8 100644
> --- a/fs/ecryptfs/Makefile
> +++ b/fs/ecryptfs/Makefile
> @@ -4,4 +4,4 @@
>  
>  obj-$(CONFIG_ECRYPT_FS) += ecryptfs.o
>  
> -ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o netlink.o miscdev.o debug.o
> +ecryptfs-objs := dentry.o file.o inode.o main.o super.o mmap.o read_write.o crypto.o keystore.o messaging.o netlink.o miscdev.o kthread.o debug.o
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index 951ee33..8ca910a 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -559,6 +559,32 @@ extern struct kmem_cache *ecryptfs_key_record_cache;
>  extern struct kmem_cache *ecryptfs_key_sig_cache;
>  extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
>  extern struct kmem_cache *ecryptfs_key_tfm_cache;
> +extern struct kmem_cache *ecryptfs_open_req_cache;
> +
> +extern struct task_struct *ecryptfs_kthread;

This can be made static to fs/ecryptfs/kthread.c.

> +struct ecryptfs_open_req {
> +#define ECRYPTFS_REQ_PROCESSED 0x00000001
> +#define ECRYPTFS_REQ_DROPPED   0x00000002
> +#define ECRYPTFS_REQ_ZOMBIE    0x00000004
> +	u32 flags;
> +	struct file **lower_file;
> +	struct dentry *lower_dentry;
> +	struct vfsmount *lower_mnt;
> +	struct task_struct *requesting_task;
> +	struct mutex mux;
> +	struct list_head kthread_ctl_list;
> +};
>
> +struct ecryptfs_kthread_ctl {
> +#define ECRYPTFS_KTHREAD_ZOMBIE 0x00000001
> +	u32 flags;
> +	struct mutex mux;
> +	struct list_head req_list;
> +	wait_queue_head_t wait;
> +};
>
> +extern struct ecryptfs_kthread_ctl ecryptfs_kthread_ctl;

I think this guy can be made static too.  As a result of which, entire
data structure definitions could possibly be pushed down into
kthread.c?

>  int ecryptfs_interpose(struct dentry *hidden_dentry,
>  		       struct dentry *this_dentry, struct super_block *sb,
> @@ -692,5 +718,10 @@ void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx);
>  int
>  ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid,
>  		      struct user_namespace *user_ns, struct pid *pid);
> +int ecryptfs_init_kthread(void);
> +void ecryptfs_destroy_kthread(void);
> +int ecryptfs_privileged_open(struct file **lower_file,
> +			     struct dentry *lower_dentry,
> +			     struct vfsmount *lower_mnt);
>  
>  #endif /* #ifndef ECRYPTFS_KERNEL_H */
> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> index 2258b8f..aced6f9 100644
> --- a/fs/ecryptfs/file.c
> +++ b/fs/ecryptfs/file.c
> @@ -191,6 +191,13 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
>  				      | ECRYPTFS_ENCRYPTED);
>  	}
>  	mutex_unlock(&crypt_stat->cs_mutex);
> +	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
> +	    && !(file->f_flags & O_RDONLY)) {
> +		rc = -EPERM;
> +		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
> +		       "file must thus be opened RO\n", __func__);

"hence" ;)

> +		goto out;
> +	}
>  	ecryptfs_set_file_lower(
>  		file, ecryptfs_inode_to_private(inode)->lower_file);
>  	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
>
> ...
>
> +/**
> + * ecryptfs_threadfn
> + * @ignored: ignored
> + *
> + * The eCryptfs kernel thread that has the responsibility of getting
> + * the lower persistent file with RW permissions.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +static int ecryptfs_threadfn(void *ignored)
> +{
> +	set_freezable();
> +	while (1)  {
> +		struct ecryptfs_open_req *req;
> +
> +		wait_event_freezable(
> +			ecryptfs_kthread_ctl.wait,
> +			!list_empty(&ecryptfs_kthread_ctl.req_list));
> +		mutex_lock(&ecryptfs_kthread_ctl.mux);
> +		if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
> +			mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +			goto out;
> +		}
> +		while (!list_empty(&ecryptfs_kthread_ctl.req_list)) {
> +			req = list_first_entry(&ecryptfs_kthread_ctl.req_list,
> +					       struct ecryptfs_open_req,
> +					       kthread_ctl_list);
> +			BUG_ON(!req);
> +			mutex_lock(&req->mux);
> +			list_del(&req->kthread_ctl_list);
> +			if (req->flags & ECRYPTFS_REQ_ZOMBIE)
> +				mutex_unlock(&req->mux);
> +			else {
> +				dget(req->lower_dentry);
> +				mntget(req->lower_mnt);
> +				(*req->lower_file) = dentry_open(
> +					req->lower_dentry, req->lower_mnt,
> +					(O_RDWR | O_LARGEFILE));
> +				req->flags |= ECRYPTFS_REQ_PROCESSED;
> +				wake_up_process(req->requesting_task);
> +				mutex_unlock(&req->mux);
> +			}
> +		}
> +		mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +	}
> +out:
> +	do_exit(0);

A plain old `return 0;' will suffice here, and is more typical.  I'm
moderately surprised that do_exit() is exported to modules, actually.

> +}
> +
> +int ecryptfs_init_kthread(void)
> +{
> +	int rc = 0;
> +
> +	mutex_init(&ecryptfs_kthread_ctl.mux);
> +	init_waitqueue_head(&ecryptfs_kthread_ctl.wait);
> +	INIT_LIST_HEAD(&ecryptfs_kthread_ctl.req_list);
> +	ecryptfs_kthread = kthread_create(&ecryptfs_threadfn, NULL,
> +					  "ecryptfs-kthread");
> +	if (IS_ERR(ecryptfs_kthread)) {
> +		rc = PTR_ERR(ecryptfs_kthread);
> +		printk(KERN_ERR "%s: Failed to create kernel thread; rc = [%d]"
> +		       "\n", __func__, rc);
> +	}
> +	wake_up_process(ecryptfs_kthread);
> +	return rc;
> +}

kthread_run() does the kthread_create() and the wake_up_process() for you.

> +void ecryptfs_destroy_kthread(void)
> +{
> +	struct ecryptfs_open_req tmp_req;
> +	struct ecryptfs_open_req *req;
> +
> +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> +	ecryptfs_kthread_ctl.flags |= ECRYPTFS_KTHREAD_ZOMBIE;
> +	list_for_each_entry(req, &ecryptfs_kthread_ctl.req_list,
> +			    kthread_ctl_list) {
> +		mutex_lock(&req->mux);
> +		req->flags |= ECRYPTFS_REQ_ZOMBIE;
> +		wake_up_process(req->requesting_task);
> +		mutex_unlock(&req->mux);
> +	}
> +	memset(&tmp_req, 0, sizeof(tmp_req));
> +	tmp_req.flags = ECRYPTFS_REQ_ZOMBIE;
> +	list_add_tail(&tmp_req.kthread_ctl_list,
> +		      &ecryptfs_kthread_ctl.req_list);
> +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +	wake_up(&ecryptfs_kthread_ctl.wait);
> +}

eh?  We attach a local variable to a global list and then return?  That
won't last very long.

> +/**
> + * ecryptfs_privileged_open
> + * @lower_file: Result of dentry_open by root on lower dentry
> + * @lower_dentry: Lower dentry for file to open
> + * @lower_mnt: Lower vfsmount for file to open
> + *
> + * This function gets a r/w file opened againt the lower dentry.
> + *
> + * Returns zero on success; non-zero otherwise
> + */
> +int ecryptfs_privileged_open(struct file **lower_file,
> +			     struct dentry *lower_dentry,
> +			     struct vfsmount *lower_mnt)
> +{
> +	struct ecryptfs_open_req *req;
> +	int rc = 0;
> +
> +	/* Corresponding dput() and mntput() are done when the
> +	 * persistent file is fput() when the eCryptfs inode is
> +	 * destroyed. */
> +	dget(lower_dentry);
> +	mntget(lower_mnt);
> +	(*lower_file) = dentry_open(lower_dentry, lower_mnt,
> +				    (O_RDWR | O_LARGEFILE));
> +	if (!IS_ERR(*lower_file))
> +		goto out;
> +	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
> +	if (!req) {
> +		rc = -ENOMEM;
> +		goto out;

Did we just leak the dentry_open() result?

> +	}
> +	mutex_init(&req->mux);
> +	req->lower_file = lower_file;
> +	req->lower_dentry = lower_dentry;
> +	req->lower_mnt = lower_mnt;
> +	req->requesting_task = current;
> +	req->flags = 0;
> +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> +	mutex_lock(&req->mux);
> +	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
> +		rc = -EIO;
> +		mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +		printk(KERN_ERR "%s: We are in the middle of shutting down; "
> +		       "aborting privileged request to open lower file\n",
> +			__func__);
> +		goto out_free;

ditto.

> +	}
> +	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
> +	mutex_unlock(&req->mux);
> +	mutex_unlock(&ecryptfs_kthread_ctl.mux);
> +	wake_up(&ecryptfs_kthread_ctl.wait);
> +schedule:
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	schedule();

This looks racy to me.  I assume we're waiting for ecryptfs_kthread to
wake us up.  But that thread could have sent us its wakeup _before_ we
did the set_current_state+schedule.  In which case we lost the wakeup
and we'll get stuck.

> +	mutex_lock(&req->mux);
> +	if (req->flags == 0) {
> +		mutex_unlock(&req->mux);
> +		goto schedule;
> +	}
> +	set_current_state(TASK_RUNNING);

This is unneeded.  schedule() always returns in state TASK_RUNNING.

> +	if (req->flags & ECRYPTFS_REQ_DROPPED
> +	    || req->flags & ECRYPTFS_REQ_ZOMBIE) {
> +		rc = -EIO;
> +		printk(KERN_WARNING "%s: Privileged open request dropped\n",
> +		       __func__);
> +		goto out_unlock;
> +	}
> +	if (IS_ERR(*req->lower_file)) {
> +		rc = PTR_ERR(*req->lower_file);
> +		dget(lower_dentry);
> +		mntget(lower_mnt);
> +		(*lower_file) = dentry_open(lower_dentry, lower_mnt,
> +					    (O_RDONLY | O_LARGEFILE));
> +		if (IS_ERR(*lower_file)) {
> +			rc = PTR_ERR(*req->lower_file);
> +			(*lower_file) = NULL;
> +			printk(KERN_WARNING "%s: Error attempting privileged "
> +			       "open of lower file with either RW or RO "
> +			       "perms; rc = [%d]. Giving up.\n",
> +			       __func__, rc);
> +		}
> +	}
> +out_unlock:
> +	mutex_unlock(&req->mux);
> +out_free:
> +	kmem_cache_free(ecryptfs_open_req_cache, req);
> +out:
> +	return rc;
> +}

