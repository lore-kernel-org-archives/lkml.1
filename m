Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbYKNJNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbYKNJNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 04:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYKNJMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 04:12:55 -0500
Received: from ppp-110-117.adsl.restena.lu ([158.64.110.117]:40017 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750918AbYKNJMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 04:12:53 -0500
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2008 04:12:53 EST
Date: Fri, 14 Nov 2008 10:01:56 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: <JosephChan@via.com.tw>
Cc: <akpm@linux-foundation.org>, <arjan@infradead.org>,
       <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <ScottFang@viatech.com.cn>
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-ID: <20081114100156.4557760c@pluto.restena.lu>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB808226A07@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB808226A07@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph,

Are you testing with 4k stacks or with 8k stacks (CONFIG_4KSTACKS)?

Note that your failure looks pretty much like the ones I mentionned in
  http://lkml.org/lkml/2008/11/9/204
It looks like some kernel text/data got corrupted though I have no
idea what caused it. For me this kind of NULL pointer dereference did
happen a few times then stopped showing up (just a reboot, not kernel
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
> IP: [<c03dc6ec>] rt_worker_func+0xc7/0x15d
> Last sysfs file: /sys/class/graphics/fb0/dev
> Modules linked in: viafb i2c_algo_bit via_rhine sg pata_via sd_mod
> ehci_hcd
> 
> Pid: 6, comm: events/0 Not tainted (2.6.28-rc4b #1) pn test
> EIP: 0060:[<c03dc6ec>] EFLAGS: 00010286 CPU:0
> EIP is at rt_worker_func+0xc7/0x15d
> ......
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
> To: 'Andrew Morton'; Bruno Prémont
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
> To: Bruno Prémont
> Cc: arjan@infradead.org; Joseph Chan;
> linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
> 
> On Mon, 10 Nov 2008 22:00:46 +0100
> Bruno Pr__mont <bonbons@linux-vserver.org> wrote:
> 
> > During conversion of viafb_ioctl() I noticed the following:
> > 
> > Those two cases just copy_from_user and do nothing with copied
> > data, incomplete implementation?:
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
