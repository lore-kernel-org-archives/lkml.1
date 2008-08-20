Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbYHTTd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbYHTTd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYHTTdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:33:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbYHTTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:33:19 -0400
Date: Wed, 20 Aug 2008 12:30:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jayakumar.lkml@gmail.com, npiggin@suse.de,
       a.p.zijlstra@chello.nl, hugh@veritas.com, hannes@saeurebad.de,
       jeremy@goop.org, kel@otaku42.de, armbru@redhat.com
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
Message-Id: <20080820123056.8f0c9d3f.akpm@linux-foundation.org>
In-Reply-To: <1219258673.3996.46.camel@localhost.localdomain>
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	<20080818233824.5d219105.akpm@linux-foundation.org>
	<1219220003.3996.29.camel@localhost.localdomain>
	<20080820013736.ec64baae.akpm@linux-foundation.org>
	<1219258673.3996.46.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 19:57:53 +0100
Ian Campbell <ijc@hellion.org.uk> wrote:

> [correcting stable@]
> 
> On Wed, 2008-08-20 at 01:37 -0700, Andrew Morton wrote:
> > On Wed, 20 Aug 2008 09:13:23 +0100 Ian Campbell <ijc@hellion.org.uk> wrote:
> > 
> > > Perhaps applying the band-aid at open time instead would be preferred?
> > 
> > That would be less racy, I expect.
> [...]
> > <tries to write a patch>
> > 
> > OK, seems that fb_ops.fb_open() has no way of getting at the `struct
> > file *' which is being opened (wtf?).  Screwed.  Need to change
> > fb_ops.fb_open(), or add a new fb_ops.fb_open_sane().
> 
> Ah yes, I remember why I did it in mmap() now...
> 
> How about this version? Not as clean as overriding fb_open() but
> involves less frobbing with unrelated drivers.
> 
> From ae2f7f118518fbfd4006c985b136a5d3d1a314af Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ijc@hellion.org.uk>
> Date: Wed, 20 Aug 2008 19:54:50 +0100
> Subject: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
> 
> Fixes kernel BUG at lib/radix-tree.c:473.
> 
> Previously the handler was incidentally provided by tmpfs but this was
> removed with:
> 
>   commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
>   Author: Hugh Dickins <hugh@veritas.com>
>   Date:   Mon Jul 28 15:46:19 2008 -0700
> 
>     tmpfs: fix kernel BUG in shmem_delete_inode
> 
> relying on this behaviour was incorrect in any case and the BUG
> also appeared when the device node was on an ext3 filesystem.
> 
> v2: override a_ops at open() time rather than mmap() time to minimise
> races per AKPM's concerns.
> 
> ...
>
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1344,6 +1344,10 @@ fb_open(struct inode *inode, struct file *file)
>  		if (res)
>  			module_put(info->fbops->owner);
>  	}
> +#ifdef CONFIG_FB_DEFERRED_IO
> +	if (info->fbdefio)
> +		fb_deferred_io_open(info, inode, file);
> +#endif

eww, hacky, but drivers/video/fbmem.c already got hacky:

#ifdef CONFIG_FB_DEFERRED_IO
        .fsync =        fb_deferred_io_fsync,
#endif

so it's not an original sin.

Does it work?
