Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755Ab0AZSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab0AZSRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745Ab0AZSRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:17:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab0AZSRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:17:44 -0500
Date: Tue, 26 Jan 2010 19:16:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: check_usage_backwards() && forwards? (Was: [2.6.33-rc5] starting
	emacs makes lockdep warning)
Message-ID: <20100126181641.GA10460@redhat.com>
References: <20100126121618.5AA5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126121618.5AA5.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add  lockdep gurus)

Lockdep has found the real bug, but the output doesn't look right to me

On 01/26, KOSAKI Motohiro wrote:
>
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.33-rc5 #77
> ---------------------------------------------------------
> emacs/1609 just changed the state of lock:
>  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190
> but this lock took another, HARDIRQ-unsafe lock in the past:
>  (&(&sighand->siglock)->rlock){-.....}

"HARDIRQ-unsafe" and "this lock took another" looks wrong, afaics.

>   ... key      at: [<ffffffff81c054a4>] __key.46539+0x0/0x8
>   ... acquired at:
>    [<ffffffff81089af6>] __lock_acquire+0x1056/0x15a0
>    [<ffffffff8108a0df>] lock_acquire+0x9f/0x120
>    [<ffffffff81423012>] _raw_spin_lock_irqsave+0x52/0x90
>    [<ffffffff8127c1be>] __proc_set_tty+0x3e/0x150
>    [<ffffffff8127e01d>] tty_open+0x51d/0x5e0

The stack-trace shows that this lock (ctrl_lock) was taken under
->siglock (which is hopefully irq-safe).

Typo in check_usage_backwards() ?

Oleg.

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2147,7 +2147,7 @@ check_usage_backwards(struct task_struct
 		return ret;
 
 	return print_irq_inversion_bug(curr, &root, target_entry,
-					this, 1, irqclass);
+					this, 0, irqclass);
 }
 
 void print_irqtrace_events(struct task_struct *curr)

