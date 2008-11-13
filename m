Return-Path: <linux-kernel-owner+w=401wt.eu-S1752586AbYKMBNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbYKMBNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKMBNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:13:37 -0500
Received: from exchtp08.via.com.tw ([61.66.243.7]:56548 "EHLO
	exchtp08.via.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbYKMBNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:13:37 -0500
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2008 20:13:36 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Fix crash in viafb due to 4k stack overflow
Date: Thu, 13 Nov 2008 08:58:22 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8081F500A@exchtp03.taipei.via.com.tw>
In-Reply-To: <20081112150104.8f7a71f6.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix crash in viafb due to 4k stack overflow
Thread-Index: AclFGpiN1zqkXWX5T3+lCZxgh33mYQAEBNww
From: <JosephChan@via.com.tw>
To: <akpm@linux-foundation.org>, <bonbons@linux-vserver.org>
Cc: <arjan@infradead.org>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Nov 2008 00:58:23.0937 (UTC) FILETIME=[EDEBDB10:01C9452A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

