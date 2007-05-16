Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbXEPQNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbXEPQNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbXEPQNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:13:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXEPQM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:12:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464B07EC.4050308@yahoo.com.au>
References: <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 17:12:08 +0100
Message-ID: <19714.1179331928@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> In general (modulo bugs and crazy filesystems), you're not allowed to have
> !uptodate pages mapped into user addresses because that implies the user
> would be allowed to see garbage.

Ths situation I have to deal with is a tricky one.  Consider:

 (1) User A modifies a page with his key.  This change gets made in the
     pagecache, but is not written back immediately.

 (2) User B then wants to modify the same page, but with a different key.
     This means that afs_prepare_write() has to flush A's writes back to the
     server before B is permitted to write.

 (3) The flush fails because A is no longer permitted to write to that file.
     This means that the change in the page cache is now stale.  We can't just
     write it back as B because B didn't make the change.

What I've made afs_prepare_write() do in this situation is to nuke A's entire
write.  We can't write any of it back.  I can't call invalidate_inode_pages()
or similar because that might incorrectly kill one of B's writes (or someone
else's writes); besides, the on-server file hasn't changed.

To nuke A's write, each page that makes up that write is marked non-uptodate
and then reloaded.  Whilst I might wish to call invalidate_inode_pages_range(),
I can't as it can/would deadlock if called from prepare_write() in two
different ways.

> >>Minor issue: you can just check for `if (!page->mapping)` for truncation,
> >>which is the usual signal to tell the reader you're checking for truncate.
> >
> >
> > That's inconsistent with other core code, truncate_complete_page() for
> > example.
> 
> Your filesystem internally moves pages between mappings like tmpfs?

You misunderstand me.  truncate_complete_page() uses this:

	if (page->mapping != mapping)

not this:

	if (!page->mapping)

I think that both cases should work in page_mkwrite().  But !page->mapping does
not appear to be the "usual signal" from what I've seen.

However, that's a minor matter.

David
