Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZDUQQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZDUQQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZDUQQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:16:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34014 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZDUQQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:16:36 -0400
Date: Tue, 21 Apr 2009 18:10:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
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
Message-ID: <20090421161006.GC5402@redhat.com>
References: <20090330013612.GA4080@redhat.com> <20090330014040.GA4807@redhat.com> <20090330123101.GQ28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0903301506310.11454@blonde.anvils> <20090331061615.GS28946@ZenIV.linux.org.uk> <Pine.LNX.4.64.0904010106310.16500@blonde.anvils> <20090401023849.GW28946@ZenIV.linux.org.uk> <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com> <Pine.LNX.4.64.0904191710320.9099@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904191710320.9099@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19, Hugh Dickins wrote:
>
> On Mon, 6 Apr 2009, Oleg Nesterov wrote:
> >
> > Sorry for delay!
>
> Please don't suppose that you can ever beat me at the slowness game!

I am still trying to compete...

> > check_unsafe_exec() doesn't need ->siglock, we can iterate over sub-threads
> > under rcu_read_lock(). Note that with RCU or ->siglock we can set the "wrong"
> > LSM_UNSAFE_SHARE if we race with copy_process(CLONE_THREAD | CLONE_FS), but
> > as it was already discussed we don't care. This means it is OK to miss the
> > freshly cloned thread which has already passed copy_fs().
>
> Yes, I agree.
> And preferable not to have IRQs disabled over that next_thread() loop.

Yes sure, we don't need local_irq_disable(), only rcu_read_lock().

> > T1 does clone(CLONE_FS /* without CLONE_THREAD */).
> >
> > T1 continues without LSM_UNSAFE_SHARE while ->fs is shared with another
> > process.
>
> If I follow you correctly, you meant to say T2 not T1 in the last step.

Yes,

> Yes, I think your clear_in_exec change is a necessary one,
> and your rcu_read_lock well worth while.

OK, I'll send 2 simple patches, the first one kills lock_task_sighand(),
another adds clear_in_exec.

But,

> One tiny change (aside from extending to compat_do_execve):
> Al originally had check_unsafe_exec()'s write_lock(&p->fs->lock)
> after the lock_task_sighand(p, &flags), but was forced to invert
> that by the IRQ issue lockdep flagged.  I think we'd all prefer
> to think of fs->lock as an innermost lock, and would like it
> now to go after your rcu_read_lock().

Since we are not going to disable IRQs, perhaps the above does
not matter? It is always safe to take rcu_read_lock(), no matter
which locks we already hold.

> (You do rcu_read_unlock() earlier, but that's okay.)

Yes, but unless we have a "strong" reason, it is better to take
fs->lock first. rcu_read_lock() is free, but disables preemption.

Oleg.

