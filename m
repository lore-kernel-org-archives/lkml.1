Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZDYDcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZDYDcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 23:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZDYDch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 23:32:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60055 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZDYDcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 23:32:36 -0400
Date: Sat, 25 Apr 2009 04:32:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 02/27] fs: scale files_lock
Message-ID: <20090425033235.GU8633@ZenIV.linux.org.uk>
References: <20090425012020.457460929@suse.de> <20090425012209.213810410@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425012209.213810410@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 11:20:22AM +1000, npiggin@suse.de wrote:
> Improve scalability of files_lock by adding per-cpu, per-sb files lists,
> protected with per-cpu locking. Effectively turning it into a big-writer
> lock.

Og dumb.  Many locks.  Many ifdefs.  Og don't like.

>  void file_sb_list_add(struct file *file, struct super_block *sb)
>  {
> -	spin_lock(&files_lock);
> +	spinlock_t *lock;
> +	struct list_head *list;
> +	int cpu;
> +
> +	lock = &get_cpu_var(files_cpulock);
> +#ifdef CONFIG_SMP
> +	BUG_ON(file->f_sb_list_cpu != -1);
> +	cpu = smp_processor_id();
> +	list = per_cpu_ptr(sb->s_files, cpu);
> +	file->f_sb_list_cpu = cpu;
> +#else
> +	list = &sb->s_files;
> +#endif
> +	spin_lock(lock);
>  	BUG_ON(!list_empty(&file->f_u.fu_list));
> -	list_add(&file->f_u.fu_list, &sb->s_files);
> -	spin_unlock(&files_lock);
> +	list_add(&file->f_u.fu_list, list);
> +	spin_unlock(lock);
> +	put_cpu_var(files_cpulock);
>  }

Don't like overhead on hot paths either.

And grown memory footprint of struct super_block (with alloc_percpu())

>  	atomic_long_t		f_count;
>  	unsigned int 		f_flags;
>  	fmode_t			f_mode;
> @@ -1330,7 +1333,11 @@ struct super_block {
>  	struct list_head	s_io;		/* parked for writeback */
>  	struct list_head	s_more_io;	/* parked for more writeback */
>  	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
> +#ifdef CONFIG_SMP
> +	struct list_head	*s_files;
> +#else
>  	struct list_head	s_files;
> +#endif
>  	/* s_dentry_lru and s_nr_dentry_unused are protected by dcache_lock */
>  	struct list_head	s_dentry_lru;	/* unused dentry lru */
>  	int			s_nr_dentry_unused;	/* # of dentry on lru */

... and ifdefs like that in structs.

What I really want to see is a rationale for all that.  Preferably with
more than microbenchmarks showing a visible impact.

Especially if you compare it with alternative variant that simply splits
files_lock on per-sb basis.
