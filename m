Return-Path: <linux-kernel-owner+w=401wt.eu-S1946246AbXBPW2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946246AbXBPW2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946249AbXBPW2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:28:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:51263 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946246AbXBPW2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:28:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L9GHJ1I2fJzC6lP7Q3/C27bUM8Pc+FNkF0mKZ280Z8AokoNtuDkNnlm8tFBjdD+rCm5+8OTt1xALqWNQOuQY+xAr59hLyMFk3yV+fDaYurSrVJFiwytMFQXhVV+FlZzXERplblJx7JcGKMcHDGUxp+rEPwyJ1h3G8jGmXxowfos=
Message-ID: <a4e6962a0702161428p240ab9acwd0a384dedd1b99e6@mail.gmail.com>
Date: Fri, 16 Feb 2007 16:28:31 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] 9p: add write-cache support to loose cache mode (take 3)
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
In-Reply-To: <20070216121226.f2382a17.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11715506591894-git-send-email-ericvh@gmail.com>
	 <1171640221420-git-send-email-ericvh@gmail.com>
	 <20070216121226.f2382a17.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 16 Feb 2007 09:37:01 -0600 Eric Van Hensbergen <ericvh@gmail.com> wrote:
>
> > +static int v9fs_vfs_writepage(struct page *page, struct writeback_control *wbc)
> > +{
> > +     char *buffer = NULL;
> > +     struct address_space *mapping = page->mapping;
> > +     int retval = -EIO;
> > +     loff_t offset = 0;
> > +     pgoff_t end_index;
> > +     int count = PAGE_CACHE_SIZE;
> > +     struct file *filp = v9fs_find_file(page);
> > +     struct inode *inode = mapping->host;
> > +
> > +     dprintk(DEBUG_VFS, "page: %p\n", page);
> > +
> > +     if ((!inode) || (!filp))
> > +             goto UnlockPage;
> > +
> > +     end_index = inode->i_size >> PAGE_CACHE_SHIFT;
> > +
> > +     /* complicated case at end of file */
> > +     if (page->index >= end_index) {
> > +             /* things got complicated... */
> > +             count = inode->i_size & (PAGE_CACHE_SIZE - 1);
> > +             if (page->index >= end_index + 1 || !count)
> > +                     return 0;       /* truncated - don't care */
> > +     }
> > +
> > +     buffer = kmap(page);
> > +     offset = ((loff_t) page->index << PAGE_CACHE_SHIFT);
> > +     page_cache_get(page);
> > +     retval = v9fs_write(filp, NULL, buffer, count, &offset);
> > +
> >       kunmap(page);
> > +
> > +      UnlockPage:
> >       unlock_page(page);
> > +     page_cache_release(page);
> > +
> >       return retval;
> >  }
>
> The page_cache_get/release here aren't needed: lock_page suffices.
>
> Are you sure the page refcounting is right if the `goto UnlockPage'
> happens?
>
> Can that goto actually happen??
>

It shouldn't, if it does we are probably in big trouble anyways.  I'll
pull it out.  Thanks.

                  -eric
