Return-Path: <linux-kernel-owner+w=401wt.eu-S2993169AbXDYUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993169AbXDYUmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993172AbXDYUmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:42:18 -0400
Received: from gw.goop.org ([64.81.55.164]:48945 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993169AbXDYUmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:42:17 -0400
Message-ID: <462FBD44.2040103@goop.org>
Date: Wed, 25 Apr 2007 13:42:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net> <462FB8E6.9070501@googlemail.com>
In-Reply-To: <462FB8E6.9070501@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Timing information is broken
>   

This looks like Andi's sched_clock stuff hitting: it returns an
inherently per-cpu result, so using it for printk timestamps isn't very
useful.

> [4294667.296007]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [4294667.296007]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |irq event stamp: 472
> [4294667.296008] hardirqs last  enabled at (472): [<c020fe3a>] irqsafe2A_rlock_12+0xb6/0xc7
> [4294667.296008] hardirqs last disabled at (471): [<c010a9f1>] sched_clock+0x78/0x120
> [4294667.296008] softirqs last  enabled at (468): [<c020fe25>] irqsafe2A_rlock_12+0xa1/0xc7
> [4294667.296008] softirqs last disabled at (464): [<c020fd90>] irqsafe2A_rlock_12+0xc/0xc7
> [4294667.296008] FAILED| [<c01052e0>] dump_trace+0x63/0x1eb
> [4294667.296008]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
> [4294667.296008]  [<c01060c4>] show_trace+0x12/0x14
> [4294667.296008]  [<c0106161>] dump_stack+0x16/0x18
> [4294667.296008]  [<c020da4f>] dotest+0x8d/0x3f4
> [4294667.296008]  [<c02181dd>] locking_selftest+0x915/0x1a58
> [4294667.296008]  [<c04f88ed>] start_kernel+0x277/0x349
> [4294667.296008]  =======================
>   

This is a bit mysterious, in that it seems to be triggered by my
softlockup watchdog patch, which doesn't seem to have anything to do
with the locking tests at all.  Filed under "Ingo's mystery".

> [4294667.511000] BUG: at arch/i386/kernel/sched-clock.c:175 init_sched_clock()
> [4294667.511000]  [<c01052e0>] dump_trace+0x63/0x1eb
> [4294667.511000]  [<c0105482>] show_trace_log_lvl+0x1a/0x30
> [4294667.511000]  [<c01060c4>] show_trace+0x12/0x14
> [4294667.511000]  [<c0106161>] dump_stack+0x16/0x18
> [4294667.511000]  [<c04fd968>] init_sched_clock+0x6d/0xcc
> [4294667.512000]  [<c04f8505>] kernel_init+0x14e/0x2bf
> [4294667.512000]  [<c0104ec3>] kernel_thread_helper+0x7/0x10
> [4294667.512000]  =======================

This also seems to be the sched_clock change; the WARN_ON is asserting
that it got initialized early enough, but it isn't. 

    J
