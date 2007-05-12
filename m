Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbXELAyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbXELAyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756483AbXELAx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:53:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbXELAxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:53:55 -0400
Date: Fri, 11 May 2007 17:53:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: rlove@rlove.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: 2.6.21-mm2: HDAPS? BUG: at kernel/mutex.c:311
Message-Id: <20070511175335.092aa0af.akpm@linux-foundation.org>
In-Reply-To: <20070512002115.GZ11166@waste.org>
References: <20070512002115.GZ11166@waste.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 19:21:15 -0500
Matt Mackall <mpm@selenic.com> wrote:

> This just hit:
> 
> [    7.856000] usbcore: registered new interface driver usbhid
> [    7.860000] BUG: at kernel/mutex.c:311 __mutex_trylock_slowpath()
> [    7.868000]  [<c0104584>] show_trace_log_lvl+0x1a/0x30
> [    7.872000]  [<c0105196>] show_trace+0x12/0x14
> [    7.876000]  [<c0105222>] dump_stack+0x15/0x17
> [    7.880000]  [<c03cd4c8>] mutex_trylock+0x56/0x15a
> [    7.888000]  [<c03172c5>] hdaps_mousedev_poll+0x10/0xcb
> [    7.892000]  [<c011f8c5>] run_timer_softirq+0x10e/0x16f
> [    7.896000]  [<c011cabc>] __do_softirq+0x5d/0xc0
> [    7.900000]  [<c0105c88>] do_softirq+0x6e/0xf0
> [    7.904000]  [<c011ca22>] irq_exit+0x3e/0x7b
> [    7.912000]  [<c0105da7>] do_IRQ+0x9d/0xb2
> [    7.916000]  [<c01040fa>] common_interrupt+0x2e/0x34
> [    7.920000]  [<c0118e5f>] printk+0x1b/0x1d
> [    7.924000]  [<c02f2f96>] usb_register_driver+0xa0/0xe5
> [    7.928000]  [<c0525018>] hid_init+0x28/0x51
> [    7.932000]  [<c050e6c4>] kernel_init+0xbc/0x23e
> [    7.940000]  [<c010420f>] kernel_thread_helper+0x7/0x10
> [    7.944000]  =======================
> [    7.948000] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> 
> Looks like it's triggered by the HDAPS driver.
> 

It's complaining about a mutex_trylock() being run from irq context.

And indeed that's buggy - the non-debug version of spin_lock_mutex() is not
irq-safe.

I'd say that's pretty dumb of the mutex interface, really.  Doing a
mutex_trylock() should be OK from all contexts.

This is caused by a recent semaphore->mutex conversion and it's in mainline
now.

Ho hum.  I suppose a suitable workaround would be to convert hdaps_mtx back
into a semaphore.  ug.

