Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbXDWI7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbXDWI7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXDWI7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:59:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbXDWI7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:59:33 -0400
Date: Mon, 23 Apr 2007 01:58:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>, ck list <ck@vds.kolivas.org>
Subject: Re: [PATCH] sched: staircase deadline misc fixes
Message-Id: <20070423015816.9f23755f.akpm@linux-foundation.org>
In-Reply-To: <200703290237.38777.kernel@kolivas.org>
References: <200703290237.38777.kernel@kolivas.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 02:37:38 +1000 Con Kolivas <kernel@kolivas.org> wrote:

> test.kernel.org found some idle time regressions in the latest update to the
> staircase deadline scheduler and Andy Whitcroft helped me track down the 
> offending problem which was present in all previous RSDL schedulers but
> previously wouldn't be manifest without changes in nice. So here is a bugfix
> for the set_load_weight being incorrectly set and a few other minor 
> improvements. Thanks Andy!
> 
> I'm cautiously optimistic that we're at the thin edge of the bugfix wedge now.
> 
> ---
> set_load_weight() should be performed after p->quota is set. This fixes a
> large SMP performance regression.
> 
> Make sure rr_interval is never set to less than one jiffy.
> 
> Some sanity checking in update_cpu_clock will prevent bogus sched_clock
> values.
> 
> SCHED_BATCH tasks should not set the rq->best_static_prio field.
> 
> Correct sysctl rr_interval description to describe the value in milliseconds.
> 
> Style fixes.
> 
> Signed-off-by: Con Kolivas <kernel@kolivas.org>
> 
> ---
>  Documentation/sysctl/kernel.txt |    8 ++--
>  kernel/sched.c                  |   73 +++++++++++++++++++++++++++++-----------

OK, this is bizarre.  I'm getting this:

[   52.754522] RTNL: assertion failed at net/ipv4/devinet.c (1055)
[   52.758258]  [<c02cb6f7>] inetdev_event+0x46/0x2d8
[   52.762041]  [<c01049c9>] show_trace_log_lvl+0x28/0x2c
[   52.765887]  [<c0105482>] show_trace+0xf/0x13
[   52.769627]  [<c01054d7>] dump_stack+0x14/0x18
[   52.773320]  [<c029b22e>] rtnl_unlock+0xd/0x2f
[   52.776999]  [<c029f410>] fib_rules_event+0x3a/0xeb
[   52.780678]  [<c01236aa>] notifier_call_chain+0x2c/0x55
[   52.784339]  [<c012371a>] raw_notifier_call_chain+0x17/0x1b
[   52.787975]  [<c0295984>] dev_open+0x63/0x6b
[   52.791587]  [<c02944fd>] dev_change_flags+0x50/0x104
[   52.795201]  [<c02cbcf4>] devinet_ioctl+0x259/0x57b
[   52.798798]  [<c02955b2>] dev_ifsioc+0x113/0x3a0
[   52.802408]  [<c028b127>] sock_ioctl+0x1a1/0x1c4
[   52.805966]  [<c028af86>] sock_ioctl+0x0/0x1c4
[   52.809475]  [<c0165969>] do_ioctl+0x19/0x4d
[   52.812977]  [<c0165b99>] vfs_ioctl+0x1fc/0x216
[   52.816478]  [<c0165bff>] sys_ioctl+0x4c/0x65
[   52.819944]  [<c0103b68>] syscall_call+0x7/0xb
[   52.823395]  =======================
[   52.826923] RTNL: assertion failed at net/ipv4/igmp.c (1358)
[   52.830485]  [<c02cf545>] ip_mc_up+0x35/0x59
[   52.834034]  [<c029b22e>] rtnl_unlock+0xd/0x2f
[   52.837569]  [<c02cb7ed>] inetdev_event+0x13c/0x2d8
[   52.841123]  [<c01049c9>] show_trace_log_lvl+0x28/0x2c
[   52.844682]  [<c0105482>] show_trace+0xf/0x13
[   52.848227]  [<c01054d7>] dump_stack+0x14/0x18
[   52.851752]  [<c029b22e>] rtnl_unlock+0xd/0x2f
[   52.855242]  [<c029f410>] fib_rules_event+0x3a/0xeb
[   52.858734]  [<c01236aa>] notifier_call_chain+0x2c/0x55
[   52.862241]  [<c012371a>] raw_notifier_call_chain+0x17/0x1b
[   52.865759]  [<c0295984>] dev_open+0x63/0x6b
[   52.869191]  [<c02944fd>] dev_change_flags+0x50/0x104
[   52.872571]  [<c02cbcf4>] devinet_ioctl+0x259/0x57b
[   52.875998]  [<c02955b2>] dev_ifsioc+0x113/0x3a0
[   52.879399]  [<c028b127>] sock_ioctl+0x1a1/0x1c4
[   52.882741]  [<c028af86>] sock_ioctl+0x0/0x1c4
[   52.886025]  [<c0165969>] do_ioctl+0x19/0x4d
[   52.889292]  [<c0165b99>] vfs_ioctl+0x1fc/0x216
[   52.892534]  [<c0165bff>] sys_ioctl+0x4c/0x65
[   52.895760]  [<c0103b68>] syscall_call+0x7/0xb
[   52.898982]  =======================
[   52.907714] RTNL: assertion failed at net/ipv4/igmp.c (1205)
[   52.910229]  [<c02cf3b7>] ip_mc_inc_group+0x3c/0x195
[   52.912771]  [<c01054d7>] dump_stack+0x14/0x18
[   52.915314]  [<c02cf551>] ip_mc_up+0x41/0x59
[   52.917856]  [<c029b22e>] rtnl_unlock+0xd/0x2f
[   52.920411]  [<c02cb7ed>] inetdev_event+0x13c/0x2d8
[   52.922990]  [<c01049c9>] show_trace_log_lvl+0x28/0x2c
[   52.925568]  [<c0105482>] show_trace+0xf/0x13
[   52.928101]  [<c01054d7>] dump_stack+0x14/0x18
[   52.930591]  [<c029b22e>] rtnl_unlock+0xd/0x2f
[   52.933061]  [<c029f410>] fib_rules_event+0x3a/0xeb
[   52.935551]  [<c01236aa>] notifier_call_chain+0x2c/0x55
[   52.938071]  [<c012371a>] raw_notifier_call_chain+0x17/0x1b
[   52.940605]  [<c0295984>] dev_open+0x63/0x6b
[   52.943141]  [<c02944fd>] dev_change_flags+0x50/0x104
[   52.945670]  [<c02cbcf4>] devinet_ioctl+0x259/0x57b
[   52.948191]  [<c02955b2>] dev_ifsioc+0x113/0x3a0
[   52.950698]  [<c028b127>] sock_ioctl+0x1a1/0x1c4
[   52.953185]  [<c028af86>] sock_ioctl+0x0/0x1c4
[   52.955656]  [<c0165969>] do_ioctl+0x19/0x4d
[   52.958122]  [<c0165b99>] vfs_ioctl+0x1fc/0x216
[   52.960590]  [<c0165bff>] sys_ioctl+0x4c/0x65
[   52.963058]  [<c0103b68>] syscall_call+0x7/0xb
[   52.965523]  =======================

and bisection shows that this patch is where it starts happening.

I see no way in which this patch can cause ASSERT_RTNL to start triggering. 
Could be the there are dynamic changes which are triggering some problem in
the networking tree, but the net code looks straightforward enough.

Anyway, after a few such traces things seem to settle down and there are no
apparent problems, so I guess I'll just ship it as-is.

Config is http://userweb.kernel.org/~akpm/config-sony.txt
