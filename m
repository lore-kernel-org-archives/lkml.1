Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYIYRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYIYRA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYIYRAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:00:12 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34499 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYIYRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:00:10 -0400
Date: Thu, 25 Sep 2008 11:59:54 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #9 (2.6.27-rc7-mm1) 1/6] LSM adapter functions.
Message-ID: <20080925165954.GA25587@us.ibm.com>
References: <20080924090317.359685535@nttdata.co.jp> <20080924090338.407746083@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080924090338.407746083@nttdata.co.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>

So IMO there is some major badness here in the form of copying all of
those functions out of fs/namei.c.  I think we need to discuss
case-by-case whether using the functions is appropriate (and hence
they should be made non-static in fs/namei.c), or whether the intended
goal should be met some other way.  For instance:
 
> ---
>  security/tomoyo/tomoyo.c |  341 +++++++++++++++++++++++++++++++++++++++++++++++
>  security/tomoyo/tomoyo.h |   97 +++++++++++++
>  2 files changed, 438 insertions(+)
> 

...

> +static int tmy_path_mknod(struct path *parent, struct dentry *dentry, int mode,
> +			  unsigned int dev)
> +{
> +	struct vfsmount *mnt = parent->mnt;
> +	struct inode *dir = parent->dentry->d_inode;
> +	int error = 0;
> +
> +	switch (mode & S_IFMT) {
> +	case S_IFREG:
> +	case 0:
> +		error = may_create(dir, dentry);

Isn't may_create already done at the top of vfs_mknod() and vfs_create()?

> +		if (error)
> +			return error;
> +		if (!dir->i_op || !dir->i_op->create)
> +			return -EACCES; /* shouldn't it be ENOSYS? */
> +		break;
> +	case S_IFCHR:
> +	case S_IFBLK:
> +	case S_IFIFO:
> +	case S_IFSOCK:
> +		error = may_create(dir, dentry);

likewise...

> +		if (error)
> +			return error;
> +		if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
> +			return -EPERM;

likewise...

> +		if (!dir->i_op || !dir->i_op->mknod)
> +			return -EPERM;
> +		error = devcgroup_inode_mknod(mode, dev);

likewise...  (except in the case of fifo/sock, devcgroup should not be
consulted as I'm not sure it'll handle that properly - have you tested
tis with the device cgroup enabled?)

> +		if (error)
> +			return error;
> +		break;
> +	default:
> +		return 0;
> +	}
> +	switch (mode & S_IFMT) {
> +	case S_IFREG:
> +	case 0:
> +		error = tmy_check_1path_perm(TMY_TYPE_CREATE_ACL, dentry, mnt);
> +		break;
> +	case S_IFCHR:
> +		error = tmy_check_1path_perm(TMY_TYPE_MKCHAR_ACL, dentry, mnt);
> +		break;
> +	case S_IFBLK:
> +		error = tmy_check_1path_perm(TMY_TYPE_MKBLOCK_ACL, dentry, mnt);
> +		break;
> +	case S_IFIFO:
> +		error = tmy_check_1path_perm(TMY_TYPE_MKFIFO_ACL, dentry, mnt);
> +		break;
> +	case S_IFSOCK:
> +		error = tmy_check_1path_perm(TMY_TYPE_MKSOCK_ACL, dentry, mnt);
> +		break;
> +	}
> +	return error;
> +}

-serge
