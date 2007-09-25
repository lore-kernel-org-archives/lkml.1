Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbXIYIZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbXIYIZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbXIYIZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:25:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:48447 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754600AbXIYIZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:25:15 -0400
Date: Tue, 25 Sep 2007 10:46:30 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, folkert@vanheusden.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.22] circular lock detected
Message-ID: <20070925084630.GA412@duck.suse.cz>
References: <20070824210033.GB13237@vanheusden.com> <20070902045529.c66eddc9.akpm@linux-foundation.org> <20070903122702.GC29908@atrey.karlin.mff.cuni.cz> <20070903054959.3ecd9576.akpm@linux-foundation.org> <20070903140135.GE7524@duck.suse.cz> <20070925100243.2ceebd9e@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925100243.2ceebd9e@twins>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 25-09-07 10:02:43, Peter Zijlstra wrote:
> On Mon, 3 Sep 2007 16:01:35 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > On Mon 03-09-07 05:49:59, Andrew Morton wrote:
> > > > On Mon, 3 Sep 2007 14:27:02 +0200 Jan Kara <jack@suse.cz> wrote:
> > > > > > On Fri, 24 Aug 2007 23:00:33 +0200 Folkert van Heusden <folkert@vanheusden.com> wrote:
> 
> > > > > Has been reported before, but I don't recall whether we fixed it.  Jan,
> > > > > do you know>?
> > > >   I think we at least found a solution: Teach lockdep that I_MUTEX for
> > > > different filesystems is different. Peter Zilstra wrote a patch for that
> > > > and Folkert even confirmed that it fixes the problem for him. I'm not
> > > > sure what happened with the patch afterwards though. Adding Peter to CC
> > > > :).
> > > 
> > > But this is a tty_lock-versus-dqptr_sem ranking error.  Unrelated to i_mutex?
> >   The final report is for this ranking but the locking chain (if I understand it
> > right) is:
> > tty_mutex (con_close) -> i_mutex (sysfs: remove_subdir)
> > i_mutex (do_truncate) -> i_alloc_sem (notify_change) -> truncate_mutex (ext3_truncate)
> > truncate_mutex (ext3_get_blocks_handle) -> dqptr_sem (dquot_alloc_space)
> > 
> > So it complains about tty_mutex vs dqptr_sem (I don't know why it does not
> > complain about tty_mutex vs i_mutex) but the wrong link in the chain is
> > that i_mutex from remove_subdir() [sysfs] and i_mutex from do_truncate()
> > [ext3] are different and should never depend on each other...
> > 
> 
> Found it again.
  Cool, thanks Peter. Andrew, would you put it into -mm? This should take care of
the false lockdep warnings from the quota code. If I recall correctly, one
of the reporters even confirmed it fixes the problem for him.
  The patch looks fine. You can add:
Signed-off-by: Jan Kara <jack@suse.cz>

									Honza

> Give each filesystem its own inode lock class. The various filesystems have
> different locking order wrt the inode locks; esp. the pseudo filesystems
> differ from the rest.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  fs/inode.c         |   12 +++++++++---
>  include/linux/fs.h |    5 +++++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c
> +++ linux-2.6/fs/inode.c
> @@ -142,6 +142,15 @@ static struct inode *alloc_inode(struct 
>  			return NULL;
>  		}
>  
> +		spin_lock_init(&inode->i_lock);
> +		lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
> +
> +		mutex_init(&inode->i_mutex);
> +		lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
> +
> +		init_rwsem(&inode->i_alloc_sem);
> +		lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
> +
>  		mapping->a_ops = &empty_aops;
>   		mapping->host = inode;
>  		mapping->flags = 0;
> @@ -190,8 +199,6 @@ void inode_init_once(struct inode *inode
>  	INIT_HLIST_NODE(&inode->i_hash);
>  	INIT_LIST_HEAD(&inode->i_dentry);
>  	INIT_LIST_HEAD(&inode->i_devices);
> -	mutex_init(&inode->i_mutex);
> -	init_rwsem(&inode->i_alloc_sem);
>  	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
>  	rwlock_init(&inode->i_data.tree_lock);
>  	spin_lock_init(&inode->i_data.i_mmap_lock);
> @@ -199,7 +206,6 @@ void inode_init_once(struct inode *inode
>  	spin_lock_init(&inode->i_data.private_lock);
>  	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
>  	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
> -	spin_lock_init(&inode->i_lock);
>  	i_size_ordered_init(inode);
>  #ifdef CONFIG_INOTIFY
>  	INIT_LIST_HEAD(&inode->inotify_watches);
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h
> +++ linux-2.6/include/linux/fs.h
> @@ -1302,8 +1302,13 @@ struct file_system_type {
>  	struct module *owner;
>  	struct file_system_type * next;
>  	struct list_head fs_supers;
> +
>  	struct lock_class_key s_lock_key;
>  	struct lock_class_key s_umount_key;
> +
> +	struct lock_class_key i_lock_key;
> +	struct lock_class_key i_mutex_key;
> +	struct lock_class_key i_alloc_sem_key;
>  };
>  
>  extern int get_sb_bdev(struct file_system_type *fs_type,
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
