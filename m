Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYHDRJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYHDRJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbYHDRJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:09:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:53904 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbYHDRJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:09:21 -0400
Date: Mon, 4 Aug 2008 18:09:24 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Keith Packard <keithp@keithp.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
In-Reply-To: <1217850352.24714.66.camel@koto.keithp.com>
Message-ID: <Pine.LNX.4.64.0808041720500.25617@blonde.site>
References: <1217573919-7496-1-git-send-email-eric@anholt.net> 
 <200808041902.23970.nickpiggin@yahoo.com.au>  <1217845590.24714.45.camel@koto.keithp.com>
  <200808042043.46710.nickpiggin@yahoo.com.au> <1217850352.24714.66.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, Keith Packard wrote:
> On Mon, 2008-08-04 at 20:43 +1000, Nick Piggin wrote:
> > read_mapping_page might help there.
> 
> That does look a lot more like what I want, as it returns an unlocked
> page. And, makes my code look cleaner to boot:
> 
>         inode = obj->filp->f_path.dentry->d_inode;
>         mapping = inode->i_mapping;
>         for (i = 0; i < page_count; i++) {
>                 page = read_mapping_page(mapping, i, NULL);
>                 if (IS_ERR(page)) {
>                         ret = PTR_ERR(page);
>                         DRM_ERROR("read_mapping_page failed: %d\n", ret);
>                         i915_gem_object_free_page_list(obj);
>                         return ret;
>                 }
>                 obj_priv->page_list[i] = page;
>         }
> 
> Does this look like it conforms to the vfs api? It appears to work when
> using shmem at least.

Yes, that's a good suggestion from Nick, should work with shmem/tmpfs
(with *proviso below) and others, and big improvement to your generality.

Whether such usage conforms to VFS API I'm not so sure: as I understand
it, it's really for internal use by a filesystem - if it's going to be
used beyond that, we ought to add a check that the filesystem it's used
upon really has a ->readpage method (and I'd rather we add such a check
than you do it at your end, in case we change the implementation later
to use something other than a ->readpage method - Nick, you'll be
nauseated to hear I was looking to see if ->fault with a pseudo-vma
could do it).  But if the layering police are happy with this, I am.

The *proviso is that for tmpfs itself this actually isn't as convenient
as directly using shmem_getpage: because this way passes a page in to
shmem_getpage, when maybe the page wanted is already here but currently
marked as swapcache rather than filecache.  It's an awkward extension
that allows tmpfs to support ->readpage at all.  But that route is in
use and well-tested, and only an inefficiency when swapping, so should
not cause you any problems.

(I have been agonizing over the way __read_cache_page, like your
original i915_gem_object_get_page_list, uses find_get_page: whereas
shmem_getpage uses find_lock_page.  I remember the latter is important,
but don't quite remember all the why.  I'm believing that it's really
only the ->fault usage where it becomes vital: things get confused, on
2.4 more than 2.6, if a swapcache tmpfs page is mapped into userspace.)

You don't examine page->mapping at all: good, there's a race by which
it could go to NULL after you acquired the page by read_mapping_page:
not by file truncation, but by swapping out at the wrong instant.
Don't worry, you have the right page, just don't rely on page->mapping.

(Sorry if I'm rather talking aloud to myself here.)

Hugh
