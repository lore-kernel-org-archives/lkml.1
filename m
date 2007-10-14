Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbXJNRY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbXJNRY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXJNRYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:24:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48025 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbXJNRYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:24:18 -0400
Date: Sun, 14 Oct 2007 13:23:50 -0400
Message-Id: <200710141723.l9EHNowh015023@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Hugh Dickins" <hugh@veritas.com>, "Ryan Finnie" <ryan@finnie.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Erez Zadok" <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-reply-to: Your message of "Sun, 14 Oct 2007 20:09:34 +0300."
             <84144f020710141009xbc5bb71w64e8288f364ab491@mail.gmail.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <84144f020710141009xbc5bb71w64e8288f364ab491@mail.gmail.com>, "Pekka Enberg" writes:
> Hi Hugh,
> 
> On Sat, 13 Oct 2007, Pekka Enberg wrote:
> > Doesn't msync(2) get to it via mm/page-writeback.c:write_cache_pages()
> > without unionfs even?
> 
> On 10/14/07, Hugh Dickins <hugh@veritas.com> wrote:
> > I believe not.  Please do double-check my assertions, I've always found
> > the _writepages paths rather twisty; but my belief (supported by the
> > fact that we've not hit shmem_writepage's BUG_ON(page_mapped(page))
> > in five years) is that tmpfs/shmem opts out of all of that with its
> >         .capabilities   = BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
> > in shmem_backing_dev_info, which avoids all those _writepages avenues
> > (e.g. through bdi_cap_writeback_dirty tests), and write_cache_pages is
> > just a subfunction of the _writepages.
> 
> Thanks for the explanation, you're obviously correct.
> 
> However, I don't think the mapping_cap_writeback_dirty() check in
> __filemap_fdatawrite_range() works as expected when tmpfs is a lower
> mount for an unionfs mount. There's no BDI_CAP_NO_WRITEBACK capability
> for unionfs mappings so do_fsync() will call write_cache_pages() that
> unconditionally invokes shmem_writepage() via unionfs_writepage().
> Unless, of course, there's some other unionfs magic I am missing.
> 
>                                    Pekka

In unionfs_writepage() I tried to emulate as best possible what the lower
f/s will have returned to the VFS.  Since tmpfs's ->writepage can return
AOP_WRITEPAGE_ACTIVATE and re-mark its page as dirty, I did the same in
unionfs: mark again my page as dirty, and return AOP_WRITEPAGE_ACTIVATE.

Should I be doing something different when unionfs stacks on top of tmpfs?
(BTW, this is probably also relevant to ecryptfs.)

Thanks,
Erez.
