Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZC2LMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZC2LMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 07:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZC2LMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 07:12:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:10602 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbZC2LMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 07:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gY4c/xa1lDb1uAoLwKEfPmO28YrTiy6EOSZgXEJRkTzQZdVhbkfj6mY3JMW9Cq4f3L
         aJk/5kmwwWOfGF1HP6CQ0MqzuCalUub7QfQcG4uRAgDJ0Cao8SSx/+Jmcc7M9TCXkVR6
         Q55kGDkFqOVlUZPJNEiPuN9Kp7wq9k8eSfSXg=
Date: Sun, 29 Mar 2009 15:19:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fix setuid sometimes wouldn't
Message-ID: <20090329111958.GA3468@x200.localdomain>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282320271.15432@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903282320271.15432@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 11:21:27PM +0000, Hugh Dickins wrote:
> check_unsafe_exec() also notes whether the fs_struct is being
> shared by more threads than will get killed by the exec, and if so
> sets LSM_UNSAFE_SHARE to make bprm_set_creds() careful about euid.
> But /proc/<pid>/cwd and /proc/<pid>/root lookups make transient
> use of get_fs_struct(), which also raises that sharing count.
> 
> This might occasionally cause a setuid program not to change euid,
> in the same way as happened with files->count (check_unsafe_exec
> also looks at sighand->count, but /proc doesn't raise that one).
> 
> We'd prefer exec not to unshare fs_struct: so fix this in procfs,
> replacing get_fs_struct() by get_fs_path(), which does path_get
> while still holding task_lock, instead of raising fs->count.

> --- 2.6.29/fs/proc/base.c
> +++ linux/fs/proc/base.c
> @@ -146,15 +146,22 @@ static unsigned int pid_entry_count_dirs
>  	return count;
>  }
>  
> -static struct fs_struct *get_fs_struct(struct task_struct *task)
> +static int get_fs_path(struct task_struct *task, struct path *path, bool root)
>  {
>  	struct fs_struct *fs;
> +	int result = -ENOENT;
> +
>  	task_lock(task);
>  	fs = task->fs;
> -	if(fs)
> -		atomic_inc(&fs->count);
> +	if (fs) {
> +		read_lock(&fs->lock);
> +		*path = root ? fs->root : fs->pwd;
> +		path_get(path);
> +		read_unlock(&fs->lock);
> +		result = 0;
> +	}
>  	task_unlock(task);
> -	return fs;
> +	return result;
>  }

I think it's better to open-code. "root" parameter is unnatural.
