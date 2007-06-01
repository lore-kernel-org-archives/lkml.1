Return-Path: <linux-kernel-owner+w=401wt.eu-S1763511AbXFAVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763511AbXFAVXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762816AbXFAVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:23:34 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:56467 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759746AbXFAVXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:23:33 -0400
To: mingo@elte.hu
CC: michal.k.k.piotrowski@gmail.com, linux-kernel@vger.kernel.org
In-reply-to: <20070601130302.GA16172@elte.hu> (message from Ingo Molnar on
	Fri, 1 Jun 2007 15:03:02 +0200)
Subject: Re: [1/3] 2.6.22-rc3: known regressions v2
References: <46600F1C.5000302@googlemail.com> <E1Hu6k5-0001Xm-00@dorka.pomaz.szeredi.hu> <20070601130302.GA16172@elte.hu>
Message-Id: <E1HuEae-0002eE-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 01 Jun 2007 23:23:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> i have no better ideas that what you already tried - but unfortunately 
> the tracer makes the bug go away and the NMI watchdog crashes your box. 
> Btw., nmi_watchdog=2 might have a higher chance of surviving (it can 
> still lock up a T60 but with a lower likelyhood).

Good tip, nmi_watchdog=2 worked.  Unlike the previous freezes, after
this one it didn't continue after some minutes.  Don't know if that's
because the NMI oopser changed something, or if this is a slightly
different lockup...

No serial port on this laptop, so screenshot done with digicam:

  http://www.kernel.org/pub/linux/kernel/people/mszeredi/freeze/nmioops.jpg

Here are the transcribed stack traces:

CPU1
process: strace
 _spin_lock
 task_rq_lock
 wait_task_inactive
 ptrace_check_attach
 sys_ptrace

CPU0
process: fusexmp_fh (this is one of several similar threads being straced)
 _spin_lock_irq
 schedule
 ptrace_stop
 ptrace_notify
 syscall_trace
 syscall_trace_enter
 tracesys

Both these seem to be spinning on rq->lock, but who is holding this
lock?

Miklos
