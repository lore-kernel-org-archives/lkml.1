Return-Path: <linux-kernel-owner+w=401wt.eu-S1761519AbYEGPQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761519AbYEGPQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbYEGPQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:16:05 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58251 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbYEGPQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:16:01 -0400
To: chrisw@sous-sol.org
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       takedakn@nttdata.co.jp
Subject: Re: [TOMOYO #8 (2.6.25-mm1) 1/7] Introduce new LSM hooks.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080501055405.024390000@nttdata.co.jp>
	<20080501055543.269648000@nttdata.co.jp>
	<20080501080144.GJ30511@sequoia.sous-sol.org>
In-Reply-To: <20080501080144.GJ30511@sequoia.sous-sol.org>
Message-Id: <200805080015.AHG26033.QOVMLOSFJHOFtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 8 May 2008 00:15:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Chris Wright wrote:

> * Toshiharu Harada (haradats@nttdata.co.jp) wrote:
> > This patch allows LSM to check permission using "struct vfsmount"
> > without passing "struct vfsmount" to VFS helper functions.
> 
> This is simply duplicating many of the existing checks.
> I don't see how this is an improvement.
> 
> > --- mm.orig/fs/namei.c
> > +++ mm/fs/namei.c
> > @@ -1595,6 +1595,9 @@ int vfs_create(struct inode *dir, struct
> >  	error = security_inode_create(dir, dentry, mode);
> >  	if (error)
> >  		return error;
> > +	error = security_path_create(dir, dentry, mode, nd);
> > +	if (error)
> > +		return error;
> 
> Pure duplication (of course adding nameidata, although I think you just
> want path).

Right. I should have added "path" parameter rather than adding a new hook.
But to avoid touching vfs_*(), I moved security_path_create() to
the callers of vfs_create().

> >  	DQUOT_INIT(dir);
> >  	error = dir->i_op->create(dir, dentry, mode, nd);
> >  	if (!error)
> > @@ -1650,6 +1653,17 @@ int may_open(struct nameidata *nd, int a
> 	...
> 	error = vfs_permission(nd, acc_mode);
> 	if (error)
> 		return error;
> 	...
> >  			return -EPERM;
> >  
> >  	/*
> > +	 * security_inode_permission() called from vfs_permission()
> > +	 * can't know that the file is going to be truncated when
> > +	 * open(filename, O_WRONLY | O_TRUNC | O_APPEND) is used.
> > +	 * So, this hook checks O_APPEND and O_TRUNC flags as well
> > +	 * as MAY_READ and MAY_WRITE flags.
> > +	 */
> > +	error = security_path_open(nd->path.dentry, nd->path.mnt, flag);
> > +	if (error)
> > +		return error;
> 
> Also duplication.  And why the unique flag handling, you don't seem to
> ever check?

Sorry. I didn't know security_dentry_open() is available.
Now, security_path_open() and security_path_uselib() have gone away.
But it also turned out that security_dentry_open() is too late for
checking open(O_CREAT) and open(O_TRUNC) cases. Thus, somehow,
I want to check O_CREAT before entering vfs_create() and
check O_TRUNC before entering do_truncate() from may_open().

Regards.
