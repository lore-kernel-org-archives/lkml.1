Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbZDFP44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbZDFP44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZDFP4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:56:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59892 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZDFP4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:56:43 -0400
Date: Mon, 6 Apr 2009 17:51:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Hugh Dickins <hugh@veritas.com>,
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
Message-ID: <20090406155103.GB21220@redhat.com>
References: <20090330000338.GB32199@redhat.com> <20090330010843.GM28946@ZenIV.linux.org.uk> <20090330011303.GN28946@ZenIV.linux.org.uk> <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401023849.GW28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Al Viro wrote:
>
> On Wed, Apr 01, 2009 at 01:28:01AM +0100, Hugh Dickins wrote:
>
> > Otherwise it looks good to me, except I keep worrying about those
> > EAGAINs.
>
> Frankly, -EAGAIN in situation when we have userland race is fine.  And
> we *do* have a userland race here - execve() will kill -9 those threads
> in case of success, so if they'd been doing something useful, they are
> about to be suddenly screwed.

Can't resist! I dislike the "in_exec && -EAGAIN" oddity too.

Yes sure, we can't break the "well written" applications. But imho this
looks strange. And a bit "assymetrical" wrt LSM_UNSAFE_SHARE, I mean
check_unsafe_exec() allows sub-threads to race or CLONE_FS but only if
LSM_UNSAFE_SHARE.

Another reason, we can have the "my test-case found something strange"
bug-reports.

So. Please feel free to nack or just ignore this message, but since I
personally dislike the current behaviour I should at least try to suggest
something else.

	- add "wait_queue_head_t in_exec_wait" to "struct linux_binprm".

	- kill fs->in_exec, add "wait_queue_head_t *in_exec_wait_ptr"
	  instead.

	- introduce the new helper,

		void fs_lock_check_exec(struct fs_struct *fs)
		{
			write_lock(&fs->lock);
			while (unlikely(fs->in_exec_wait_ptr)) {
				DECLARE_WAITQUEUE(wait, current);

				if (fatal_signal_pending(current))
					/*
					 * clone/exec can't succeed, and this
					 * thread won't return to the user-space
					 */
					break;

				__add_wait_queue(fs->in_exec_wait_ptr, &wait);
				__set_current_state(TASK_KILLABLE);
				write_unlock(&fs->lock);

				schedule();

				write_lock(&fs->lock);
				__remove_wait_queue(&wait);
			}
		}

	  Or we can return -EANYTHING when fatal_signal_pending(), this doesn't
	  matter.

	  Note that this helper can block only if we race with our sub-thread
	  in the middle of !LSM_UNSAFE_SHARE exec. Otherwise this is not slower
	  than write_lock(fs->lock) + if (fs->in_exec) we currently have.


	 - change copy_fs() to do

		if (clone_flags & CLONE_FS) {
			fs_lock_check_exec(fs);
			fs->users++;
			write_unlock(&fs->lock);
			return 0;
		}


	- change check_unsafe_exec:

		void check_unsafe_exec(struct linux_binprm *bprm)
		{
			struct task_struct *p = current, *t;
			unsigned n_fs;

			bprm->unsafe = tracehook_unsafe_exec(p);

			n_fs = 1;
			fs_lock_check_exec(&p->fs);
			if (p->fs->in_exec_wait_ptr)
				/* we are going to die */
				goto out;

			rcu_read_lock();
			for (t = next_thread(p); t != p; t = next_thread(t)) {
				if (t->fs == p->fs)
					n_fs++;
			}
			rcu_read_unlock();

			if (p->fs->users > n_fs) {
				bprm->unsafe |= LSM_UNSAFE_SHARE;
			} else {
				bprm->unsafe |= __LSM_EXEC_WAKE;
				init_waitqueue_head(&bprm->in_exec_wait);
				p->fs->in_exec_wait_ptr = &bprm->in_exec_wait;
			}
		out:
			write_unlock(&p->fs->lock);
		}



	 - and, finally, change do_execve()

			/* execve succeeded */
			current->fs->in_exec_wait_ptr = NULL;

			...

		out_unmark:
			if (bprm->unsafe & __LSM_EXEC_WAKE) {
				write_lock(&current->fs->lock);
				current->fs->in_exec_wait_ptr = NULL;
				wake_up_locked(&bprm->in_exec_wait);
				write_unlock(&current->fs->lock);
			}

Comments?

Oleg.

