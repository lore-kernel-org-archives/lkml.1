Return-Path: <linux-kernel-owner+w=401wt.eu-S1751660AbYHRIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbYHRIFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYHRIEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:04:30 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:47204 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYHRIEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:04:24 -0400
Subject: Re: kernel BUG at lib/radix-tree.c:473!
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
In-Reply-To: <1219046079.3996.11.camel@localhost.localdomain>
References: <1218697362.26014.9.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0808150049110.17216@blonde.site>
	 <1218989974.3996.4.camel@localhost.localdomain>
	 <200808181132.43718.nickpiggin@yahoo.com.au>
	 <1219046079.3996.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 10:04:34 +0200
Message-Id: <1219046674.10800.267.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 08:54 +0100, Ian Campbell wrote:
> On Mon, 2008-08-18 at 11:32 +1000, Nick Piggin wrote:
> > On Monday 18 August 2008 02:19, Ian Campbell wrote:
> > > FWIW the patch below apparently makes it work for me, but I'm not going
> > > to pretend I follow what's going on, why or what else it breaks ;-)
> > 
> > I think Iwould prefer fs_defio to use its own set_page_dirty
> > function. __set_page_dirty_no_writeback is supposed to be used
> > on pagecache, by filesystems.
> 
> fbdefio: add set_page_dirty handler to deferred IO FB
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
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Johannes Weiner <hannes@saeurebad.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Kel Modderman <kel@otaku42.de>
> Cc: Markus Armbruster <armbru@redhat.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  drivers/video/fb_defio.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
> index 59df132..214bb7c 100644
> --- a/drivers/video/fb_defio.c
> +++ b/drivers/video/fb_defio.c
> @@ -114,11 +114,23 @@ static struct vm_operations_struct
> fb_deferred_io_vm_ops = {
>  	.page_mkwrite	= fb_deferred_io_mkwrite,
>  };
>  
> +static int fb_deferred_io_set_page_dirty(struct page *page)
> +{
> +	if (!PageDirty(page))
> +		SetPageDirty(page);
> +	return 0;
> +}
> +
> +static const struct address_space_operations fb_deferred_io_aops = {
> +	.set_page_dirty = fb_deferred_io_set_page_dirty,
> +};
> +
>  static int fb_deferred_io_mmap(struct fb_info *info, struct
> vm_area_struct *vma)
>  {
>  	vma->vm_ops = &fb_deferred_io_vm_ops;
>  	vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
>  	vma->vm_private_data = info;
> +	vma->vm_file->f_mapping->a_ops = &fb_deferred_io_aops;
>  	return 0;
>  }
>  
> -- 
> 1.5.6.3
> 

