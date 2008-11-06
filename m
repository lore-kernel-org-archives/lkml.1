Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYKFL7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYKFL7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 06:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYKFL7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 06:59:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58152 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbYKFL7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 06:59:31 -0500
Date: Thu, 6 Nov 2008 13:59:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       doug.chapman@hp.com
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
Message-ID: <20081106125951.GA5756@redhat.com>
References: <20081105191211.c0316b94.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105191211.c0316b94.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Begin forwarded message:
>
> On Tue, 2008-10-28 at 14:38 -0400, Doug Chapman wrote:
> > On Mon, 2008-10-27 at 11:39 -0700, Frank Mayhar wrote:
> > > On Wed, 2008-10-22 at 13:03 -0400, Doug Chapman wrote:
> > > > Unable to handle kernel paging request at virtual address
> > > > 94949494949494a4
> > >
> > > I take it this can be read as an uninitialized (or cleared) pointer?
> > >
> > > It certainly looks like this is a race in thread (process?) teardown.  I
> > > don't have hardware on which to reproduce this but _looks_ like another
> > > thread has gotten in and torn down the process while we've been busy.
> >
> > I finally managed to get kdump working and caught this in the act.  I
> > still need to dig into this more but I think these 2 threads will show
> > us the race condition.  Note that this is a slightly hacked kernel in
> > that I removed "static" from a few functions to better see what was
> > going on but no real functional changes when compared to a recent (day
> > old or so) git pull from Linus's tree.
>
> After digging through this a bit, I've concluded that it's probably a
> race between process reap and the dequeue_entity() call to update_curr()
> combined with a side effect of the slab debug stuff.  The
> account_group_exec_runtime() routine (like the rest of these routines)
> checks tsk->signal and tsk->signal->cputime.totals for NULL to make sure
> they're still valid.  It looks like at this point tsk->signal is valid
> (since the tsk->signal->cputime dereference succeeded) but
> tsk->signal->cputime.totals is invalid.  That can't happen unless the
> process is being reaped,

Frank, currently I don't have the source code which I can look at,
so I am probably wrong... But just in case, perhaps we can do

	-	account_group_exec_runtime(...);
	+	if (lock_task_sighand(...)) {
	+		account_group_exec_runtime(...);
	+		unlock_task_sighand();
	+	}

?

Once we take ->siglock the task can't be reaped, and ->signal becomes
stable and != NULL.

Oleg.

