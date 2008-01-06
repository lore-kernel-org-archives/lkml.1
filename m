Return-Path: <linux-kernel-owner+w=401wt.eu-S1758343AbYAFVSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbYAFVSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbYAFVSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:18:15 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55743 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbYAFVSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:18:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.24-rc5: 'sysctl table check failed' when turning on printer
References: <20080106150722.GA15887@elte.hu>
	<m1tzlqlmkd.fsf@ebiederm.dsl.xmission.com>
	<200801062159.20014.elendil@planet.nl>
Date: Sun, 06 Jan 2008 14:17:30 -0700
In-Reply-To: <200801062159.20014.elendil@planet.nl> (Frans Pop's message of
	"Sun, 6 Jan 2008 21:59:18 +0100")
Message-ID: <m1prwelklx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> writes:

> On Sunday 06 January 2008, Eric W. Biederman wrote:
>> Short of two programs coming in and simultaneously trying to claim
>> the parallel port and there being not exclusion in ppdev.c I don't
>> have a clue what could cause the reported error.
>
> That could well be the root cause as the full log shows:

Ok.  Looking at it there is mutual exclusion for the parallel port
after we register.

So my guess is:

Two programs open the parellel port device.
The open goes through ppdev.c
ppdev.c uses the same name for both.
parport doesn't do any mutual exclusion (except for claim).
Everything except sysctl happens inside of the claim so we
haven't seen any other bugs.

So if my guess is right we need to move the register_sysctl_table
call into the claim logic.  And the unregister_syctl_table
call into the unclaim logic.

I've got to run.

Later,
Eric



> Jan  6 01:21:02 faramir kernel: ppdev0: registered pardevice
> Jan 6 01:21:03 faramir kernel: sysctl table check failed:
> /dev/parport/parport0/devices/ppdev0/timeslice Sysctl already exists
> Jan 6 01:21:03 faramir kernel: Pid: 11078, comm: hpijs Not tainted 2.6.24-rc6 #1
> Jan  6 01:21:03 faramir kernel:
> Jan  6 01:21:03 faramir kernel: Call Trace:
> Jan  6 01:21:03 faramir kernel:  [<ffffffff8024c104>] set_fail+0x3f/0x47
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c5ba>]
> sysctl_check_table+0x4ae/0x4fb
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c0b6>]
> sysctl_check_lookup+0xc1/0xd0
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c5d0>]
> sysctl_check_table+0x4c4/0x4fb
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c0b6>]
> sysctl_check_lookup+0xc1/0xd0
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c5d0>]
> sysctl_check_table+0x4c4/0x4fb
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c0b6>]
> sysctl_check_lookup+0xc1/0xd0
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c5d0>]
> sysctl_check_table+0x4c4/0x4fb
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c0b6>]
> sysctl_check_lookup+0xc1/0xd0
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c5d0>]
> sysctl_check_table+0x4c4/0x4fb
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c0b6>]
> sysctl_check_lookup+0xc1/0xd0
> Jan 6 01:21:03 faramir kernel: [<ffffffff8024c5d0>]
> sysctl_check_table+0x4c4/0x4fb
> Jan 6 01:21:03 faramir kernel: [<ffffffff8023ca8d>]
> register_sysctl_table+0x52/0x9d
> Jan 6 01:21:03 faramir kernel: [<ffffffff881ea7cb>]
> :parport:parport_device_proc_register+0xc3/0xe3
> Jan 6 01:21:03 faramir kernel: [<ffffffff881e8da7>]
> :parport:parport_register_device+0x206/0x267
> Jan  6 01:21:03 faramir kernel:  [<ffffffff884151ae>] :ppdev:pp_irq+0x0/0x40
> Jan 6 01:21:03 faramir kernel: [<ffffffff8841574f>] :ppdev:pp_ioctl+0x13f/0x77c
> Jan  6 01:21:03 faramir kernel:  [<ffffffff80296a55>] do_ioctl+0x55/0x6b
> Jan  6 01:21:03 faramir kernel:  [<ffffffff80296cae>] vfs_ioctl+0x243/0x25c
> Jan  6 01:21:03 faramir kernel:  [<ffffffff80296d18>] sys_ioctl+0x51/0x71
> Jan  6 01:21:03 faramir kernel:  [<ffffffff8020beee>] system_call+0x7e/0x83
> Jan  6 01:21:03 faramir kernel:
> Jan  6 01:21:03 faramir kernel: ppdev0: registered pardevice
> Jan 6 01:22:10 faramir kernel: ppdev0: released pardevice because user-space
> forgot
> Jan  6 01:22:10 faramir kernel: ppdev0: unregistered pardevice
> Jan  6 01:22:11 faramir kernel: ppdev0: unregistered pardevice
> Jan  6 03:24:57 faramir kernel: fuse exit
>
> Sorry for not providing that info earlier, but the first time I had this
> issue I had two print jobs after eachother and because of that I overlooked
> the double registering.
>
> I am printing through CUPS on a fairly standard Debian unstable system
> running the KDE desktop.
