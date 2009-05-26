Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbZEZXyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbZEZXyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZEZXye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:54:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889AbZEZXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:33 -0400
Date: Tue, 26 May 2009 16:54:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matheus Izvekov <mizvekov@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [BUG] parport issue on 2.6.29
Message-Id: <20090526165416.9078d218.akpm@linux-foundation.org>
In-Reply-To: <20090521202655.GA13944@izvekov>
References: <20090521202655.GA13944@izvekov>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 17:26:55 -0300
Matheus Izvekov <mizvekov@gmail.com> wrote:

> This warning happens whenever a specific parallel port control app is run 
> without a device attached to it. After the first timeout, the app hangs,
> and needs SIGKILL to exit.
> 
> WARNING: at kernel/sysctl.c:2021 unregister_sysctl_table+0xa3/0x110()

I guess this is

void unregister_sysctl_table(struct ctl_table_header * header)
{
	might_sleep();

	if (header == NULL)
		return;

	spin_lock(&sysctl_lock);
	start_unregistering(header);
	if (!--header->parent->count) {
		WARN_ON(1);

> Hardware name:         
> Modules linked in:
> Pid: 12161, comm: x-killer.exe Not tainted 2.6.29.4 #14
> Call Trace:
> [<ffffffff8024c910>] warn_slowpath+0xd0/0x130
> [<ffffffff80269859>] ? sched_clock_cpu+0xb9/0x190
> [<ffffffff802484b4>] ? try_to_wake_up+0x174/0x330
> [<ffffffff80268554>] ? up+0x34/0x50
> [<ffffffff8024d1cd>] ? release_console_sem+0x1bd/0x210
> [<ffffffff80aaa4d4>] ? printk+0x67/0x69
> [<ffffffff80254ec3>] unregister_sysctl_table+0xa3/0x110
> [<ffffffff806b3128>] parport_device_proc_unregister+0x28/0x40
> [<ffffffff806b05f5>] parport_unregister_device+0x15/0x180
> [<ffffffff806a0acc>] pp_release+0xbc/0x1f0
> [<ffffffff802d3883>] __fput+0xc3/0x1e0
> [<ffffffff802d39bd>] fput+0x1d/0x30
> [<ffffffff802d0220>] filp_close+0x50/0x80
> [<ffffffff8024ec74>] put_files_struct+0x84/0xe0
> [<ffffffff8024ed1e>] exit_files+0x4e/0x60
> [<ffffffff80250696>] do_exit+0x196/0x930
> [<ffffffff80250e6e>] do_group_exit+0x3e/0xb0
> [<ffffffff8025bda4>] get_signal_to_deliver+0x2a4/0x420
> [<ffffffff8020b7aa>] do_notify_resume+0xba/0x900
> [<ffffffff8023c16e>] ? __wake_up+0x4e/0x70
> [<ffffffff8026c4a9>] ? getnstimeofday+0x59/0xe0
> [<ffffffff80267a09>] ? ktime_get_ts+0x59/0x60
> [<ffffffff80274314>] ? compat_sys_futex+0xb4/0x140
> [<ffffffff8020c8b5>] int_signal+0x12/0x17
> --[ end trace ff1bd583c825c0c5 ]---
> pdev0: unregistered pardevice

<looks for explanatory code comments, gets disappointed>

Eric, can you please help decode the reason for this kernel warning?

Thanks.
