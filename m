Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXBMQJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXBMQJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXBMQJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:09:45 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:21780 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXBMQJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:09:44 -0500
Date: Tue, 13 Feb 2007 19:16:27 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, viro@ftp.linux.org.uk,
       linux-kernel@vger.kernel.org, duncan.sands@math.u-psud.fr
Subject: Re: [PATCH v4] Fix rmmod/read/write races in /proc entries
Message-ID: <20070213161627.GC6036@localhost.sw.ru>
References: <20070208132012.GA6041@localhost.sw.ru> <20070209010037.7f4393c5.akpm@linux-foundation.org> <20070211202330.GA24509@martell.zuzino.mipt.ru> <20070212223552.59d733b1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212223552.59d733b1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 10:35:52PM -0800, Andrew Morton wrote:
> On Sun, 11 Feb 2007 23:23:30 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > [PATCH v4] Fix rmmod/read/write races in /proc entries
> 
> This:
> 
> static ssize_t
> proc_file_write(struct file *file, const char __user *buffer,
> 		size_t count, loff_t *ppos)
> {
> 	struct inode *inode = file->f_path.dentry->d_inode;
> 	struct proc_dir_entry * dp;
> 	ssize_t rv = -EIO;
> 	
> 	dp = PDE(inode);
> 
> 	if (!dp->write_proc)
> 		goto out;
> 
> 	spin_lock(&dp->pde_unload_lock);
> 	if (!dp->proc_fops)
> 		/*
> 		 * remove_proc_entry() marked PDE as "going away".
> 		 * No new writers allowed.
> 		 */
> 		goto out_unlock;
> 
> versus
> 
> 		spin_lock(&de->pde_unload_lock);
> 		/*
> 		 * Stop accepting new readers/writers. If you're dynamically
> 		 * allocating ->proc_fops, save a pointer somewhere.
> 		 */
> 		de->proc_fops = NULL;
> 		/* Wait until all existing readers/writers are done. */
> 		if (de->pde_users > 0) {
> 			struct completion c;
>
> 			init_completion(&c);
> 			if (!de->pde_unload_completion)
> 				de->pde_unload_completion = &c;
>
> 			spin_unlock(&de->pde_unload_lock);
> 			spin_unlock(&proc_subdir_lock);
>
> 			wait_for_completion(de->pde_unload_completion);
>
> 			spin_lock(&proc_subdir_lock);
> 			goto continue_removing;
> 		}
> 		spin_unlock(&de->pde_unload_lock);
>   <here>
> 	...
> 	<free de>
>
> What prevents proc_file_write() from looking up and playing with this de in
> <here>?

If I understood your two-column diagram correctly, scenario below can't
happen because of PDE's own refcount (->count) and existence of
->deleted (0/1)

remove_proc_entry() sees positive ->count and doesn't immediately free
PDE. remove_proc_entry() will at most a) lock b) access to check
->proc_fops which is NULL now, and c) unlock which is fine because
memory is in place.

->count is bumped in proc_get_inode after checking PDEs lists, but our
PDE was already removed from it.

