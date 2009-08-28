Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbZH1RVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbZH1RVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 13:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZH1RVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 13:21:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZH1RVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 13:21:34 -0400
Date: Fri, 28 Aug 2009 19:17:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: eligible_child() && __WCLONE && task_detached() (Was: mmotm
	2009-08-24-16-24 uploaded)
Message-ID: <20090828171724.GA17445@redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org> <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com> <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com> <20090827093441.GA3451@redhat.com> <20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com> <20090827100846.GA6462@redhat.com> <20090827193133.b7eed4a9.kamezawa.hiroyu@jp.fujitsu.com> <20090827105209.GA8469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827105209.GA8469@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eligible_child:

	/* Wait for all children (clone and not) if __WALL is set;
	 * otherwise, wait for clone children *only* if __WCLONE is
	 * set; otherwise, wait for non-clone children *only*.  (Note:
	 * A "clone" child here is one that reports to its parent
	 * using a signal other than SIGCHLD.) */

	if (((p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
	    && !(wo->wo_flags & __WALL))
		return 0;

I just can't understand what is the supposed behaviour when p is
sub-thread and p->exit_signal == -1.

This only matters when the caller is ptracer, and p is tracee. In
this case ptracer should use __WCLONE or __WALL, this doesn't look
very logical. Firstly, the comment says

	* A "clone" child here is one that reports to its parent
	* using a signal other than SIGCHLD.

but, unless ptraced, sub-thread reports nothing to ->parent.

IOW, perhaps this check should be

	if (!task_detached(p) && !(wo->wo_flags & __WALL) &&
	    (p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
		return 0;

?

When task_detached(p) == T, "p->exit_signal != SIGCHLD" looks like a
false positive to me. Because -1 is not a siganl, this is a marker
which indicates the deatached task - sub-thread or EXIT_DEAD. It _seems_
to me this check was added when threads were processes, and it was
possible to wait/reap a thread, not process.

In short. If ptracer calls wait4(ptraced_sub_thread), is it really
supposed it must use __WCLONE || __WALL?


(this check also breaks child_wait_callback() logic in
  do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
  but we can fix this in many ways. Just I am not sure _what_ should be
  fixed)

Oleg.

On 08/27, Oleg Nesterov wrote:
>
> On 08/27, KAMEZAWA Hiroyuki wrote:
> >
> > On Thu, 27 Aug 2009 12:08:46 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > >
> > > OK, I seem to understand what happens. Could you try the patch below?
> > >
> >
> > worked.
>
> Thanks. I need to think a bit, then I send the fix.
>
> > IMHO, it's necessary to "wake up parent with -ECHILD if all children dies"
>
> Of course! It was supposed to do. More precisely, we should wake up when
> any child which cuould be interesting to ->parent dies. No need to check
> "all children died" case specially. If parent sleeps on ->wait_chldexit
> there must be at least on eligible child.
>
> The problem is, do_notify_parent() changes ->exit_signal _before_ it calls
> __wake_up_parent(). This changes the result of eligible_child().
>
> Oleg.

