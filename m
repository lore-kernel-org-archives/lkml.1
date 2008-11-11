Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYKKCKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYKKCKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 21:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYKKCKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 21:10:38 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56108 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbYKKCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 21:10:36 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [Bug #11380] lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20081110132208.GB10294@redhat.com>
References: <20081110073047.GA28578@elte.hu> <20081110132208.GB10294@redhat.com>
Message-Id: <20081111105706.6174.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 11 Nov 2008 11:10:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/10, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.26 and 2.6.27.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11380
> > > Subject		: lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
> > > Submitter	: Ingo Molnar <mingo@elte.hu>
> > > Date		: 2008-08-20 6:44 (82 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=121921480931970&w=4
> > 
> > had a quick look again: i believe this one still triggers, and it's 
> > caused by some interaction between input code and workqueue code. I 
> > think it started triggering when Oleg's workqueue annotation patches 
> > went upstream:
> > 
> > 6af8bf3: workqueues: add comments to __create_workqueue_key()
> > 8448502: workqueues: do CPU_UP_CANCELED if CPU_UP_PREPARE fails
> > 8de6d30: workqueues: schedule_on_each_cpu() can use schedule_work_on()
> > ef1ca23: workqueues: queue_work() can use queue_work_on()
> > a67da70: workqueues: lockdep annotations for flush_work()
> > 3da1c84: workqueues: make get_online_cpus() useable for work->func()
> > 8616a89: workqueues: schedule_on_each_cpu: use flush_work()
> > db70089: workqueues: implement flush_work()
> > 1a4d9b0: workqueues: insert_work: use "list_head *" instead of "int tail"
> 
> "make get_online_cpus() useable for work->func()" changed the locking.
> destroy_workqueue() was changed to take cpu_maps_update_begin() instead
> of get_online_cpus(). Other patches can't make any difference afaics.
> 
> Currently I don't understand why lockdep complains, will try to do
> more grepping later.

I check original report.
Is this really cpu hotplug related warnings?

it seem simple ABBA lock, right?


-> #4 (&dev->mutex){--..}:
       [<c0160f87>] validate_chain+0x831/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
       [<c0782d02>] input_register_handle+0x26/0x7a			dev->mutex
       [<c04a62c9>] kbd_connect+0x64/0x8d
       [<c0782842>] input_attach_handler+0x38/0x6b
       [<c0784216>] input_register_handler+0x74/0xc3			input_mutex
       [<c0f54e4b>] kbd_init+0x66/0x91
       [<c0f54f7b>] vty_init+0xce/0xd7
       [<c0f54952>] tty_init+0x193/0x197
       [<c010112a>] do_one_initcall+0x42/0x133
       [<c0f2d5cb>] kernel_init+0x16e/0x1d5
       [<c0117c03>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #3 (input_mutex){--..}:
       [<c0160f87>] validate_chain+0x831/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
       [<c0783fbe>] input_register_device+0xff/0x17f		input_mutex
       [<c048a889>] acpi_button_add+0x31e/0x429
       [<c04889f4>] acpi_device_probe+0x43/0xde
       [<c052c67f>] driver_probe_device+0xa5/0x120
       [<c052c73c>] __driver_attach+0x42/0x64			dev->sem
       [<c052be91>] bus_for_each_dev+0x43/0x65
       [<c052c507>] driver_attach+0x19/0x1b
       [<c052c251>] bus_add_driver+0x9e/0x1a1
       [<c052c8de>] driver_register+0x76/0xd2
       [<c0488dc3>] acpi_bus_register_driver+0x3f/0x41
       [<c0f51bf2>] acpi_button_init+0x32/0x51
       [<c010112a>] do_one_initcall+0x42/0x133
       [<c0f2d201>] do_async_initcalls+0x1a/0x2a
       [<c0150eec>] run_workqueue+0xc3/0x193			
       [<c015195d>] worker_thread+0xbb/0xc7
       [<c0153e2a>] kthread+0x40/0x66
       [<c0117c03>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff


