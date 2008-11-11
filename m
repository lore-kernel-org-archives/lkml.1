Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYKKLBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYKKLBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbYKKLBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:01:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60097 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbYKKLBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:01:15 -0500
Date: Tue, 11 Nov 2008 13:01:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11380] lockdep warning: cpu_add_remove_lock
	at:cpu_maps_update_begin+0x14/0x16
Message-ID: <20081111120111.GA3503@redhat.com>
References: <20081110073047.GA28578@elte.hu> <20081110132208.GB10294@redhat.com> <20081111105706.6174.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111105706.6174.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, KOSAKI Motohiro wrote:
>
> it seem simple ABBA lock, right?
>
> -> #4 (&dev->mutex){--..}:
>        [<c0160f87>] validate_chain+0x831/0xaa2
>        [<c0161872>] __lock_acquire+0x67a/0x6e0
>        [<c0161933>] lock_acquire+0x5b/0x81
>        [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
>        [<c0782d02>] input_register_handle+0x26/0x7a			dev->mutex
                                                                        ^^^^^^^^^^
>        [<c04a62c9>] kbd_connect+0x64/0x8d
>        [<c0782842>] input_attach_handler+0x38/0x6b
>        [<c0784216>] input_register_handler+0x74/0xc3			input_mutex
>        [<c0f54e4b>] kbd_init+0x66/0x91
>        [<c0f54f7b>] vty_init+0xce/0xd7
>        [<c0f54952>] tty_init+0x193/0x197
>        [<c010112a>] do_one_initcall+0x42/0x133
>        [<c0f2d5cb>] kernel_init+0x16e/0x1d5
>        [<c0117c03>] kernel_thread_helper+0x7/0x10
>        [<ffffffff>] 0xffffffff
>
> -> #3 (input_mutex){--..}:
>        [<c0160f87>] validate_chain+0x831/0xaa2
>        [<c0161872>] __lock_acquire+0x67a/0x6e0
>        [<c0161933>] lock_acquire+0x5b/0x81
>        [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
>        [<c0783fbe>] input_register_device+0xff/0x17f		input_mutex
>        [<c048a889>] acpi_button_add+0x31e/0x429
>        [<c04889f4>] acpi_device_probe+0x43/0xde
>        [<c052c67f>] driver_probe_device+0xa5/0x120
>        [<c052c73c>] __driver_attach+0x42/0x64			dev->sem
                                                                ^^^^^^^^
input_dev->mutex != device->sem

> ...
>        [<c0f2d201>] do_async_initcalls+0x1a/0x2a
>        [<c0150eec>] run_workqueue+0xc3/0x193			
>        [<c015195d>] worker_thread+0xbb/0xc7
>        [<c0153e2a>] kthread+0x40/0x66

What is the kernel version, btw? I can't find do_async_initcalls
in 2.6.27 or 2.6.28.

Anyway, this really looks like lockdep bug to me. Even if we really
have the circular dependency (will try to grep more) I can't understand
why lockdep claims that polldev_mutex depends on cpu_add_remove_lock.

Oleg.

