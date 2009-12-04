Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbZLDOUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbZLDOUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbZLDOUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:20:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbZLDOUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:20:15 -0500
Subject: Re: [RFC PATCH 1/6] shmem: use alloc_file instead of init_file
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, serue@us.ibm.com, hch@lst.de, john@johnmccutchan.com,
       rlove@rlove.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       jens.axboe@oracle.com, akpm@linux-foundation.org, matthew@wil.cx,
       hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, davem@davemloft.net, arnd@arndb.de,
       eric.dumazet@gmail.com
In-Reply-To: <E1NGRBh-0004da-Cv@pomaz-ex.szeredi.hu>
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
	 <E1NGRBh-0004da-Cv@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 09:19:13 -0500
Message-Id: <1259936353.2722.4.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 06:58 +0100, Miklos Szeredi wrote:
> On Thu, 03 Dec 2009, Eric Paris wrote:
> > shmem uses get_empty_filp() and then init_file().  Their is no good reason
> > not to just use alloc_file() like everything else.
> 
> There's a more in this patch, though, and none of that is explained...
> 
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> >  mm/shmem.c |   20 ++++++++++----------
> >  1 files changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 356dd99..831f8bb 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2640,32 +2640,32 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
> >  	if (!dentry)
> >  		goto put_memory;
> >  
> > -	error = -ENFILE;
> > -	file = get_empty_filp();
> > -	if (!file)
> > -		goto put_dentry;
> > -
> >  	error = -ENOSPC;
> >  	inode = shmem_get_inode(root->d_sb, S_IFREG | S_IRWXUGO, 0, flags);
> >  	if (!inode)
> > -		goto close_file;
> > +		goto put_dentry;
> >  
> >  	d_instantiate(dentry, inode);
> >  	inode->i_size = size;
> >  	inode->i_nlink = 0;	/* It is unlinked */
> > -	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> > -		  &shmem_file_operations);
> > +
> > +	error = -ENFILE;
> > +	file = alloc_file(shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
> > +			  &shmem_file_operations);
> > +	if (!file)
> > +		goto put_dentry;
> >  
> >  #ifndef CONFIG_MMU
> >  	error = ramfs_nommu_expand_for_mapping(inode, size);
> >  	if (error)
> >  		goto close_file;
> >  #endif
> > -	ima_counts_get(file);
> 
> Where's this gone?

That's the impetuous for the whole patch series.  I originally did the
ima rework first an the vfs changes second, but decided to push the vfs
stuff first and I guess I forgot to back out this bit of ima change I
had done.  This will be dropped for actual submission. 

> >  	return file;
> >  
> > +#ifndef CONFIG_MMU
> >  close_file:
> 
> I suggest moving this piece of cleanup into the ifdef above, instead
> of adding more ifdefs.

Ok.

> > -	put_filp(file);
> > +	fput(file);
> 
> OK, put_filp() seems to have been wrong here, but please document it
> in the changelog.

It was only wrong in the ifndef !CONFIG_MMU case.  The other error path
which ended up here used it correctly.  In any case, I'll mention it in
the changelog.

