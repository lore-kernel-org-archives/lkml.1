Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZFBHGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZFBHGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759165AbZFBHGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:06:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:37883 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758917AbZFBHGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:06:42 -0400
Date: Tue, 2 Jun 2009 09:06:42 +0200
From: Nick Piggin <npiggin@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 03/23] vfs: Generalize the file_list
Message-ID: <20090602070642.GD31556@wotan.suse.de>
References: <m1oct739xu.fsf@fess.ebiederm.org> <1243893048-17031-3-git-send-email-ebiederm@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243893048-17031-3-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 02:50:28PM -0700, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> In the implementation of revoke it is desirable to find all of the
> files we want to operation on.  Currently tty's and mark_files_ro
> use the file_list for this, and this patch generalizes the file
> list so it can be used more efficiently.
> 
> This patch starts by introducing struct file_list making the file
> list a first class object.  file_list_lock and file_list_unlock
> are modified to take this object, making it clear which file_list
> we intended to lock.
> 
> file_move is transformed into file_list_add taking a file_list and not
> allowing the movement of one file to another. __dentry_open
> is modified to support this by only adding normal files in open,
> special files have always been ignored when walking the file_list.
> __dentry_open skipping special files allows __ptmx_open and __tty_open
> to safely call file_add as they are adding the file to the file_list
> for the first time.
> 
> file_kill has been renamed file_list_del to make it clear what it is
> doing and to keep from confusing it with a more revoke like operation.
> 
> put_filp has been modified to not take file_list_del as we are never
> on a file_list when put_filp is called.
> 
> fs_may_remount_ro and mark_files_ro have been modified to walk the
> inode list to find all of the inodes and then to walk the file list
> on those inodes.  It can be a slightly longer walk as we frequently
> cache inodes that we do not have open but the overall complexity
> should be about the same,

Well not really. I have a couple of orders of magnitude more cached
inodes than open files here.


> these are slow path functions, and it
> gives us much greater flexibility overall.

Define flexibility. Walking the sb's file list and checking for
equality with the inode in question gives the same functionality,
just different performance profile.


> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -699,6 +699,11 @@ static inline int mapping_writably_mapped(struct address_space *mapping)
>  	return mapping->i_mmap_writable != 0;
>  }
>  
> +struct file_list {
> +	spinlock_t		lock;
> +	struct list_head	list;
> +};
> +
>  /*
>   * Use sequence counter to get consistent i_size on 32-bit processors.
>   */
> @@ -764,6 +769,7 @@ struct inode {
>  	struct list_head	inotify_watches; /* watches on this inode */
>  	struct mutex		inotify_mutex;	/* protects the watches list */
>  #endif
> +	struct file_list	i_files;
>  
>  	unsigned long		i_state;
>  	unsigned long		dirtied_when;	/* jiffies of first dirtying */
> @@ -934,9 +940,15 @@ struct file {
>  	unsigned long f_mnt_write_state;
>  #endif
>  };
> -extern spinlock_t files_lock;
> -#define file_list_lock() spin_lock(&files_lock);
> -#define file_list_unlock() spin_unlock(&files_lock);
> +
> +static inline void file_list_lock(struct file_list *files)
> +{
> +	spin_lock(&files->lock);
> +}
> +static inline void file_list_unlock(struct file_list *files)
> +{
> +	spin_unlock(&files->lock);
> +}

I don't really like this. It's just a list head. Get rid of
all these wrappers and crap I'd say. In fact, starting with my
patch to unexport files_lock and remove these wrappers would
be reasonable, wouldn't it?

Increasing the size of the struct inode by 24 bytes hurts.
Even when you decrapify it and can reuse i_lock or something,
then it is still 16 bytes on 64-bit.

I haven't looked through all the patches... but this is to
speed up a slowpath operation, isn't it? Or does revoke
need to be especially performant?

So this patch is purely a perofrmance improvement? Then I think
it needs to be justified with numbers and the downsides (bloating
struct inode in particulra) to be changelogged.
