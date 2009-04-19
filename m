Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbZDSQj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbZDSQj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZDSQjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:39:16 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42807 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZDSQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:39:15 -0400
Date: Sun, 19 Apr 2009 17:30:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Oleg Nesterov <oleg@redhat.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
 sometimes doesn't)
In-Reply-To: <20090406153127.GA21220@redhat.com>
Message-ID: <Pine.LNX.4.64.0904191710320.9099@blonde.anvils>
References: <20090330010843.GM28946@ZenIV.linux.org.uk>
 <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com>
 <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk>
 <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Oleg Nesterov wrote:
> On 04/01, Al Viro wrote:
> >
> > Rebased and pushed (same tree, same branch; included into for-next, along
> > with related cleanups).
> 
> Sorry for delay!

Please don't suppose that you can ever beat me at the slowness game!

> 
> Afaics, the usage of fs->in_exec is not completely right. But firstly, a
> couple of minor nits.
> 
> 
> check_unsafe_exec() doesn't need ->siglock, we can iterate over sub-threads
> under rcu_read_lock(). Note that with RCU or ->siglock we can set the "wrong"
> LSM_UNSAFE_SHARE if we race with copy_process(CLONE_THREAD | CLONE_FS), but
> as it was already discussed we don't care. This means it is OK to miss the
> freshly cloned thread which has already passed copy_fs().

Yes, I agree.
And preferable not to have IRQs disabled over that next_thread() loop.

> 
> 
> do_execve:
> 
> 	/* execve succeeded */
> 	write_lock(&current->fs->lock);
> 	current->fs->in_exec = 0;
> 	write_unlock(&current->fs->lock);
> 
> afaics, fs->lock is not needed. If ->in_exec was set, it was set by this
> thread-group and we do not share ->fs with another process. Since we are
> the only thread now, we can clear ->in_exec lockless.

Right, given your fix below.  I wondered for a moment if a barrier
would then be needed, but no, this is all racy (erring on the safe
side) if the userspace insists on being racy here.

> 
> 
> And now, what I think is wrong:
> 
> do_execve:
> 
> 	out_unmark:
> 		write_lock(&current->fs->lock);
> 		current->fs->in_exec = 0;
> 		write_unlock(&current->fs->lock);
> 
> Two threads T1 and T2 and another process P, all share the same ->fs.
> 
> T1 starts do_execve(BAD_FILE). It calls check_unsafe_exec(), since ->fs is
> shared, we set LSM_UNSAFE but not ->in_exec (actually, not very good name).
> 
> P exits and decrements fs->users.
> 
> T2 starts do_execve(), calls check_unsafe_exec(), now ->fs is not shared,
> we set fs->in_exec.
> 
> T1 continues, open_exec(BAD_FILE) fails, we clear ->in_exec and return
> to the user-space.
> 
> T1 does clone(CLONE_FS /* without CLONE_THREAD */).
> 
> T1 continues without LSM_UNSAFE_SHARE while ->fs is shared with another
> process.

If I follow you correctly, you meant to say T2 not T1 in the last step.

> 
> 
> What do you think about the (uncompiled) patch below ? It doesn't change
> compat_do_execve(), just for discussion.
> 
> But see also another message I am going to send...
> 
> Oleg.
> 
> do_execve() must not clear fs->in_exec if it was set by another thread,
> and we don't need fs->lock to clear.
> 
> Also, s/lock_task_sighand/rcu_read_lock/ in check_unsafe_exec().

Yes, I think your clear_in_exec change is a necessary one,
and your rcu_read_lock well worth while.

One tiny change (aside from extending to compat_do_execve):
Al originally had check_unsafe_exec()'s write_lock(&p->fs->lock)
after the lock_task_sighand(p, &flags), but was forced to invert
that by the IRQ issue lockdep flagged.  I think we'd all prefer
to think of fs->lock as an innermost lock, and would like it
now to go after your rcu_read_lock().

(You do rcu_read_unlock() earlier, but that's okay.)

Hugh

> 
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1060,7 +1060,6 @@ EXPORT_SYMBOL(install_exec_creds);
>  int check_unsafe_exec(struct linux_binprm *bprm)
>  {
>  	struct task_struct *p = current, *t;
> -	unsigned long flags;
>  	unsigned n_fs;
>  	int res = 0;
>  
> @@ -1068,11 +1067,12 @@ int check_unsafe_exec(struct linux_binpr
>  
>  	n_fs = 1;
>  	write_lock(&p->fs->lock);
> -	lock_task_sighand(p, &flags);
> +	rcu_read_lock();
>  	for (t = next_thread(p); t != p; t = next_thread(t)) {
>  		if (t->fs == p->fs)
>  			n_fs++;
>  	}
> +	rcu_read_unlock();
>  
>  	if (p->fs->users > n_fs) {
>  		bprm->unsafe |= LSM_UNSAFE_SHARE;
> @@ -1080,9 +1080,8 @@ int check_unsafe_exec(struct linux_binpr
>  		if (p->fs->in_exec)
>  			res = -EAGAIN;
>  		p->fs->in_exec = 1;
> +		res = 1;
>  	}
> -
> -	unlock_task_sighand(p, &flags);
>  	write_unlock(&p->fs->lock);
>  
>  	return res;
> @@ -1284,6 +1283,7 @@ int do_execve(char * filename,
>  	struct linux_binprm *bprm;
>  	struct file *file;
>  	struct files_struct *displaced;
> +	bool clear_in_exec;
>  	int retval;
>  
>  	retval = unshare_files(&displaced);
> @@ -1306,8 +1306,9 @@ int do_execve(char * filename,
>  		goto out_unlock;
>  
>  	retval = check_unsafe_exec(bprm);
> -	if (retval)
> +	if (retval < 0)
>  		goto out_unlock;
> +	clear_in_exec = retval;
>  
>  	file = open_exec(filename);
>  	retval = PTR_ERR(file);
> @@ -1355,9 +1356,7 @@ int do_execve(char * filename,
>  		goto out;
>  
>  	/* execve succeeded */
> -	write_lock(&current->fs->lock);
>  	current->fs->in_exec = 0;
> -	write_unlock(&current->fs->lock);
>  	current->in_execve = 0;
>  	mutex_unlock(&current->cred_exec_mutex);
>  	acct_update_integrals(current);
> @@ -1377,9 +1376,8 @@ out_file:
>  	}
>  
>  out_unmark:
> -	write_lock(&current->fs->lock);
> -	current->fs->in_exec = 0;
> -	write_unlock(&current->fs->lock);
> +	if (clear_in_exec)
> +		current->fs->in_exec = 0;
>  
>  out_unlock:
>  	current->in_execve = 0;
