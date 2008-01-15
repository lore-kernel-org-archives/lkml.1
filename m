Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYAORSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYAORSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 12:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYAORSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 12:18:35 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:8473 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYAORSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 12:18:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nv3bRhR9MXd+rDzGjgBbEWg+tjsCu/SGfiRDFpy86v0wyVHHJMDqJVQ3xAlqHh8d3PAsORQcLK3IWN8BKsVKwwJHvBog3pPmT7QbfOOcp2dP1xMBotfDid+4T/cMbIxnakBAdLCQCV1GKzyF6kzUX3i+qKSJx0RoU3DEzxcxPLU=
Message-ID: <4df4ef0c0801150918l71504c81s49fc8c9e427896f3@mail.gmail.com>
Date: Tue, 15 Jan 2008 20:18:32 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] Updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com, miklos@szeredi.hu
In-Reply-To: <1200414911.26045.32.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	 <1200412978699-git-send-email-salikhmetov@gmail.com>
	 <1200414911.26045.32.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/15, Peter Zijlstra <a.p.zijlstra@chello.nl>:
>
> On Tue, 2008-01-15 at 19:02 +0300, Anton Salikhmetov wrote:
>
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 3d3848f..53d0e34 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -997,35 +997,39 @@ int __set_page_dirty_no_writeback(struct page *page)
> >   */
> >  int __set_page_dirty_nobuffers(struct page *page)
> >  {
> > -     if (!TestSetPageDirty(page)) {
> > -             struct address_space *mapping = page_mapping(page);
> > -             struct address_space *mapping2;
> > +     struct address_space *mapping = page_mapping(page);
> > +     struct address_space *mapping2;
> >
> > -             if (!mapping)
> > -                     return 1;
> > +     if (!mapping)
> > +             return 1;
> >
> > -             write_lock_irq(&mapping->tree_lock);
> > -             mapping2 = page_mapping(page);
> > -             if (mapping2) { /* Race with truncate? */
> > -                     BUG_ON(mapping2 != mapping);
> > -                     WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
> > -                     if (mapping_cap_account_dirty(mapping)) {
> > -                             __inc_zone_page_state(page, NR_FILE_DIRTY);
> > -                             __inc_bdi_stat(mapping->backing_dev_info,
> > -                                             BDI_RECLAIMABLE);
> > -                             task_io_account_write(PAGE_CACHE_SIZE);
> > -                     }
> > -                     radix_tree_tag_set(&mapping->page_tree,
> > -                             page_index(page), PAGECACHE_TAG_DIRTY);
> > -             }
> > -             write_unlock_irq(&mapping->tree_lock);
> > -             if (mapping->host) {
> > -                     /* !PageAnon && !swapper_space */
> > -                     __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> > +     mapping->mtime = CURRENT_TIME;
> > +     set_bit(AS_MCTIME, &mapping->flags);
>
> This seems vulnerable to the race we have against truncate, handled by
> the mapping2 magic below. Do we care?
>
> > +
> > +     if (TestSetPageDirty(page))
> > +             return 0;
> > +
> > +     write_lock_irq(&mapping->tree_lock);
> > +     mapping2 = page_mapping(page);
> > +     if (mapping2) {
> > +             /* Race with truncate? */
> > +             BUG_ON(mapping2 != mapping);
> > +             WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
> > +             if (mapping_cap_account_dirty(mapping)) {
> > +                     __inc_zone_page_state(page, NR_FILE_DIRTY);
> > +                     __inc_bdi_stat(mapping->backing_dev_info,
> > +                                     BDI_RECLAIMABLE);
> > +                     task_io_account_write(PAGE_CACHE_SIZE);
> >               }
> > -             return 1;
> > +             radix_tree_tag_set(&mapping->page_tree,
> > +                             page_index(page), PAGECACHE_TAG_DIRTY);
> >       }
> > -     return 0;
> > +     write_unlock_irq(&mapping->tree_lock);
> > +
> > +     if (mapping->host)
> > +             __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);

The inode gets marked dirty using the same "mapping" variable
as my code does. So, AFAIU, my change does not introduce any new
vulnerabilities. I would nevertherless be grateful to you for a scenario
where the race would be triggered.

> > +
> > +     return 1;
> >  }
> >  EXPORT_SYMBOL(__set_page_dirty_nobuffers);
> >
>
>
