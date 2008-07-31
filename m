Return-Path: <linux-kernel-owner+w=401wt.eu-S1763453AbYGaAdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453AbYGaAdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYGaAdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:33:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53324 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYGaAdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:33:37 -0400
Date: Thu, 31 Jul 2008 01:33:32 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch resend] vfs: move executable checking into
	->permission()
Message-ID: <20080731003332.GJ28946@ZenIV.linux.org.uk>
References: <E1KOBJb-0005L0-RF@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KOBJb-0005L0-RF@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 03:02:03PM +0200, Miklos Szeredi wrote:
>  static int coda_ioctl_permission(struct inode *inode, int mask)
>  {
> -        return 0;
> +	return check_execute(dentry->d_inode, mask);
>  }

Er?
	a) mismerge from dentry-based variant
	b) I'd say return mask & MAY_EXEC ? -EACCES : 0 - it's *NOT* going to
be an executable file, TYVM.

>  static int hfs_permission(struct inode *inode, int mask)
>  {
>  	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC)
> -		return 0;
> +		return check_execute(inode, mask);
>  	return generic_permission(inode, mask, NULL);
>  }

WTF is going on in that one?  I realize that you are not changing behaviour,
but...

> +int check_execute(struct inode *inode, int mask)
> +{
> +	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
> +	    !(inode->i_mode & S_IXUGO))
> +		return -EACCES;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(check_execute);

Umm...  I'm not sure.  For one thing, I'd take check for MAY_EXEC to callers.
For another, quite a few of those might have enough information to make calling
that helper pointless.

> +++ linux-2.6/fs/proc/proc_sysctl.c	2008-07-30 14:39:31.000000000 +0200
> @@ -311,6 +311,9 @@ static int proc_sys_permission(struct in
>  		error = sysctl_perm(head->root, table, mask);
>  
>  	sysctl_head_finish(head);
> +	if (!error)
> +		error = check_execute(inode, mask);
> +
>  	return error;
>  }

No.  If anything, we want non-directories fail MAY_EXEC here, no matter
what i_mode we might have.  Executable files in /proc/sys/* are NOT going
to be allowed, no matter what...

>  	if (mask & ~mode & (MAY_READ | MAY_WRITE | MAY_EXEC))
> -		error = -EACCES;
> -	return error;
> +		return -EACCES;
> +
> +	return check_execute(inode, mask);

That's wrong.  If mask contains MAY_EXEC and we got to calling check_execute(),
we know that ~mode & MAY_EXEC is 0.  IOW, we know that inode->i_mode >> 6 has
bit 0 set.  IOW, we know that inode->i_mode contain S_IXUSR.  IOW, your
check_execute() here is an obfuscated way to spell 0.
