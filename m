Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZFFHXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZFFHXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZFFHWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:22:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47620 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZFFHWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:22:50 -0400
Date: Sat, 6 Jun 2009 08:22:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/9] exec_path 1/9: introduce ->exec_path and switch
	/proc/*/exe
Message-ID: <20090606072244.GA13497@ZenIV.linux.org.uk>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603230422.GB853@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 03:04:22AM +0400, Alexey Dobriyan wrote:
> diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
> index eff74b9..6c56262 100644
> --- a/fs/binfmt_som.c
> +++ b/fs/binfmt_som.c
> @@ -174,6 +174,7 @@ static int map_som_binary(struct file *file,
>  	up_write(&current->mm->mmap_sem);
>  	if (retval > 0 || retval < -1024)
>  		retval = 0;
> +	set_task_exec_path(current, &bprm->file->f_path);

Oh?  Even on failure exits?
> +	if (!path->mnt || !path->dentry)
> +		return -ENOENT;

Umm...  I really don't like that.  Note that path with NULL vfsmount
and non-NULL dentry should never happen.  If anything, we ought
to add path_empty(path) (!(path)->mnt) and convert such places to it.

> +static inline void set_task_exec_path(struct task_struct *tsk, struct path *path)
> +{
> +	struct path old_path;
> +
> +	path_get(path);
> +	task_lock(tsk);
> +	old_path = tsk->exec_path;
> +	tsk->exec_path = *path;
> +	task_unlock(tsk);
> +	path_put(&old_path);
> +}

Do we ever have a right to do that to anything other than current?  Note
that fork() is a special case anyway...

> +	set_task_exec_path(tsk, &(struct path){ .mnt = NULL, .dentry = NULL });

Ew...

> +	get_task_exec_path(current, &p->exec_path);
> +

We already have that value sitting there, so why not get_path(&p->exec_path)?

The real problem I have with that we *really* can't umount the filesystem
that used to host the binary anymore.  At all.

Frankly, I'm almost tempted to add explicit way to switch the damn thing
via /proc/self/something - e.g. allow a binary to write a pathname to
/proc/self/set_exec and have that switch the sucker.  The interesting
part, of course, is figuring out the security implications of that...
