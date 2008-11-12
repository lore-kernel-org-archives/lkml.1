Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYKLXB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYKLXB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYKLXBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:01:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbYKLXBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:01:20 -0500
Date: Wed, 12 Nov 2008 15:01:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: arjan@infradead.org, JosephChan@via.com.tw,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix crash in viafb due to 4k stack overflow
Message-Id: <20081112150104.8f7a71f6.akpm@linux-foundation.org>
In-Reply-To: <20081110220046.10376327@neptune.home>
References: <20081109202537.33ead0a2@neptune.home>
	<20081109113603.d45361ad.akpm@linux-foundation.org>
	<20081109122515.1deb9ec2@infradead.org>
	<20081109213811.4b85adc6@neptune.home>
	<20081109125522.b5266352.akpm@linux-foundation.org>
	<20081109223748.3182e31d@neptune.home>
	<20081109145959.6a8d9e8e.akpm@linux-foundation.org>
	<20081110220046.10376327@neptune.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> In each case 256*4 bytes are allocated but only 4 bytes (size of pointer)
> are copied to/from userspace though viafb_(get|set)_gamma_table() operates
> on the full 256 elements...
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
> After checking, fbset just uses some generic framebuffer IOCTLs outside
> of viafb's scope, thus not passing through viafb_ioctl().
> 
> 
> 
> ---
> --- linux-2.6.28-rc3/drivers/video/via/viafbdev.c.orig	2008-11-09 19:36:47.000000000 +0100
> +++ linux-2.6.28-rc3/drivers/video/via/viafbdev.c	2008-11-10 20:50:32.000000000 +0100

hm, OK, I dropped the old patch and merged this one.

It'd be nice to have it runtime tested and reviewed by Joseph, but we
haven't heard from him yet.  viafb might be 8k-stacks-only in 2.6.27,
which would be bad.

