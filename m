Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbYKNKUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbYKNKUo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYKNKUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:20:19 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:17192 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbYKNKUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:20:17 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH] Fix crash in viafb due to 4k stack overflow
Date: Fri, 14 Nov 2008 18:20:12 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB808226B80@exchtp03.taipei.via.com.tw>
In-Reply-To: <20081114100156.4557760c@pluto.restena.lu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix crash in viafb due to 4k stack overflow
Thread-Index: AclGOTCFw5tnciJzSCS7Y6ayTm4x1QAB6NrQ
From: <JosephChan@via.com.tw>
To: <bonbons@linux-vserver.org>
Cc: <akpm@linux-foundation.org>, <arjan@infradead.org>,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <ScottFang@viatech.com.cn>
X-OriginalArrivalTime: 14 Nov 2008 10:20:14.0813 (UTC) FILETIME=[959510D0:01C94642]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mAEAKsdq014370

 
8K stacks, I don't enable the CONFIG_4KSTACKS.
In addition, I also tried to enable CONFIG_4KSTACKS, the system still returns me lots "panic" during system bootup. :(

BRs,
Joseph Chan 

-----Original Message-----
From: Bruno PrÃ©mont [mailto:bonbons@linux-vserver.org] 
Sent: Friday, November 14, 2008 5:02 PM
To: Joseph Chan
Cc: akpm@linux-foundation.org; arjan@infradead.org; linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; Scott Fang
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow

Joseph,

Are you testing with 4k stacks or with 8k stacks (CONFIG_4KSTACKS)?

Note that your failure looks pretty much like the ones I mentionned in
  http://lkml.org/lkml/2008/11/9/204
It looks like some kernel text/data got corrupted though I have no idea what caused it. For me this kind of NULL pointer dereference did happen a few times then stopped showing up (just a reboot, not kernel
change/recompile)

Bruno


On Fri, 14 Nov 2008 <JosephChan@via.com.tw> wrote:
> After testing the patch with 2.6.28-rc4 kernel, I found something 
> strange in both viafb built-in and module modes. See the result on my 
> EPIA-EX (CX700) below. Based on the result, it looks like something 
> wrong with the new patch.
> 
> Kernel 2.6.28-rc4 + viafb-fix-crash-due-to-4k-stack-overflow.patch
> 
> 1. w/o patching the viafb-fix-crash-due-to-4k-stack-overflow.patch
> => System works properly without "kernel panic" issue.
> 
> 2. w/ patching the viafb-fix-crash-due-to-4k-stack-overflow.patch
> => System hangs with "kernel panic" randomly after loading the viafb 
> module. Such as:
> BUG: unable to handle kernel NULL pointer dereference at 000000c7
> IP: [<c03dc6ec>] rt_worker_func+0xc7/0x15d Last sysfs file: 
> /sys/class/graphics/fb0/dev Modules linked in: viafb i2c_algo_bit 
> via_rhine sg pata_via sd_mod ehci_hcd
> 
> Pid: 6, comm: events/0 Not tainted (2.6.28-rc4b #1) pn test
> EIP: 0060:[<c03dc6ec>] EFLAGS: 00010286 CPU:0 EIP is at 
> rt_worker_func+0xc7/0x15d ......
> ....
> .....
> 
> 
> BRs,
> Joseph
> 
> -----Original Message-----
> From: Joseph Chan
> Sent: Thursday, November 13, 2008 8:58 AM
> To: 'Andrew Morton'; Bruno PrÃ©mont
> Cc: arjan@infradead.org; linux-fbdev-devel@lists.sourceforge.net;
> linux-kernel@vger.kernel.org Subject: RE: [PATCH] Fix crash in viafb 
> due to 4k stack overflow
> 
> I will try this new patch later. :)
> 
> BRs,
> Joseph Chan
> 
> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Thursday, November 13, 2008 7:01 AM
> To: Bruno PrÃ©mont
> Cc: arjan@infradead.org; Joseph Chan;
> linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
> 
> On Mon, 10 Nov 2008 22:00:46 +0100
> Bruno Pr__mont <bonbons@linux-vserver.org> wrote:
> 
> > During conversion of viafb_ioctl() I noticed the following:
> > 
> > Those two cases just copy_from_user and do nothing with copied data, 
> > incomplete implementation?:
> >         case VIAFB_SET_PANEL_POSITION:
> >                 if (copy_from_user(&u.panel_pos_size_para, argp,
> >                                    sizeof(u.panel_pos_size_para)))
> >                         return -EFAULT;
> >                 break;
> >         case VIAFB_SET_PANEL_SIZE:
> >                 if (copy_from_user(&u.panel_pos_size_para, argp,
> >                                    sizeof(u.panel_pos_size_para)))
> >                         return -EFAULT;
> >                 break;
> > 
> > Handling of GET/SET GAMMA looks buggy:
> > In each case 256*4 bytes are allocated but only 4 bytes (size of
> > pointer) are copied to/from userspace though
> > viafb_(get|set)_gamma_table() operates on the full 256 elements...
> >         case VIAFB_SET_GAMMA_LUT:
> >                 viafb_gamma_table = kmalloc(256 * sizeof(u32), 
> > GFP_KERNEL); if (!viafb_gamma_table)
> >                         return -ENOMEM;
> >                 if (copy_from_user(viafb_gamma_table, argp,
> >                                 sizeof(viafb_gamma_table))) {
> >                         kfree(viafb_gamma_table);
> >                         return -EFAULT;
> >                 }
> >                 viafb_set_gamma_table(viafb_bpp, viafb_gamma_table);
> >                 kfree(viafb_gamma_table);
> >                 break;
> > 
> >         case VIAFB_GET_GAMMA_LUT:
> >                 viafb_gamma_table = kmalloc(256 * sizeof(u32), 
> > GFP_KERNEL); if (!viafb_gamma_table)
> >                         return -ENOMEM;
> >                 viafb_get_gamma_table(viafb_gamma_table);
> >                 if (copy_to_user(argp, viafb_gamma_table,
> >                         sizeof(viafb_gamma_table))) {
> >                         kfree(viafb_gamma_table);
> >                         return -EFAULT;
> >                 }
> >                 kfree(viafb_gamma_table);
> >                 break;
> > 
> > I don't know if there is a userspace app that uses these VIA 
> > IOCTLs... so the ioctl part is just compile-tested.
> > After checking, fbset just uses some generic framebuffer IOCTLs 
> > outside of viafb's scope, thus not passing through viafb_ioctl().
> > 
> > 
> > 
> > ---
> > --- linux-2.6.28-rc3/drivers/video/via/viafbdev.c.orig
> > 2008-11-09 19:36:47.000000000 +0100 +++
> > linux-2.6.28-rc3/drivers/video/via/viafbdev.c	2008-11-10
> > 20:50:32.000000000 +0100
> 
> hm, OK, I dropped the old patch and merged this one.
> 
> It'd be nice to have it runtime tested and reviewed by Joseph, but we 
> haven't heard from him yet.  viafb might be 8k-stacks-only in 2.6.27, 
> which would be bad.
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
