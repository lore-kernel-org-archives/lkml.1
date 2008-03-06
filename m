Return-Path: <linux-kernel-owner+w=401wt.eu-S935510AbYCFVhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935510AbYCFVhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbYCFVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:37:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969AbYCFVhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:37:45 -0500
Date: Thu, 6 Mar 2008 13:36:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: g.liakhovetski@gmx.de, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, bunk@kernel.org, gregkh@suse.de
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-Id: <20080306133632.34d77bbc.akpm@linux-foundation.org>
In-Reply-To: <20080306205951.GA23989@elte.hu>
References: <200803030316.07165.rjw@sisk.pl>
	<20080306072704.GA28518@elte.hu>
	<Pine.LNX.4.64.0803062054110.8669@axis700.grange>
	<20080306121127.42ac0682.akpm@linux-foundation.org>
	<20080306125153.d95db2b9.akpm@linux-foundation.org>
	<20080306205951.GA23989@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008 21:59:51 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I'd love to poke around in kgdb (what does kthread_stop_info.k point 
> > at?) but it seems that -mm's copy of kgdb got taken away when I wasn't 
> > looking. Can I have it back please?
> 
> it's in the full x86.git or you can pick up the kgdb-light tree:
> 
>   http://people.redhat.com/mingo/kgdb-light.git/README
> 

We'll see.

Meanwhile, further investigation show that cpu_callback() (the one in
kernel/softlockup.c) is waiting on this thread:

watchdog/1    R  running task        0     8      2 task_struct:ffff81025f1089e0
 ffff81025f10deb0 0000000000000046 0000000000000000 0000000000000246
 ffff81025f10de20 ffff81025f1089e0 ffff81025f1080c0 ffff81025f108d30
 000000015f10de50 00000000ffff2adf ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff80263290>] ? watchdog+0x0/0x1dc
 [<ffffffff802632d6>] watchdog+0x46/0x1dc
 [<ffffffff80263290>] ? watchdog+0x0/0x1dc
 [<ffffffff8024704d>] kthread+0x44/0x6b
 [<ffffffff8020cd88>] child_rip+0xa/0x12
 [<ffffffff80247009>] ? kthread+0x0/0x6b
 [<ffffffff8020cd7e>] ? child_rip+0x0/0x12

kthread_stop_info.k=ffff81025f1089e0

(gdb) l *0xffffffff802632d6
0xffffffff802632d6 is in watchdog (kernel/softlockup.c:229).
224              */
225             while (!kthread_should_stop()) {
226                     touch_softlockup_watchdog();
227                     schedule();
228     
229                     if (kthread_should_stop())
230                             break;
231     
232                     if (this_cpu == check_cpu) {
233                             if (sysctl_hung_task_timeout_secs)

so this watchdog thread seems to be runnable, but not running.  What would
cause this?  

The only other runnable task is

events/2      R  running task        0    29      2 task_struct:ffff81025f2da300
 ffff81025f2e3ec0 0000000000000046 0000000000000286 ffff81000102ebc0
 ffff81000102ebe0 ffff81025f2da300 ffff81025f147380 ffff81025f2da650
 000000025f2e3e60 00000000ffff3310 ffff81000102ebc8 ffff81025f20e440
Call Trace:
 [<ffffffff802442ce>] ? worker_thread+0x0/0xe5
 [<ffffffff80244371>] worker_thread+0xa3/0xe5
 [<ffffffff80247364>] ? autoremove_wake_function+0x0/0x36
 [<ffffffff802442ce>] ? worker_thread+0x0/0xe5
 [<ffffffff8024704d>] kthread+0x44/0x6b
 [<ffffffff8020cd88>] child_rip+0xa/0x12
 [<ffffffff80247009>] ? kthread+0x0/0x6b
 [<ffffffff8020cd7e>] ? child_rip+0x0/0x12

which is on a different CPU.
