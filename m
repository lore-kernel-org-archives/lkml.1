Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYG3KLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYG3KLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYG3KLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:11:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbYG3KL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:11:29 -0400
Date: Wed, 30 Jul 2008 03:10:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [BUG] wireless : cpu stuck for 61s
Message-Id: <20080730031047.54e13e2d.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
References: <20080729055731.GA3265@darkstar>
	<1217334724.10489.47.camel@johannes.berg>
	<20080730020820.8bcc00e2.akpm@linux-foundation.org>
	<a8e1da0807300302m35a0a7c0q2ff2e0ab92a69239@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 18:02:03 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> On Wed, Jul 30, 2008 at 5:08 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 29 Jul 2008 14:32:04 +0200 Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> >> On Tue, 2008-07-29 at 13:57 +0800, Dave Young wrote:
> >> > While set my wlan0 to ad-hoc mode and then set the essid to something,
> >> > this bug triggered.
> >> >
> >> > I suspect it's related to debugfs or mutex? But I'm not sure.
> >> >
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] BUG: soft lockup - CPU#0 stuck for 61s! [events/0:9]
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493]
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] Pid: 9, comm: events/0 Tainted: G        W (2.6.26-smp #3)
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP: 0060:[<c0450bc3>] EFLAGS: 00000246 CPU: 0
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP is at mutex_lock_nested+0x1b3/0x280
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EAX: 00000000 EBX: f7bf5284 ECX: f7c7e000 EDX: f7bf52a8
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] ESI: f7bf5288 EDI: 00000246 EBP: f7c7fedc ESP: f7c7fe9c
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] CR0: 8005003b CR2: b800c5ac CR3: 36e71000 CR4: 000006d0
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR6: ffff0ff0 DR7: 00000400
> >> > Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c02375a6>] ? debugfs_create_file+0x46/0x210
> >>
> >> It looks like it's getting stuck on
> >> mutex_lock(&parent->d_inode->i_mutex);
> >>
> >> inside debugfs_create_by_name, but I have no idea why that would happen.
> >>
> >
> > Dave, please try sysrq-W or sysrq-T during that 60 seconds, see if we
> > can find another task which is holding onto that lock.
> >
> >
> 
> Andrew, the keyboard doesn't response after the bug triggered.
> 
> So I just keep sysrq-W / sysrq-T every several seconds after I set the
> wlan0 interface.
> Attached please see the long log file.

argh.  Look:

Jul 30 17:34:22 darkstar kernel: [  145.111510]        f703fbf8 00000082 00000002 f703fbe4 f703fbd8 00000000 f704ac40 f703fbcc 
Jul 30 17:34:22 darkstar kernel: [  145.111510]        00000046 c0669060 c066c580 c066c580 c066c580 f703fbe8 f704ad94 c1eaf580 
Jul 30 17:34:22 darkstar kernel: [  145.111510]        00000001 f704ac40 00000000 f702ca00 c0452697 ffff55ba 00000000 c014b06d 
Jul 30 17:34:22 darkstar kernel: [  145.111510] Call Trace:
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0452697>] ? _spin_unlock_irqrestore+0x47/0x60
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c014b06d>] ? trace_hardirqs_on+0xbd/0x140
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0450265>] schedule_timeout+0x75/0xc0
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c01942c0>] ? __pollwait+0x60/0xd0
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<f888b02e>] ? evdev_poll+0x2e/0x60 [evdev]
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0193564>] do_sys_poll+0x264/0x3a0
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0194260>] ? __pollwait+0x0/0xd0
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0122160>] ? default_wake_function+0x0/0x10
Jul 30 17:34:22 darkstar last message repeated 3 times
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c01220c5>] ? try_to_wake_up+0x75/0x110
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c014aed0>] ? mark_held_locks+0x40/0x80
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c014b77b>] ? __lock_acquire+0x24b/0x1040
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c014b77b>] ? __lock_acquire+0x24b/0x1040
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c03da639>] ? sock_def_readable+0x59/0x80
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c014b77b>] ? __lock_acquire+0x24b/0x1040
Jul 30 17:34:22 darkstar last message repeated 5 times
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0109d0f>] ? native_sched_clock+0x7f/0xb0
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0243b4f>] ? security_file_permission+0xf/0x20
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0186387>] ? rw_verify_area+0x57/0xc0
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0451f5d>] ? _spin_unlock+0x1d/0x20
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0186b94>] ? vfs_read+0x94/0x130
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<f888be60>] ? evdev_read+0x0/0x1b0 [evdev]
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0103dbf>] ? restore_nocheck+0x12/0x15
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c01936cd>] sys_poll+0x2d/0x70
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0103d5e>] syscall_call+0x7/0xb
Jul 30 17:34:22 darkstar kernel: [  145.111510]  =======================
Jul 30 17:34:22 darkstar kernel: [  145.111510]        f63efd94 00000092 00000002 00000000 00000000 f5064028 f7049d80 00000001 
Jul 30 17:34:22 darkstar kernel: [  145.111510]        00000000 c0669060 c066c580 c066c580 c066c580 00000000 f7049ed4 c1e5d580 
Jul 30 17:34:22 darkstar kernel: [  145.111510]        00000000 00000000 00000135 f702e080 f7049d80 00000003 00000000 f7049d80 
Jul 30 17:34:22 darkstar kernel: [  145.111510] Call Trace:
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0450265>] schedule_timeout+0x75/0xc0
Jul 30 17:34:22 darkstar kernel: [  145.111510]  [<c0436b98>] unix_stream_recvmsg+0x2a8/0x4e0


We're missing part of the sysrq traces.  I noticed this a while back. 
We need this info to find the D-state processes.

It's _possible_ that the kernel is actually trying to print this info,
but it's doing it at a different prink facility level from the stack
output, so we're only seeing part of the printing.

Please try changing your logging level (dmesg -n 0, or dmesg -n 7 - I
always forget which).  Then retry the sysrq-T.  If that successfully
causes _all_ the output to be presented, then please rerun the above
test.

You might want to compress the file too - I don't know whether the vger
servers will accept a 730kB mail.

