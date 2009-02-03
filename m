Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbZBCSZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbZBCSZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZBCSZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:25:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46289 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZBCSZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:25:26 -0500
Date: Tue, 3 Feb 2009 19:22:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] process wide itimer cruft
Message-ID: <20090203182240.GA19079@redhat.com>
References: <1233473426.2604.13.camel@ymzhang> <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com> <1233476961.13659.12.camel@minggr.sh.intel.com> <1233479836.4787.63.camel@laptop> <1233482239.4787.65.camel@laptop> <1233537134.2604.24.camel@ymzhang> <1233564818.4787.107.camel@laptop> <1233662165.10184.33.camel@laptop> <20090203172305.GA11285@redhat.com> <1233683499.10184.45.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233683499.10184.45.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Peter Zijlstra wrote:
>
> ->live  -- the number of associated tasks,
> ->count -- not quite a refcount?

No, ->count is not a refcount.

Basically, ->count means how many threads didn't pass release_task() yet.
Well, actually __exit_signal(), but this doesn't matter. The thread becomes
"really dead" after that. Until then, it is still visible to, say,
find_task_by_vpid, signals, etc.

But if we have a zombie group leader, it may stay zombie "forever", and
->count doesn't go to zero. So we also have signal->live, when it is zero
we know that all sub-threads at least entered do_exit(). For example,
we can safely do exit_itimers() when ->live == 0, no other thread can
do sys_timer_create() (or any syscall of course).

> Could you shed a bit of light on the distinction between sighand and
> signal?

->signal is protected by ->sighand->siglock, and they both cleared
"atomically" under ->siglock in __exit_signal. I guess, the only
reason for 2 structures is CLONE_SIGHAND which can be used without
CLONE_THREAD.

Now, let's look at arch/ia64/kernel/ptrace.c:ptrace_attach_sync_user_rbs()

	read_lock(&tasklist_lock);
	if (child->signal) {
		... this task is alive, we can proceed ...

This is correct, but if we want to make ->signal refcountable, we
should turn the above check into

	if (child->sighand) {

This is the same, but allows use to never clear task->signal.

I'll try to send the patch which does this today, we should also
change posix-cpu-timers.c and thats all, if my grepping was right.

> > I think we really need another counter, at least for now.
>
> Don't rush on my account, Ingo's proposed solution doesn't need this.

OK.

Oleg.

