Return-Path: <linux-kernel-owner+w=401wt.eu-S933428AbXFFCnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428AbXFFCnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 22:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXFFCnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 22:43:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43373 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbXFFCnD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 22:43:03 -0400
Date: Tue, 5 Jun 2007 19:42:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "clameter@sgi.com" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused
 kmalloc bug
Message-Id: <20070605194236.03e07a1f.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 01:56:01 +0000 "young dave" <hidave.darkstar@gmail.com> wrote:

> Hi,
> when I remove the usb bluetooth adapter , the kernel reporting bug:
> 
> /* this two line is printk message I printed in net/bluetooth/hci_core.c */
> 
> #before free dev: c3758430
> #after free dev
> 
> =============================================================================
> BUG kmalloc-1024: Poison overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xc3758440-0xc3758440. First byte 0x6a instead of 0x6b
> INFO: Allocated in hci_alloc_dev+0x1f/0x80 [bluetooth] age=6094 cpu=0 pid=9586
> INFO: Freed in device_release+0x82/0x90 age=0 cpu=0 pid=7
> INFO: Slab 0xc106eb00 used=6 fp=0xc3758430 flags=0x400020c3
> INFO: Object 0xc3758430 @offset=1072 fp=0xc375b240

I don't get it.  device_release() doesn't call kfree() or kmem_cache_free()
or any such thing.

> Bytes b4 0xc3758420:  00 00 00 00 b9 ea 09 00 5a 5a 5a 5a 5a 5a 5a 5a
> ....¹ê..ZZZZZZZZ
>   Object 0xc3758430:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
>   Object 0xc3758440:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> jkkkkkkkkkkkkkkk
>   Object 0xc3758450:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
>   Object 0xc3758460:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
>   Object 0xc3758470:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
>   Object 0xc3758480:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
>   Object 0xc3758490:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
>   Object 0xc37584a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> kkkkkkkkkkkkkkkk
>  Redzone 0xc3758830:  bb bb bb bb
> »»»»
>  Padding 0xc3758858:  5a 5a 5a 5a 5a 5a 5a 5a
> ZZZZZZZZ
>  [<c016db1a>] check_bytes_and_report+0xaa/0xe0
>  [<c016de48>] check_object+0x198/0x1e0
>  [<c016e2ac>] alloc_debug_processing+0x9c/0x130
>  [<c016ed9a>] __slab_alloc+0x10a/0x220
>  [<c03c412a>] pskb_expand_head+0x4a/0x140
>  [<c016fa12>] __kmalloc+0x72/0x80
>  [<c03c412a>] pskb_expand_head+0x4a/0x140
>  [<c03c412a>] pskb_expand_head+0x4a/0x140
>  [<c016e2d6>] alloc_debug_processing+0xc6/0x130
>  [<c03dbcc8>] netlink_broadcast+0x68/0x370
>  [<c02727fd>] kobject_uevent_env+0x32d/0x4e0
>  [<c02728e4>] kobject_uevent_env+0x414/0x4e0
>  [<c01858df>] d_kill+0x3f/0x60
>  [<c018591a>] dput+0x1a/0xf0
>  [<c02dbd7c>] device_del+0x1ac/0x2e0
>  [<c0360e88>] usb_disable_device+0x78/0xf0
>  [<c035b923>] usb_disconnect+0x93/0xf0
>  [<c035cb02>] hub_port_connect_change+0x2f2/0x3b0
>  [<c035cdd2>] hub_events+0x212/0x420
>  [<c0138470>] autoremove_wake_function+0x0/0x50
>  [<c035d005>] hub_thread+0x25/0x110
>  [<c0138470>] autoremove_wake_function+0x0/0x50
>  [<c0138470>] autoremove_wake_function+0x0/0x50
>  [<c035cfe0>] hub_thread+0x0/0x110
>  [<c0137e99>] kthread+0x59/0xa0
>  [<c0137e40>] kthread+0x0/0xa0
>  [<c0104df3>] kernel_thread_helper+0x7/0x14
>  =======================
> FIX kmalloc-1024: Restoring 0xc3758440-0xc3758440=0x6b
> 
> FIX kmalloc-1024: Marking all objects used

Could perhaps be due to bluetooth-postpone-hci_dev-unregistration.patch,
but I don't see how.  (But that patch looks a bit dodgy wrt module unload
so I think I'll drop it).

Are you able to reproduce this in 2.6.22-rc4?

