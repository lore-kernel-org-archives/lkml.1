Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbZCCDQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbZCCDQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZCCDQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:16:35 -0500
Received: from silene.metacarta.com ([208.80.142.18]:42995 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbZCCDQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:16:33 -0500
Date: Mon, 2 Mar 2009 22:16:28 -0500 (EST)
From: Joe Malicki <jmalicki@metacarta.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Kenneth Baker <bakerkj@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <30226597.10050111236050188053.JavaMail.root@ouachita>
In-Reply-To: <15171620.10049841236049960269.JavaMail.root@ouachita>
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

> On Thu, 26 Feb 2009, Joe Malicki wrote:
> > ----- "Joe Malicki" <jmalicki@metacarta.com> wrote:
> > 
> > > Very rarely, we experience a setuid program not properly getting
> > > the euid of its owner.
> > > 
> > > Thus far, we have only seen failures for the program being setuid
> > > root, being run by a non-root user, on a multi-core machine. 
> Trying
> > > to
> > > setuid to a user from root, *or* booting with maxcpus=1 and trying
> to
> > > setuid from a non-root user to root, both fail.
> > 
> > Sorry, misstated that.
> > 
> > setuid from nonroot->root, or with maxcpus=1, always seems to work.
> > 
> > Only multiple cores with setuid to root has failed for us.
> 
> Here's a shot in the dark: I may be misreading things, and I don't
> quite see how it fits with the finer details you mention here; but
> it looks to me as if /proc/*/cwd and /proc/*/root lookup interferes
> with the fs->count check in fs/exec.c's unsafe_exec().
> 
> If you would, please give this patch against 2.6.28* a try (applies
> to 2.6.29-rc too, but not to 2.6.24*), to see if it makes any
> difference to you.  I'm hoping not to hear from you for a while!
> 
> (I assume it's okay to read_lock fs->lock while holding task_lock:
> I didn't see anywhere else doing so, but lockdep hasn't objected
> yet.)
> 
> Hugh

Hugh...

Thanks for the attention!  This didn't seem to fix our problem
(surprisingly) since it does seem to fit with the finer details:

1) The software load we were running it on does a health check every few minutes
   which, among other things, executes several lsof and ss (sockstat) processes.
2) In security/commoncap.c, the code:
     void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
{
        if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
            !cap_issubset(bprm->cap_post_exec_permitted,
                          current->cap_permitted)) {
                set_dumpable(current->mm, suid_dumpable);
                current->pdeath_signal = 0;

                if (unsafe & ~LSM_UNSAFE_PTRACE_CAP) {
                        if (!capable(CAP_SETUID)) {
                                bprm->e_uid = current->uid;
                                bprm->e_gid = current->gid;
                        }
                        if (cap_limit_ptraced_target()) {
                                bprm->cap_post_exec_permitted = cap_intersect(
                                        bprm->cap_post_exec_permitted,
                                        current->cap_permitted);
                        }
                }
        }
.....

Looks like it would fail because of that (is the ~LSM_UNSAFE_PTRACE_CAP
actually the intended condition?  It wasn't clear either way for me, due to
the lack of comments).

I could not reproduce the problem without our system-health-monitor process,
or on several other machines at home (Ubuntu 8.04 and Ubuntu 8.10 with updated
kernels, running multicore).  So I am very suspicious of that race, although your
patch didn't seem to fix it.... (?!?!)

Thanks,
Joe Malicki
  
P.S. Michael Itz did a lot of work related to this issue, and managed to narrow 
it down quite a bit, and I feel guilty putting a lot out there without mentioning that.
