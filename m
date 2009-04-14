Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbZDNV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbZDNV2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZDNV2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:28:05 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49276 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbZDNV16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XlAm3skz6/hSZS5p4HR+nlgDEa5M+ZgHnC1H/1Rko7tnb6s8XmSho/wSML9CkDQN5c
         oNEpXpqVE5AWBfaXfXWm6uaGL10rYwn4jAbS+6m9nfd547OpDtXRAeM3aC+iriUOzdG1
         E0YGkD3k7Xpj+jdMn4dXSEk4a7P6tbPh8UD4I=
Date: Tue, 14 Apr 2009 23:27:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>, Jeff Mahoney <jeffm@suse.com>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [tree] latest kill-the-BKL tree, v12
Message-ID: <20090414212749.GE5968@nowhere>
References: <1239680065-25013-1-git-send-email-fweisbec@gmail.com> <20090414045109.GA26908@orion> <20090414090146.GH27003@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414090146.GH27003@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:01:46AM +0200, Ingo Molnar wrote:
> 
> * Alexander Beregalov <a.beregalov@gmail.com> wrote:
> 
> > On Tue, Apr 14, 2009 at 05:34:22AM +0200, Frederic Weisbecker wrote:
> > > Ingo,
> > > 
> > > This small patchset fixes some deadlocks I've faced after trying
> > > some pressures with dbench on a reiserfs partition.
> > > 
> > > There is still some work pending such as adding some checks to ensure we
> > > _always_ release the lock before sleeping, as you suggested.
> > > Also I have to fix a lockdep warning reported by Alessio Igor Bogani.
> > > And also some optimizations....
> > > 
> > > Thanks,
> > > Frederic.
> > > 
> > > Frederic Weisbecker (3):
> > >   kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
> > >   kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
> > >   kill-the-BKL/reiserfs: only acquire the write lock once in
> > >     reiserfs_dirty_inode
> > > 
> > >  fs/reiserfs/inode.c         |   10 +++++++---
> > >  fs/reiserfs/lock.c          |   26 ++++++++++++++++++++++++++
> > >  fs/reiserfs/super.c         |   15 +++++++++------
> > >  include/linux/reiserfs_fs.h |    2 ++
> > >  4 files changed, 44 insertions(+), 9 deletions(-)
> > > 
> > 
> > Hi
> > 
> > The same test - dbench on reiserfs on loop on sparc64.
> > 
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.30-rc1-00457-gb21597d-dirty #2
> 
> I'm wondering ... your version hash suggests you used vanilla 
> upstream as a base for your test. There's a string of other fixes 
> from Frederic in tip:core/kill-the-BKL branch, have you picked them 
> all up when you did your testing?


Indeed, I fixed it (at least looks like the same warn) 
in a previous patch. I forgot to cc Alexander for this one.


> 
> The most coherent way to test this would be to pick up the latest 
> core/kill-the-BKL git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/kill-the-BKL
> 
> Or you can also try the combo patch below (against latest mainline). 
> The tree already includes the latest 3 fixes from Frederic as well, 
> so it should be a one-stop-shop.
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Alessio Igor Bogani (17):
>       remove the BKL: Remove BKL from tracer registration
>       drivers/char/generic_nvram.c: Replace the BKL with a mutex
>       isofs: Remove BKL
>       kernel/sys.c: Replace the BKL with a mutex
>       sound/oss/au1550_ac97.c: Remove BKL
>       sound/oss/soundcard.c: Use &inode->i_mutex instead of the BKL
>       sound/sound_core.c: Use &inode->i_mutex instead of the BKL
>       drivers/bluetooth/hci_vhci.c: Use &inode->i_mutex instead of the BKL
>       sound/oss/vwsnd.c: Remove BKL
>       sound/core/sound.c: Use &inode->i_mutex instead of the BKL
>       drivers/char/nvram.c: Remove BKL
>       sound/oss/msnd_pinnacle.c: Use &inode->i_mutex instead of the BKL
>       drivers/char/nvram.c: Use &inode->i_mutex instead of the BKL
>       sound/core/info.c: Use &inode->i_mutex instead of the BKL
>       sound/oss/dmasound/dmasound_core.c: Use &inode->i_mutex instead of the BKL
>       remove the BKL: remove "BKL auto-drop" assumption from svc_recv()
>       remove the BKL: remove "BKL auto-drop" assumption from nfs3_rpc_wrapper()
> 
> Frederic Weisbecker (6):
>       reiserfs: kill-the-BKL
>       kill-the-BKL: fix missing #include smp_lock.h
>       reiserfs, kill-the-BKL: fix unsafe j_flush_mutex lock


It was the above one.

Frederic.


>       kill-the-BKL/reiserfs: provide a tool to lock only once the write lock
>       kill-the-BKL/reiserfs: lock only once in reiserfs_truncate_file
>       kill-the-BKL/reiserfs: only acquire the write lock once in reiserfs_dirty_inode
> 
> Ingo Molnar (21):
>       revert ("BKL: revert back to the old spinlock implementation")
>       remove the BKL: change get_fs_type() BKL dependency
>       remove the BKL: reduce BKL locking during bootup
>       remove the BKL: restruct ->bd_mutex and BKL dependency
>       remove the BKL: change ext3 BKL assumption
>       remove the BKL: reduce misc_open() BKL dependency
>       remove the BKL: remove "BKL auto-drop" assumption from vt_waitactive()
>       remove the BKL: remove it from the core kernel!
>       softlockup helper: print BKL owner
>       remove the BKL: flush_workqueue() debug helper & fix
>       remove the BKL: tty updates
>       remove the BKL: lockdep self-test fix
>       remove the BKL: request_module() debug helper
>       remove the BKL: procfs debug helper and BKL elimination
>       remove the BKL: do not take the BKL in init code
>       remove the BKL: restructure NFS code
>       tty: fix BKL related leak and crash
>       remove the BKL: fix UP build
>       remove the BKL: use the BKL mutex on !SMP too
>       remove the BKL: merge fix
>       remove the BKL: fix build in fs/proc/generic.c
> 
> 
>  arch/mn10300/Kconfig               |   11 +++
>  drivers/bluetooth/hci_vhci.c       |   15 ++--
>  drivers/char/generic_nvram.c       |   10 ++-
>  drivers/char/misc.c                |    8 ++
>  drivers/char/nvram.c               |   11 +--
>  drivers/char/tty_ldisc.c           |   14 +++-
>  drivers/char/vt_ioctl.c            |    8 ++
>  fs/block_dev.c                     |    4 +-
>  fs/ext3/super.c                    |    4 -
>  fs/filesystems.c                   |   14 ++++
>  fs/isofs/dir.c                     |    3 -
>  fs/isofs/inode.c                   |    4 -
>  fs/isofs/namei.c                   |    3 -
>  fs/isofs/rock.c                    |    3 -
>  fs/nfs/nfs3proc.c                  |    7 ++
>  fs/proc/generic.c                  |    7 ++-
>  fs/proc/root.c                     |    2 +
>  fs/reiserfs/Makefile               |    2 +-
>  fs/reiserfs/bitmap.c               |    2 +
>  fs/reiserfs/dir.c                  |    8 ++
>  fs/reiserfs/fix_node.c             |   10 +++
>  fs/reiserfs/inode.c                |   33 ++++++--
>  fs/reiserfs/ioctl.c                |    6 +-
>  fs/reiserfs/journal.c              |  136 +++++++++++++++++++++++++++--------
>  fs/reiserfs/lock.c                 |   89 ++++++++++++++++++++++
>  fs/reiserfs/resize.c               |    2 +
>  fs/reiserfs/stree.c                |    2 +
>  fs/reiserfs/super.c                |   56 ++++++++++++--
>  include/linux/hardirq.h            |   18 ++---
>  include/linux/reiserfs_fs.h        |   14 ++-
>  include/linux/reiserfs_fs_sb.h     |    9 ++
>  include/linux/smp_lock.h           |   36 ++-------
>  init/Kconfig                       |    5 -
>  init/main.c                        |    7 +-
>  kernel/fork.c                      |    4 +
>  kernel/hung_task.c                 |    3 +
>  kernel/kmod.c                      |   22 ++++++
>  kernel/sched.c                     |   16 +----
>  kernel/softlockup.c                |    1 +
>  kernel/sys.c                       |   15 ++--
>  kernel/trace/trace.c               |    8 --
>  kernel/workqueue.c                 |   13 +++
>  lib/Makefile                       |    3 +-
>  lib/kernel_lock.c                  |  142 ++++++++++--------------------------
>  net/sunrpc/sched.c                 |    6 ++
>  net/sunrpc/svc_xprt.c              |   13 +++
>  sound/core/info.c                  |    6 +-
>  sound/core/sound.c                 |    5 +-
>  sound/oss/au1550_ac97.c            |    7 --
>  sound/oss/dmasound/dmasound_core.c |   14 ++--
>  sound/oss/msnd_pinnacle.c          |    6 +-
>  sound/oss/soundcard.c              |   33 +++++----
>  sound/oss/vwsnd.c                  |    3 -
>  sound/sound_core.c                 |    6 +-
>  54 files changed, 571 insertions(+), 318 deletions(-)
>  create mode 100644 fs/reiserfs/lock.c
> 
> diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
> index 3559267..adeae17 100644
> --- a/arch/mn10300/Kconfig
> +++ b/arch/mn10300/Kconfig
> @@ -186,6 +186,17 @@ config PREEMPT
>  	  Say Y here if you are building a kernel for a desktop, embedded
>  	  or real-time system.  Say N if you are unsure.
>  
> +config PREEMPT_BKL
> +	bool "Preempt The Big Kernel Lock"
> +	depends on PREEMPT
> +	default y
> +	help
> +	  This option reduces the latency of the kernel by making the
> +	  big kernel lock preemptible.
> +
> +	  Say Y here if you are building a kernel for a desktop system.
> +	  Say N if you are unsure.
> +
>  config MN10300_CURRENT_IN_E2
>  	bool "Hold current task address in E2 register"
>  	default y
> diff --git a/drivers/bluetooth/hci_vhci.c b/drivers/bluetooth/hci_vhci.c
> index 0bbefba..28b0cb9 100644
> --- a/drivers/bluetooth/hci_vhci.c
> +++ b/drivers/bluetooth/hci_vhci.c
> @@ -28,7 +28,7 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  #include <linux/types.h>
>  #include <linux/errno.h>
>  #include <linux/sched.h>
> @@ -259,11 +259,11 @@ static int vhci_open(struct inode *inode, struct file *file)
>  	skb_queue_head_init(&data->readq);
>  	init_waitqueue_head(&data->read_wait);
>  
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	hdev = hci_alloc_dev();
>  	if (!hdev) {
>  		kfree(data);
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -ENOMEM;
>  	}
>  
> @@ -284,12 +284,12 @@ static int vhci_open(struct inode *inode, struct file *file)
>  		BT_ERR("Can't register HCI device");
>  		kfree(data);
>  		hci_free_dev(hdev);
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -EBUSY;
>  	}
>  
>  	file->private_data = data;
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  
>  	return nonseekable_open(inode, file);
>  }
> @@ -312,10 +312,11 @@ static int vhci_release(struct inode *inode, struct file *file)
>  
>  static int vhci_fasync(int fd, struct file *file, int on)
>  {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct vhci_data *data = file->private_data;
>  	int err = 0;
>  
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	err = fasync_helper(fd, file, on, &data->fasync);
>  	if (err < 0)
>  		goto out;
> @@ -326,7 +327,7 @@ static int vhci_fasync(int fd, struct file *file, int on)
>  		data->flags &= ~VHCI_FASYNC;
>  
>  out:
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return err;
>  }
>  
> diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
> index a00869c..95d2653 100644
> --- a/drivers/char/generic_nvram.c
> +++ b/drivers/char/generic_nvram.c
> @@ -19,7 +19,7 @@
>  #include <linux/miscdevice.h>
>  #include <linux/fcntl.h>
>  #include <linux/init.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  #include <asm/uaccess.h>
>  #include <asm/nvram.h>
>  #ifdef CONFIG_PPC_PMAC
> @@ -28,9 +28,11 @@
>  
>  #define NVRAM_SIZE	8192
>  
> +static DEFINE_MUTEX(nvram_lock);
> +
>  static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
>  {
> -	lock_kernel();
> +	mutex_lock(&nvram_lock);
>  	switch (origin) {
>  	case 1:
>  		offset += file->f_pos;
> @@ -40,11 +42,11 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
>  		break;
>  	}
>  	if (offset < 0) {
> -		unlock_kernel();
> +		mutex_unlock(&nvram_lock);
>  		return -EINVAL;
>  	}
>  	file->f_pos = offset;
> -	unlock_kernel();
> +	mutex_unlock(&nvram_lock);
>  	return file->f_pos;
>  }
>  
> diff --git a/drivers/char/misc.c b/drivers/char/misc.c
> index a5e0db9..8194880 100644
> --- a/drivers/char/misc.c
> +++ b/drivers/char/misc.c
> @@ -36,6 +36,7 @@
>  #include <linux/module.h>
>  
>  #include <linux/fs.h>
> +#include <linux/smp_lock.h>
>  #include <linux/errno.h>
>  #include <linux/miscdevice.h>
>  #include <linux/kernel.h>
> @@ -130,8 +131,15 @@ static int misc_open(struct inode * inode, struct file * file)
>  	}
>  		
>  	if (!new_fops) {
> +		int bkl = kernel_locked();
> +
>  		mutex_unlock(&misc_mtx);
> +		if (bkl)
> +			unlock_kernel();
>  		request_module("char-major-%d-%d", MISC_MAJOR, minor);
> +		if (bkl)
> +			lock_kernel();
> +
>  		mutex_lock(&misc_mtx);
>  
>  		list_for_each_entry(c, &misc_list, list) {
> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
> index 88cee40..bc6220b 100644
> --- a/drivers/char/nvram.c
> +++ b/drivers/char/nvram.c
> @@ -38,7 +38,7 @@
>  #define NVRAM_VERSION	"1.3"
>  
>  #include <linux/module.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  #include <linux/nvram.h>
>  
>  #define PC		1
> @@ -214,7 +214,9 @@ void nvram_set_checksum(void)
>  
>  static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
>  {
> -	lock_kernel();
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +
> +	mutex_lock(&inode->i_mutex);
>  	switch (origin) {
>  	case 0:
>  		/* nothing to do */
> @@ -226,7 +228,7 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
>  		offset += NVRAM_BYTES;
>  		break;
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return (offset >= 0) ? (file->f_pos = offset) : -EINVAL;
>  }
>  
> @@ -331,14 +333,12 @@ static int nvram_ioctl(struct inode *inode, struct file *file,
>  
>  static int nvram_open(struct inode *inode, struct file *file)
>  {
> -	lock_kernel();
>  	spin_lock(&nvram_state_lock);
>  
>  	if ((nvram_open_cnt && (file->f_flags & O_EXCL)) ||
>  	    (nvram_open_mode & NVRAM_EXCL) ||
>  	    ((file->f_mode & FMODE_WRITE) && (nvram_open_mode & NVRAM_WRITE))) {
>  		spin_unlock(&nvram_state_lock);
> -		unlock_kernel();
>  		return -EBUSY;
>  	}
>  
> @@ -349,7 +349,6 @@ static int nvram_open(struct inode *inode, struct file *file)
>  	nvram_open_cnt++;
>  
>  	spin_unlock(&nvram_state_lock);
> -	unlock_kernel();
>  
>  	return 0;
>  }
> diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
> index f78f5b0..1e20212 100644
> --- a/drivers/char/tty_ldisc.c
> +++ b/drivers/char/tty_ldisc.c
> @@ -659,9 +659,19 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
>  
>  	/*
>  	 * Wait for ->hangup_work and ->buf.work handlers to terminate
> +	 *
> +	 * It's safe to drop/reacquire the BKL here as
> +	 * flush_scheduled_work() can sleep anyway:
>  	 */
> -
> -	flush_scheduled_work();
> +	{
> +		int bkl = kernel_locked();
> +
> +		if (bkl)
> +			unlock_kernel();
> +		flush_scheduled_work();
> +		if (bkl)
> +			lock_kernel();
> +	}
>  
>  	/*
>  	 * Wait for any short term users (we know they are just driver
> diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
> index a2dee0e..181ff38 100644
> --- a/drivers/char/vt_ioctl.c
> +++ b/drivers/char/vt_ioctl.c
> @@ -1178,8 +1178,12 @@ static DECLARE_WAIT_QUEUE_HEAD(vt_activate_queue);
>  int vt_waitactive(int vt)
>  {
>  	int retval;
> +	int bkl = kernel_locked();
>  	DECLARE_WAITQUEUE(wait, current);
>  
> +	if (bkl)
> +		unlock_kernel();
> +
>  	add_wait_queue(&vt_activate_queue, &wait);
>  	for (;;) {
>  		retval = 0;
> @@ -1205,6 +1209,10 @@ int vt_waitactive(int vt)
>  	}
>  	remove_wait_queue(&vt_activate_queue, &wait);
>  	__set_current_state(TASK_RUNNING);
> +
> +	if (bkl)
> +		lock_kernel();
> +
>  	return retval;
>  }
>  
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index f45dbc1..e262527 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1318,8 +1318,8 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  	struct gendisk *disk = bdev->bd_disk;
>  	struct block_device *victim = NULL;
>  
> -	mutex_lock_nested(&bdev->bd_mutex, for_part);
>  	lock_kernel();
> +	mutex_lock_nested(&bdev->bd_mutex, for_part);
>  	if (for_part)
>  		bdev->bd_part_count--;
>  
> @@ -1344,8 +1344,8 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
>  			victim = bdev->bd_contains;
>  		bdev->bd_contains = NULL;
>  	}
> -	unlock_kernel();
>  	mutex_unlock(&bdev->bd_mutex);
> +	unlock_kernel();
>  	bdput(bdev);
>  	if (victim)
>  		__blkdev_put(victim, mode, 1);
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 599dbfe..dc905f9 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1585,8 +1585,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  	sbi->s_resgid = EXT3_DEF_RESGID;
>  	sbi->s_sb_block = sb_block;
>  
> -	unlock_kernel();
> -
>  	blocksize = sb_min_blocksize(sb, EXT3_MIN_BLOCK_SIZE);
>  	if (!blocksize) {
>  		printk(KERN_ERR "EXT3-fs: unable to set blocksize\n");
> @@ -1993,7 +1991,6 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
>  		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
>  		"writeback");
>  
> -	lock_kernel();
>  	return 0;
>  
>  cantfind_ext3:
> @@ -2022,7 +2019,6 @@ failed_mount:
>  out_fail:
>  	sb->s_fs_info = NULL;
>  	kfree(sbi);
> -	lock_kernel();
>  	return ret;
>  }
>  
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index 1aa7026..1e8b492 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -13,7 +13,9 @@
>  #include <linux/slab.h>
>  #include <linux/kmod.h>
>  #include <linux/init.h>
> +#include <linux/smp_lock.h>
>  #include <linux/module.h>
> +
>  #include <asm/uaccess.h>
>  
>  /*
> @@ -256,12 +258,24 @@ module_init(proc_filesystems_init);
>  static struct file_system_type *__get_fs_type(const char *name, int len)
>  {
>  	struct file_system_type *fs;
> +	int bkl = kernel_locked();
> +
> +	/*
> +	 * We request a module that might trigger user-space
> +	 * tasks. So explicitly drop the BKL here:
> +	 */
> +	if (bkl)
> +		unlock_kernel();
>  
>  	read_lock(&file_systems_lock);
>  	fs = *(find_filesystem(name, len));
>  	if (fs && !try_module_get(fs->owner))
>  		fs = NULL;
>  	read_unlock(&file_systems_lock);
> +
> +	if (bkl)
> +		lock_kernel();
> +
>  	return fs;
>  }
>  
> diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
> index 2f0dc5a..263a697 100644
> --- a/fs/isofs/dir.c
> +++ b/fs/isofs/dir.c
> @@ -10,7 +10,6 @@
>   *
>   *  isofs directory handling functions
>   */
> -#include <linux/smp_lock.h>
>  #include "isofs.h"
>  
>  int isofs_name_translate(struct iso_directory_record *de, char *new, struct inode *inode)
> @@ -260,13 +259,11 @@ static int isofs_readdir(struct file *filp,
>  	if (tmpname == NULL)
>  		return -ENOMEM;
>  
> -	lock_kernel();
>  	tmpde = (struct iso_directory_record *) (tmpname+1024);
>  
>  	result = do_isofs_readdir(inode, filp, dirent, filldir, tmpname, tmpde);
>  
>  	free_page((unsigned long) tmpname);
> -	unlock_kernel();
>  	return result;
>  }
>  
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index b4cbe96..708bbc7 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -17,7 +17,6 @@
>  #include <linux/slab.h>
>  #include <linux/nls.h>
>  #include <linux/ctype.h>
> -#include <linux/smp_lock.h>
>  #include <linux/statfs.h>
>  #include <linux/cdrom.h>
>  #include <linux/parser.h>
> @@ -955,8 +954,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
>  	int section, rv, error;
>  	struct iso_inode_info *ei = ISOFS_I(inode);
>  
> -	lock_kernel();
> -
>  	error = -EIO;
>  	rv = 0;
>  	if (iblock < 0 || iblock != iblock_s) {
> @@ -1032,7 +1029,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
>  
>  	error = 0;
>  abort:
> -	unlock_kernel();
>  	return rv != 0 ? rv : error;
>  }
>  
> diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
> index 8299889..36d6545 100644
> --- a/fs/isofs/namei.c
> +++ b/fs/isofs/namei.c
> @@ -176,7 +176,6 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
>  	if (!page)
>  		return ERR_PTR(-ENOMEM);
>  
> -	lock_kernel();
>  	found = isofs_find_entry(dir, dentry,
>  				&block, &offset,
>  				page_address(page),
> @@ -187,10 +186,8 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
>  	if (found) {
>  		inode = isofs_iget(dir->i_sb, block, offset);
>  		if (IS_ERR(inode)) {
> -			unlock_kernel();
>  			return ERR_CAST(inode);
>  		}
>  	}
> -	unlock_kernel();
>  	return d_splice_alias(inode, dentry);
>  }
> diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
> index c2fb2dd..c3a883b 100644
> --- a/fs/isofs/rock.c
> +++ b/fs/isofs/rock.c
> @@ -679,7 +679,6 @@ static int rock_ridge_symlink_readpage(struct file *file, struct page *page)
>  
>  	init_rock_state(&rs, inode);
>  	block = ei->i_iget5_block;
> -	lock_kernel();
>  	bh = sb_bread(inode->i_sb, block);
>  	if (!bh)
>  		goto out_noread;
> @@ -749,7 +748,6 @@ repeat:
>  		goto fail;
>  	brelse(bh);
>  	*rpnt = '\0';
> -	unlock_kernel();
>  	SetPageUptodate(page);
>  	kunmap(page);
>  	unlock_page(page);
> @@ -766,7 +764,6 @@ out_bad_span:
>  	printk("symlink spans iso9660 blocks\n");
>  fail:
>  	brelse(bh);
> -	unlock_kernel();
>  error:
>  	SetPageError(page);
>  	kunmap(page);
> diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
> index d0cc5ce..d91047c 100644
> --- a/fs/nfs/nfs3proc.c
> +++ b/fs/nfs/nfs3proc.c
> @@ -17,6 +17,7 @@
>  #include <linux/nfs_page.h>
>  #include <linux/lockd/bind.h>
>  #include <linux/nfs_mount.h>
> +#include <linux/smp_lock.h>
>  
>  #include "iostat.h"
>  #include "internal.h"
> @@ -28,11 +29,17 @@ static int
>  nfs3_rpc_wrapper(struct rpc_clnt *clnt, struct rpc_message *msg, int flags)
>  {
>  	int res;
> +	int bkl = kernel_locked();
> +
>  	do {
>  		res = rpc_call_sync(clnt, msg, flags);
>  		if (res != -EJUKEBOX)
>  			break;
> +		if (bkl)
> +			unlock_kernel();
>  		schedule_timeout_killable(NFS_JUKEBOX_RETRY_TIME);
> +		if (bkl)
> +			lock_kernel();
>  		res = -ERESTARTSYS;
>  	} while (!fatal_signal_pending(current));
>  	return res;
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index fa678ab..d472853 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -20,6 +20,7 @@
>  #include <linux/bitops.h>
>  #include <linux/spinlock.h>
>  #include <linux/completion.h>
> +#include <linux/smp_lock.h>
>  #include <asm/uaccess.h>
>  
>  #include "internal.h"
> @@ -526,7 +527,7 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *filp, void *dirent,
>  	}
>  	ret = 1;
>  out:
> -	return ret;	
> +	return ret;
>  }
>  
>  int proc_readdir(struct file *filp, void *dirent, filldir_t filldir)
> @@ -707,6 +708,8 @@ struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
>  	struct proc_dir_entry *ent;
>  	nlink_t nlink;
>  
> +	WARN_ON_ONCE(kernel_locked());
> +
>  	if (S_ISDIR(mode)) {
>  		if ((mode & S_IALLUGO) == 0)
>  			mode |= S_IRUGO | S_IXUGO;
> @@ -737,6 +740,8 @@ struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
>  	struct proc_dir_entry *pde;
>  	nlink_t nlink;
>  
> +	WARN_ON_ONCE(kernel_locked());
> +
>  	if (S_ISDIR(mode)) {
>  		if ((mode & S_IALLUGO) == 0)
>  			mode |= S_IRUGO | S_IXUGO;
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 1e15a2b..702d32d 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -164,8 +164,10 @@ static int proc_root_readdir(struct file * filp,
>  
>  	if (nr < FIRST_PROCESS_ENTRY) {
>  		int error = proc_readdir(filp, dirent, filldir);
> +
>  		if (error <= 0)
>  			return error;
> +
>  		filp->f_pos = FIRST_PROCESS_ENTRY;
>  	}
>  
> diff --git a/fs/reiserfs/Makefile b/fs/reiserfs/Makefile
> index 7c5ab63..6a9e30c 100644
> --- a/fs/reiserfs/Makefile
> +++ b/fs/reiserfs/Makefile
> @@ -7,7 +7,7 @@ obj-$(CONFIG_REISERFS_FS) += reiserfs.o
>  reiserfs-objs := bitmap.o do_balan.o namei.o inode.o file.o dir.o fix_node.o \
>  		 super.o prints.o objectid.o lbalance.o ibalance.o stree.o \
>  		 hashes.o tail_conversion.o journal.o resize.o \
> -		 item_ops.o ioctl.o procfs.o xattr.o
> +		 item_ops.o ioctl.o procfs.o xattr.o lock.o
>  
>  ifeq ($(CONFIG_REISERFS_FS_XATTR),y)
>  reiserfs-objs += xattr_user.o xattr_trusted.o
> diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
> index e716161..1470334 100644
> --- a/fs/reiserfs/bitmap.c
> +++ b/fs/reiserfs/bitmap.c
> @@ -1256,7 +1256,9 @@ struct buffer_head *reiserfs_read_bitmap_block(struct super_block *sb,
>  	else {
>  		if (buffer_locked(bh)) {
>  			PROC_INFO_INC(sb, scan_bitmap.wait);
> +			reiserfs_write_unlock(sb);
>  			__wait_on_buffer(bh);
> +			reiserfs_write_lock(sb);
>  		}
>  		BUG_ON(!buffer_uptodate(bh));
>  		BUG_ON(atomic_read(&bh->b_count) == 0);
> diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
> index 67a80d7..6d71aa0 100644
> --- a/fs/reiserfs/dir.c
> +++ b/fs/reiserfs/dir.c
> @@ -174,14 +174,22 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
>  				// user space buffer is swapped out. At that time
>  				// entry can move to somewhere else
>  				memcpy(local_buf, d_name, d_reclen);
> +
> +				/*
> +				 * Since filldir might sleep, we can release
> +				 * the write lock here for other waiters
> +				 */
> +				reiserfs_write_unlock(inode->i_sb);
>  				if (filldir
>  				    (dirent, local_buf, d_reclen, d_off, d_ino,
>  				     DT_UNKNOWN) < 0) {
> +					reiserfs_write_lock(inode->i_sb);
>  					if (local_buf != small_buf) {
>  						kfree(local_buf);
>  					}
>  					goto end;
>  				}
> +				reiserfs_write_lock(inode->i_sb);
>  				if (local_buf != small_buf) {
>  					kfree(local_buf);
>  				}
> diff --git a/fs/reiserfs/fix_node.c b/fs/reiserfs/fix_node.c
> index 5e5a4e6..bf5f2cb 100644
> --- a/fs/reiserfs/fix_node.c
> +++ b/fs/reiserfs/fix_node.c
> @@ -1022,7 +1022,11 @@ static int get_far_parent(struct tree_balance *tb,
>  	/* Check whether the common parent is locked. */
>  
>  	if (buffer_locked(*pcom_father)) {
> +
> +		/* Release the write lock while the buffer is busy */
> +		reiserfs_write_unlock(tb->tb_sb);
>  		__wait_on_buffer(*pcom_father);
> +		reiserfs_write_lock(tb->tb_sb);
>  		if (FILESYSTEM_CHANGED_TB(tb)) {
>  			brelse(*pcom_father);
>  			return REPEAT_SEARCH;
> @@ -1927,7 +1931,9 @@ static int get_direct_parent(struct tree_balance *tb, int h)
>  		return REPEAT_SEARCH;
>  
>  	if (buffer_locked(bh)) {
> +		reiserfs_write_unlock(tb->tb_sb);
>  		__wait_on_buffer(bh);
> +		reiserfs_write_lock(tb->tb_sb);
>  		if (FILESYSTEM_CHANGED_TB(tb))
>  			return REPEAT_SEARCH;
>  	}
> @@ -2278,7 +2284,9 @@ static int wait_tb_buffers_until_unlocked(struct tree_balance *tb)
>  				    REPEAT_SEARCH : CARRY_ON;
>  			}
>  #endif
> +			reiserfs_write_unlock(tb->tb_sb);
>  			__wait_on_buffer(locked);
> +			reiserfs_write_lock(tb->tb_sb);
>  			if (FILESYSTEM_CHANGED_TB(tb))
>  				return REPEAT_SEARCH;
>  		}
> @@ -2349,7 +2357,9 @@ int fix_nodes(int op_mode, struct tree_balance *tb,
>  
>  	/* if it possible in indirect_to_direct conversion */
>  	if (buffer_locked(tbS0)) {
> +		reiserfs_write_unlock(tb->tb_sb);
>  		__wait_on_buffer(tbS0);
> +		reiserfs_write_lock(tb->tb_sb);
>  		if (FILESYSTEM_CHANGED_TB(tb))
>  			return REPEAT_SEARCH;
>  	}
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index 6fd0f47..153668e 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -489,10 +489,14 @@ static int reiserfs_get_blocks_direct_io(struct inode *inode,
>  	   disappeared */
>  	if (REISERFS_I(inode)->i_flags & i_pack_on_close_mask) {
>  		int err;
> -		lock_kernel();
> +
> +		reiserfs_write_lock(inode->i_sb);
> +
>  		err = reiserfs_commit_for_inode(inode);
>  		REISERFS_I(inode)->i_flags &= ~i_pack_on_close_mask;
> -		unlock_kernel();
> +
> +		reiserfs_write_unlock(inode->i_sb);
> +
>  		if (err < 0)
>  			ret = err;
>  	}
> @@ -616,7 +620,6 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
>  	loff_t new_offset =
>  	    (((loff_t) block) << inode->i_sb->s_blocksize_bits) + 1;
>  
> -	/* bad.... */
>  	reiserfs_write_lock(inode->i_sb);
>  	version = get_inode_item_key_version(inode);
>  
> @@ -997,10 +1000,14 @@ int reiserfs_get_block(struct inode *inode, sector_t block,
>  			if (retval)
>  				goto failure;
>  		}
> -		/* inserting indirect pointers for a hole can take a
> -		 ** long time.  reschedule if needed
> +		/*
> +		 * inserting indirect pointers for a hole can take a
> +		 * long time.  reschedule if needed and also release the write
> +		 * lock for others.
>  		 */
> +		reiserfs_write_unlock(inode->i_sb);
>  		cond_resched();
> +		reiserfs_write_lock(inode->i_sb);
>  
>  		retval = search_for_position_by_key(inode->i_sb, &key, &path);
>  		if (retval == IO_ERROR) {
> @@ -2076,8 +2083,9 @@ int reiserfs_truncate_file(struct inode *inode, int update_timestamps)
>  	int error;
>  	struct buffer_head *bh = NULL;
>  	int err2;
> +	int lock_depth;
>  
> -	reiserfs_write_lock(inode->i_sb);
> +	lock_depth = reiserfs_write_lock_once(inode->i_sb);
>  
>  	if (inode->i_size > 0) {
>  		error = grab_tail_page(inode, &page, &bh);
> @@ -2146,14 +2154,17 @@ int reiserfs_truncate_file(struct inode *inode, int update_timestamps)
>  		page_cache_release(page);
>  	}
>  
> -	reiserfs_write_unlock(inode->i_sb);
> +	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
> +
>  	return 0;
>        out:
>  	if (page) {
>  		unlock_page(page);
>  		page_cache_release(page);
>  	}
> -	reiserfs_write_unlock(inode->i_sb);
> +
> +	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
> +
>  	return error;
>  }
>  
> @@ -2612,7 +2623,10 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
>  	int ret;
>  	int old_ref = 0;
>  
> +	reiserfs_write_unlock(inode->i_sb);
>  	reiserfs_wait_on_write_block(inode->i_sb);
> +	reiserfs_write_lock(inode->i_sb);
> +
>  	fix_tail_page_for_writing(page);
>  	if (reiserfs_transaction_running(inode->i_sb)) {
>  		struct reiserfs_transaction_handle *th;
> @@ -2762,7 +2776,10 @@ int reiserfs_commit_write(struct file *f, struct page *page,
>  	int update_sd = 0;
>  	struct reiserfs_transaction_handle *th = NULL;
>  
> +	reiserfs_write_unlock(inode->i_sb);
>  	reiserfs_wait_on_write_block(inode->i_sb);
> +	reiserfs_write_lock(inode->i_sb);
> +
>  	if (reiserfs_transaction_running(inode->i_sb)) {
>  		th = current->journal_info;
>  	}
> diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
> index 0ccc3fd..5e40b0c 100644
> --- a/fs/reiserfs/ioctl.c
> +++ b/fs/reiserfs/ioctl.c
> @@ -141,9 +141,11 @@ long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> -	lock_kernel();
> +
> +	reiserfs_write_lock(inode->i_sb);
>  	ret = reiserfs_ioctl(inode, file, cmd, (unsigned long) compat_ptr(arg));
> -	unlock_kernel();
> +	reiserfs_write_unlock(inode->i_sb);
> +
>  	return ret;
>  }
>  #endif
> diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
> index 77f5bb7..7976d7d 100644
> --- a/fs/reiserfs/journal.c
> +++ b/fs/reiserfs/journal.c
> @@ -429,21 +429,6 @@ static void clear_prepared_bits(struct buffer_head *bh)
>  	clear_buffer_journal_restore_dirty(bh);
>  }
>  
> -/* utility function to force a BUG if it is called without the big
> -** kernel lock held.  caller is the string printed just before calling BUG()
> -*/
> -void reiserfs_check_lock_depth(struct super_block *sb, char *caller)
> -{
> -#ifdef CONFIG_SMP
> -	if (current->lock_depth < 0) {
> -		reiserfs_panic(sb, "journal-1", "%s called without kernel "
> -			       "lock held", caller);
> -	}
> -#else
> -	;
> -#endif
> -}
> -
>  /* return a cnode with same dev, block number and size in table, or null if not found */
>  static inline struct reiserfs_journal_cnode *get_journal_hash_dev(struct
>  								  super_block
> @@ -552,11 +537,48 @@ static inline void insert_journal_hash(struct reiserfs_journal_cnode **table,
>  	journal_hash(table, cn->sb, cn->blocknr) = cn;
>  }
>  
> +/*
> + * Several mutexes depend on the write lock.
> + * However sometimes we want to relax the write lock while we hold
> + * these mutexes, according to the release/reacquire on schedule()
> + * properties of the Bkl that were used.
> + * Reiserfs performances and locking were based on this scheme.
> + * Now that the write lock is a mutex and not the bkl anymore, doing so
> + * may result in a deadlock:
> + *
> + * A acquire write_lock
> + * A acquire j_commit_mutex
> + * A release write_lock and wait for something
> + * B acquire write_lock
> + * B can't acquire j_commit_mutex and sleep
> + * A can't acquire write lock anymore
> + * deadlock
> + *
> + * What we do here is avoiding such deadlock by playing the same game
> + * than the Bkl: if we can't acquire a mutex that depends on the write lock,
> + * we release the write lock, wait a bit and then retry.
> + *
> + * The mutexes concerned by this hack are:
> + * - The commit mutex of a journal list
> + * - The flush mutex
> + * - The journal lock
> + */
> +static inline void reiserfs_mutex_lock_safe(struct mutex *m,
> +			       struct super_block *s)
> +{
> +	while (!mutex_trylock(m)) {
> +		reiserfs_write_unlock(s);
> +		schedule();
> +		reiserfs_write_lock(s);
> +	}
> +}
> +
>  /* lock the current transaction */
>  static inline void lock_journal(struct super_block *sb)
>  {
>  	PROC_INFO_INC(sb, journal.lock_journal);
> -	mutex_lock(&SB_JOURNAL(sb)->j_mutex);
> +
> +	reiserfs_mutex_lock_safe(&SB_JOURNAL(sb)->j_mutex, sb);
>  }
>  
>  /* unlock the current transaction */
> @@ -708,7 +730,9 @@ static void check_barrier_completion(struct super_block *s,
>  		disable_barrier(s);
>  		set_buffer_uptodate(bh);
>  		set_buffer_dirty(bh);
> +		reiserfs_write_unlock(s);
>  		sync_dirty_buffer(bh);
> +		reiserfs_write_lock(s);
>  	}
>  }
>  
> @@ -996,8 +1020,13 @@ static int reiserfs_async_progress_wait(struct super_block *s)
>  {
>  	DEFINE_WAIT(wait);
>  	struct reiserfs_journal *j = SB_JOURNAL(s);
> -	if (atomic_read(&j->j_async_throttle))
> +
> +	if (atomic_read(&j->j_async_throttle)) {
> +		reiserfs_write_unlock(s);
>  		congestion_wait(WRITE, HZ / 10);
> +		reiserfs_write_lock(s);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -1043,7 +1072,8 @@ static int flush_commit_list(struct super_block *s,
>  	}
>  
>  	/* make sure nobody is trying to flush this one at the same time */
> -	mutex_lock(&jl->j_commit_mutex);
> +	reiserfs_mutex_lock_safe(&jl->j_commit_mutex, s);
> +
>  	if (!journal_list_still_alive(s, trans_id)) {
>  		mutex_unlock(&jl->j_commit_mutex);
>  		goto put_jl;
> @@ -1061,12 +1091,17 @@ static int flush_commit_list(struct super_block *s,
>  
>  	if (!list_empty(&jl->j_bh_list)) {
>  		int ret;
> -		unlock_kernel();
> +
> +		/*
> +		 * We might sleep in numerous places inside
> +		 * write_ordered_buffers. Relax the write lock.
> +		 */
> +		reiserfs_write_unlock(s);
>  		ret = write_ordered_buffers(&journal->j_dirty_buffers_lock,
>  					    journal, jl, &jl->j_bh_list);
>  		if (ret < 0 && retval == 0)
>  			retval = ret;
> -		lock_kernel();
> +		reiserfs_write_lock(s);
>  	}
>  	BUG_ON(!list_empty(&jl->j_bh_list));
>  	/*
> @@ -1114,12 +1149,19 @@ static int flush_commit_list(struct super_block *s,
>  		bn = SB_ONDISK_JOURNAL_1st_BLOCK(s) +
>  		    (jl->j_start + i) % SB_ONDISK_JOURNAL_SIZE(s);
>  		tbh = journal_find_get_block(s, bn);
> +
> +		reiserfs_write_unlock(s);
>  		wait_on_buffer(tbh);
> +		reiserfs_write_lock(s);
>  		// since we're using ll_rw_blk above, it might have skipped over
>  		// a locked buffer.  Double check here
>  		//
> -		if (buffer_dirty(tbh))	/* redundant, sync_dirty_buffer() checks */
> +		/* redundant, sync_dirty_buffer() checks */
> +		if (buffer_dirty(tbh)) {
> +			reiserfs_write_unlock(s);
>  			sync_dirty_buffer(tbh);
> +			reiserfs_write_lock(s);
> +		}
>  		if (unlikely(!buffer_uptodate(tbh))) {
>  #ifdef CONFIG_REISERFS_CHECK
>  			reiserfs_warning(s, "journal-601",
> @@ -1143,10 +1185,15 @@ static int flush_commit_list(struct super_block *s,
>  			if (buffer_dirty(jl->j_commit_bh))
>  				BUG();
>  			mark_buffer_dirty(jl->j_commit_bh) ;
> +			reiserfs_write_unlock(s);
>  			sync_dirty_buffer(jl->j_commit_bh) ;
> +			reiserfs_write_lock(s);
>  		}
> -	} else
> +	} else {
> +		reiserfs_write_unlock(s);
>  		wait_on_buffer(jl->j_commit_bh);
> +		reiserfs_write_lock(s);
> +	}
>  
>  	check_barrier_completion(s, jl->j_commit_bh);
>  
> @@ -1286,7 +1333,9 @@ static int _update_journal_header_block(struct super_block *sb,
>  
>  	if (trans_id >= journal->j_last_flush_trans_id) {
>  		if (buffer_locked((journal->j_header_bh))) {
> +			reiserfs_write_unlock(sb);
>  			wait_on_buffer((journal->j_header_bh));
> +			reiserfs_write_lock(sb);
>  			if (unlikely(!buffer_uptodate(journal->j_header_bh))) {
>  #ifdef CONFIG_REISERFS_CHECK
>  				reiserfs_warning(sb, "journal-699",
> @@ -1312,12 +1361,16 @@ static int _update_journal_header_block(struct super_block *sb,
>  				disable_barrier(sb);
>  				goto sync;
>  			}
> +			reiserfs_write_unlock(sb);
>  			wait_on_buffer(journal->j_header_bh);
> +			reiserfs_write_lock(sb);
>  			check_barrier_completion(sb, journal->j_header_bh);
>  		} else {
>  		      sync:
>  			set_buffer_dirty(journal->j_header_bh);
> +			reiserfs_write_unlock(sb);
>  			sync_dirty_buffer(journal->j_header_bh);
> +			reiserfs_write_lock(sb);
>  		}
>  		if (!buffer_uptodate(journal->j_header_bh)) {
>  			reiserfs_warning(sb, "journal-837",
> @@ -1409,7 +1462,7 @@ static int flush_journal_list(struct super_block *s,
>  
>  	/* if flushall == 0, the lock is already held */
>  	if (flushall) {
> -		mutex_lock(&journal->j_flush_mutex);
> +		reiserfs_mutex_lock_safe(&journal->j_flush_mutex, s);
>  	} else if (mutex_trylock(&journal->j_flush_mutex)) {
>  		BUG();
>  	}
> @@ -1553,7 +1606,11 @@ static int flush_journal_list(struct super_block *s,
>  					reiserfs_panic(s, "journal-1011",
>  						       "cn->bh is NULL");
>  				}
> +
> +				reiserfs_write_unlock(s);
>  				wait_on_buffer(cn->bh);
> +				reiserfs_write_lock(s);
> +
>  				if (!cn->bh) {
>  					reiserfs_panic(s, "journal-1012",
>  						       "cn->bh is NULL");
> @@ -1769,7 +1826,7 @@ static int kupdate_transactions(struct super_block *s,
>  	struct reiserfs_journal *journal = SB_JOURNAL(s);
>  	chunk.nr = 0;
>  
> -	mutex_lock(&journal->j_flush_mutex);
> +	reiserfs_mutex_lock_safe(&journal->j_flush_mutex, s);
>  	if (!journal_list_still_alive(s, orig_trans_id)) {
>  		goto done;
>  	}
> @@ -1973,11 +2030,19 @@ static int do_journal_release(struct reiserfs_transaction_handle *th,
>  	reiserfs_mounted_fs_count--;
>  	/* wait for all commits to finish */
>  	cancel_delayed_work(&SB_JOURNAL(sb)->j_work);
> +
> +	/*
> +	 * We must release the write lock here because
> +	 * the workqueue job (flush_async_commit) needs this lock
> +	 */
> +	reiserfs_write_unlock(sb);
>  	flush_workqueue(commit_wq);
> +
>  	if (!reiserfs_mounted_fs_count) {
>  		destroy_workqueue(commit_wq);
>  		commit_wq = NULL;
>  	}
> +	reiserfs_write_lock(sb);
>  
>  	free_journal_ram(sb);
>  
> @@ -2243,7 +2308,11 @@ static int journal_read_transaction(struct super_block *sb,
>  	/* read in the log blocks, memcpy to the corresponding real block */
>  	ll_rw_block(READ, get_desc_trans_len(desc), log_blocks);
>  	for (i = 0; i < get_desc_trans_len(desc); i++) {
> +
> +		reiserfs_write_unlock(sb);
>  		wait_on_buffer(log_blocks[i]);
> +		reiserfs_write_lock(sb);
> +
>  		if (!buffer_uptodate(log_blocks[i])) {
>  			reiserfs_warning(sb, "journal-1212",
>  					 "REPLAY FAILURE fsck required! "
> @@ -2964,8 +3033,11 @@ static void queue_log_writer(struct super_block *s)
>  	init_waitqueue_entry(&wait, current);
>  	add_wait_queue(&journal->j_join_wait, &wait);
>  	set_current_state(TASK_UNINTERRUPTIBLE);
> -	if (test_bit(J_WRITERS_QUEUED, &journal->j_state))
> +	if (test_bit(J_WRITERS_QUEUED, &journal->j_state)) {
> +		reiserfs_write_unlock(s);
>  		schedule();
> +		reiserfs_write_lock(s);
> +	}
>  	__set_current_state(TASK_RUNNING);
>  	remove_wait_queue(&journal->j_join_wait, &wait);
>  }
> @@ -2982,7 +3054,9 @@ static void let_transaction_grow(struct super_block *sb, unsigned int trans_id)
>  	struct reiserfs_journal *journal = SB_JOURNAL(sb);
>  	unsigned long bcount = journal->j_bcount;
>  	while (1) {
> +		reiserfs_write_unlock(sb);
>  		schedule_timeout_uninterruptible(1);
> +		reiserfs_write_lock(sb);
>  		journal->j_current_jl->j_state |= LIST_COMMIT_PENDING;
>  		while ((atomic_read(&journal->j_wcount) > 0 ||
>  			atomic_read(&journal->j_jlock)) &&
> @@ -3033,7 +3107,9 @@ static int do_journal_begin_r(struct reiserfs_transaction_handle *th,
>  
>  	if (test_bit(J_WRITERS_BLOCKED, &journal->j_state)) {
>  		unlock_journal(sb);
> +		reiserfs_write_unlock(sb);
>  		reiserfs_wait_on_write_block(sb);
> +		reiserfs_write_lock(sb);
>  		PROC_INFO_INC(sb, journal.journal_relock_writers);
>  		goto relock;
>  	}
> @@ -3506,14 +3582,14 @@ static void flush_async_commits(struct work_struct *work)
>  	struct reiserfs_journal_list *jl;
>  	struct list_head *entry;
>  
> -	lock_kernel();
> +	reiserfs_write_lock(sb);
>  	if (!list_empty(&journal->j_journal_list)) {
>  		/* last entry is the youngest, commit it and you get everything */
>  		entry = journal->j_journal_list.prev;
>  		jl = JOURNAL_LIST_ENTRY(entry);
>  		flush_commit_list(sb, jl, 1);
>  	}
> -	unlock_kernel();
> +	reiserfs_write_unlock(sb);
>  }
>  
>  /*
> @@ -4041,7 +4117,7 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
>  	 * the new transaction is fully setup, and we've already flushed the
>  	 * ordered bh list
>  	 */
> -	mutex_lock(&jl->j_commit_mutex);
> +	reiserfs_mutex_lock_safe(&jl->j_commit_mutex, sb);
>  
>  	/* save the transaction id in case we need to commit it later */
>  	commit_trans_id = jl->j_trans_id;
> @@ -4203,10 +4279,10 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
>  	 * is lost.
>  	 */
>  	if (!list_empty(&jl->j_tail_bh_list)) {
> -		unlock_kernel();
> +		reiserfs_write_unlock(sb);
>  		write_ordered_buffers(&journal->j_dirty_buffers_lock,
>  				      journal, jl, &jl->j_tail_bh_list);
> -		lock_kernel();
> +		reiserfs_write_lock(sb);
>  	}
>  	BUG_ON(!list_empty(&jl->j_tail_bh_list));
>  	mutex_unlock(&jl->j_commit_mutex);
> diff --git a/fs/reiserfs/lock.c b/fs/reiserfs/lock.c
> new file mode 100644
> index 0000000..cb1bba3
> --- /dev/null
> +++ b/fs/reiserfs/lock.c
> @@ -0,0 +1,89 @@
> +#include <linux/reiserfs_fs.h>
> +#include <linux/mutex.h>
> +
> +/*
> + * The previous reiserfs locking scheme was heavily based on
> + * the tricky properties of the Bkl:
> + *
> + * - it was acquired recursively by a same task
> + * - the performances relied on the release-while-schedule() property
> + *
> + * Now that we replace it by a mutex, we still want to keep the same
> + * recursive property to avoid big changes in the code structure.
> + * We use our own lock_owner here because the owner field on a mutex
> + * is only available in SMP or mutex debugging, also we only need this field
> + * for this mutex, no need for a system wide mutex facility.
> + *
> + * Also this lock is often released before a call that could block because
> + * reiserfs performances were partialy based on the release while schedule()
> + * property of the Bkl.
> + */
> +void reiserfs_write_lock(struct super_block *s)
> +{
> +	struct reiserfs_sb_info *sb_i = REISERFS_SB(s);
> +
> +	if (sb_i->lock_owner != current) {
> +		mutex_lock(&sb_i->lock);
> +		sb_i->lock_owner = current;
> +	}
> +
> +	/* No need to protect it, only the current task touches it */
> +	sb_i->lock_depth++;
> +}
> +
> +void reiserfs_write_unlock(struct super_block *s)
> +{
> +	struct reiserfs_sb_info *sb_i = REISERFS_SB(s);
> +
> +	/*
> +	 * Are we unlocking without even holding the lock?
> +	 * Such a situation could even raise a BUG() if we don't
> +	 * want the data become corrupted
> +	 */
> +	WARN_ONCE(sb_i->lock_owner != current,
> +		  "Superblock write lock imbalance");
> +
> +	if (--sb_i->lock_depth == -1) {
> +		sb_i->lock_owner = NULL;
> +		mutex_unlock(&sb_i->lock);
> +	}
> +}
> +
> +/*
> + * If we already own the lock, just exit and don't increase the depth.
> + * Useful when we don't want to lock more than once.
> + *
> + * We always return the lock_depth we had before calling
> + * this function.
> + */
> +int reiserfs_write_lock_once(struct super_block *s)
> +{
> +	struct reiserfs_sb_info *sb_i = REISERFS_SB(s);
> +
> +	if (sb_i->lock_owner != current) {
> +		mutex_lock(&sb_i->lock);
> +		sb_i->lock_owner = current;
> +		return sb_i->lock_depth++;
> +	}
> +
> +	return sb_i->lock_depth;
> +}
> +
> +void reiserfs_write_unlock_once(struct super_block *s, int lock_depth)
> +{
> +	if (lock_depth == -1)
> +		reiserfs_write_unlock(s);
> +}
> +
> +/*
> + * Utility function to force a BUG if it is called without the superblock
> + * write lock held.  caller is the string printed just before calling BUG()
> + */
> +void reiserfs_check_lock_depth(struct super_block *sb, char *caller)
> +{
> +	struct reiserfs_sb_info *sb_i = REISERFS_SB(sb);
> +
> +	if (sb_i->lock_depth < 0)
> +		reiserfs_panic(sb, "%s called without kernel lock held %d",
> +			       caller);
> +}
> diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
> index 238e9d9..6a7bfb3 100644
> --- a/fs/reiserfs/resize.c
> +++ b/fs/reiserfs/resize.c
> @@ -142,7 +142,9 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
>  
>  			set_buffer_uptodate(bh);
>  			mark_buffer_dirty(bh);
> +			reiserfs_write_unlock(s);
>  			sync_dirty_buffer(bh);
> +			reiserfs_write_lock(s);
>  			// update bitmap_info stuff
>  			bitmap[i].free_count = sb_blocksize(sb) * 8 - 1;
>  			brelse(bh);
> diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
> index d036ee5..6bd99a9 100644
> --- a/fs/reiserfs/stree.c
> +++ b/fs/reiserfs/stree.c
> @@ -629,7 +629,9 @@ int search_by_key(struct super_block *sb, const struct cpu_key *key,	/* Key to s
>  				search_by_key_reada(sb, reada_bh,
>  						    reada_blocks, reada_count);
>  			ll_rw_block(READ, 1, &bh);
> +			reiserfs_write_unlock(sb);
>  			wait_on_buffer(bh);
> +			reiserfs_write_lock(sb);
>  			if (!buffer_uptodate(bh))
>  				goto io_error;
>  		} else {
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index 0ae6486..f6c5606 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -470,6 +470,13 @@ static void reiserfs_put_super(struct super_block *s)
>  	struct reiserfs_transaction_handle th;
>  	th.t_trans_id = 0;
>  
> +	/*
> +	 * We didn't need to explicitly lock here before, because put_super
> +	 * is called with the bkl held.
> +	 * Now that we have our own lock, we must explicitly lock.
> +	 */
> +	reiserfs_write_lock(s);
> +
>  	/* change file system state to current state if it was mounted with read-write permissions */
>  	if (!(s->s_flags & MS_RDONLY)) {
>  		if (!journal_begin(&th, s, 10)) {
> @@ -499,6 +506,8 @@ static void reiserfs_put_super(struct super_block *s)
>  
>  	reiserfs_proc_info_done(s);
>  
> +	reiserfs_write_unlock(s);
> +	mutex_destroy(&REISERFS_SB(s)->lock);
>  	kfree(s->s_fs_info);
>  	s->s_fs_info = NULL;
>  
> @@ -558,25 +567,28 @@ static void reiserfs_dirty_inode(struct inode *inode)
>  	struct reiserfs_transaction_handle th;
>  
>  	int err = 0;
> +	int lock_depth;
> +
>  	if (inode->i_sb->s_flags & MS_RDONLY) {
>  		reiserfs_warning(inode->i_sb, "clm-6006",
>  				 "writing inode %lu on readonly FS",
>  				 inode->i_ino);
>  		return;
>  	}
> -	reiserfs_write_lock(inode->i_sb);
> +	lock_depth = reiserfs_write_lock_once(inode->i_sb);
>  
>  	/* this is really only used for atime updates, so they don't have
>  	 ** to be included in O_SYNC or fsync
>  	 */
>  	err = journal_begin(&th, inode->i_sb, 1);
> -	if (err) {
> -		reiserfs_write_unlock(inode->i_sb);
> -		return;
> -	}
> +	if (err)
> +		goto out;
> +
>  	reiserfs_update_sd(&th, inode);
>  	journal_end(&th, inode->i_sb, 1);
> -	reiserfs_write_unlock(inode->i_sb);
> +
> +out:
> +	reiserfs_write_unlock_once(inode->i_sb, lock_depth);
>  }
>  
>  #ifdef CONFIG_REISERFS_FS_POSIX_ACL
> @@ -1191,7 +1203,15 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
>  	unsigned int qfmt = 0;
>  #ifdef CONFIG_QUOTA
>  	int i;
> +#endif
> +
> +	/*
> +	 * We used to protect using the implicitly acquired bkl here.
> +	 * Now we must explictly acquire our own lock
> +	 */
> +	reiserfs_write_lock(s);
>  
> +#ifdef CONFIG_QUOTA
>  	memcpy(qf_names, REISERFS_SB(s)->s_qf_names, sizeof(qf_names));
>  #endif
>  
> @@ -1316,11 +1336,13 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
>  	}
>  
>  out_ok:
> +	reiserfs_write_unlock(s);
>  	kfree(s->s_options);
>  	s->s_options = new_opts;
>  	return 0;
>  
>  out_err:
> +	reiserfs_write_unlock(s);
>  	kfree(new_opts);
>  	return err;
>  }
> @@ -1425,7 +1447,9 @@ static int read_super_block(struct super_block *s, int offset)
>  static int reread_meta_blocks(struct super_block *s)
>  {
>  	ll_rw_block(READ, 1, &(SB_BUFFER_WITH_SB(s)));
> +	reiserfs_write_unlock(s);
>  	wait_on_buffer(SB_BUFFER_WITH_SB(s));
> +	reiserfs_write_lock(s);
>  	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
>  		reiserfs_warning(s, "reiserfs-2504", "error reading the super");
>  		return 1;
> @@ -1634,7 +1658,7 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
>  	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
>  	if (!sbi) {
>  		errval = -ENOMEM;
> -		goto error;
> +		goto error_alloc;
>  	}
>  	s->s_fs_info = sbi;
>  	/* Set default values for options: non-aggressive tails, RO on errors */
> @@ -1648,6 +1672,20 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
>  	/* setup default block allocator options */
>  	reiserfs_init_alloc_options(s);
>  
> +	mutex_init(&REISERFS_SB(s)->lock);
> +	REISERFS_SB(s)->lock_depth = -1;
> +
> +	/*
> +	 * This function is called with the bkl, which also was the old
> +	 * locking used here.
> +	 * do_journal_begin() will soon check if we hold the lock (ie: was the
> +	 * bkl). This is likely because do_journal_begin() has several another
> +	 * callers because at this time, it doesn't seem to be necessary to
> +	 * protect against anything.
> +	 * Anyway, let's be conservative and lock for now.
> +	 */
> +	reiserfs_write_lock(s);
> +
>  	jdev_name = NULL;
>  	if (reiserfs_parse_options
>  	    (s, (char *)data, &(sbi->s_mount_opt), &blocks, &jdev_name,
> @@ -1871,9 +1909,13 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
>  	init_waitqueue_head(&(sbi->s_wait));
>  	spin_lock_init(&sbi->bitmap_lock);
>  
> +	reiserfs_write_unlock(s);
> +
>  	return (0);
>  
>  error:
> +	reiserfs_write_unlock(s);
> +error_alloc:
>  	if (jinit_done) {	/* kill the commit thread, free journal ram */
>  		journal_release_error(NULL, s);
>  	}
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index 4525747..dc4b327 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -84,14 +84,6 @@
>   */
>  #define in_nmi()	(preempt_count() & NMI_MASK)
>  
> -#if defined(CONFIG_PREEMPT)
> -# define PREEMPT_INATOMIC_BASE kernel_locked()
> -# define PREEMPT_CHECK_OFFSET 1
> -#else
> -# define PREEMPT_INATOMIC_BASE 0
> -# define PREEMPT_CHECK_OFFSET 0
> -#endif
> -
>  /*
>   * Are we running in atomic context?  WARNING: this macro cannot
>   * always detect atomic context; in particular, it cannot know about
> @@ -99,11 +91,17 @@
>   * used in the general case to determine whether sleeping is possible.
>   * Do not use in_atomic() in driver code.
>   */
> -#define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
> +#define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
> +
> +#ifdef CONFIG_PREEMPT
> +# define PREEMPT_CHECK_OFFSET 1
> +#else
> +# define PREEMPT_CHECK_OFFSET 0
> +#endif
>  
>  /*
>   * Check whether we were atomic before we did preempt_disable():
> - * (used by the scheduler, *after* releasing the kernel lock)
> + * (used by the scheduler)
>   */
>  #define in_atomic_preempt_off() \
>  		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
> diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
> index 2245c78..6587b4e 100644
> --- a/include/linux/reiserfs_fs.h
> +++ b/include/linux/reiserfs_fs.h
> @@ -52,11 +52,15 @@
>  #define REISERFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
>  #define REISERFS_IOC32_SETVERSION	FS_IOC32_SETVERSION
>  
> -/* Locking primitives */
> -/* Right now we are still falling back to (un)lock_kernel, but eventually that
> -   would evolve into real per-fs locks */
> -#define reiserfs_write_lock( sb ) lock_kernel()
> -#define reiserfs_write_unlock( sb ) unlock_kernel()
> +/*
> + * Locking primitives. The write lock is a per superblock
> + * special mutex that has properties close to the Big Kernel Lock
> + * which was used in the previous locking scheme.
> + */
> +void reiserfs_write_lock(struct super_block *s);
> +void reiserfs_write_unlock(struct super_block *s);
> +int reiserfs_write_lock_once(struct super_block *s);
> +void reiserfs_write_unlock_once(struct super_block *s, int lock_depth);
>  
>  struct fid;
>  
> diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
> index 5621d87..cec8319 100644
> --- a/include/linux/reiserfs_fs_sb.h
> +++ b/include/linux/reiserfs_fs_sb.h
> @@ -7,6 +7,8 @@
>  #ifdef __KERNEL__
>  #include <linux/workqueue.h>
>  #include <linux/rwsem.h>
> +#include <linux/mutex.h>
> +#include <linux/sched.h>
>  #endif
>  
>  typedef enum {
> @@ -355,6 +357,13 @@ struct reiserfs_sb_info {
>  	struct reiserfs_journal *s_journal;	/* pointer to journal information */
>  	unsigned short s_mount_state;	/* reiserfs state (valid, invalid) */
>  
> +	/* Serialize writers access, replace the old bkl */
> +	struct mutex lock;
> +	/* Owner of the lock (can be recursive) */
> +	struct task_struct *lock_owner;
> +	/* Depth of the lock, start from -1 like the bkl */
> +	int lock_depth;
> +
>  	/* Comment? -Hans */
>  	void (*end_io_handler) (struct buffer_head *, int);
>  	hashf_t s_hash_function;	/* pointer to function which is used
> diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
> index 813be59..c80ad37 100644
> --- a/include/linux/smp_lock.h
> +++ b/include/linux/smp_lock.h
> @@ -1,29 +1,9 @@
>  #ifndef __LINUX_SMPLOCK_H
>  #define __LINUX_SMPLOCK_H
>  
> -#ifdef CONFIG_LOCK_KERNEL
> +#include <linux/compiler.h>
>  #include <linux/sched.h>
>  
> -#define kernel_locked()		(current->lock_depth >= 0)
> -
> -extern int __lockfunc __reacquire_kernel_lock(void);
> -extern void __lockfunc __release_kernel_lock(void);
> -
> -/*
> - * Release/re-acquire global kernel lock for the scheduler
> - */
> -#define release_kernel_lock(tsk) do { 		\
> -	if (unlikely((tsk)->lock_depth >= 0))	\
> -		__release_kernel_lock();	\
> -} while (0)
> -
> -static inline int reacquire_kernel_lock(struct task_struct *task)
> -{
> -	if (unlikely(task->lock_depth >= 0))
> -		return __reacquire_kernel_lock();
> -	return 0;
> -}
> -
>  extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
>  extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
>  
> @@ -39,14 +19,12 @@ static inline void cycle_kernel_lock(void)
>  	unlock_kernel();
>  }
>  
> -#else
> +static inline int kernel_locked(void)
> +{
> +	return current->lock_depth >= 0;
> +}
>  
> -#define lock_kernel()				do { } while(0)
> -#define unlock_kernel()				do { } while(0)
> -#define release_kernel_lock(task)		do { } while(0)
>  #define cycle_kernel_lock()			do { } while(0)
> -#define reacquire_kernel_lock(task)		0
> -#define kernel_locked()				1
> +extern void debug_print_bkl(void);
>  
> -#endif /* CONFIG_LOCK_KERNEL */
> -#endif /* __LINUX_SMPLOCK_H */
> +#endif
> diff --git a/init/Kconfig b/init/Kconfig
> index 7be4d38..51d9ae7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -57,11 +57,6 @@ config BROKEN_ON_SMP
>  	depends on BROKEN || !SMP
>  	default y
>  
> -config LOCK_KERNEL
> -	bool
> -	depends on SMP || PREEMPT
> -	default y
> -
>  config INIT_ENV_ARG_LIMIT
>  	int
>  	default 32 if !UML
> diff --git a/init/main.c b/init/main.c
> index 3585f07..ab13ebb 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -457,7 +457,6 @@ static noinline void __init_refok rest_init(void)
>  	numa_default_policy();
>  	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
>  	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
> -	unlock_kernel();
>  
>  	/*
>  	 * The boot idle thread must execute schedule()
> @@ -557,7 +556,6 @@ asmlinkage void __init start_kernel(void)
>   * Interrupts are still disabled. Do necessary setups, then
>   * enable them
>   */
> -	lock_kernel();
>  	tick_init();
>  	boot_cpu_init();
>  	page_address_init();
> @@ -631,6 +629,8 @@ asmlinkage void __init start_kernel(void)
>  	 */
>  	locking_selftest();
>  
> +	lock_kernel();
> +
>  #ifdef CONFIG_BLK_DEV_INITRD
>  	if (initrd_start && !initrd_below_start_ok &&
>  	    page_to_pfn(virt_to_page((void *)initrd_start)) < min_low_pfn) {
> @@ -677,6 +677,7 @@ asmlinkage void __init start_kernel(void)
>  	signals_init();
>  	/* rootfs populating might need page-writeback */
>  	page_writeback_init();
> +	unlock_kernel();
>  #ifdef CONFIG_PROC_FS
>  	proc_root_init();
>  #endif
> @@ -801,7 +802,6 @@ static noinline int init_post(void)
>  	/* need to finish all async __init code before freeing the memory */
>  	async_synchronize_full();
>  	free_initmem();
> -	unlock_kernel();
>  	mark_rodata_ro();
>  	system_state = SYSTEM_RUNNING;
>  	numa_default_policy();
> @@ -841,7 +841,6 @@ static noinline int init_post(void)
>  
>  static int __init kernel_init(void * unused)
>  {
> -	lock_kernel();
>  	/*
>  	 * init can run on any cpu.
>  	 */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b9e2edd..b5c5089 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -63,6 +63,7 @@
>  #include <linux/fs_struct.h>
>  #include <trace/sched.h>
>  #include <linux/magic.h>
> +#include <linux/smp_lock.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -955,6 +956,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	struct task_struct *p;
>  	int cgroup_callbacks_done = 0;
>  
> +	if (system_state == SYSTEM_RUNNING && kernel_locked())
> +		debug_check_no_locks_held(current);
> +
>  	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
>  		return ERR_PTR(-EINVAL);
>  
> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index 022a492..c790a59 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -13,6 +13,7 @@
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
>  #include <linux/lockdep.h>
> +#include <linux/smp_lock.h>
>  #include <linux/module.h>
>  #include <linux/sysctl.h>
>  
> @@ -100,6 +101,8 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
>  	sched_show_task(t);
>  	__debug_show_held_locks(t);
>  
> +	debug_print_bkl();
> +
>  	touch_nmi_watchdog();
>  
>  	if (sysctl_hung_task_panic)
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index b750675..de0fe01 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -36,6 +36,8 @@
>  #include <linux/resource.h>
>  #include <linux/notifier.h>
>  #include <linux/suspend.h>
> +#include <linux/smp_lock.h>
> +
>  #include <asm/uaccess.h>
>  
>  extern int max_threads;
> @@ -78,6 +80,7 @@ int __request_module(bool wait, const char *fmt, ...)
>  	static atomic_t kmod_concurrent = ATOMIC_INIT(0);
>  #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
>  	static int kmod_loop_msg;
> +	int bkl = kernel_locked();
>  
>  	va_start(args, fmt);
>  	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
> @@ -109,9 +112,28 @@ int __request_module(bool wait, const char *fmt, ...)
>  		return -ENOMEM;
>  	}
>  
> +	/*
> +	 * usermodehelper blocks waiting for modprobe. We cannot
> +	 * do that with the BKL held. Also emit a (one time)
> +	 * warning about callsites that do this:
> +	 */
> +	if (bkl) {
> +		if (debug_locks) {
> +			WARN_ON_ONCE(1);
> +			debug_show_held_locks(current);
> +			debug_locks_off();
> +		}
> +		unlock_kernel();
> +	}
> +
>  	ret = call_usermodehelper(modprobe_path, argv, envp,
>  			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
> +
>  	atomic_dec(&kmod_concurrent);
> +
> +	if (bkl)
> +		lock_kernel();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(__request_module);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 5724508..84155c6 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5020,9 +5020,6 @@ asmlinkage void __sched __schedule(void)
>  	prev = rq->curr;
>  	switch_count = &prev->nivcsw;
>  
> -	release_kernel_lock(prev);
> -need_resched_nonpreemptible:
> -
>  	schedule_debug(prev);
>  
>  	if (sched_feat(HRTICK))
> @@ -5068,10 +5065,7 @@ need_resched_nonpreemptible:
>  	} else
>  		spin_unlock_irq(&rq->lock);
>  
> -	if (unlikely(reacquire_kernel_lock(current) < 0))
> -		goto need_resched_nonpreemptible;
>  }
> -
>  asmlinkage void __sched schedule(void)
>  {
>  need_resched:
> @@ -6253,11 +6247,6 @@ static void __cond_resched(void)
>  #ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
>  	__might_sleep(__FILE__, __LINE__);
>  #endif
> -	/*
> -	 * The BKS might be reacquired before we have dropped
> -	 * PREEMPT_ACTIVE, which could trigger a second
> -	 * cond_resched() call.
> -	 */
>  	do {
>  		add_preempt_count(PREEMPT_ACTIVE);
>  		schedule();
> @@ -6565,11 +6554,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
>  	spin_unlock_irqrestore(&rq->lock, flags);
>  
>  	/* Set the preempt count _outside_ the spinlocks! */
> -#if defined(CONFIG_PREEMPT)
> -	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
> -#else
>  	task_thread_info(idle)->preempt_count = 0;
> -#endif
> +
>  	/*
>  	 * The idle tasks have their own, simple scheduling class:
>  	 */
> diff --git a/kernel/softlockup.c b/kernel/softlockup.c
> index 88796c3..6c18577 100644
> --- a/kernel/softlockup.c
> +++ b/kernel/softlockup.c
> @@ -17,6 +17,7 @@
>  #include <linux/notifier.h>
>  #include <linux/module.h>
>  #include <linux/sysctl.h>
> +#include <linux/smp_lock.h>
>  
>  #include <asm/irq_regs.h>
>  
> diff --git a/kernel/sys.c b/kernel/sys.c
> index e7998cf..b740a21 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -8,7 +8,7 @@
>  #include <linux/mm.h>
>  #include <linux/utsname.h>
>  #include <linux/mman.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  #include <linux/notifier.h>
>  #include <linux/reboot.h>
>  #include <linux/prctl.h>
> @@ -356,6 +356,8 @@ EXPORT_SYMBOL_GPL(kernel_power_off);
>   *
>   * reboot doesn't sync: do that yourself before calling this.
>   */
> +DEFINE_MUTEX(reboot_lock);
> +
>  SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  		void __user *, arg)
>  {
> @@ -380,7 +382,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  	if ((cmd == LINUX_REBOOT_CMD_POWER_OFF) && !pm_power_off)
>  		cmd = LINUX_REBOOT_CMD_HALT;
>  
> -	lock_kernel();
> +	mutex_lock(&reboot_lock);
>  	switch (cmd) {
>  	case LINUX_REBOOT_CMD_RESTART:
>  		kernel_restart(NULL);
> @@ -396,19 +398,19 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  
>  	case LINUX_REBOOT_CMD_HALT:
>  		kernel_halt();
> -		unlock_kernel();
> +		mutex_unlock(&reboot_lock);
>  		do_exit(0);
>  		panic("cannot halt");
>  
>  	case LINUX_REBOOT_CMD_POWER_OFF:
>  		kernel_power_off();
> -		unlock_kernel();
> +		mutex_unlock(&reboot_lock);
>  		do_exit(0);
>  		break;
>  
>  	case LINUX_REBOOT_CMD_RESTART2:
>  		if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0) {
> -			unlock_kernel();
> +			mutex_unlock(&reboot_lock);
>  			return -EFAULT;
>  		}
>  		buffer[sizeof(buffer) - 1] = '\0';
> @@ -432,7 +434,8 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
>  		ret = -EINVAL;
>  		break;
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&reboot_lock);
> +
>  	return ret;
>  }
>  
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 1ce5dc6..18d9e86 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -489,13 +489,6 @@ __acquires(kernel_lock)
>  		return -1;
>  	}
>  
> -	/*
> -	 * When this gets called we hold the BKL which means that
> -	 * preemption is disabled. Various trace selftests however
> -	 * need to disable and enable preemption for successful tests.
> -	 * So we drop the BKL here and grab it after the tests again.
> -	 */
> -	unlock_kernel();
>  	mutex_lock(&trace_types_lock);
>  
>  	tracing_selftest_running = true;
> @@ -583,7 +576,6 @@ __acquires(kernel_lock)
>  #endif
>  
>   out_unlock:
> -	lock_kernel();
>  	return ret;
>  }
>  
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index f71fb2a..d0868e8 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -399,13 +399,26 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
>  void flush_workqueue(struct workqueue_struct *wq)
>  {
>  	const struct cpumask *cpu_map = wq_cpu_map(wq);
> +	int bkl = kernel_locked();
>  	int cpu;
>  
>  	might_sleep();
> +	if (bkl) {
> +		if (debug_locks) {
> +			WARN_ON_ONCE(1);
> +			debug_show_held_locks(current);
> +			debug_locks_off();
> +		}
> +		unlock_kernel();
> +	}
> +
>  	lock_map_acquire(&wq->lockdep_map);
>  	lock_map_release(&wq->lockdep_map);
>  	for_each_cpu(cpu, cpu_map)
>  		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
> +
> +	if (bkl)
> +		lock_kernel();
>  }
>  EXPORT_SYMBOL_GPL(flush_workqueue);
>  
> diff --git a/lib/Makefile b/lib/Makefile
> index d6edd67..9894a52 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
>  
>  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> -	 string_helpers.o
> +	 kernel_lock.o string_helpers.o
>  
>  ifeq ($(CONFIG_DEBUG_KOBJECT),y)
>  CFLAGS_kobject.o += -DDEBUG
> @@ -40,7 +40,6 @@ lib-$(CONFIG_GENERIC_FIND_FIRST_BIT) += find_next_bit.o
>  lib-$(CONFIG_GENERIC_FIND_NEXT_BIT) += find_next_bit.o
>  lib-$(CONFIG_GENERIC_FIND_LAST_BIT) += find_last_bit.o
>  obj-$(CONFIG_GENERIC_HWEIGHT) += hweight.o
> -obj-$(CONFIG_LOCK_KERNEL) += kernel_lock.o
>  obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
>  obj-$(CONFIG_DEBUG_LIST) += list_debug.o
>  obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
> diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
> index 39f1029..ca03ae8 100644
> --- a/lib/kernel_lock.c
> +++ b/lib/kernel_lock.c
> @@ -1,131 +1,67 @@
>  /*
> - * lib/kernel_lock.c
> + * This is the Big Kernel Lock - the traditional lock that we
> + * inherited from the uniprocessor Linux kernel a decade ago.
>   *
> - * This is the traditional BKL - big kernel lock. Largely
> - * relegated to obsolescence, but used by various less
> + * Largely relegated to obsolescence, but used by various less
>   * important (or lazy) subsystems.
> - */
> -#include <linux/smp_lock.h>
> -#include <linux/module.h>
> -#include <linux/kallsyms.h>
> -#include <linux/semaphore.h>
> -
> -/*
> - * The 'big kernel lock'
> - *
> - * This spinlock is taken and released recursively by lock_kernel()
> - * and unlock_kernel().  It is transparently dropped and reacquired
> - * over schedule().  It is used to protect legacy code that hasn't
> - * been migrated to a proper locking design yet.
>   *
>   * Don't use in new code.
> - */
> -static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kernel_flag);
> -
> -
> -/*
> - * Acquire/release the underlying lock from the scheduler.
>   *
> - * This is called with preemption disabled, and should
> - * return an error value if it cannot get the lock and
> - * TIF_NEED_RESCHED gets set.
> + * It now has plain mutex semantics (i.e. no auto-drop on
> + * schedule() anymore), combined with a very simple self-recursion
> + * layer that allows the traditional nested use:
>   *
> - * If it successfully gets the lock, it should increment
> - * the preemption count like any spinlock does.
> + *   lock_kernel();
> + *     lock_kernel();
> + *     unlock_kernel();
> + *   unlock_kernel();
>   *
> - * (This works on UP too - _raw_spin_trylock will never
> - * return false in that case)
> + * Please migrate all BKL using code to a plain mutex.
>   */
> -int __lockfunc __reacquire_kernel_lock(void)
> -{
> -	while (!_raw_spin_trylock(&kernel_flag)) {
> -		if (need_resched())
> -			return -EAGAIN;
> -		cpu_relax();
> -	}
> -	preempt_disable();
> -	return 0;
> -}
> +#include <linux/smp_lock.h>
> +#include <linux/kallsyms.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
>  
> -void __lockfunc __release_kernel_lock(void)
> -{
> -	_raw_spin_unlock(&kernel_flag);
> -	preempt_enable_no_resched();
> -}
> +static DEFINE_MUTEX(kernel_mutex);
>  
>  /*
> - * These are the BKL spinlocks - we try to be polite about preemption.
> - * If SMP is not on (ie UP preemption), this all goes away because the
> - * _raw_spin_trylock() will always succeed.
> + * Get the big kernel lock:
>   */
> -#ifdef CONFIG_PREEMPT
> -static inline void __lock_kernel(void)
> +void __lockfunc lock_kernel(void)
>  {
> -	preempt_disable();
> -	if (unlikely(!_raw_spin_trylock(&kernel_flag))) {
> -		/*
> -		 * If preemption was disabled even before this
> -		 * was called, there's nothing we can be polite
> -		 * about - just spin.
> -		 */
> -		if (preempt_count() > 1) {
> -			_raw_spin_lock(&kernel_flag);
> -			return;
> -		}
> +	struct task_struct *task = current;
> +	int depth = task->lock_depth + 1;
>  
> +	if (likely(!depth))
>  		/*
> -		 * Otherwise, let's wait for the kernel lock
> -		 * with preemption enabled..
> +		 * No recursion worries - we set up lock_depth _after_
>  		 */
> -		do {
> -			preempt_enable();
> -			while (spin_is_locked(&kernel_flag))
> -				cpu_relax();
> -			preempt_disable();
> -		} while (!_raw_spin_trylock(&kernel_flag));
> -	}
> -}
> -
> -#else
> +		mutex_lock(&kernel_mutex);
>  
> -/*
> - * Non-preemption case - just get the spinlock
> - */
> -static inline void __lock_kernel(void)
> -{
> -	_raw_spin_lock(&kernel_flag);
> +	task->lock_depth = depth;
>  }
> -#endif
>  
> -static inline void __unlock_kernel(void)
> +void __lockfunc unlock_kernel(void)
>  {
> -	/*
> -	 * the BKL is not covered by lockdep, so we open-code the
> -	 * unlocking sequence (and thus avoid the dep-chain ops):
> -	 */
> -	_raw_spin_unlock(&kernel_flag);
> -	preempt_enable();
> -}
> +	struct task_struct *task = current;
>  
> -/*
> - * Getting the big kernel lock.
> - *
> - * This cannot happen asynchronously, so we only need to
> - * worry about other CPU's.
> - */
> -void __lockfunc lock_kernel(void)
> -{
> -	int depth = current->lock_depth+1;
> -	if (likely(!depth))
> -		__lock_kernel();
> -	current->lock_depth = depth;
> +	if (WARN_ON_ONCE(task->lock_depth < 0))
> +		return;
> +
> +	if (likely(--task->lock_depth < 0))
> +		mutex_unlock(&kernel_mutex);
>  }
>  
> -void __lockfunc unlock_kernel(void)
> +void debug_print_bkl(void)
>  {
> -	BUG_ON(current->lock_depth < 0);
> -	if (likely(--current->lock_depth < 0))
> -		__unlock_kernel();
> +#ifdef CONFIG_DEBUG_MUTEXES
> +	if (mutex_is_locked(&kernel_mutex)) {
> +		printk(KERN_EMERG "BUG: **** BKL held by: %d:%s\n",
> +			kernel_mutex.owner->task->pid,
> +			kernel_mutex.owner->task->comm);
> +	}
> +#endif
>  }
>  
>  EXPORT_SYMBOL(lock_kernel);
> diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
> index ff50a05..e28d0fd 100644
> --- a/net/sunrpc/sched.c
> +++ b/net/sunrpc/sched.c
> @@ -224,9 +224,15 @@ EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
>  
>  static int rpc_wait_bit_killable(void *word)
>  {
> +	int bkl = kernel_locked();
> +
>  	if (fatal_signal_pending(current))
>  		return -ERESTARTSYS;
> +	if (bkl)
> +		unlock_kernel();
>  	schedule();
> +	if (bkl)
> +		lock_kernel();
>  	return 0;
>  }
>  
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index c200d92..acfb60c 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -600,6 +600,7 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
>  	struct xdr_buf		*arg;
>  	DECLARE_WAITQUEUE(wait, current);
>  	long			time_left;
> +	int bkl = kernel_locked();
>  
>  	dprintk("svc: server %p waiting for data (to = %ld)\n",
>  		rqstp, timeout);
> @@ -624,7 +625,11 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
>  					set_current_state(TASK_RUNNING);
>  					return -EINTR;
>  				}
> +				if (bkl)
> +					unlock_kernel();
>  				schedule_timeout(msecs_to_jiffies(500));
> +				if (bkl)
> +					lock_kernel();
>  			}
>  			rqstp->rq_pages[i] = p;
>  		}
> @@ -643,7 +648,11 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
>  	arg->tail[0].iov_len = 0;
>  
>  	try_to_freeze();
> +	if (bkl)
> +		unlock_kernel();
>  	cond_resched();
> +	if (bkl)
> +		lock_kernel();
>  	if (signalled() || kthread_should_stop())
>  		return -EINTR;
>  
> @@ -685,7 +694,11 @@ int svc_recv(struct svc_rqst *rqstp, long timeout)
>  		add_wait_queue(&rqstp->rq_wait, &wait);
>  		spin_unlock_bh(&pool->sp_lock);
>  
> +		if (bkl)
> +			unlock_kernel();
>  		time_left = schedule_timeout(timeout);
> +		if (bkl)
> +			lock_kernel();
>  
>  		try_to_freeze();
>  
> diff --git a/sound/core/info.c b/sound/core/info.c
> index 35df614..eb81d55 100644
> --- a/sound/core/info.c
> +++ b/sound/core/info.c
> @@ -22,7 +22,6 @@
>  #include <linux/init.h>
>  #include <linux/time.h>
>  #include <linux/mm.h>
> -#include <linux/smp_lock.h>
>  #include <linux/string.h>
>  #include <sound/core.h>
>  #include <sound/minors.h>
> @@ -163,13 +162,14 @@ static void snd_remove_proc_entry(struct proc_dir_entry *parent,
>  
>  static loff_t snd_info_entry_llseek(struct file *file, loff_t offset, int orig)
>  {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct snd_info_private_data *data;
>  	struct snd_info_entry *entry;
>  	loff_t ret;
>  
>  	data = file->private_data;
>  	entry = data->entry;
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	switch (entry->content) {
>  	case SNDRV_INFO_CONTENT_TEXT:
>  		switch (orig) {
> @@ -198,7 +198,7 @@ static loff_t snd_info_entry_llseek(struct file *file, loff_t offset, int orig)
>  	}
>  	ret = -ENXIO;
>  out:
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return ret;
>  }
>  
> diff --git a/sound/core/sound.c b/sound/core/sound.c
> index 7872a02..b4ba31d 100644
> --- a/sound/core/sound.c
> +++ b/sound/core/sound.c
> @@ -21,7 +21,6 @@
>  
>  #include <linux/init.h>
>  #include <linux/slab.h>
> -#include <linux/smp_lock.h>
>  #include <linux/time.h>
>  #include <linux/device.h>
>  #include <linux/moduleparam.h>
> @@ -172,9 +171,9 @@ static int snd_open(struct inode *inode, struct file *file)
>  {
>  	int ret;
>  
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	ret = __snd_open(inode, file);
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return ret;
>  }
>  
> diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
> index 4191acc..98318b0 100644
> --- a/sound/oss/au1550_ac97.c
> +++ b/sound/oss/au1550_ac97.c
> @@ -49,7 +49,6 @@
>  #include <linux/poll.h>
>  #include <linux/bitops.h>
>  #include <linux/spinlock.h>
> -#include <linux/smp_lock.h>
>  #include <linux/ac97_codec.h>
>  #include <linux/mutex.h>
>  
> @@ -1254,7 +1253,6 @@ au1550_mmap(struct file *file, struct vm_area_struct *vma)
>  	unsigned long   size;
>  	int ret = 0;
>  
> -	lock_kernel();
>  	mutex_lock(&s->sem);
>  	if (vma->vm_flags & VM_WRITE)
>  		db = &s->dma_dac;
> @@ -1282,7 +1280,6 @@ au1550_mmap(struct file *file, struct vm_area_struct *vma)
>  	db->mapped = 1;
>  out:
>  	mutex_unlock(&s->sem);
> -	unlock_kernel();
>  	return ret;
>  }
>  
> @@ -1854,12 +1851,9 @@ au1550_release(struct inode *inode, struct file *file)
>  {
>  	struct au1550_state *s = (struct au1550_state *)file->private_data;
>  
> -	lock_kernel();
>  
>  	if (file->f_mode & FMODE_WRITE) {
> -		unlock_kernel();
>  		drain_dac(s, file->f_flags & O_NONBLOCK);
> -		lock_kernel();
>  	}
>  
>  	mutex_lock(&s->open_mutex);
> @@ -1876,7 +1870,6 @@ au1550_release(struct inode *inode, struct file *file)
>  	s->open_mode &= ((~file->f_mode) & (FMODE_READ|FMODE_WRITE));
>  	mutex_unlock(&s->open_mutex);
>  	wake_up(&s->open_wait);
> -	unlock_kernel();
>  	return 0;
>  }
>  
> diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
> index 793b7f4..86d7b9f 100644
> --- a/sound/oss/dmasound/dmasound_core.c
> +++ b/sound/oss/dmasound/dmasound_core.c
> @@ -181,7 +181,7 @@
>  #include <linux/init.h>
>  #include <linux/soundcard.h>
>  #include <linux/poll.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -329,10 +329,10 @@ static int mixer_open(struct inode *inode, struct file *file)
>  
>  static int mixer_release(struct inode *inode, struct file *file)
>  {
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	mixer.busy = 0;
>  	module_put(dmasound.mach.owner);
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return 0;
>  }
>  static int mixer_ioctl(struct inode *inode, struct file *file, u_int cmd,
> @@ -848,7 +848,7 @@ static int sq_release(struct inode *inode, struct file *file)
>  {
>  	int rc = 0;
>  
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  
>  	if (file->f_mode & FMODE_WRITE) {
>  		if (write_sq.busy)
> @@ -879,7 +879,7 @@ static int sq_release(struct inode *inode, struct file *file)
>  	write_sq_wake_up(file); /* checks f_mode */
>  #endif /* blocking open() */
>  
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  
>  	return rc;
>  }
> @@ -1296,10 +1296,10 @@ printk("dmasound: stat buffer used %d bytes\n", len) ;
>  
>  static int state_release(struct inode *inode, struct file *file)
>  {
> -	lock_kernel();
> +	mutex_lock($inode->i_mutex);
>  	state.busy = 0;
>  	module_put(dmasound.mach.owner);
> -	unlock_kernel();
> +	mutex_unlock($inode->i_mutex);
>  	return 0;
>  }
>  
> diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
> index bf27e00..039f57d 100644
> --- a/sound/oss/msnd_pinnacle.c
> +++ b/sound/oss/msnd_pinnacle.c
> @@ -40,7 +40,7 @@
>  #include <linux/delay.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  #include <asm/irq.h>
>  #include <asm/io.h>
>  #include "sound_config.h"
> @@ -791,14 +791,14 @@ static int dev_release(struct inode *inode, struct file *file)
>  	int minor = iminor(inode);
>  	int err = 0;
>  
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	if (minor == dev.dsp_minor)
>  		err = dsp_release(file);
>  	else if (minor == dev.mixer_minor) {
>  		/* nothing */
>  	} else
>  		err = -EINVAL;
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return err;
>  }
>  
> diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
> index 61aaeda..5376d7e 100644
> --- a/sound/oss/soundcard.c
> +++ b/sound/oss/soundcard.c
> @@ -41,7 +41,7 @@
>  #include <linux/major.h>
>  #include <linux/delay.h>
>  #include <linux/proc_fs.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/device.h>
> @@ -143,6 +143,7 @@ static int get_mixer_levels(void __user * arg)
>  
>  static ssize_t sound_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  	int dev = iminor(file->f_path.dentry->d_inode);
>  	int ret = -EINVAL;
>  
> @@ -152,7 +153,7 @@ static ssize_t sound_read(struct file *file, char __user *buf, size_t count, lof
>  	 *	big one anyway, we might as well bandage here..
>  	 */
>  	 
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	
>  	DEB(printk("sound_read(dev=%d, count=%d)\n", dev, count));
>  	switch (dev & 0x0f) {
> @@ -170,16 +171,17 @@ static ssize_t sound_read(struct file *file, char __user *buf, size_t count, lof
>  	case SND_DEV_MIDIN:
>  		ret = MIDIbuf_read(dev, file, buf, count);
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return ret;
>  }
>  
>  static ssize_t sound_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>  {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  	int dev = iminor(file->f_path.dentry->d_inode);
>  	int ret = -EINVAL;
>  	
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	DEB(printk("sound_write(dev=%d, count=%d)\n", dev, count));
>  	switch (dev & 0x0f) {
>  	case SND_DEV_SEQ:
> @@ -197,7 +199,7 @@ static ssize_t sound_write(struct file *file, const char __user *buf, size_t cou
>  		ret =  MIDIbuf_write(dev, file, buf, count);
>  		break;
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return ret;
>  }
>  
> @@ -254,7 +256,7 @@ static int sound_release(struct inode *inode, struct file *file)
>  {
>  	int dev = iminor(inode);
>  
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	DEB(printk("sound_release(dev=%d)\n", dev));
>  	switch (dev & 0x0f) {
>  	case SND_DEV_CTL:
> @@ -279,7 +281,7 @@ static int sound_release(struct inode *inode, struct file *file)
>  	default:
>  		printk(KERN_ERR "Sound error: Releasing unknown device 0x%02x\n", dev);
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  
>  	return 0;
>  }
> @@ -417,6 +419,7 @@ static unsigned int sound_poll(struct file *file, poll_table * wait)
>  
>  static int sound_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  	int dev_class;
>  	unsigned long size;
>  	struct dma_buffparms *dmap = NULL;
> @@ -429,35 +432,35 @@ static int sound_mmap(struct file *file, struct vm_area_struct *vma)
>  		printk(KERN_ERR "Sound: mmap() not supported for other than audio devices\n");
>  		return -EINVAL;
>  	}
> -	lock_kernel();
> +	mutex_lock(&inode->i_mutex);
>  	if (vma->vm_flags & VM_WRITE)	/* Map write and read/write to the output buf */
>  		dmap = audio_devs[dev]->dmap_out;
>  	else if (vma->vm_flags & VM_READ)
>  		dmap = audio_devs[dev]->dmap_in;
>  	else {
>  		printk(KERN_ERR "Sound: Undefined mmap() access\n");
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -EINVAL;
>  	}
>  
>  	if (dmap == NULL) {
>  		printk(KERN_ERR "Sound: mmap() error. dmap == NULL\n");
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -EIO;
>  	}
>  	if (dmap->raw_buf == NULL) {
>  		printk(KERN_ERR "Sound: mmap() called when raw_buf == NULL\n");
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -EIO;
>  	}
>  	if (dmap->mapping_flags) {
>  		printk(KERN_ERR "Sound: mmap() called twice for the same DMA buffer\n");
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -EIO;
>  	}
>  	if (vma->vm_pgoff != 0) {
>  		printk(KERN_ERR "Sound: mmap() offset must be 0.\n");
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -EINVAL;
>  	}
>  	size = vma->vm_end - vma->vm_start;
> @@ -468,7 +471,7 @@ static int sound_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (remap_pfn_range(vma, vma->vm_start,
>  			virt_to_phys(dmap->raw_buf) >> PAGE_SHIFT,
>  			vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return -EAGAIN;
>  	}
>  
> @@ -480,7 +483,7 @@ static int sound_mmap(struct file *file, struct vm_area_struct *vma)
>  	memset(dmap->raw_buf,
>  	       dmap->neutral_byte,
>  	       dmap->bytes_in_use);
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return 0;
>  }
>  
> diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
> index 187f727..f14e81d 100644
> --- a/sound/oss/vwsnd.c
> +++ b/sound/oss/vwsnd.c
> @@ -145,7 +145,6 @@
>  #include <linux/init.h>
>  
>  #include <linux/spinlock.h>
> -#include <linux/smp_lock.h>
>  #include <linux/wait.h>
>  #include <linux/interrupt.h>
>  #include <linux/mutex.h>
> @@ -3005,7 +3004,6 @@ static int vwsnd_audio_release(struct inode *inode, struct file *file)
>  	vwsnd_port_t *wport = NULL, *rport = NULL;
>  	int err = 0;
>  
> -	lock_kernel();
>  	mutex_lock(&devc->io_mutex);
>  	{
>  		DBGEV("(inode=0x%p, file=0x%p)\n", inode, file);
> @@ -3033,7 +3031,6 @@ static int vwsnd_audio_release(struct inode *inode, struct file *file)
>  	wake_up(&devc->open_wait);
>  	DEC_USE_COUNT;
>  	DBGR();
> -	unlock_kernel();
>  	return err;
>  }
>  
> diff --git a/sound/sound_core.c b/sound/sound_core.c
> index 2b302bb..76691a0 100644
> --- a/sound/sound_core.c
> +++ b/sound/sound_core.c
> @@ -515,7 +515,7 @@ static int soundcore_open(struct inode *inode, struct file *file)
>  	struct sound_unit *s;
>  	const struct file_operations *new_fops = NULL;
>  
> -	lock_kernel ();
> +	mutex_lock(&inode->i_mutex);
>  
>  	chain=unit&0x0F;
>  	if(chain==4 || chain==5)	/* dsp/audio/dsp16 */
> @@ -564,11 +564,11 @@ static int soundcore_open(struct inode *inode, struct file *file)
>  			file->f_op = fops_get(old_fops);
>  		}
>  		fops_put(old_fops);
> -		unlock_kernel();
> +		mutex_unlock(&inode->i_mutex);
>  		return err;
>  	}
>  	spin_unlock(&sound_loader_lock);
> -	unlock_kernel();
> +	mutex_unlock(&inode->i_mutex);
>  	return -ENODEV;
>  }
>  

