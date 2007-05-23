Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXEWXlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXEWXlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbXEWXlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:41:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46305 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756108AbXEWXlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:41:08 -0400
Date: Thu, 24 May 2007 01:40:47 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Zan Lynx <zlynx@acm.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <1179962229.8575.4.camel@localhost>
Message-ID: <Pine.LNX.4.64.0705240131050.27422@twin.jikos.cz>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <1179962229.8575.4.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Zan Lynx wrote:

> I am having weird problems with USB keyboard and mouse.  The USB 
> keyboard will drop keystrokes, but not all of them.  The mouse seems to 
> move fine but drops clicks.  Could be that an occasional missed move 
> event isn't noticeable.  Nothing is logged when a key is dropped. 
> However, I did have some of this when it was first booting:
> BUG: at drivers/hid/hid-core.c:778 implement()
> Call Trace:
> [<ffffffff880bb5ac>] :hid:hid_output_report+0x1dc/0x270
> [<ffffffff880c651a>] :usbhid:hid_submit_ctrl+0x7a/0x260
> [<ffffffff880c68ee>] :usbhid:usbhid_submit_report+0x11e/0x200
> [<ffffffff880c9312>] :usbhid:hiddev_ioctl+0x3e2/0xae0
> [<ffffffff8053523e>] do_page_fault+0x42e/0x880
> [<ffffffff802b486d>] do_ioctl+0x7d/0xa0
> [<ffffffff802b4ab1>] vfs_ioctl+0x221/0x2d0
> [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
> [<ffffffff802b4ba9>] sys_ioctl+0x49/0x80
> [<ffffffff8020a16e>] system_call+0x7e/0x83

OK, so something is touching one of your HID devices through hiddev, and 
tries to push through it something that doesn't comply to the report 
descriptor of the device. Are you aware of any userspace daemons running 
which would touch /dev/hiddev*? (acupsd, nut, hid2hci, etc.).

Just for clarification, does situation get any better when you disable 
hidraw, which I see you have enabled? (if that doesn't help, testing with 
hiddev disabled should also be interesting - that would avoid the 
possibility that userspace mocks the device up through hiddev).

> BUG: at include/linux/slub_def.h:83 kmalloc_index()
> Call Trace:
>  [<ffffffff802a2e09>] get_slab+0xb9/0x180
>  [<ffffffff802a2965>] kfree+0xc5/0x110
>  [<ffffffff802a2fd4>] __kmalloc+0x24/0xc0
>  [<ffffffff8049ab18>] get_modalias+0x68/0x120
>  [<ffffffff8049ac07>] dmi_dev_uevent+0x37/0x60
>  [<ffffffff80443b63>] dev_uevent+0x163/0x220
>  [<ffffffff803bcc97>] kobject_uevent_env+0x2b7/0x500
>  [<ffffffff80444f50>] bus_add_device+0x20/0x140
>  [<ffffffff804438d2>] device_add+0x4a2/0x5b0
>  [<ffffffff807a0a1b>] dmi_id_init+0x2cb/0x2f0
>  [<ffffffff807866e6>] kernel_init+0x156/0x330
>  [<ffffffff80531f5c>] trace_hardirqs_on_thunk+0x35/0x37
>  [<ffffffff8025a711>] trace_hardirqs_on+0xc1/0x160
>  [<ffffffff8020b028>] child_rip+0xa/0x12
>  [<ffffffff8020a710>] restore_args+0x0/0x30
>  [<ffffffff803e6c10>] vgacon_cursor+0x0/0x1f0
>  [<ffffffff8023ad5b>] release_console_sem+0x4b/0x230
>  [<ffffffff80786590>] kernel_init+0x0/0x330
>  [<ffffffff8020b01e>] child_rip+0x0/0x12

This BTW needs a separate bugreport.

> input,hiddev0,hidraw2: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.2-2.2.1

This is pretty strange. Mouse shouldn't be claimed by hiddev. Seems like 
this mouse probably has some "interesting" HID report descriptor. Could 
you please recompile with CONFIG_HID_DEBUG enabled and send me the output?

> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.22-rc2-mm1 #1
> -------------------------------------------------------
> rhythmbox/6976 is trying to acquire lock:
>  (&mm->mmap_sem){----}, at: [<ffffffff80534f8c>] do_page_fault+0x17c/0x880
> but task is already holding lock:
>  (&data->latch){----}, at: [<ffffffff8034a701>] get_exclusive_access+0x11/0x20
> which lock already depends on the new lock.

This also needs a separate report.


Do you please have any indication which kernel versions were OK with the 
same .config, with respect to the USB mouse/keyboard hogs you are seeing 
with 2.6.22-rc2-mm1?

Thanks,

-- 
Jiri Kosina
