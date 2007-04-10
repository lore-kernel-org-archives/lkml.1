Return-Path: <linux-kernel-owner+w=401wt.eu-S1030201AbXDJBPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030201AbXDJBPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030274AbXDJBPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:15:53 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39450 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201AbXDJBPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:15:51 -0400
Date: Mon, 9 Apr 2007 18:15:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Jeff Garzik <jeff@garzik.org>, Robin Holt <holt@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-Id: <20070409181540.579e55d4.akpm@linux-foundation.org>
In-Reply-To: <m1mz1hyryh.fsf@ebiederm.dsl.xmission.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<4616CBF0.7090606@garzik.org>
	<20070409172339.48d661d6.akpm@linux-foundation.org>
	<m1mz1hyryh.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2007 18:48:54 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > I suspect there are quite a few kernel threads which don't really need to
> > be threads at all: the code would quite happily work if it was changed to
> > use keventd, via schedule_work() and friends.  But kernel threads are
> > somewhat easier to code for.
> >
> > I also suspect that there are a number of workqueue threads which
> > could/should have used create_singlethread_workqueue().  Often this is
> > because the developer just didn't think to do it.
> >
> > otoh, a lot of these inefficeincies are probably down in scruffy drivers
> > rather than in core or top-level code.
> >
> > <I also wonder where all these parented-by-init,
> > presumably-not-using-kthread kernel threads are coming from>
> 
> 
> >From another piece of this thread.

Yeah, sorry.  Without mentioning any names, someone@tv-sign.ru broke the
threading so I came in halfway.

> > > Robin how many kernel thread per cpu are you seeing?
> > 
> > 10.
> > 
> > FYI, pid 1539 is kthread.
> > 
> > a01:~ # ps -ef | egrep "\[.*\/255\]" 
> > root       512     1  0 Apr08 ?        00:00:00 [migration/255]
> > root       513     1  0 Apr08 ?        00:00:00 [ksoftirqd/255]
> > root      1281     1  0 Apr08 ?        00:00:02 [events/255]
> > root      2435  1539  0 Apr08 ?        00:00:00 [kblockd/255]
> > root      3159  1539  0 Apr08 ?        00:00:00 [aio/255]
> > root      4007  1539  0 Apr08 ?        00:00:00 [cqueue/255]
> > root      8653  1539  0 Apr08 ?        00:00:00 [ata/255]
> > root     17438  1539  0 Apr08 ?        00:00:00 [xfslogd/255]
> > root     17950  1539  0 Apr08 ?        00:00:00 [xfsdatad/255]
> > root     18426  1539  0 Apr08 ?        00:00:00 [rpciod/255]
> 
> 
> So it looks like there were about 1500 kernel threads that started up before
> kthread started.
> 
> So the kernel threads appear to have init as their parent is because
> they started before kthread for the most part.
> 
> At 10 kernel threads per cpu there may be a little bloat but it isn't
> out of control.  It is mostly that we are observing the kernel as
> NR_CPUS approaches infinity.  4096 isn't infinity yet but it's easily
> a 1000 fold bigger then most people are used to :)

Yes, I expect we could run init_workqueues() much earlier, from process 0
rather than from process 1.  Something _might_ blow up as it often does when
we change startup ordering, but in this case it would be somewhat surprising.

