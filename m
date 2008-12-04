Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYLDOAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYLDOAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYLDOAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:00:06 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54126 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYLDOAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:00:04 -0500
Date: Thu, 4 Dec 2008 14:52:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jay Lan <jlan@sgi.com>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081204135250.GA5448@redhat.com>
References: <20081203181220.GA22918@redhat.com> <Pine.LNX.4.64.0812031957570.19174@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812031957570.19174@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Hugh Dickins wrote:
>
> On Wed, 3 Dec 2008, Oleg Nesterov wrote:
>
> > Unless we are going to decrease rss/vm there is no point to call the
> > (racy) update_hiwater_xxx() helpers. Still do_exit() does this, and
>
> I'm puzzled by this comment.  exit() _is_ about to decrease rss/vm,
> so isn't it right to be calling update_hiwater_xxx()?

Do you mean exit_mm()->...->exit_mmap() ? But this doesn't matter, this
->mm is going away. Nobody can read these counters when ->mm_users == 0,
no?

> There is a question of who's going to be able to see the result from
> this point on: I forget whether I was doing it for my own satisfaction,
> or for a real observer.  Even if there isn't a real observer today,
> I think I'd prefer do_exit() to continue to update_hiwater_xxx(),
> in case an observer is added tomorrow - unless you feel it's
> unjustifiably adding code to and slowing down process exit.

Please see below,

> You say "(racy)": in my view, it was only as racy as whatever might
> cause it to be racy.  By that, I mean that if the numbers ended up
> slightly wrong, you could reasonably imagine that the races happened
> in a different sequence which would have ended up with the numbers
> seen.  Have you noticed something more serious we need to fix?

But the difference can be huge. Let's suppose the process has 2 threads
T1 and T2.

T1 exits, calls update_hiwater_vm(), notices that mm->hiwater_vm must be
updated, and preempted right before mm->hiwater_vm = new_value.

T2 does free(malloc(A_LOT)) and exits. It sets the correct value for
->hiwater_vm which takes A_LOT into account and disappears.

T1 resumes, and "reverts" ->hiwater_vm to the "new_value" which was
calculated before.

Now, since T1 is the last exiting thread, the whole thread group
exits and we report the wrong ->hiwater_vm to the userspace.

Yes, this race is unlikely. But there is another reason (perhaps
not very good) why I tried to remove update_hiwater_xxx() from
do_exit().

Imho this code looks as if: from now it is "safe" to use ->hiwater_xxx
directly because we already updated it. But it is not. Unless we are
the last thread, we can't trust mm->hiwater_xxx anyway, we should
re-check get_mm_rss/total_vm.

> > Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() to use instead,
> > and kill the "if (tsk->mm) {}" code in do_exit().
>
> If you're going to add special helper macros (I don't care myself),
> wouldn't it be better to convert fs/proc/task_mmu.c (the original
> consumer) to use them too?

Yes, I was going to convert task_mem(), but noticed that it has
to read get_mm_rss() and ->total_vm anyway. Still, perhaps it
would be more clean to use the new macros anyway, even if this
wiil (unlikely) need a couple of extra cpu ticks.

> And, as I say, I'd _prefer_ that block to remain in do_exit(),
> but don't have strong evidence why it should.

I think that update_hiwater_xxx() should be "private" for vm code which
does zap/unmap, and any observer should use get_mm_hiwater_xxx(). Nobody
should use mm->hiwater_xxx directly.

But I don't (and of course can't) have a strong opinion on that,
will wait for your verdict and re-send.

The patch need the update anyway, I just noticed that if we remove
update_hiwater_xxx() from do_exit(), we should change the comment
in exit_mmap().

> > The first helper will
> > be also used to actually fill/report rusage->ru_maxrss.
>
> Oh, yes, I noticed a mail yesterday in which you claimed to Cc me,
> but didn't (like we all claim to be attaching missing patches ;)

Yes sorry ;) The only problem with mutt is that it is not possible
to change CC while editing the text (unless edit_headers is set).

Oleg.

