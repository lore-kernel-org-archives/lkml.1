Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYHDSkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYHDSkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756633AbYHDSjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:39:40 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56293 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbYHDSjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:39:37 -0400
Date: Mon, 4 Aug 2008 19:39:32 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Keith Packard <keithp@keithp.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
In-Reply-To: <1217870748.24714.79.camel@koto.keithp.com>
Message-ID: <Pine.LNX.4.64.0808041855050.5717@blonde.site>
References: <1217573919-7496-1-git-send-email-eric@anholt.net> 
 <200808041902.23970.nickpiggin@yahoo.com.au>  <1217845590.24714.45.camel@koto.keithp.com>
  <200808042043.46710.nickpiggin@yahoo.com.au>  <1217850352.24714.66.camel@koto.keithp.com>
  <Pine.LNX.4.64.0808041720500.25617@blonde.site> <1217870748.24714.79.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, Keith Packard wrote:
> On Mon, 2008-08-04 at 18:09 +0100, Hugh Dickins wrote:
> 
> > Whether such usage conforms to VFS API I'm not so sure: as I understand
> > it, it's really for internal use by a filesystem
> 
> Sure, but presumably it could even be used by a layered file system?

Could, yes, but should? I wouldn't presume to answer with any authority.

> >  - if it's going to be
> > used beyond that, we ought to add a check that the filesystem it's used
> > upon really has a ->readpage method (and I'd rather we add such a check
> > than you do it at your end, in case we change the implementation later
> > to use something other than a ->readpage method - Nick, you'll be
> > nauseated to hear I was looking to see if ->fault with a pseudo-vma
> > could do it).  But if the layering police are happy with this, I am.
> 
> It seems like I should put a check into my code that is kernel version
> dependent so that I can't oops if someone tries to use a filesystem that
> doesn't have ->readpage.

Well, I guess put the check on ->readpage into your code for now, and
by the time GEM gets into Linus's tree, we should have -EINVAL checks
on NULL filler() in __read_cache_page() and read_cache_page_async(),
so remove check at your end before final submission.

(You could leave it there, and strictly we ought to update GEM if we
make any change to our implementation; but it is the kind of detail
that gets overlooked - witness the way I failed to grasp the readahead
side-effects of adding ->readpage into tmpfs until recently.  I'm just
afraid we'd break you unwittingly: better not, though easily fixed.)

I'm not sending the patch right now, waiting to see if this direction
wins general favour.

> So, when I release the pages from the page cache, I'm currently calling
> mark_page_accessed for all pages, and set_page_dirty for pages which may
> have been written by the GPU. Are those calls still needed?

I think you should drop the mark_page_accessed(): that's done in
read_cache_page_async() as part of the initial read_mapping_page().
But do it again when releasing if you think there's a good chance
that object will be wanted again shortly.  set_page_dirty() if
modified by GPU, yes, that would still be needed.

For how long are these objects' pages pinned in memory like this?
I ask because Rik & Lee have patches in -mm, trying to avoid long
scans of LRUs cluttered with unevictable pages.  I've no idea
whether you're adding a lot or a little to that problem.

Hugh
