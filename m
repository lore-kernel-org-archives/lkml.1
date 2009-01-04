Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZADRmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZADRmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZADRmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:42:04 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38477 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZADRmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:42:01 -0500
Date: Sun, 4 Jan 2009 23:14:50 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090104174450.GB4301@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Kernbench runs on latest Linux git tree stalled with the following
lockdep warning.

Lockdep warning and lockup on Jan 3 Linus git tree
commit 7d3b56ba37a95f1f370f50258ed3954c304c524b

kernbench run with two threads stalled.  sched_mc was zero.
x86_64 system with 8 logical CPUs in dual socket quad core
configuration.

I will post more information as I debug this warning/bug.  

--Vaidy


 kernel: =============================================
 kernel: [ INFO: possible recursive locking detected ]
 kernel: 2.6.28-autotest-sv #1
 kernel: ---------------------------------------------
 kernel: autotest/6230 is trying to acquire lock:
 kernel:  (&rq->lock){++..}, at: [<ffffffff80229240>] task_rq_lock+0x44/0x7e
 kernel:
 kernel: but task is already holding lock:
 kernel:  (&rq->lock){++..}, at: [<ffffffff805d0fd4>] schedule+0x144/0x9d6
 kernel:
 kernel: other info that might help us debug this:
 kernel: 1 lock held by autotest/6230:
 kernel:  #0:  (&rq->lock){++..}, at: [<ffffffff805d0fd4>] schedule+0x144/0x9d6
 kernel:
 kernel: stack backtrace:
 kernel: Pid: 6230, comm: autotest Not tainted 2.6.28-autotest-sv #1
 kernel: Call Trace:
 kernel:  [<ffffffff802560d8>] __lock_acquire+0xe2a/0x15ed
 kernel:  [<ffffffff80256920>] lock_acquire+0x85/0xa9
 kernel:  [<ffffffff80229240>] task_rq_lock+0x44/0x7e
 kernel:  [<ffffffff805d3f4c>] _spin_lock+0x2d/0x5f
 kernel:  [<ffffffff80229240>] task_rq_lock+0x44/0x7e
 kernel:  [<ffffffff80229240>] task_rq_lock+0x44/0x7e
 kernel:  [<ffffffff8022de2e>] try_to_wake_up+0x83/0x26f
 kernel:  [<ffffffff805d0fd4>] schedule+0x144/0x9d6
 kernel:  [<ffffffff805d13e8>] schedule+0x558/0x9d6
 kernel:  [<ffffffff802549c8>] trace_hardirqs_on_caller+0x120/0x14a
 kernel:  [<ffffffff8024a241>] hrtimer_start_range_ns+0x143/0x156
 kernel:  [<ffffffff805d2b82>] schedule_hrtimeout_range+0xcc/0xff
 kernel:  [<ffffffff80249ba0>] hrtimer_wakeup+0x0/0x22
 kernel:  [<ffffffff805d2b64>] schedule_hrtimeout_range+0xae/0xff
 kernel:  [<ffffffff802aa6e8>] do_select+0x502/0x55d
 kernel:  [<ffffffff802aa1e6>] do_select+0x0/0x55d
 kernel:  [<ffffffff802aac5f>] __pollwait+0x0/0xe5
 kernel:  [<ffffffff8022e01a>] default_wake_function+0x0/0x9
 kernel:  [<ffffffff8022e01a>] default_wake_function+0x0/0x9
 kernel:  [<ffffffff80256882>] __lock_acquire+0x15d4/0x15ed
 last message repeated 2 times
 kernel:  [<ffffffff80252913>] lock_release_holdtime+0x1b/0x16c
 kernel:  [<ffffffff80252913>] lock_release_holdtime+0x1b/0x16c
 kernel:  [<ffffffff802aa774>] core_sys_select+0x31/0x2b0
 kernel:  [<ffffffff802aa92f>] core_sys_select+0x1ec/0x2b0
 kernel:  [<ffffffff802aa774>] core_sys_select+0x31/0x2b0
 kernel:  [<ffffffff8024785b>] remove_wait_queue+0x12/0x41
 kernel:  [<ffffffff80252913>] lock_release_holdtime+0x1b/0x16c
 kernel:  [<ffffffff805d3dc9>] _spin_unlock_irqrestore+0x3e/0x44
 kernel:  [<ffffffff802549c8>] trace_hardirqs_on_caller+0x120/0x14a
 kernel:  [<ffffffff80237c6e>] do_wait+0x2a4/0x395
 kernel:  [<ffffffff8024cc09>] getnstimeofday+0x38/0x92
 kernel:  [<ffffffff802aac36>] sys_select+0x92/0xbb
 kernel:  [<ffffffff8020bedb>] system_call_fastpath+0x16/0x1b

