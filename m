Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZCDB3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZCDB3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZCDB2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:28:52 -0500
Received: from silene.metacarta.com ([208.80.142.18]:49285 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZCDB2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:28:51 -0500
Date: Tue, 3 Mar 2009 20:28:46 -0500 (EST)
From: Joe Malicki <jmalicki@metacarta.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kenneth Baker <bakerkj@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <5025982.10132161236130126636.JavaMail.root@ouachita>
In-Reply-To: <Pine.LNX.4.64.0903031037590.13485@blonde.anvils>
Subject: Re: BUG: setuid sometimes doesn't.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [66.31.17.145]
X-Mailer: Zimbra 5.0.9_GA_2533.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.9_GA_2533.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Hugh Dickins" <hugh@veritas.com> wrote:

> > 
> > Thanks for the attention!  This didn't seem to fix our problem
> > (surprisingly) since it does seem to fit with the finer details:
> 
> I'm sorry if I've wasted your time, but I am not surprised now.

Oh, not at all!  We're glad to help you out since we have a platform
that can reproduce, it's not that much work at this point to test a
patch (given we've already got a minimal reproduction case etc.)

> I went back to look closer, and the fs->count on /proc/*/{cwd,root}
> is merely the most obvious case: files->count is equally vulnerable
> to lookups on /proc/*/fd/*, via get_files_struct() calls (but the
> third LSM_UNSAFE_SHARE, sighand->count, appears to be of no
> interest to /proc, so safe from this point of view).

Good catch, I missed that (I had trouble tracking down everything
involved in /proc - I was looking for that case but overlooked it).

> So I think my patch was seriously incomplete.  However, the
> files->count
> case looks a lot harder to fix than the fs->count one.  Having
> started
> on this issue, I'd better do my best to come up with a fix to the
> files
> count side of it too, but must give it a little thought and time, and
> will need to CC some good people even if I do manage a patch - it's
> all too easy to fix this but introduce other more serious security
> or data lifetime errors.
>
> It would be nice to offer a preliminary patch which at least confirms
> that it is this /proc access which is causing the problem; but I
> didn't
> see how to do that without going all out for a fix.  Perhaps I'll
> have
> to compromise on a racy patch just to confirm the issue, we'll see.

I suppose we can test by ignoring the files->count for LSM_UNSAFE_SHARE
(it doesn't prove it's /proc, but at least narrows things down somewhat).
 
> > 
> > 1) The software load we were running it on does a health check every
> few minutes
> >    which, among other things, executes several lsof and ss
> (sockstat) processes.
> 
> lsof, yes, that fits exactly (perhaps ss equally but I don't know).
> 
> I'm afraid your health check is endangering the health of your
> system!
> But I do think the kernel's unreliable setuid is unacceptable
> behaviour.

The irony!

 
> > 
> > I could not reproduce the problem without our system-health-monitor
> process,
> > or on several other machines at home (Ubuntu 8.04 and Ubuntu 8.10
> with updated
> > kernels, running multicore).  So I am very suspicious of that race,
> although your
> > patch didn't seem to fix it.... (?!?!)
> 
> I didn't manage to reproduce it here myself either,
> though perhaps I should have tried on more machines.

I suspect it is something subtle about our workload that we haven't
entirely isolated (merely running lsof in a loop oddly doesn't seem
sufficient...)

> I'll get back to you... but not immediately.
> 
> Hugh

Given that this bug occurs exceedingly rarely "in the wild" outside of
our minimal test case, a delay isn't a concern.

Thanks!
Joe Malicki
