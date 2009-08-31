Return-Path: <linux-kernel-owner+w=401wt.eu-S1751273AbZHaJrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbZHaJrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 05:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZHaJrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 05:47:12 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63143 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZHaJrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 05:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=W9rCgYpPYQmo8JewH/hgnGnEDRkvtIluL4MSldF1KI+7IsjUS+XesuXOQEebsgsBQO
         3uFJAg52F1lW53tohxhNYNAXgx+sGvy9r8zhAUID1IIM56uA+XLryhImm+GHBR+mIENB
         pvLnWvAD13EXaQqTqfLXk9T8lYxaz80VQqPts=
Message-ID: <4A9B9C1C.9020506@gmail.com>
Date: Mon, 31 Aug 2009 11:47:08 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: suspend race -next regression [Was: Power: fix suspend vt regression]
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com> <20090811170050.GA26041@suse.de> <4A81E073.5080703@gmail.com>
In-Reply-To: <4A81E073.5080703@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 11:19 PM, Jiri Slaby wrote:
> However there is still a race or something. Sometimes the suspend goes
> through, sometimes it doesn't. I will investigate this further.

Hmm, this took a loong time to track down a bit. Code instrumentation by
outb(XX, 0x80) usually caused the issue to disappear.

However I found out that it's caused by might_sleep() calls in
flush_workqueue() and flush_cpu_workqueue(). I.e. it looks like there is
a task which deadlocks/spins forever. If we won't reschedule to it,
suspend proceeds.

I replaced the latter might_sleep() by show_state() and removed
refrigerated tasks afterwards. The thing is that I don't know if the
prank task is there. I need a scheduler to store "next" task pid or
whatever to see what it picked as "next" and so what will run due to
might_sched(). I can then show it on port 80 display and read it when
the hangup occurs.

Depending on which might_sleep(), either flush_workqueue() never (well,
at least in next 5 minutes) proceeds to for_each_cpu() or
wait_for_completion() in flush_cpu_workqueue() never returns.

It's a regression against some -rc1 based -next tree. Bisection
impossible, suspend needs to be run even 7 times before it occurs. Maybe
a s/might_sleep/yield/ could make it happen earlier (going to try)?

Attaching the filtered show_task() output:
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Suspending console(s) (use no_console_suspend to debug)
sd 1:0:0:0: [sdb] Synchronizing SCSI cache
sd 1:0:0:0: [sdb] Stopping disk
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
parport_pc 00:08: disabled
serial 00:06: disabled
ath5k 0000:04:00.0: PCI INT A disabled
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PCI INT A disabled
uhci_hcd 0000:00:1d.2: PCI INT D disabled
uhci_hcd 0000:00:1d.1: PCI INT B disabled
uhci_hcd 0000:00:1d.0: PCI INT A disabled
HDA Intel 0000:00:1b.0: PCI INT A disabled
ehci_hcd 0000:00:1a.7: PCI INT D disabled
uhci_hcd 0000:00:1a.2: PCI INT C disabled
uhci_hcd 0000:00:1a.1: PCI INT B disabled
uhci_hcd 0000:00:1a.0: PCI INT A disabled
e1000e 0000:00:19.0: PCI INT A disabled
e1000e 0000:00:19.0: PME# enabled
e1000e 0000:00:19.0: wake-up capability enabled by ACPI
ACPI handle has no context!
ehci_hcd 0000:00:1d.7: PME# disabled
ehci_hcd 0000:00:1a.7: PME# disabled
ACPI: Preparing to enter system sleep state S3
Disabling non-boot CPUs ...
  task                        PC stack   pid father
init          D ffff8801cb8ffb60     0     1      0 0x00000000
 ffff8801cb86fd88 0000000000000086 00000001cb86fd88 ffff8801cb854000
 ffff8801cb854000 0000000000000ba2 ffff8801cb86fd28 00000000ffff36c7
 ffff8801cb8542a8 000000000000df68 00000000000118c0 ffff8801cb8542a8
Call Trace:
 [<ffffffff8105d5fd>] refrigerator+0xad/0x100
 [<ffffffff8104eb64>] get_signal_to_deliver+0x84/0x380
 [<ffffffff8100b36c>] do_notify_resume+0xbc/0x7c0
 [<ffffffff8105ebe9>] ? ktime_get_ts+0xa9/0xe0
 [<ffffffff810d2c18>] ? poll_select_copy_remaining+0xf8/0x150
 [<ffffffff810d44d4>] ? sys_select+0x54/0x110
 [<ffffffff8100bfc5>] sysret_signal+0x6d/0xb7
kthreadd      S 0000000000000001     0     2      0 0x00000000
 ffff8801cb871f00 0000000000000046 ffff8801cb871f40 ffffffff8100ce32
 0000000000000001 ffff8801cb8546b0 ffff8801cb8546b0 ffff8801c5dddcc0
 ffff8801cb854958 000000000000df68 00000000000118c0 ffff8801cb854958
Call Trace:
 [<ffffffff8100ce32>] ? kernel_thread+0x82/0xe0
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff810562a5>] kthreadd+0x115/0x120
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff81056190>] ? kthreadd+0x0/0x120
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
migration/0   S 0000000000000000     0     3      2 0x00000000
 ffff8801cb875e70 0000000000000046 ffff8800282918c0 0000000000000001
 ffff8801cb875df0 ffffffff81036bdd ffff8801c5fef730 00000000ffff367a
 ffff8801cb8592e8 000000000000df68 00000000000118c0 ffff8801cb8592e8
Call Trace:
 [<ffffffff81036bdd>] ? enqueue_task_fair+0x3d/0x80
 [<ffffffff8103bafe>] migration_thread+0x1ae/0x2c0
 [<ffffffff8103b950>] ? migration_thread+0x0/0x2c0
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
ksoftirqd/0   S ffff8801cb8596f0     0     4      2 0x00000000
 ffff8801cb877ea0 0000000000000046 0000000000000000 00000000000118c0
 0000000000000000 ffffffff81595920 0000000000000000 00000000ffff35ed
 ffff8801cb859998 000000000000df68 00000000000118c0 ffff8801cb859998
Call Trace:
 [<ffffffff8103760d>] ? default_wake_function+0xd/0x10
 [<ffffffff810450b5>] ksoftirqd+0xc5/0x100
 [<ffffffff81044ff0>] ? ksoftirqd+0x0/0x100
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
watchdog/0    S 0000000000000001     0     5      2 0x00000000
 ffff8801cb879eb0 0000000000000046 ffff8801cb879e20 ffffffff810687c3
 ffff8801cb85a080 ffff8800282118c0 ffff8801cb879ea0 ffffffff81037f5f
 ffff8801cb85a328 000000000000df68 00000000000118c0 ffff8801cb85a328
Call Trace:
 [<ffffffff810687c3>] ? rt_mutex_adjust_pi+0x73/0x80
 [<ffffffff81037f5f>] ? __sched_setscheduler+0x19f/0x420
 [<ffffffff81080a20>] ? watchdog+0x0/0x90
 [<ffffffff81080a20>] ? watchdog+0x0/0x90
 [<ffffffff81080a72>] watchdog+0x52/0x90
 [<ffffffff81080a20>] ? watchdog+0x0/0x90
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
migration/1   S 0000000000000001     0     6      2 0x00000000
 ffff8801cb87de70 0000000000000046 ffff8800282118c0 0000000000000000
 ffff8801cb87ddf0 ffffffff81036bdd ffff8801c9080200 00000000ffff367a
 ffff8801cb85a9d8 000000000000df68 00000000000118c0 ffff8801cb85a9d8
Call Trace:
 [<ffffffff81036bdd>] ? enqueue_task_fair+0x3d/0x80
 [<ffffffff8103bafe>] migration_thread+0x1ae/0x2c0
 [<ffffffff8103b950>] ? migration_thread+0x0/0x2c0
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
ksoftirqd/1   S ffff8801cb8600c0     0     7      2 0x00000000
 ffff8801cb87fea0 0000000000000046 ffff8801cb860368 000000000000df68
 00000000000118c0 ffff8801cb860370 ffff8801cb9197f0 00000000ffff35bf
 ffff8801cb860368 000000000000df68 00000000000118c0 ffff8801cb860368
Call Trace:
 [<ffffffff810450b5>] ksoftirqd+0xc5/0x100
 [<ffffffff81044ff0>] ? ksoftirqd+0x0/0x100
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
watchdog/1    S 0000000000000001     0     8      2 0x00000000
 ffff8801cb885eb0 0000000000000046 ffff8801cb885e20 ffffffff810687c3
 ffff8801cb860770 ffff8800282918c0 ffff8801cb885ea0 00000000fffedc26
 ffff8801cb860a18 000000000000df68 00000000000118c0 ffff8801cb860a18
Call Trace:
 [<ffffffff810687c3>] ? rt_mutex_adjust_pi+0x73/0x80
 [<ffffffff81080a20>] ? watchdog+0x0/0x90
 [<ffffffff81080a20>] ? watchdog+0x0/0x90
 [<ffffffff81080a72>] watchdog+0x52/0x90
 [<ffffffff81080a20>] ? watchdog+0x0/0x90
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
events/0      S ffff8801cb8617b0     0     9      2 0x00000000
 ffff8801cb88be60 0000000000000046 ffff8801cb88be10 ffffffff8128fcf5
 ffffffff81595ef8 ffff8800282142c8 ffff8801cb88bde0 00000000ffff36e5
 ffff8801cb861a58 000000000000df68 00000000000118c0 ffff8801cb861a58
Call Trace:
 [<ffffffff8128fcf5>] ? e1000_watchdog_task+0x185/0x6e0
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
events/1      S ffff8801cb864140     0    10      2 0x00000000
 ffff8801cb88de60 0000000000000046 ffff8801cb88ddb0 ffff8801cb88ddb0
 ffff8801cb88de00 ffff8800282942c0 ffffffff8136fd80 00000000ffff37ee
 ffff8801cb8643e8 000000000000df68 00000000000118c0 ffff8801cb8643e8
Call Trace:
 [<ffffffff8136fd80>] ? linkwatch_event+0x0/0x30
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
cpuset        S ffff8801cb8647f0     0    11      2 0x00000000
 ffff8801cb891e60 0000000000000046 ffff8801cb891de0 ffffffff81036826
 0000000000000000 ffff8801cb8647f0 ffff8800282918c0 00000000fffedb2d
 ffff8801cb864a98 000000000000df68 00000000000118c0 ffff8801cb864a98
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
khelper       S ffff8801cb865180     0    12      2 0x00000000
 ffff8801cb893e60 0000000000000046 0000000000000611 ffff8801c9ae4000
 ffffffff810518c0 0000000000000000 ffffffff8100ce90 00000000ffff35bf
 ffff8801cb865428 000000000000df68 00000000000118c0 ffff8801cb865428
Call Trace:
 [<ffffffff810518c0>] ? wait_for_helper+0x0/0x80
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
netns         S ffff8801cb865830     0    15      2 0x00000000
 ffff8801cb8b9e60 0000000000000046 ffff8801cb8b9de0 ffffffff81036826
 0000000000000000 ffff8801cb865830 ffff8800282918c0 00000000fffedb2d
 ffff8801cb865ad8 000000000000df68 00000000000118c0 ffff8801cb865ad8
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
async/mgr     S ffff8801cb8e3e80     0    19      2 0x00000000
 ffff8801cb8e3e70 0000000000000046 ffff8801cb8e3de0 ffffffff81032332
 0000000000000001 ffff8800282918c0 ffff8801cb8e3e00 ffffffff810323a8
 ffff8801cb8c2468 000000000000df68 00000000000118c0 ffff8801cb8c2468
Call Trace:
 [<ffffffff81032332>] ? enqueue_task+0x32/0x80
 [<ffffffff810323a8>] ? activate_task+0x28/0x40
 [<ffffffff8105c6e5>] async_manager_thread+0x65/0x100
 [<ffffffff81037600>] ? default_wake_function+0x0/0x10
 [<ffffffff8105c680>] ? async_manager_thread+0x0/0x100
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
pm            D ffff8801cb8c2870     0    20      2 0x00000000
 ffff8801cb8e5e30 0000000000000046 0000000000000000 ffff8801c9044080
 0000000000000000 0000000000000000 ffff8801cb8e5e60 ffffffff8142dc98
 ffff8801cb8c2b18 000000000000df68 00000000000118c0 ffff8801cb8c2b18
Call Trace:
 [<ffffffff8142dc98>] ? thread_return+0x3e/0x726
 [<ffffffff8105d5fd>] refrigerator+0xad/0x100
 [<ffffffff81051da5>] worker_thread+0xf5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kblockd/0     S ffff8801cb8df200     0   159      2 0x00000000
 ffff8801cba77e60 0000000000000046 ffff8801ca5114c8 ffff880028214688
 ffff8801cba77fd8 ffff8801cb8df200 ffff8801cba77df0 00000000ffff362d
 ffff8801cb8df4a8 000000000000df68 00000000000118c0 ffff8801cb8df4a8
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kblockd/1     S ffff8801cb8df8b0     0   160      2 0x00000000
 ffff8801cba7be60 0000000000000046 ffff8801ca4544c8 ffff880028294688
 ffff8801cba7bfd8 ffff8801cb8df8b0 ffff8801cba7bdf0 00000000ffff362a
 ffff8801cb8dfb58 000000000000df68 00000000000118c0 ffff8801cb8dfb58
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kacpid        S ffff8801cba7e240     0   162      2 0x00000000
 ffff8801cba9de60 0000000000000046 ffff8801cba9ddb0 ffff8801cba9ddb0
 0000000000000000 0000000000000286 ffff8801cba9ddf0 0000000000000202
 ffff8801cba7e4e8 000000000000df68 00000000000118c0 ffff8801cba7e4e8
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kacpi_notify  S ffff8801cba7e8f0     0   163      2 0x00000000
 ffff8801cba9fe60 0000000000000046 ffff8801cba9fde0 ffffffff81036826
 ffff8801cb854048 0000000000000286 ffff8801cba9fdf0 0000000000000202
 ffff8801cba7eb98 000000000000df68 00000000000118c0 ffff8801cba7eb98
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kacpi_hotplug S ffff8801cba7f280     0   164      2 0x00000000
 ffff8801cbaa3e60 0000000000000046 ffff8801cbaa3db0 ffff8801cbaa3db0
 0000000000000000 0000000000000286 ffff8801cbaa3df0 0000000000000202
 ffff8801cba7f528 000000000000df68 00000000000118c0 ffff8801cba7f528
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
ata/0         S ffff8801cba7f930     0   246      2 0x00000000
 ffff8801cb8e7e60 0000000000000046 ffff8801cb8e7de0 ffffffff81036826
 0000000000000000 ffff8801cba7f930 ffff8800282118c0 ffffffff81595920
 ffff8801cba7fbd8 000000000000df68 00000000000118c0 ffff8801cba7fbd8
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
ata/1         S ffff8801cb970000     0   247      2 0x00000000
 ffff8801cb8c1e60 0000000000000046 ffff8801cb8c1de0 ffffffff81036826
 ffff8801cb8c1df0 ffff8801cb970000 ffff8800282918c0 00000000fffedb2d
 ffff8801cb9702a8 000000000000df68 00000000000118c0 ffff8801cb9702a8
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
ata_aux       S ffff8801cb9706b0     0   248      2 0x00000000
 ffff8801cb907e60 0000000000000046 ffff8801cb907de0 ffffffff81036826
 0000000000000000 ffff8801cb9706b0 ffff8800282918c0 00000000fffedb2d
 ffff8801cb970958 000000000000df68 00000000000118c0 ffff8801cb970958
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
<removed refrigerated tasks>
aio/0         S ffff8801cba521c0     0   333      2 0x00000000
 ffff8801cb9e1e60 0000000000000046 ffff8801cb9e1de0 ffffffff81036826
 0000000000000000 ffff8801cba521c0 ffff8800282118c0 ffffffff81595920
 ffff8801cba52468 000000000000df68 00000000000118c0 ffff8801cba52468
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
aio/1         S ffff8801cb9f4180     0   334      2 0x00000000
 ffff8801cb911e60 0000000000000046 ffff8801cb911de0 ffffffff81036826
 ffff8801cb911df0 ffff8801cb9f4180 ffff8800282918c0 00000000fffedb2d
 ffff8801cb9f4428 000000000000df68 00000000000118c0 ffff8801cb9f4428
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
crypto/0      S ffff8801cb9f4830     0   336      2 0x00000000
 ffff8801cb937e60 0000000000000046 ffff8801cb937de0 ffffffff81036826
 0000000000000000 ffff8801cb9f4830 ffff8800282118c0 ffffffff81595920
 ffff8801cb9f4ad8 000000000000df68 00000000000118c0 ffff8801cb9f4ad8
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
crypto/1      S ffff8801cb9f51c0     0   337      2 0x00000000
 ffff8801cbb47e60 0000000000000046 ffff8801cbb47de0 ffffffff81036826
 ffff8801cbb47df0 ffff8801cb9f51c0 ffff8800282918c0 00000000fffedb2d
 ffff8801cb9f5468 000000000000df68 00000000000118c0 ffff8801cb9f5468
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
i915/0        S ffff8801cb9f5870     0   437      2 0x00000000
 ffff8801cab79e60 0000000000000046 ffff8801cab79de0 ffff8801cb9bc820
 ffff8801cbb77e68 ffff8801cb9bc800 ffff8801cbb77000 00000000ffff310a
 ffff8801cb9f5b18 000000000000df68 00000000000118c0 ffff8801cb9f5b18
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
i915/1        S ffff8801cb974730     0   438      2 0x00000000
 ffff8801cab7be60 0000000000000046 ffff8801cab7bde0 ffff8801cb9bc820
 ffff8801cbb77e68 ffff8801cb9bc800 ffff8801cbb77000 00000000ffff2f47
 ffff8801cb9749d8 000000000000df68 00000000000118c0 ffff8801cb9749d8
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
scsi_eh_0     S ffff8801cb301ea0     0   482      2 0x00000000
 ffff8801cb301e50 0000000000000046 ffff8801cb301dc0 ffffffff8116b067
 ffff8801cab6c800 0000000000000000 ffff8801cb301dd0 ffffffff8123af02
 ffff8801cb9204a8 000000000000df68 00000000000118c0 ffff8801cb9204a8
Call Trace:
 [<ffffffff8116b067>] ? kobject_put+0x27/0x60
 [<ffffffff8123af02>] ? put_device+0x12/0x20
 [<ffffffff8125584e>] scsi_error_handler+0x7e/0x430
 [<ffffffff812557d0>] ? scsi_error_handler+0x0/0x430
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
scsi_eh_1     S ffff8801cbbc7ea0     0   485      2 0x00000000
 ffff8801cbbc7e50 0000000000000046 ffff8801cbbc7dc0 ffffffff8116b067
 ffff8801cbbd1000 0000000000000000 ffff8801cbbc7dd0 ffffffff8123af02
 ffff8801cb91e468 000000000000df68 00000000000118c0 ffff8801cb91e468
Call Trace:
 [<ffffffff8116b067>] ? kobject_put+0x27/0x60
 [<ffffffff8123af02>] ? put_device+0x12/0x20
 [<ffffffff8125584e>] scsi_error_handler+0x7e/0x430
 [<ffffffff812557d0>] ? scsi_error_handler+0x0/0x430
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
scsi_eh_2     S ffff8801cb313ea0     0   488      2 0x00000000
 ffff8801cb313e50 0000000000000046 ffff8801cb313de0 ffffffff81032cfe
 ffff8801cb313de0 0000000000000282 ffff8801cb31c000 00000000ffff36e5
 ffff8801cb91c428 000000000000df68 00000000000118c0 ffff8801cb91c428
Call Trace:
 [<ffffffff81032cfe>] ? __wake_up+0x4e/0x70
 [<ffffffff8125584e>] scsi_error_handler+0x7e/0x430
 [<ffffffff812557d0>] ? scsi_error_handler+0x0/0x430
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
scsi_eh_3     S ffff8801cbbc3ea0     0   491      2 0x00000000
 ffff8801cbbc3e50 0000000000000046 ffff8801cbbc3dc0 ffffffff8116b067
 ffff8801cbbd4000 0000000000000000 ffff8801cbbc3dd0 00000000ffff36e5
 ffff8801cb9193e8 000000000000df68 00000000000118c0 ffff8801cb9193e8
Call Trace:
 [<ffffffff8116b067>] ? kobject_put+0x27/0x60
 [<ffffffff8125584e>] scsi_error_handler+0x7e/0x430
 [<ffffffff812557d0>] ? scsi_error_handler+0x0/0x430
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
scsi_eh_4     S ffff8801cb309ea0     0   494      2 0x00000000
 ffff8801cb309e50 0000000000000046 ffff8801cb309de0 ffffffff81032cfe
 ffff8801cb309de0 0000000000000282 ffff8801cbb84000 0000000000000000
 ffff8801cb8e13a8 000000000000df68 00000000000118c0 ffff8801cb8e13a8
Call Trace:
 [<ffffffff81032cfe>] ? __wake_up+0x4e/0x70
 [<ffffffff8125584e>] scsi_error_handler+0x7e/0x430
 [<ffffffff812557d0>] ? scsi_error_handler+0x0/0x430
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
scsi_eh_5     S ffff8801cb30fea0     0   497      2 0x00000000
 ffff8801cb30fe50 0000000000000046 ffff8801cb30fde0 ffffffff81032cfe
 ffff8801cb30fde0 0000000000000282 ffff8801cbb88000 0000000000000000
 ffff8801cb8b1368 000000000000df68 00000000000118c0 ffff8801cb8b1368
Call Trace:
 [<ffffffff81032cfe>] ? __wake_up+0x4e/0x70
 [<ffffffff8125584e>] scsi_error_handler+0x7e/0x430
 [<ffffffff812557d0>] ? scsi_error_handler+0x0/0x430
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kstriped      S ffff8801cb92d140     0   562      2 0x00000000
 ffff8801ca4a5e60 0000000000000046 ffff8801ca4a5de0 ffffffff81036826
 ffff8801cb854048 ffff880028291800 ffff8800282918c0 00000000fffedb2d
 ffff8801cb92d3e8 000000000000df68 00000000000118c0 ffff8801cb92d3e8
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
usbhid_resume D ffff8801ca45a140     0   591      2 0x00000000
 ffff8801ca4fbe30 0000000000000046 0000000000000000 ffff8801ca74e400
 ffff8801ca59a280 0000000000000000 ffff8801ca4fbe60 ffffffff8142dc98
 ffff8801ca45a3e8 000000000000df68 00000000000118c0 ffff8801ca45a3e8
Call Trace:
 [<ffffffff8142dc98>] ? thread_return+0x3e/0x726
 [<ffffffff8105d5fd>] refrigerator+0xad/0x100
 [<ffffffff81051da5>] worker_thread+0xf5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
hd-audio0     S ffff8801ca4c5240     0   601      2 0x00000000
 ffff8801ca509e60 0000000000000046 ffff8801ca509de0 ffffffff81036826
 ffff8801cb854048 ffff880028291800 ffff8800282918c0 00000000fffedb2d
 ffff8801ca4c54e8 000000000000df68 00000000000118c0 ffff8801ca4c54e8
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
md3_raid1     S ffff8801ca59fe80     0   656      2 0x00000000
 ffff8801ca59fdb0 0000000000000046 ffff8801ca59fd20 ffffffff812e2743
 ffff8801ca4c7aa0 0000000000000246 ffff8801ca59fe50 00000000ffff0f39
 ffff8801cb989b18 000000000000df68 00000000000118c0 ffff8801cb989b18
Call Trace:
 [<ffffffff812e2743>] ? flush_pending_writes+0x13/0x90
 [<ffffffff8142e8d5>] schedule_timeout+0x1c5/0x230
 [<ffffffff812e286a>] ? raid1d+0xa/0x10d0
 [<ffffffff812eaaea>] md_thread+0xea/0x130
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff812eaa00>] ? md_thread+0x0/0x130
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kjournald     S ffff8801ca582898     0   668      2 0x00000000
 ffff8801ca57de60 0000000000000046 ffff8801ca588000 ffff8801ca582968
 ffff880100000000 00000001ca582888 ffff880100000fdc 00000000ffff367a
 ffff8801cb981328 000000000000df68 00000000000118c0 ffff8801cb981328
Call Trace:
 [<ffffffff8113b24d>] kjournald+0x20d/0x230
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8113b040>] ? kjournald+0x0/0x230
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
<removed refrigerated tasks>
phy0          S ffff8801c93860c0     0  1010      2 0x00000000
 ffff8801ca643e60 0000000000000046 ffff8801ca643de0 ffffffff81036826
 0000000000000001 ffff8801c93860c0 ffff8800282118c0 00000000fffee0bd
 ffff8801c9386368 000000000000df68 00000000000118c0 ffff8801c9386368
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kdmflush      S ffff8801c88660c0     0  1251      2 0x00000000
 ffff8801c8825e60 0000000000000046 0000000000000000 ffff8801ca6a4cc8
 ffff8801c8825fd8 ffff8801c88660c0 ffff8801c8825de0 00000000fffee367
 ffff8801c8866368 000000000000df68 00000000000118c0 ffff8801c8866368
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kdmflush      S ffff8801ca5d36b0     0  1256      2 0x00000000
 ffff8801c8b49e60 0000000000000046 0000000000000000 ffff8801ca6eb0c8
 ffff8801c8b49fd8 ffff8801ca5d36b0 ffff8801c8b49de0 00000000fffee367
 ffff8801ca5d3958 000000000000df68 00000000000118c0 ffff8801ca5d3958
Call Trace:
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kdmflush      S ffff8801c8ba0140     0  1262      2 0x00000000
 ffff8801c92d3e60 0000000000000046 0000000000000000 ffff8801cb329cc8
 ffff8801c92d3fd8 ffff8801c8ba0140 ffff8801c92d3de0 ffffffff8105a599
 ffff8801c8ba03e8 000000000000df68 00000000000118c0 ffff8801c8ba03e8
Call Trace:
 [<ffffffff8105a599>] ? up_write+0x9/0x10
 [<ffffffff81051c3f>] ? run_workqueue+0xcf/0x140
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kjournald     S ffff8801cb329498     0  1310      2 0x00000000
 ffff8801c9347e60 0000000000000046 ffff8801c9347dd0 ffffffff810566d1
 ffff8801c893f738 ffff8801cb329488 ffff8801c9347e20 ffff8801cb329400
 ffff8801c9386a18 000000000000df68 00000000000118c0 ffff8801c9386a18
Call Trace:
 [<ffffffff810566d1>] ? autoremove_wake_function+0x11/0x40
 [<ffffffff8113b24d>] kjournald+0x20d/0x230
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8113b040>] ? kjournald+0x0/0x230
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kjournald     S ffff8801ca5c7c98     0  1311      2 0x00000000
 ffff8801c88bfe60 0000000000000046 ffff8801c88bfdd0 ffffffff810566d1
 0000000000000000 ffff8801ca5c7c88 ffff8801c88bfe20 ffff8801ca5c7c00
 ffff8801ca72f3a8 000000000000df68 00000000000118c0 ffff8801ca72f3a8
Call Trace:
 [<ffffffff810566d1>] ? autoremove_wake_function+0x11/0x40
 [<ffffffff8113b24d>] kjournald+0x20d/0x230
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8113b040>] ? kjournald+0x0/0x230
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kjournald     S ffff8801ca6f7498     0  1312      2 0x00000000
 ffff8801c887fe60 0000000000000046 ffff8801c887fdd0 ffffffff810566d1
 ffff8801c893f738 ffff8801ca6f7488 ffff8801c887fe20 ffff8801ca6f7400
 ffff8801ca6d54e8 000000000000df68 00000000000118c0 ffff8801ca6d54e8
Call Trace:
 [<ffffffff810566d1>] ? autoremove_wake_function+0x11/0x40
 [<ffffffff8113b24d>] kjournald+0x20d/0x230
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8113b040>] ? kjournald+0x0/0x230
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kjournald     S ffff8801ca78c898     0  1313      2 0x00000000
 ffff8801c88c3e60 0000000000000046 ffff8801c88c3dd0 ffffffff810566d1
 0000000000000000 ffff8801ca78c888 ffff8801c88c3e20 00000000fffee41f
 ffff8801c893f2e8 000000000000df68 00000000000118c0 ffff8801c893f2e8
Call Trace:
 [<ffffffff810566d1>] ? autoremove_wake_function+0x11/0x40
 [<ffffffff8113b24d>] kjournald+0x20d/0x230
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8113b040>] ? kjournald+0x0/0x230
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kjournald     S ffff8801ca78d898     0  1314      2 0x00000000
 ffff8801c8843e60 0000000000000046 ffff8801c8843dd0 ffffffff810566d1
 0000000000000000 ffff8801ca78d888 ffff8801c8843e20 00000000fffee424
 ffff8801cb989468 000000000000df68 00000000000118c0 ffff8801cb989468
Call Trace:
 [<ffffffff810566d1>] ? autoremove_wake_function+0x11/0x40
 [<ffffffff8113b24d>] kjournald+0x20d/0x230
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8113b040>] ? kjournald+0x0/0x230
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
<removed refrigerated tasks>
rpciod/0      S ffff8801ca60f7f0     0  2535      2 0x00000000
 ffff8801ca719e60 0000000000000046 ffff8801ca719de0 ffffffff81036826
 ffff8801ca719df0 ffff8801ca60f7f0 ffff8800282118c0 00000000fffeeca9
 ffff8801ca60fa98 000000000000df68 00000000000118c0 ffff8801ca60fa98
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
rpciod/1      S ffff8801c9362080     0  2536      2 0x00000000
 ffff8801ca577e60 0000000000000046 ffff8801ca577de0 ffffffff81036826
 ffff8801c9bb5188 ffff880028291800 ffff8800282918c0 00000000fffeecba
 ffff8801c9362328 000000000000df68 00000000000118c0 ffff8801c9362328
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
nfsiod        S ffff8801c9b998f0     0  2571      2 0x00000000
 ffff8801c9163e60 0000000000000046 ffff8801c9163de0 ffffffff81036826
 ffff8801c9163df0 ffff8801c9b998f0 ffff8800282118c0 00000000fffeece9
 ffff8801c9b99b98 000000000000df68 00000000000118c0 ffff8801c9b99b98
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
<removed refrigerated tasks>
pm-suspend    D ffff8801cb880000     0  3423   3387 0x00000000
 ffff8801c5dddc08 0000000000000086 0000000000000000 ffff8801c5dddc30
 ffff8801c5dddb78 ffffffff8103321c ffff8801c5dddba8 00000000ffff37ee
 ffff8801ca59a528 000000000000df68 00000000000118c0 ffff8801ca59a528
Call Trace:
 [<ffffffff8103321c>] ? __enqueue_entity+0x7c/0x80
 [<ffffffff8142e864>] schedule_timeout+0x154/0x230
 [<ffffffff8104a5c0>] ? process_timeout+0x0/0x10
 [<ffffffff8142e587>] wait_for_common+0xc7/0x170
 [<ffffffff81037600>] ? default_wake_function+0x0/0x10
 [<ffffffff8142e6ae>] wait_for_completion_timeout+0xe/0x10
 [<ffffffff8141cbf6>] _cpu_down+0xe6/0x110
 [<ffffffff8104115b>] disable_nonboot_cpus+0xab/0x130
 [<ffffffff8106e84d>] suspend_devices_and_enter+0xad/0x1a0
 [<ffffffff8106ea1b>] enter_state+0xdb/0xf0
 [<ffffffff8106e151>] state_store+0x91/0x100
 [<ffffffff8116af27>] kobj_attr_store+0x17/0x20
 [<ffffffff8111b590>] sysfs_write_file+0xe0/0x160
 [<ffffffff810c3698>] vfs_write+0xb8/0x1b0
 [<ffffffff81432ab5>] ? do_page_fault+0x185/0x350
 [<ffffffff810c3cfc>] sys_write+0x4c/0x80
 [<ffffffff8100beeb>] system_call_fastpath+0x16/0x1b
kstop/0       R  running task        0  3836      2 0x00000000
 ffff8801c980fe60 0000000000000046 ffff8801c980fde0 ffffffff81036826
 0000000000000001 ffff8801c6e241c0 ffff8800282118c0 00000000ffff380f
 ffff8801c6e24468 000000000000df68 00000000000118c0 ffff8801c6e24468
Call Trace:
 [<ffffffff81036826>] ? dequeue_task_fair+0x86/0x90
 [<ffffffff81051d95>] worker_thread+0xe5/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kstop/1       R  running task        0  3837      2 0x00000000
 ffff8801c5f08000 0000000000000001 ffffe8ffffc89888 ffffe8ffffc89888
 ffff8801c5f09e80 ffffe8ffffc87450 ffffffffffffff10 ffffffff81080556
 0000000000000010 0000000000000293 ffff8801c5f09e00 0000000000000018
Call Trace:
 [<ffffffff81080556>] ? stop_cpu+0x76/0xe0
 [<ffffffff810804e0>] ? stop_cpu+0x0/0xe0
 [<ffffffff81051c28>] ? run_workqueue+0xb8/0x140
 [<ffffffff81051d5b>] ? worker_thread+0xab/0x120
 [<ffffffff810566c0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81051cb0>] ? worker_thread+0x0/0x120
 [<ffffffff8105633e>] ? kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] ? child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
kcpu_down     R  running task        0  3838      2 0x00000008
 ffff8801c9867e50 ffffffff8105279a ffffffff815df680 0000000000000004
 ffffffff815df680 ffff8801c5dddd58 ffff8801c9867e80 ffffffff810804ac
 0000000000000001 ffff8801c9867ef8 ffff8801c5dddd58 0000000000000010
Call Trace:
 [<ffffffff8105279a>] ? flush_workqueue+0x5a/0x90
 [<ffffffff810804ac>] ? __stop_machine+0x10c/0x140
 [<ffffffff8141c882>] ? _cpu_down_thread+0xa2/0x2f0
 [<ffffffff8141c7e0>] ? _cpu_down_thread+0x0/0x2f0
 [<ffffffff8105633e>] ? kthread+0x8e/0xa0
 [<ffffffff8100ce9a>] ? child_rip+0xa/0x20
 [<ffffffff810562b0>] ? kthread+0x0/0xa0
 [<ffffffff8100ce90>] ? child_rip+0x0/0x20
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU1 is down
Extended CMOS year: 2000
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
Back to C!
<removed devices prints>
Restarting tasks ... done.
