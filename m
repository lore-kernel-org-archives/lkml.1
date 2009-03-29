Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZC2A7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZC2A7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 20:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZC2A7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 20:59:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48696 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbZC2A7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 20:59:21 -0400
Date: Sun, 29 Mar 2009 01:53:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Q: check_unsafe_exec() races (Was: [PATCH 2/4] fix setuid
	sometimes doesn't)
Message-ID: <20090329005343.GA12139@redhat.com>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282319270.15432@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903282319270.15432@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -void check_unsafe_exec(struct linux_binprm *bprm, struct files_struct *files)
> +void check_unsafe_exec(struct linux_binprm *bprm)
>  {
>  	struct task_struct *p = current, *t;
>  	unsigned long flags;
> -	unsigned n_fs, n_files, n_sighand;
> +	unsigned n_fs, n_sighand;
>
>  	bprm->unsafe = tracehook_unsafe_exec(p);
>
>  	n_fs = 1;
> -	n_files = 1;
>  	n_sighand = 1;
>  	lock_task_sighand(p, &flags);
>  	for (t = next_thread(p); t != p; t = next_thread(t)) {
>  		if (t->fs == p->fs)
>  			n_fs++;
> -		if (t->files == files)
> -			n_files++;
>  		n_sighand++;
>  	}
>
>  	if (atomic_read(&p->fs->count) > n_fs ||
> -	    atomic_read(&p->files->count) > n_files ||
>  	    atomic_read(&p->sighand->count) > n_sighand)
>  		bprm->unsafe |= LSM_UNSAFE_SHARE;

Can't find the patch which introduced check_unsafe_exec(), so
I am asking here.

How it is supposed to work?

Let's suppose we have two threads T1 and T2. T1 exits, and calls
exit_fs().

	exit_fs:

		tsk->fs = NULL;
		// WINDOW
		put_fs_struct(fs);

Now, if T2 does exec() and check_unsafe_exec() happens in the WINDOW
above, we set LSM_UNSAFE_SHARE.

Or we can race with sub-thread doing clone(CLONE_FS|CLONE_THREAD),
the new thread is not visible in ->thread_group, buy copy_fs()
can already increment fs->count.


Another question. Why do we check sighand->count? We always unshare
->sighand on exec, see de_thread().


Minor, but why lock_task_sighand() ? This helper is "__must_check".
If it can't fail (yes, it can't fail here), spin_lock_irq(siglock)
is enough. (and given that ->siglock can't help anyway to calculate
n_fs, we could use rcu_read_lock() instead).


(as for these patches, I think they are correct).

Oleg.

