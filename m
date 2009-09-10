Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbZIJPnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbZIJPnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZIJPnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:43:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:52942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZIJPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:43:21 -0400
Subject: Re: [2.6.31-rc9] hotplug SATA vs lockdep: false positive?
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
In-Reply-To: <6278d2220909091420g688bd11fybc33be4e472757b1@mail.gmail.com>
References: <6278d2220909091420g688bd11fybc33be4e472757b1@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 17:43:22 +0200
Message-Id: <1252597402.7205.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 22:20 +0100, Daniel J Blueman wrote:

> When hot-plugging my SATA DVD drive into my laptop, I see a lockdep
> warning [1]. On closer inspection, both flush_workqueue() and
> worker_thread() do tricks with lockdep maps. False positive?

No, looks like a typical case of a workqueue trying to flush itself,
something that can easily deadlock for real.

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.31-rc9-290cd #1
> -------------------------------------------------------
> kacpi_hotplug/198 is trying to acquire lock:
>  (kacpid){+.+.+.}, at: [<ffffffff81073a70>] flush_workqueue+0x0/0xf0
> (workqueue.c:292)
> 
> but task is already holding lock:
>  (&dpc->work){+.+.+.}, at: [<ffffffff81072a42>]
> worker_thread+0x1f2/0x3c0 (bitops.h:101)
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&dpc->work){+.+.+.}:
>        [<ffffffff8108eb19>] __lock_acquire+0xe29/0x1240
>        [<ffffffff8108f04e>] lock_acquire+0x11e/0x170
>        [<ffffffff81072a92>] worker_thread+0x242/0x3c0 (workqueue.c:291)
>        [<ffffffff81077456>] kthread+0xa6/0xc0
>        [<ffffffff8100d29a>] child_rip+0xa/0x20
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (kacpid){+.+.+.}:
>        [<ffffffff8108ebe1>] __lock_acquire+0xef1/0x1240
>        [<ffffffff8108f04e>] lock_acquire+0x11e/0x170
>        [<ffffffff81073acc>] flush_workqueue+0x5c/0xf0 (workqueue.c:403)
>        [<ffffffff812f6eaf>] acpi_os_wait_events_complete+0x10/0x1e
>        [<ffffffff812f6ee7>] acpi_os_execute_hp_deferred+0x2a/0x3e
>        [<ffffffff81072a98>] worker_thread+0x248/0x3c0 (workqueue.c:292)
>        [<ffffffff81077456>] kthread+0xa6/0xc0
>        [<ffffffff8100d29a>] child_rip+0xa/0x20
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> other info that might help us debug this:
> 
> 2 locks held by kacpi_hotplug/198:
>  #0:  (kacpi_hotplug){+.+...}, at: [<ffffffff81072a42>]
> worker_thread+0x1f2/0x3c0
>  #1:  (&dpc->work){+.+.+.}, at: [<ffffffff81072a42>] worker_thread+0x1f2/0x3c0
> 
> stack backtrace:
> Pid: 198, comm: kacpi_hotplug Tainted: G         C 2.6.31-rc9-290cd #1
> 
> Call Trace:
>  [<ffffffff8108c8a7>] print_circular_bug_tail+0xa7/0x100
>  [<ffffffff8108ebe1>] __lock_acquire+0xef1/0x1240
>  [<ffffffff8108a808>] ? add_lock_to_list+0x58/0xf0
>  [<ffffffff8108f04e>] lock_acquire+0x11e/0x170
>  [<ffffffff81073a70>] ? flush_workqueue+0x0/0xf0 (workqueue.c:397)
>  [<ffffffff812f6ebd>] ? acpi_os_execute_hp_deferred+0x0/0x3e
>  [<ffffffff81073acc>] flush_workqueue+0x5c/0xf0 (workqueue.c:403)
>  [<ffffffff81073a70>] ? flush_workqueue+0x0/0xf0 (workqueue.c:397)
>  [<ffffffff812f6eaf>] acpi_os_wait_events_complete+0x10/0x1e drivers/acpi/osl.c
>  [<ffffffff812f6ee7>] acpi_os_execute_hp_deferred+0x2a/0x3e
>  [<ffffffff81072a98>] worker_thread+0x248/0x3c0 (workqueue.c:292)
>  [<ffffffff81072a42>] ? worker_thread+0x1f2/0x3c0
>  [<ffffffff81077900>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff81072850>] ? worker_thread+0x0/0x3c0
>  [<ffffffff81077456>] kthread+0xa6/0xc0
>  [<ffffffff8100d29a>] child_rip+0xa/0x20
>  [<ffffffff8100cbd4>] ? restore_args+0x0/0x30
>  [<ffffffff810773b0>] ? kthread+0x0/0xc0
>  [<ffffffff8100d290>] ? child_rip+0x0/0x20

