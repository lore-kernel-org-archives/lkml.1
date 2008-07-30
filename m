Return-Path: <linux-kernel-owner+w=401wt.eu-S1762222AbYG3OiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762222AbYG3OiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761967AbYG3Oht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:37:49 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:47961 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbYG3Ohr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:37:47 -0400
Subject: Re: [patch] vfs: make security_inode_setattr() calling consistent
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, akpm@linux-foundation.org, jmorris@namei.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1KOARi-0004wu-1G@pomaz-ex.szeredi.hu>
References: <E1KOARi-0004wu-1G@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 30 Jul 2008 10:37:27 -0400
Message-Id: <1217428647.20373.235.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-30 at 14:06 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Call security_inode_setattr() consistetly before inode_change_ok().
> It doesn't make sense to try to "optimize" the i_op->setattr == NULL
> case, as most filesystem do define their own setattr function.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Unfortunate since we'd prefer to have the DAC checks applied first, and
since inode_change_ok() may alter the ia_mode in response to those
checks, but it does seem inconsistent at present and it doesn't yield
any difference in the ltp selinux testsuite results.

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  fs/attr.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/fs/attr.c
> ===================================================================
> --- linux-2.6.orig/fs/attr.c	2008-07-30 13:52:35.000000000 +0200
> +++ linux-2.6/fs/attr.c	2008-07-30 13:52:41.000000000 +0200
> @@ -159,17 +159,17 @@ int notify_change(struct dentry * dentry
>  	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
>  		return 0;
>  
> +	error = security_inode_setattr(dentry, attr);
> +	if (error)
> +		return error;
> +
>  	if (ia_valid & ATTR_SIZE)
>  		down_write(&dentry->d_inode->i_alloc_sem);
>  
>  	if (inode->i_op && inode->i_op->setattr) {
> -		error = security_inode_setattr(dentry, attr);
> -		if (!error)
> -			error = inode->i_op->setattr(dentry, attr);
> +		error = inode->i_op->setattr(dentry, attr);
>  	} else {
>  		error = inode_change_ok(inode, attr);
> -		if (!error)
> -			error = security_inode_setattr(dentry, attr);
>  		if (!error) {
>  			if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
>  			    (ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))
-- 
Stephen Smalley
National Security Agency

