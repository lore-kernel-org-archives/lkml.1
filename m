Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYKTEAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYKTEAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 23:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYKTEAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 23:00:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbYKTEAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 23:00:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ratan Nalumasu <rnalumasu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_wait wakeup optimization
In-Reply-To: Linus Torvalds's message of  Wednesday, 19 November 2008 19:35:45 -0800 <alpine.LFD.2.00.0811191929450.21698@nehalem.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <93ad5f3f0808181334i684e68b7yb61e3586d35880f6@mail.gmail.com>
	<93ad5f3f0808181804m3b74fe68v1fdcf4edf6c7b465@mail.gmail.com>
	<20080819214546.9BD5715426B@magilla.localdomain>
	<93ad5f3f0808191746g44acbccdm715222698ed20ee1@mail.gmail.com>
	<20080820010415.EB87B15449D@magilla.localdomain>
	<93ad5f3f0808191851i1fdd0332g8befbc538551f24@mail.gmail.com>
	<93ad5f3f0808221333pe9b95fp886f6313b4be384e@mail.gmail.com>
	<20080823013655.F3B3615426C@magilla.localdomain>
	<93ad5f3f0808261601g4fa6429dgbcb21e4218e92f2a@mail.gmail.com>
	<20080826230620.5865E154233@magilla.localdomain>
	<93ad5f3f0811191404g28361b1ei329c3e326b21087d@mail.gmail.com>
	<20081120012017.3CC3C15423A@magilla.localdomain>
	<alpine.LFD.2.00.0811191929450.21698@nehalem.linux-foundation.org>
Emacs: the definitive fritterware.
Message-Id: <20081120035951.EC81815423A@magilla.localdomain>
Date: Wed, 19 Nov 2008 19:59:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch looks sane, and look worth queueing up for the next merge window. 
> But if somebody actually has numbers and/or can talk about the real-life 
> load that made people even notice this, that would be good to add to the 
> description.

Ratan came up with the idea.  I just filled in some of the details to make
it work and clean it up.  So I'll leave this explanation to him.

> Also, do we really need to call eligible_child() twice? The real wait only 
> does it once in that "wait_consider_task()". Explanations would be good..

The reasons for a second call are unrelated in the thread_group_leader case
and the non-leader case.

In the thread_group_leader case, we might be doing the wakeup for a child
whose parent ignores SIGCHLD.  Since it self-reaps, there will be nothing
left for do_wait() to find after it wakes up.  But the wake-up is still
required.  A parent that ignores SIGCHLD can do e.g.:

	while (wait (NULL) > 0);

and that will block while there are any live children, then quickly fail
with ECHILD when there are none left.  So, we cannot short-circuit this
wake-up, even though when do_wait() wakes up and then calls eligible_child(),
it won't match due to ->exit_signal==-1 (aka task_detached()).  (Note the
second eligible_child() call is only needed when task_detached(task),
i.e. its parent ignored SIGCHLD, not the common case.)

In the non-leader case, we're dealing with the one situation where
do_notify_parent() can be called on a task other than current.
Unfortunately, in the wake_function we have no way to tell which task was
the argument to do_notify_parent().  We can only assume that it was
current, as it usually is.  So we're short-circuiting if current is an
eligible child for the particular do_wait() call, not if the task passed to
do_notify_parent() is eligible.

This one case is in release_task(); the call is on current->group_leader.
So to avoid wrongly skipping the wake-up in this case, we do a second check
on the eligibility of the group_leader.  We wouldn't need this if we knew
which task was the argument to the do_notify_parent() call doing the wake-up,
but I don't know how to communicate that down.

I haven't thought of something simpler that wouldn't have false negatives
for needs_wakeup().


Thanks,
Roland
