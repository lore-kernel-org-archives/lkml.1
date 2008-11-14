Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbYKNIlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbYKNIlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbYKNIlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:41:35 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:11572 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbYKNIle convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:41:34 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Fix crash in viafb due to 4k stack overflow
Date: Fri, 14 Nov 2008 16:41:26 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808226A07@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix crash in viafb due to 4k stack overflow
Thread-Index: AclFGpiN1zqkXWX5T3+lCZxgh33mYQAEBNwwAEHFd0A=
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <bonbons@linux-vserver.org>
Cc: <arjan@infradead.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <ScottFang@viatech.com.cn>
X-OriginalArrivalTime: 14 Nov 2008 08:41:27.0960 (UTC) FILETIME=[C8E71180:01C94634]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After testing the patch with 2.6.28-rc4 kernel, I found something strange in both viafb built-in and module modes.
See the result on my EPIA-EX (CX700) below. Based on the result, it looks like something wrong with the new patch.

Kernel 2.6.28-rc4 + viafb-fix-crash-due-to-4k-stack-overflow.patch

1. w/o patching the viafb-fix-crash-due-to-4k-stack-overflow.patch
=> System works properly without "kernel panic" issue.

2. w/ patching the viafb-fix-crash-due-to-4k-stack-overflow.patch
=> System hangs with "kernel panic" randomly after loading the viafb module.
     Such as:
BUG: unable to handle kernel NULL pointer dereference at 000000c7
IP: [<c03dc6ec>] rt_worker_func+0xc7/0x15d
Last sysfs file: /sys/class/graphics/fb0/dev
Modules linked in: viafb i2c_algo_bit via_rhine sg pata_via sd_mod ehci_hcd

Pid: 6, comm: events/0 Not tainted (2.6.28-rc4b #1) pn test
EIP: 0060:[<c03dc6ec>] EFLAGS: 00010286 CPU:0
EIP is at rt_worker_func+0xc7/0x15d
......
....
.....


BRs,
Joseph

-----Original Message-----
From: Joseph Chan 
Sent: Thursday, November 13, 2008 8:58 AM
To: 'Andrew Morton'; Bruno Prémont
Cc: arjan@infradead.org; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: RE: [PATCH] Fix crash in viafb due to 4k stack overflow

I will try this new patch later. :)

BRs,
Joseph Chan

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org]
Sent: Thursday, November 13, 2008 7:01 AM
To: Bruno Prémont
Cc: arjan@infradead.org; Joseph Chan; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow

On Mon, 10 Nov 2008 22:00:46 +0100
Bruno Pr__mont <bonbons@linux-vserver.org> wrote:

> During conversion of viafb_ioctl() I noticed the following:
> 
> Those two cases just copy_from_user and do nothing with copied data, 
> incomplete implementation?:
>         case VIAFB_SET_PANEL_POSITION:
>                 if (copy_from_user(&u.panel_pos_size_para, argp,
>                                    sizeof(u.panel_pos_size_para)))
>                         return -EFAULT;
>                 break;
>         case VIAFB_SET_PANEL_SIZE:
>                 if (copy_from_user(&u.panel_pos_size_para, argp,
>                                    sizeof(u.panel_pos_size_para)))
>                         return -EFAULT;
>                 break;
> 
> Handling of GET/SET GAMMA looks buggy:
> In each case 256*4 bytes are allocated but only 4 bytes (size of
> pointer) are copied to/from userspace though
> viafb_(get|set)_gamma_table() operates on the full 256 elements...
>         case VIAFB_SET_GAMMA_LUT:
>                 viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);
>                 if (!viafb_gamma_table)
>                         return -ENOMEM;
>                 if (copy_from_user(viafb_gamma_table, argp,
>                                 sizeof(viafb_gamma_table))) {
>                         kfree(viafb_gamma_table);
>                         return -EFAULT;
>                 }
>                 viafb_set_gamma_table(viafb_bpp, viafb_gamma_table);
>                 kfree(viafb_gamma_table);
>                 break;
> 
>         case VIAFB_GET_GAMMA_LUT:
>                 viafb_gamma_table = kmalloc(256 * sizeof(u32), GFP_KERNEL);
>                 if (!viafb_gamma_table)
>                         return -ENOMEM;
>                 viafb_get_gamma_table(viafb_gamma_table);
>                 if (copy_to_user(argp, viafb_gamma_table,
>                         sizeof(viafb_gamma_table))) {
>                         kfree(viafb_gamma_table);
>                         return -EFAULT;
>                 }
>                 kfree(viafb_gamma_table);
>                 break;
> 
> I don't know if there is a userspace app that uses these VIA IOCTLs...
> so the ioctl part is just compile-tested.
> After checking, fbset just uses some generic framebuffer IOCTLs 
> outside of viafb's scope, thus not passing through viafb_ioctl().
> 
> 
> 
> ---
> --- linux-2.6.28-rc3/drivers/video/via/viafbdev.c.orig	2008-11-09 19:36:47.000000000 +0100
> +++ linux-2.6.28-rc3/drivers/video/via/viafbdev.c	2008-11-10 20:50:32.000000000 +0100

hm, OK, I dropped the old patch and merged this one.

It'd be nice to have it runtime tested and reviewed by Joseph, but we haven't heard from him yet.  viafb might be 8k-stacks-only in 2.6.27, which would be bad.

