Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbZIAM00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbZIAM00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZIAM0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:26:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320AbZIAM0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:26:25 -0400
Date: Tue, 1 Sep 2009 14:22:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 0/2] fix do_wait(!__WALL) hang (Was: mmotm
	2009-08-24-16-24 uploaded)
Message-ID: <20090901122240.GA20989@redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org> <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com> <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com> <20090827093441.GA3451@redhat.com> <20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com> <20090827100846.GA6462@redhat.com> <20090827193133.b7eed4a9.kamezawa.hiroyu@jp.fujitsu.com> <20090827105209.GA8469@redhat.com> <20090828171724.GA17445@redhat.com> <20090828191624.0F5BC45B02@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828191624.0F5BC45B02@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28, Roland McGrath wrote:
>
> > eligible_child:
> >
> > 	/* Wait for all children (clone and not) if __WALL is set;
> > 	 * otherwise, wait for clone children *only* if __WCLONE is
> > 	 * set; otherwise, wait for non-clone children *only*.  (Note:
> > 	 * A "clone" child here is one that reports to its parent
> > 	 * using a signal other than SIGCHLD.) */
> >
> > 	if (((p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
> > 	    && !(wo->wo_flags & __WALL))
> > 		return 0;
> >
> > I just can't understand what is the supposed behaviour when p is
> > sub-thread and p->exit_signal == -1.
>
> As you say, you're not even supposed to be here when exit_signal = -1,
> except for the ptrace case.  This logic exists for the non-CLONE_THREAD
> clone case, i.e. ->exit_signal != SIGCHLD and != -1.
>
> > IOW, perhaps this check should be
> >
> > 	if (!task_detached(p) && !(wo->wo_flags & __WALL) &&
> > 	    (p->exit_signal != SIGCHLD) ^ !!(wo->wo_flags & __WCLONE))
> > 		return 0;
>
> That seems OK to me.

And this looks more right...

> > In short. If ptracer calls wait4(ptraced_sub_thread), is it really
> > supposed it must use __WCLONE || __WALL?
>
> I suspect not, but I'm not quite sure.  That is, it makes sense to me that
> a ptracer should always get its tracees in all waits.  That is consistent
> with not having to use WUNTRACED, for example.  But I'm not really sure any
> more what the historical behavior of this has been.

Yes. Let's not change this code. This is user-visible, might break something.
I think it is better to make more "safe" fix.

Oleg.

