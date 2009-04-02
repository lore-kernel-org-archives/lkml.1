Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZDBOV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZDBOV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZDBOVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:21:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43220 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbZDBOVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:21:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030051.10644.nickpiggin@yahoo.com.au>
References: <200904030051.10644.nickpiggin@yahoo.com.au> <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230347.28177.28093.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/43] FS-Cache: Release page->private after failed readahead [ver #46]
Date: Thu, 02 Apr 2009 15:21:07 +0100
Message-ID: <5069.1238682067@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> This does not release the page for which the filler function fails.

That's a good point.  That page is attached to the pagecache and the LRU by
that point.  I suppose the page could be removed (but someone else may be
trying to reference it by this point), or I could amend the patch text to:

	The attached patch causes read_cache_pages() to release page-private
	data on a page for which add_to_page_cache() fails.  If the filler
	function fails, then the problematic page is left attached to the
	pagecache (with appropriate flags set, one presumes) and the remaining
	to-be-attached pages are invalidated and discarded.  This permits
	pages with caching references associated with them to be cleaned up.

	The invalidatepage() address space op is called (indirectly) to do the
	honours.

How about that?

> I don't have a problem with this if it is significantly easier to do here
> than the caller -- it should be a slowpath.

It could be done in the caller - every caller of read_cache_pages() that might
have the pages pre-annotated.  But the changes are all in the error handling
path.  If read_cache_pages() doesn't see an error, these changes are not
activated.

David
