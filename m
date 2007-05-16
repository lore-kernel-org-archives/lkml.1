Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXEPQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXEPQ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXEPQ5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:57:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXEPQ5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:57:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464B3209.4010003@yahoo.com.au>
References: <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 17:56:27 +0100
Message-ID: <23262.1179334587@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > I can't call invalidate_inode_pages() or similar because that might
> > incorrectly kill one of B's writes (or someone else's writes); besides,
> > the on-server file hasn't changed.
> 
> Why would that kill anyone's writes?

Because invalidate_inode_pages() forcibly removes the dirty flag from each page
in the inode and then calls invalidatepage() - and thus they don't get written
back, but some of those pages may contain writes from other processes.  The
whole inode isn't owned by one user at a time.

I hadn't considered invalidate_inode_pages_range(), but that suffers from the
deadlock problem.

> > I can't as it can/would deadlock if called from prepare_write() in two
> > different ways.
> 
> Which ways? Are you talking about prepare_write being called from
> page_mkwrite, or anywhere?

 (1) prepare_write() is called with the target page locked and does not release
     the lock.  The truncation routines lock the page prior to invalidating it.
     Any truncation routine that skips locked pages is of no use.

 (2) Consider a run of pages that make up a single write by one user.  Two
     other writes from other users may be attempting to overwrite that run at
     the same time.  Each of them would need to invalidate the other's locked
     page(s).

Furthermore, the caller of prepare_write() probably won't take kindly to the
page it's dealing with being evicted from the pagecache.

> More generally it sounds like a nasty thing to have a writeback cache if it
> can become incoherent (due to dirty pages that subsequently cannot be
> written back) without notification. Have you tried doing a write-through
> one?

How do you do a write-through cache for shared-writable mmap?

> You may be clearing PG_uptodate, but isn't there still an underlying problem
> that you can have mappings to the page at that point? If that isn't a problem
> for you, then I don't know why you would have to clear PG_uptodate at all.

There might be, yes.  I guess I should ask the VM to nuke all PTEs to each of
these pages too.

David
