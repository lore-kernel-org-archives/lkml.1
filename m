Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZC2VmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZC2VmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZC2VmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:42:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55419 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZC2VmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:42:12 -0400
Date: Sun, 29 Mar 2009 23:36:35 +0200
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
Message-ID: <20090329213635.GA21820@redhat.com>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils> <Pine.LNX.4.64.0903282319270.15432@blonde.anvils> <20090329005343.GA12139@redhat.com> <20090329041022.GF28946@ZenIV.linux.org.uk> <20090329045206.GA15519@redhat.com> <20090329055513.GH28946@ZenIV.linux.org.uk> <20090329060118.GI28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329060118.GI28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Al Viro wrote:
>
> > In principle, we can mark these threads as "-EAGAIN on such clone()" and
> > clean that on exec failure.

We can't. We can miss the new subthread if we race with clone(CLONE_THREAD).
Unless we add the additional locking, of course.

We can set current->signal->flags |= SIGNAL_DO_NOT_CLONE_FS. But this is
really nasty. For examlpe, what if this flag is already set when
check_unsafe_exec() takes ->siglock ? We should return -ESOMETHING, not
good. Or schedule_timeout_uninterruptible(1) until it is cleared?

This also means copy_process()->copy_fs() path should take ->siglock too,
otherwise we we don't have a barrier.

> ... or just do that to fs_struct.  After finding that there's no outside
> users.  Commenst?

This is even worse. Not only we race with our sub-threads, we race
with CLONE_FS processes.

We can't mark fs_struct after finding that there's no outside users
lockless. Because we can't know whether this is "after" or not, we
can't trust "atomic_read(fs->count) <= n_fs".

Unless we re-use fs_struct->lock. In this case copy_fs() should take
it too. But again, ->fs can be already marked when we enter
check_unsafe_exec().


And btw check_unsafe_exec() seem to have another hole. Another thread
(which shares ->fs with us) can do exit_fs() right before we read
fs->count. Since this thread was already accounted in n_fs, we can
miss the fact we share ->fs with another process.


Perhaps I missed something...


Not that I like this idea (actually I hate), but perhaps we can change
the meaning of LSM_UNSAFE_SHARE,

	selinux_bprm_set_creds:

		if (new_tsec->sid != old_tsec->sid) {
			...

			if (avc_has_perm(...))
				bprm->unsafe |= LSM_UNSAFE_SHARE;
		}


Then we modify de_thread(). It sends SIGKILL to all subthreads, this
means that another thread can't clone() after we drop ->siglock. So we
can add this code to the ->siglock protected section

	if (unlikely(bprm->unsafe & LSM_UNSAFE_SHARE)) {
		if (fs_struct_is_shared())
			return -EPERM;
	}

	...
	zap_other_threads();

Oh, ugly.

I'd better hope I missed something ;)

Oleg.

