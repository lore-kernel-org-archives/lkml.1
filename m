Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZH1TQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZH1TQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZH1TQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:16:33 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:52462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752567AbZH1TQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:16:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: eligible_child() && __WCLONE && task_detached() (Was: mmotm
	2009-08-24-16-24 uploaded)
In-Reply-To: Oleg Nesterov's message of  Friday, 28 August 2009 19:17:24 +0200 <20090828171724.GA17445@redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
	<20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827093441.GA3451@redhat.com>
	<20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827100846.GA6462@redhat.com>
	<20090827193133.b7eed4a9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827105209.GA8469@redhat.com>
	<20090828171724.GA17445@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090828191624.0F5BC45B02@magilla.sf.frob.com>
Date: Fri, 28 Aug 2009 12:16:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> eligible_child:
> 
> 	/* Wait for all children (clone and not) if __WALL is set;
> 	 * otherwise, wait for clone children *only* if __WCLONE is
> 	 * set; otherwise, wait for non-clone children *only*.  (Note:
> 	 * A "clone" child here is one that reports to its parent
> 	 * using a signal other than SIGCHLD.) */
> 
> 	if (((p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
> 	    && !(wo->wo_flags & __WALL))
> 		return 0;
> 
> I just can't understand what is the supposed behaviour when p is
> sub-thread and p->exit_signal == -1.

As you say, you're not even supposed to be here when exit_signal = -1,
except for the ptrace case.  This logic exists for the non-CLONE_THREAD
clone case, i.e. ->exit_signal != SIGCHLD and != -1.

> IOW, perhaps this check should be
> 
> 	if (!task_detached(p) && !(wo->wo_flags & __WALL) &&
> 	    (p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
> 		return 0;

That seems OK to me.

> When task_detached(p) == T, "p->exit_signal != SIGCHLD" looks like a
> false positive to me. Because -1 is not a siganl, this is a marker
> which indicates the deatached task - sub-thread or EXIT_DEAD. It _seems_
> to me this check was added when threads were processes, and it was
> possible to wait/reap a thread, not process.

That's all still possible, it's just no longer common.
i.e. clone(SIGUSR1|CLONE_VM, ...) or whatnot (no CLONE_THREAD).

> In short. If ptracer calls wait4(ptraced_sub_thread), is it really
> supposed it must use __WCLONE || __WALL?

I suspect not, but I'm not quite sure.  That is, it makes sense to me that
a ptracer should always get its tracees in all waits.  That is consistent
with not having to use WUNTRACED, for example.  But I'm not really sure any
more what the historical behavior of this has been.  The code in GDB uses
__WALL and __WCLONE in various places, clearly assuming that just ptrace
alone is not enough for every wait4 call to catch every tracee.  It seems
likely that this method was necessary in the past and that's why the code
is like that.


Thanks,
Roland
