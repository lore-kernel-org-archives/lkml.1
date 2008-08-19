Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYHSGkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYHSGkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYHSGkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:40:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYHSGkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:40:09 -0400
Date: Mon, 18 Aug 2008 23:38:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Kel Modderman <kel@otaku42.de>,
       Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
Message-Id: <20080818233824.5d219105.akpm@linux-foundation.org>
In-Reply-To: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 07:02:45 +0100 Ian Campbell <ijc@hellion.org.uk> wrote:

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
> Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
> Acked-by: Nick Piggin <npiggin@suse.de>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Johannes Weiner <hannes@saeurebad.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Kel Modderman <kel@otaku42.de>
> Cc: Markus Armbruster <armbru@redhat.com>
> Cc: stable@vger.kernel.org [14fcc23fd is in 2.6.25.14 and 2.6.26.1]
> ---
>  drivers/video/fb_defio.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
> index 59df132..214bb7c 100644
> --- a/drivers/video/fb_defio.c
> +++ b/drivers/video/fb_defio.c
> @@ -114,11 +114,23 @@ static struct vm_operations_struct fb_deferred_io_vm_ops = {
>  	.page_mkwrite	= fb_deferred_io_mkwrite,
>  };
>  
> +static int fb_deferred_io_set_page_dirty(struct page *page)
> +{
> +	if (!PageDirty(page))
> +		SetPageDirty(page);
> +	return 0;
> +}

<searches, finds the thread.  "kernel BUG at lib/radix-tree.c:473!">

Is there actually any benefit in setting these pages dirty?  Or should
this be an empty function?  I see claims in the above thread that this
driver uses PG_dirty for optimising writeback but I can't immediately
locate any code which actually does that.

> +static const struct address_space_operations fb_deferred_io_aops = {
> +	.set_page_dirty = fb_deferred_io_set_page_dirty,
> +};
> +
>  static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
>  {
>  	vma->vm_ops = &fb_deferred_io_vm_ops;
>  	vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
>  	vma->vm_private_data = info;
> +	vma->vm_file->f_mapping->a_ops = &fb_deferred_io_aops;
>  	return 0;
>  }

Seems a bit odd to rewrite the address_space_operations at mmap()-time.
A filesystem will usually do this on the inode when it is first being
set up, when no other thread of control can be looking at it.

	grep 'if .*[-]>a_ops' */*.c

and you'll see that lots of code assumes that a_ops doesn't get
swizzled around (to contain a bunch of NULL pointers!) under its feet. 
Maybe none of those code paths are applicable to the /dev/fb0 inode,
but it would be painful to work out which paths _are_ applicable and to
verify that they're all safe wrt a_ops getting whisked away.

Rewriting page->mapping within the vm_operations_struct.fault handler
seems a bit suspect for similar reasons.

I suspect that we just shouldn't be pretending that this is a regular
anon/pagecache page to this extent.  Maybe a suitable fix would be to
teach fb_deferred_io_fault() to instantiate the pte itself
(vm_insert_page()) and then return VM_FAULT_NOPAGE?

I assume there's a reason why we aren't VM_IO/VM_RESERVED/PG_reserved in
here.

