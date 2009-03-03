Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbZCCLSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbZCCLSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCCLSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:18:05 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43900 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbZCCLSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:18:04 -0500
Date: Tue, 3 Mar 2009 11:16:36 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Joe Malicki <jmalicki@metacarta.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kenneth Baker <bakerkj@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: setuid sometimes doesn't.
In-Reply-To: <30226597.10050111236050188053.JavaMail.root@ouachita>
Message-ID: <Pine.LNX.4.64.0903031037590.13485@blonde.anvils>
References: <30226597.10050111236050188053.JavaMail.root@ouachita>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009, Joe Malicki wrote:
> ----- "Hugh Dickins" <hugh@veritas.com> wrote:
> > On Thu, 26 Feb 2009, Joe Malicki wrote:
> > > 
> > > > Very rarely, we experience a setuid program not properly getting
> > > > the euid of its owner.
> > 
> > Here's a shot in the dark: I may be misreading things, and I don't
> > quite see how it fits with the finer details you mention here; but
> > it looks to me as if /proc/*/cwd and /proc/*/root lookup interferes
> > with the fs->count check in fs/exec.c's unsafe_exec().
> 
> Thanks for the attention!  This didn't seem to fix our problem
> (surprisingly) since it does seem to fit with the finer details:

I'm sorry if I've wasted your time, but I am not surprised now.

I went back to look closer, and the fs->count on /proc/*/{cwd,root}
is merely the most obvious case: files->count is equally vulnerable
to lookups on /proc/*/fd/*, via get_files_struct() calls (but the
third LSM_UNSAFE_SHARE, sighand->count, appears to be of no
interest to /proc, so safe from this point of view).

So I think my patch was seriously incomplete.  However, the files->count
case looks a lot harder to fix than the fs->count one.  Having started
on this issue, I'd better do my best to come up with a fix to the files
count side of it too, but must give it a little thought and time, and
will need to CC some good people even if I do manage a patch - it's
all too easy to fix this but introduce other more serious security
or data lifetime errors.

It would be nice to offer a preliminary patch which at least confirms
that it is this /proc access which is causing the problem; but I didn't
see how to do that without going all out for a fix.  Perhaps I'll have
to compromise on a racy patch just to confirm the issue, we'll see.

> 
> 1) The software load we were running it on does a health check every few minutes
>    which, among other things, executes several lsof and ss (sockstat) processes.

lsof, yes, that fits exactly (perhaps ss equally but I don't know).

I'm afraid your health check is endangering the health of your system!
But I do think the kernel's unreliable setuid is unacceptable behaviour.

> 2) In security/commoncap.c, the code:
>      void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
> {
...
>                 if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
>                         if (!capable(CAP_SETUID)) {
>                                 bprm->e_uid = current->uid;
>                                 bprm->e_gid = current->gid;
>                         }
>                 }
...
> 
> Looks like it would fail because of that (is the ~LSM_UNSAFE_PTRACE_CAP
> actually the intended condition?  It wasn't clear either way for me, due to
> the lack of comments).

Yes, that's where I believe the transiently wrong result of unsafe_exec()
causes the wrong euid to be set (without even failing the exec).  I'm
pretty sure that test is as intended: it is wanting to deal differently
with ptrace and cloned cases; but this is all unfamiliar territory to me.

> 
> I could not reproduce the problem without our system-health-monitor process,
> or on several other machines at home (Ubuntu 8.04 and Ubuntu 8.10 with updated
> kernels, running multicore).  So I am very suspicious of that race, although your
> patch didn't seem to fix it.... (?!?!)

I didn't manage to reproduce it here myself either,
though perhaps I should have tried on more machines.

> 
> Thanks,
> Joe Malicki
>   
> P.S. Michael Itz did a lot of work related to this issue, and managed to narrow 
> it down quite a bit, and I feel guilty putting a lot out there without mentioning that.

Many thanks to the both of you: narrowing such things down is hard work,
but I do think you've made a very interesting and worthwhile discovery.

I'll get back to you... but not immediately.

Hugh
