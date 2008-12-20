Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYLTQc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYLTQc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 11:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYLTQcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 11:32:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48592 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYLTQcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 11:32:19 -0500
Date: Sat, 20 Dec 2008 17:30:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Null pointer deref with hrtimer_try_to_cancel()
Message-ID: <20081220163033.GB26499@redhat.com>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain> <20081220161457.GA26499@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220161457.GA26499@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Oleg Nesterov wrote:
>
> On 12/19, Thomas Gleixner wrote:
> >
> > On Fri, 19 Dec 2008, Eric Sesterhenn wrote:
> >
> > > root@computer-desktop:~/testing/ltp-full-20081130/tools/strace_test#
> > > ./timer_create04
> > > timer_create04    1  FAIL  :  timer_create(2) failed to produce expected
> > > error; 22 , errno : EINVAL and got 0
> > > timer_create04    2  PASS  :  timer_create(2) expected failure; Got
> > > errno - EINVAL : Invalid parameter
> > > timer_create04    3  PASS  :  timer_create(2) expected failure; Got
> > > errno - EFAULT : Bad address
> > > timer_create04    4  PASS  :  timer_create(2) expected failure; Got
> > > errno - EFAULT : Bad address
> > > timer_create04    5  PASS  :  timer_create(2) expected failure; Got
> > > errno - EFAULT : Bad address
> > > timer_create04    6  PASS  :  timer_create(2) expected failure; Got
> > > errno - EFAULT : Bad address
>
> according to above, timer_create() always returns -EXXX ?

Aaah. I misread the first "FAIL" above. timer_create() succeeds!

hmm... it does timer_create(MAX_CLOCKS) and thus it should fail...

Can't find the original commit at
	http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git

but now we have CLOCK_MONOTONIC_RAW == 4, and MAX_CLOCKS == 4. So the
test should be fixed too, the first timer_create() should not fail on
2.6.28.

OK, sys_timer_create(CLOCK_MONOTONIC_RAW) calls
__hrtimer_init(CLOCK_MONOTONIC_RAW) and this looks just wrong:

	 timer->base = &cpu_base->clock_base[CLOCK_MONOTONIC_RAW];

while HRTIMER_MAX_CLOCK_BASES == 2. So time->base points to
"nowhere", this can explain the crash.

Thomas?

Oleg.

