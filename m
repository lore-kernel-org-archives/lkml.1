Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYHRIGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYHRIGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYHRIF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:05:58 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:37395 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751345AbYHRIF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:05:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xRIqSkSzNGeSm92O/Uy6T9glbMgQp28JiRDpG/lvJijCO4cr3LFv2+HECyRZxhoQcgT5/6LINzyifiEDHZ7qwPrefZ4KVkyyEYIkEprCnAhTSY77JgCVEnslKy0K3GGDC63GqQEszNFsm+2bDYeDY/IojRWHO+I7o4qDZZU8Z1Q=  ;
X-YMail-OSG: syY_GZEVM1kuOnQtHyT_HpsAPKcpZk36kSRZ5JaMhyQWb7.Jn8t4v0TbPRBlRkMCauexb7L4aTlGv7aSCmEk4w05hAOD2AwlyiGZnsbwv8pKcE9ZlyNKA3Foha4DotQlbdBuYhzN6po2QRJpBh4rrTlx
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
Date: Mon, 18 Aug 2008 18:05:43 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
References: <1218697362.26014.9.camel@localhost.localdomain> <200808181132.43718.nickpiggin@yahoo.com.au> <1219046079.3996.11.camel@localhost.localdomain>
In-Reply-To: <1219046079.3996.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181805.44187.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 17:54, Ian Campbell wrote:
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
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks,
Acked-by: Nick Piggin <npiggin@suse.de>

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
