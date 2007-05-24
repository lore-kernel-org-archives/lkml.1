Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbXEXXTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbXEXXTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbXEXXSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:18:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXEXXSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:18:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1180046115.8872.27.camel@heimdal.trondhjem.org>
References: <1180046115.8872.27.camel@heimdal.trondhjem.org> <20070524133821.3ee9c9f3.akpm@linux-foundation.org> <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com> <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com> <27608.1180042522@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from the pagecache
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Fri, 25 May 2007 00:18:45 +0100
Message-ID: <29320.1180048725@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> No. If the write fails, then NFS will mark the mapping as invalid and
> attempt to call invalidate_inode_pages2() at the earliest possible
> moment.

Will it erase *all* unwritten writes?  Or is that what launder_page() is for?

How do you deal with pages that were in the process of being written out when
that particular write was rejected?  Do you just summarily clear PG_writeback
and hope no-one else looks at the page until invalidate_inode_pages2() gets
around to excising it?  Or do you have a better way?

> I'm adding in a patch to defer marking the page as uptodate until the
> write is successful in cases where NFS is writing a pristine page.

That sounds reasonable, though it doesn't help in the case I'm looking at.  Do
you also munge i_size if the write fails?

> As for pages that are already marked as uptodate, well you already have
> a race: you have deferred the page write, and so other processes may
> already have read the rejected data before you tried to write it out.

Yeah, I know, and that's very difficult to deal with without some formal
transaction rollback mechanism.  I think that the best I can do is to discard
the dodgy data that I've got lurking in the pagecache, but I still have to
deal with writes made by other users to that file after the rejected write.

There isn't a perfect way of dealing with it, given the circumstances.

David
