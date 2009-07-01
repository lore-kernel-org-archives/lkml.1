Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbZGASMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbZGASMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZGASMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:12:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52005 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZGASMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:12:10 -0400
Message-ID: <4A4BA6F8.7090905@redhat.com>
Date: Wed, 01 Jul 2009 13:12:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, eteo@redhat.com,
       viro@zeniv.linux.org.uk, esandeen@redhat.com
Subject: Re: [Patch] allow file truncations when both suid and write permissions
 set
References: <20090625090146.6616.9720.sendpatchset@localhost.localdomain>
In-Reply-To: <20090625090146.6616.9720.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> When suid is set and the non-owner user has write permission,
> any writing into this file should be allowed and suid should be
> removed after that.
> 
> However, current kernel only allows writing without truncations,
> when we do truncations on that file, we get EPERM. This is a bug.

Thanks, I'd noticed this once too but never put together a patch... :(

> Steps to reproduce this bug:
> 
> % ls -l rootdir/file1
> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> % echo h > rootdir/file1
> zsh: operation not permitted: rootdir/file1
> % ls -l rootdir/file1
> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> % echo h >> rootdir/file1
> % ls -l rootdir/file1
> -rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1
> 
> This patch fixes it.
> 
> (Need to Cc stable?)

probably a good idea.

> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Eric Sandeen <esandeen@redhat.com>
> Cc: Eugene Teo <eteo@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> 
> ---
> diff --git a/fs/open.c b/fs/open.c
> index dd98e80..ebf6d8d 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -199,7 +199,7 @@ out:
>  int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
>  	struct file *filp)
>  {
> -	int err;
> +	int ret;
>  	struct iattr newattrs;
>  
>  	/* Not pretty: "inode->i_size" shouldn't really be signed. But it is. */
> @@ -214,12 +214,15 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
>  	}
>  
>  	/* Remove suid/sgid on truncate too */
> -	newattrs.ia_valid |= should_remove_suid(dentry);
> +	ret = should_remove_suid(dentry);
> +	newattrs.ia_valid |=  ret;
> +	if (ret)
> +		newattrs.ia_valid |= ATTR_FORCE;

So I think the main problem here is simply that we didn't set
ATTR_FORCE, right...

Seems a little odd to |= with ret, -then- check if it's non-0.  Maybe:

 	/* Remove suid/sgid on truncate too */
-	newattrs.ia_valid |= should_remove_suid(dentry);
+	ret = should_remove_suid(dentry);
+	if (ret)
+		newattrs.ia_valid |= (ret | ATTR_FORCE);

?

Otherwise this much looks right to me, though I don't claim to be the
world's foremost expert at this.  :)

Thanks,
-Eric

>  	mutex_lock(&dentry->d_inode->i_mutex);
> -	err = notify_change(dentry, &newattrs);
> +	ret = notify_change(dentry, &newattrs);
>  	mutex_unlock(&dentry->d_inode->i_mutex);
> -	return err;
> +	return ret;
>  }
>  
>  static long do_sys_truncate(const char __user *pathname, loff_t length)

