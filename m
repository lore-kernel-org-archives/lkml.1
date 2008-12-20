Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYLTQQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYLTQQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 11:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYLTQQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 11:16:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42137 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYLTQQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 11:16:44 -0500
Date: Sat, 20 Dec 2008 17:14:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Null pointer deref with hrtimer_try_to_cancel()
Message-ID: <20081220161457.GA26499@redhat.com>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812192243350.3376@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19, Thomas Gleixner wrote:
>
> On Fri, 19 Dec 2008, Eric Sesterhenn wrote:
>
> > I was running the strace-test from ltp 20081130 with 2.6.28-rc9, when i got the following bug
> > (I can reproduce the bug by simply running the testcase timer_create04)

Thanks a lot Eric (and thanks for .s files you sent me privately).

At first glance this all is very strange.

> > [ 2460.444044]  [<c0141070>] ? hrtimer_try_to_cancel+0x20/0x90
> > [ 2460.444044]  [<c013cf94>] ? exit_itimers+0x94/0xf0
> > [ 2460.444044]  [<c012cab2>] ? do_exit+0x602/0x810

So, when the task exits its has a timer in ->posix_timers.

However, this means sys_timer_create() must return 0, the code
is very simple

	spin_lock_irq(&current->sighand->siglock);
	new_timer->it_process = process;
	list_add(&new_timer->list, &current->signal->posix_timers);
	spin_unlock_irq(&current->sighand->siglock);

	return 0;

and nobody else adds the timer to ->posix_timers.

But,

> > root@computer-desktop:~/testing/ltp-full-20081130/tools/strace_test#
> > ./timer_create04
> > timer_create04    1  FAIL  :  timer_create(2) failed to produce expected
> > error; 22 , errno : EINVAL and got 0
> > timer_create04    2  PASS  :  timer_create(2) expected failure; Got
> > errno - EINVAL : Invalid parameter
> > timer_create04    3  PASS  :  timer_create(2) expected failure; Got
> > errno - EFAULT : Bad address
> > timer_create04    4  PASS  :  timer_create(2) expected failure; Got
> > errno - EFAULT : Bad address
> > timer_create04    5  PASS  :  timer_create(2) expected failure; Got
> > errno - EFAULT : Bad address
> > timer_create04    6  PASS  :  timer_create(2) expected failure; Got
> > errno - EFAULT : Bad address

according to above, timer_create() always returns -EXXX ?

I'll try to re-produce and investigate tomorrow.

Oleg.

