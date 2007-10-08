Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbXJHXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbXJHXhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXJHXhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:37:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59720 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752284AbXJHXhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:37:23 -0400
Date: Tue, 9 Oct 2007 09:36:37 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       David Howells <dhowells@redhat.com>, Dave Chinner <dgc@sgi.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, mark.fasheh@oracle.com,
       hugh <hugh@veritas.com>, stable <stable@kernel.org>
Subject: Re: [PATCH] mm: set_page_dirty_balance() vs ->page_mkwrite()
Message-ID: <20071008233637.GF995458@sgi.com>
References: <1191862477.20745.22.camel@twins> <200710081637.01122.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710081637.01122.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 04:37:00PM +1000, Nick Piggin wrote:
> On Tuesday 09 October 2007 02:54, Peter Zijlstra wrote:
> > It seems that with the recent usage of ->page_mkwrite() a little detail
> > was overlooked.
> >
> > .22-rc1 merged OCFS2 usage of this hook
> > .23-rc1 merged XFS usage
> > .24-rc1 will most likely merge NFS usage
> >
> > Please consider this for .23 final and maybe even .22.x
> >
> > ---
> > Subject: mm: set_page_dirty_balance() vs ->page_mkwrite()
> >
> > All the current page_mkwrite() implementations also set the page dirty.
> > Which results in the set_page_dirty_balance() call to _not_ call balance,
> > because the page is already found dirty.
> >
> > This allows us to dirty a _lot_ of pages without ever hitting
> > balance_dirty_pages().  Not good (tm).
> >
> > Force a balance call if ->page_mkwrite() was successful.
> 
> Would it be better to just have the callers set_page_dirty_balance()?

block_page_mkwrite() is just using generic interfaces to do this,
same as pretty much any write() system call. The idea was to make it
as similar to the write() call path as possible...

However, unlike generic_file_buffered_write(), we are not calling
balance_dirty_pages_ratelimited(mapping) between
->prepare/commit_write call pairs.  Perhaps this should be added to
block_page_mkwrite() after the page is unlocked....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
