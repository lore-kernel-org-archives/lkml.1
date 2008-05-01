Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbYEAPSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbYEAPSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbYEAPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:17:55 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:43841 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYEAPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:17:54 -0400
Subject: Re: [TOMOYO #8 (2.6.25-mm1) 1/7] Introduce new LSM hooks.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: chrisw@sous-sol.org, viro@ZenIV.linux.org.uk, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
In-Reply-To: <200805020007.HHC90622.OQSFOJtVOMFHFL@I-love.SAKURA.ne.jp>
References: <20080501055405.024390000@nttdata.co.jp>
	 <20080501055543.269648000@nttdata.co.jp>
	 <20080501080144.GJ30511@sequoia.sous-sol.org>
	 <200805020007.HHC90622.OQSFOJtVOMFHFL@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 01 May 2008 11:17:28 -0400
Message-Id: <1209655048.25678.478.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 00:07 +0900, Tetsuo Handa wrote:
> Hello.
> 
> Chris Wright wrote:
> > * Toshiharu Harada (haradats@nttdata.co.jp) wrote:
> > > This patch allows LSM to check permission using "struct vfsmount"
> > > without passing "struct vfsmount" to VFS helper functions.
> > 
> > This is simply duplicating many of the existing checks.
> > I don't see how this is an improvement.
> > 
> > > --- mm.orig/fs/namei.c
> > > +++ mm/fs/namei.c
> > > @@ -1595,6 +1595,9 @@ int vfs_create(struct inode *dir, struct
> > >  	error = security_inode_create(dir, dentry, mode);
> > >  	if (error)
> > >  		return error;
> > > +	error = security_path_create(dir, dentry, mode, nd);
> > > +	if (error)
> > > +		return error;
> > 
> > Pure duplication (of course adding nameidata, although I think you just
> > want path).
> 
> Stephen Smalley advised me to add parameter to existing hook rather than
> introducing a new hook if the location of existing hook is appropriate.
> OK. I'd like to add "struct nameidata" to security_inode_create()
> rather than introducing security_path_create() in the next patch.

I had thought you were going to add new hooks in the callers, not try to
use the nameidata here.  And I wouldn't pass the nameidata there, just
what you actually need (e.g. the vfsmount).

> > 
> > >  	DQUOT_INIT(dir);
> > >  	error = dir->i_op->create(dir, dentry, mode, nd);
> > >  	if (!error)
> > > @@ -1650,6 +1653,17 @@ int may_open(struct nameidata *nd, int a
> > 	...
> > 	error = vfs_permission(nd, acc_mode);
> > 	if (error)
> > 		return error;
> > 	...
> > >  			return -EPERM;
> > >  
> > >  	/*
> > > +	 * security_inode_permission() called from vfs_permission()
> > > +	 * can't know that the file is going to be truncated when
> > > +	 * open(filename, O_WRONLY | O_TRUNC | O_APPEND) is used.
> > > +	 * So, this hook checks O_APPEND and O_TRUNC flags as well
> > > +	 * as MAY_READ and MAY_WRITE flags.
> > > +	 */
> > > +	error = security_path_open(nd->path.dentry, nd->path.mnt, flag);
> > > +	if (error)
> > > +		return error;
> > 
> > Also duplication.  And why the unique flag handling, you don't seem to
> > ever check?
> 
> The MAY_WRITE flag is not passed to security_inode_permission()
> if security_inode_permission() is called from __open_namei_create().
> Since TOMOYO Linux doesn't check MAY_READ/MAY_WRITE permissions for individual
> read()/write() requests, the permission checks at open() time (i.e. may_open())
> is the only chance to check MAY_WRITE flag. If I can't check MAY_WRITE flag
> here, TOMOYO Linux can't control open(O_WRONLY | O_CREATE | O_EXCL).

You can apply whatever checks you want from your hook in the create
path, right?

> > > @@ -2021,7 +2035,12 @@ fail:
> > >  }
> > >  EXPORT_SYMBOL_GPL(lookup_create);
> > >  
> > > -int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> > > +/*
> > > + * These pre_vfs_*() functions are separated from vfs_*() functions so that
> > > + * LSM's security_path_*() functions can do DAC checks before MAC checks
> > > + * without duplicating may_create()/may_delete() functions.
> > > + */
> > > +int pre_vfs_mknod(struct inode *dir, struct dentry *dentry, int mode)
> > >  {
> > >  	int error = may_create(dir, dentry, NULL);
> > >  
> > > @@ -2033,6 +2052,14 @@ int vfs_mknod(struct inode *dir, struct 
> > >  
> > >  	if (!dir->i_op || !dir->i_op->mknod)
> > >  		return -EPERM;
> > > +	return 0;
> > > +}
> > > +
> > > +int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
> > > +{
> > > +	int error = pre_vfs_mknod(dir, dentry, mode);
> > > +	if (error)
> > > +		return error;
> > 
> > More duplication, you'll get a call chain like:
> > 
> > sys_mknod
> >   security_path_mknod
> >     pre_vfs_mknod
> >   vfs_mknod
> >    pre_vfs_mknod
> >    security_inode_mknod
> > 
> This is an inevitable duplication since I want to do conventional checks
> (DAC checks and inode operation existence checks) before TOMOYO Linux's check.
> 
> By the way, Stephen Smalley thinks it is better to copy codes which is needed by
> pre_vfs_*() (i.e. may_create()/may_delete()/check_sticky()) into
> security/tomoyo/ directory and leave vfs_*() untouched rather than
> extract pre_vfs_*() from vfs_*() and call pre_vfs_*() from vfs_*().
> Question to Al Viro: Do you prefer "copying may_create()/may_delete()/
> check_sticky() functions into security/tomoyo/ directory and leaving vfs_*()
> untouched" to "extracting pre_vfs_*() and making them accessible from
> security/tomoyo/ directory"? If you prefer copying, I'd like to copy them and
> remove pre_vfs_*() in the next patch.

I don't see how splitting out the parts that you are putting in the pre_
functions is especially useful.  Making the may_create()/may_delete()
helpers non-static might make sense.

-- 
Stephen Smalley
National Security Agency

