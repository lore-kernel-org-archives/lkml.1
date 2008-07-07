Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYGGRUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYGGRUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYGGRUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:20:12 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:60418 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbYGGRUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:20:11 -0400
Subject: RE: nfs client readdir caching issue?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andy Chittenden <andyc@bluearc.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <0F10A59FDFFDFD4E9BEBD7365DE6725501F64C4B@uk-email.terastack.bluearc.com>
References: <0F10A59FDFFDFD4E9BEBD7365DE6725501EC3707@uk-email.terastack.bluearc.com>
	 <1215020245.9783.10.camel@localhost>
	 <0F10A59FDFFDFD4E9BEBD7365DE6725501F64C4B@uk-email.terastack.bluearc.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 13:20:07 -0400
Message-Id: <1215451207.19512.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: C77144C509735C4E80B6A227D370066BE9F090A6
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 99 total 9132083 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-03 at 09:47 +0100, Andy Chittenden wrote:
> > If so, then invalidate_inode_pages2_range() would have to be broken:
> we
> > always clear the readdir cache immediately after reading in the page
> > with index 0 (i.e. the first readdir page).
> 
> I'm confused by the call to invalidate_inode_pages2_range:
> 
>         if (page->index == 0)
>                 invalidate_inode_pages2_range(inode->i_mapping,
> PAGE_CACHE_SIZE, -1);
> 
> That's passing in a pgoff_t of 4096 as the start page offset from which
> to invalidate. And an enormous number for the end page to invalidate to.
> So it looks like the nfs client is trying to invalidate from a *byte*
> offset of 4096 (but if that's true, the first page could contain less
> than 4096 bytes depending on the size of the readdir response it
> received but I'll leave that to one side for the moment).
> 
> What's confusing me is that when I look at the implementation of
> invalidate_inode_pages2_range, I see this call to pagevec_lookup:
> 
>                 pagevec_lookup(&pvec, mapping, next,
>                         min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1))
> {
> 
> looking at the pagevec_lookup comments, it claims the fourth parameter
> is the number of pages:
> 
> * @nr_pages:   The maximum number of pages
> 
> So how can (end - next) be a number of pages? (next will be 4096 in the
> call from the nfs client). IE it looks like
> invalidate_inode_pages2_range is expecting a page range (as the name
> suggests). IE I'm wondering whether the call to
> invalidate_inode_pages2_range should be:
> 
>         if (page->index == 0)
>                 invalidate_inode_pages2_range(inode->i_mapping, 1, -1);
> 
> FWIW We've also seen this on larger directories so I'm wondering what
> would happen if a readdir part way down the cookie chain returned more
> data (or less) than it did last time. IE if the above is correct, then
> replace the two lines with:
> 
> 	invalidate_inode_pages2_range(inode->i_mapping, page->index + 1,
> -1);
> 
> IE purge the rest of the pages for the inode.

Hi Andy,

Apologies for the late response. I was travelling on Thursday, and got
caught up with the long weekend due to the July 4th holiday in the US.


Yes, I agree with your comment above: the
invalidate_inode_pages2_range() call is specifying a byte range instead
of a page index range, and is therefore wrong.

Another thought is that individual pages might perhaps get evicted by VM
pressure, in which case we might perhaps want to re-read not only the
evicted page, but all subsequent pages too (in case the server returns
more/less data per page so that the alignment of the next entry
changes).

Cheers
  Trond
-------------------------------------------------------------------------
From: Trond Myklebust <Trond.Myklebust@netapp.com>
NFS: Fix readdir cache invalidation

invalidate_inode_pages2_range() takes page offset arguments, not byte
ranges.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 58d43da..982a206 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -204,7 +204,7 @@ int nfs_readdir_filler(nfs_readdir_descriptor_t *desc, struct page *page)
 	 * Note: assumes we have exclusive access to this mapping either
 	 *	 through inode->i_mutex or some other mechanism.
 	 */
-	if (page->index == 0 && invalidate_inode_pages2_range(inode->i_mapping, PAGE_CACHE_SIZE, -1) < 0) {
+	if (invalidate_inode_pages2_range(inode->i_mapping, page->index + 1, -1) < 0) {
 		/* Should never happen */
 		nfs_zap_mapping(inode, inode->i_mapping);
 	}


