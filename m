Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXCPGot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXCPGot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 02:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbXCPGos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 02:44:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:23680 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXCPGor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 02:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BHsHmCouY2CqLW7p9LJgf/Y2cKq8ctkGc+gGbmHFZBwPTLzkojofY0NDeyLXuLFqUZwpQC6kpQLWBV78hbGWYAyEF8izDyBNbmwGtVcCd/TKwvGNIXjfrEGXhod8fMV1NHS0wblbzUOqFlr9xBcRU1DgZnynCjw8+tsuaR3oPmo=
Message-ID: <84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
Date: Fri, 16 Mar 2007 08:44:46 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] revoke: core code
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070315173438.efadd514.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	 <20070315173438.efadd514.akpm@linux-foundation.org>
X-Google-Sender-Auth: 0c149e5ff7f69e28
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Sun, 11 Mar 2007 13:30:49 +0200 (EET) Pekka J Enberg
<penberg@cs.helsinki.fi> wrote:

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> noooo.... all system calls must return long.

Fixed.

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> so....  the modification of vm_flags is racy?
>
> > +     smp_mb();
>
> Please always document barriers.  There's presumably some vm_flags reader
> we're concerned about here, but how is the code reader to know what the
> code writer was thinking?

We're need to watch out for page faults after the shared mappings have
been taken down and mmap(2) trying to remap. I'll add a comment here.

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> This all looks very strange.  If the calling process expires its timeslice,
> the entire system call fails?
>
> What's happening here?

Me being stupid. I followed what unmap_mapping_range_vma is doing but
failed to see what its callers are doing. I'll fix it up.

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> do_fsync() is seriously suboptimal - it will run an ext3 commit.
> do_sync_file_range(...,
> SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER)
> will run maybe five times quicker.
>
> But otoh, do_sync_file_range() will fail to write back the pages for a
> data=journal ext3 file, I expect (oops).

But it's good enough for generic_file_revoke, no? Ext3 should probably
implement it's own revoke hook so you can drop the ext2 and ext3 hooks
if you're worried, I did them mostly for testing.

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> Why is this code using invalidate_inode_pages2()?  That function keeps on
> breaking, has ill-defined semantics and will probably change in the future.
>
> Exactly what semantics are you looking for here, and why?

What the comment says "make pending reads fail." When revoking an
inode, we need to make sure there are no pending I/O that will
complete after revocation and thus leak information.

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> The blank line before the EXPORT_SYMBOL() is a waste of space.

I'll fix that up.

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > +static struct inode *revokefs_alloc_inode(struct super_block *sb)
> > +{
> > +     struct revokefs_inode_info *info;
> > +
> > +     info = kmem_cache_alloc(revokefs_inode_cache, GFP_NOFS);
> > +     if (!info)
> > +             return NULL;
> > +
> > +     return &info->vfs_inode;
> > +}
>
> Why GFP_NOFS?

GFP_KERNEL should be sufficient. I'll fix that up.

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > ===================================================================
> > --- /dev/null 1970-01-01 00:00:00.000000000 +0000
> > +++ uml-2.6/include/linux/revoked_fs_i.h      2007-03-11 13:09:20.000000000 +0200
> > @@ -0,0 +1,20 @@
> > +#ifndef _LINUX_REVOKED_FS_I_H
> > +#define _LINUX_REVOKED_FS_I_H
> > +
> > +#define REVOKEFS_MAGIC 0x5245564B      /* REVK */
>
> This is supposed to go into magic.h.

Will do. Thank you Andrew.
