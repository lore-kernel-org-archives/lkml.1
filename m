Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZLDEEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZLDEEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 23:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbZLDEEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 23:04:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:55308 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbZLDEEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 23:04:41 -0500
Date: Fri, 4 Dec 2009 05:04:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, jmorris@namei.org, zohar@us.ibm.com,
       jack@suse.cz, jmalicki@metacarta.com, dsmith@redhat.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
Subject: Re: [RFC PATCH 5/6] vfs: make init-file static
Message-ID: <20091204040443.GD22022@wotan.suse.de>
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com> <20091203195925.8925.21416.stgit@paris.rdu.redhat.com> <20091203224402.GA12995@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091203224402.GA12995@us.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 04:44:02PM -0600, Serge E. Hallyn wrote:
> Quoting Eric Paris (eparis@redhat.com):
> > init-file is no longer used by anything except alloc_file.  Make it static and
> > remove from headers.

These look like pretty good changes to me, FWIW. I had found myself
wondering about this recently so it's good to see it improved.


> Should these go through a deprecation period?  (Same for the next patch)

Maybe waiting a release or two couldn't hurt. Unless Eric you
have some other changes in mind after these?

 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> >  fs/file_table.c      |   73 ++++++++++++++++++++++----------------------------
> >  include/linux/file.h |    3 --
> >  2 files changed, 32 insertions(+), 44 deletions(-)
> > 
> > diff --git a/fs/file_table.c b/fs/file_table.c
> > index 4bef4c0..0f9d2f2 100644
> > --- a/fs/file_table.c
> > +++ b/fs/file_table.c
> > @@ -150,53 +150,16 @@ fail:
> >  EXPORT_SYMBOL(get_empty_filp);
> > 
> >  /**
> > - * alloc_file - allocate and initialize a 'struct file'
> > - * @mnt: the vfsmount on which the file will reside
> > - * @dentry: the dentry representing the new file
> > - * @mode: the mode with which the new file will be opened
> > - * @fop: the 'struct file_operations' for the new file
> > - *
> > - * Use this instead of get_empty_filp() to get a new
> > - * 'struct file'.  Do so because of the same initialization
> > - * pitfalls reasons listed for init_file().  This is a
> > - * preferred interface to using init_file().
> > - *
> > - * If all the callers of init_file() are eliminated, its
> > - * code should be moved into this function.
> > - */
> > -struct file *alloc_file(struct vfsmount *mnt, struct dentry *dentry,
> > -		fmode_t mode, const struct file_operations *fop)
> > -{
> > -	struct file *file;
> > -
> > -	file = get_empty_filp();
> > -	if (!file)
> > -		return NULL;
> > -
> > -	init_file(file, mnt, dentry, mode, fop);
> > -	return file;
> > -}
> > -EXPORT_SYMBOL(alloc_file);
> > -
> > -/**
> >   * init_file - initialize a 'struct file'
> >   * @file: the already allocated 'struct file' to initialized
> >   * @mnt: the vfsmount on which the file resides
> >   * @dentry: the dentry representing this file
> >   * @mode: the mode the file is opened with
> >   * @fop: the 'struct file_operations' for this file
> > - *
> > - * Use this instead of setting the members directly.  Doing so
> > - * avoids making mistakes like forgetting the mntget() or
> > - * forgetting to take a write on the mnt.
> > - *
> > - * Note: This is a crappy interface.  It is here to make
> > - * merging with the existing users of get_empty_filp()
> > - * who have complex failure logic easier.  All users
> > - * of this should be moving to alloc_file().
> >   */
> > -int init_file(struct file *file, struct vfsmount *mnt, struct dentry *dentry,
> > -	   fmode_t mode, const struct file_operations *fop)
> > +static int init_file(struct file *file, struct vfsmount *mnt,
> > +		     struct dentry *dentry, fmode_t mode,
> > +		     const struct file_operations *fop)
> >  {
> >  	int error = 0;
> >  	file->f_path.dentry = dentry;
> > @@ -218,7 +181,35 @@ int init_file(struct file *file, struct vfsmount *mnt, struct dentry *dentry,
> >  	}
> >  	return error;
> >  }
> > -EXPORT_SYMBOL(init_file);
> > +
> > +/**
> > + * alloc_file - allocate and initialize a 'struct file'
> > + * @mnt: the vfsmount on which the file will reside
> > + * @dentry: the dentry representing the new file
> > + * @mode: the mode with which the new file will be opened
> > + * @fop: the 'struct file_operations' for the new file
> > + *
> > + * Use this instead of get_empty_filp() to get a new
> > + * 'struct file'.  Do so because of the same initialization
> > + * pitfalls reasons listed for init_file().  This is a
> > + * preferred interface to using init_file().
> > + *
> > + * If all the callers of init_file() are eliminated, its
> > + * code should be moved into this function.
> > + */
> > +struct file *alloc_file(struct vfsmount *mnt, struct dentry *dentry,
> > +		fmode_t mode, const struct file_operations *fop)
> > +{
> > +	struct file *file;
> > +
> > +	file = get_empty_filp();
> > +	if (!file)
> > +		return NULL;
> > +
> > +	init_file(file, mnt, dentry, mode, fop);
> > +	return file;
> > +}
> > +EXPORT_SYMBOL(alloc_file);
> > 
> >  void fput(struct file *file)
> >  {
> > diff --git a/include/linux/file.h b/include/linux/file.h
> > index 335a0a5..6a8d361 100644
> > --- a/include/linux/file.h
> > +++ b/include/linux/file.h
> > @@ -18,9 +18,6 @@ extern void drop_file_write_access(struct file *file);
> >  struct file_operations;
> >  struct vfsmount;
> >  struct dentry;
> > -extern int init_file(struct file *, struct vfsmount *mnt,
> > -		struct dentry *dentry, fmode_t mode,
> > -		const struct file_operations *fop);
> >  extern struct file *alloc_file(struct vfsmount *, struct dentry *dentry,
> >  		fmode_t mode, const struct file_operations *fop);
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
