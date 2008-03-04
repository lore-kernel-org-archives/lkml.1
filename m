Return-Path: <linux-kernel-owner+w=401wt.eu-S1764273AbYCDPrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764273AbYCDPrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYCDPrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:47:39 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60520 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbYCDPri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:47:38 -0500
Date: Tue, 4 Mar 2008 18:51:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
Message-ID: <20080304155113.GC564@tv-sign.ru>
References: <20080302184430.GA16362@tv-sign.ru> <20080304122654.7313227010A@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304122654.7313227010A@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Roland McGrath wrote:
>
> [... big snip...]

Thanks Roland. I need a time to understand your explanation (I even printed
it to read in metro ;). I'll return tomorrow.

A quick note right now:

> static int group_is_really_stopped(struct task_struct *p)
> {
> 	int ret = 0;
> 	spin_lock(&p->sighand->siglock);
> 	ret = (p->signal->flags & (SIGNAL_STOP_STOPPING|SIGNAL_STOP_STOPPED)) ||
> 		p->signal->group_stop_count > 0;
> 	spin_unlock(&p->sighand->siglock);
> 	return ret;
> }

I thought abot something like that too.

However, SIGNAL_STOP_STOPPED doesn't relaible with ptrace. I mean, ptracer
doesn't clear SIGNAL_STOP_STOPPED. This is btw one of the problems which
complicates fixing do_wait(WSTOPPED).

As for SIGNAL_STOP_STOPPING... I am dreaming to find the way to eliminate
this lock-drop in get_signal_to_deliver(). Not sure this is possible, but
it is so nasty. For example, SIGNAL_STOP_DEQUEUED is racy, and I don't know
how to fix this. The patch we discussed some time ago doesn't really work
because dequeue_signal() drops the lock too. The latter is fixable afaics,
but needs very ugly changes.

Oleg.

