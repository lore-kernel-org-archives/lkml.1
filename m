Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbXEPNRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbXEPNRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXEPNRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:17:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXEPNRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:17:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464AF3F3.30204@yahoo.com.au>
References: <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 14:16:31 +0100
Message-ID: <17173.1179321391@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> I would strongly suggest you used (0, PAGE_CACHE_SIZE) for the range,

That tells prepare_write() that the region to be modified is the whole page -
which is incorrect.  We're going to change a little bit of it.

Hmmm... Thinking about it again, I probably shouldn't be using
afs_prepare_write() at all.  afs_prepare_write() does two things:

 (1) Fills in the bits around the edges of the region to be modified if the
     page is not up to date.

 (2) Records the region of the page to be modified.

If afs_prepare_write() function is invoked by write(), then the region in (2)
is known, and thus the edges are known.

But if it's called from page_mkwrite(), we don't know where the edges are, so
we have to refresh the entire page if it's not up to date, and then we have to
record that the entire page needs writing back as we don't know which bits
have changed.

> and have your nopage function DTRT.

That assumes nopage() will be called in all cases - which it won't.

> Rather than add this (not always correct) comment about the VM workings, I'd
> just add a directive in the page_mkwrite API documentation that the filesystem
> is to return 0 if the page has been truncated.

I still want to put a comment in my code to say *why* I'm doing this.

> Minor issue: you can just check for `if (!page->mapping)` for truncation,
> which is the usual signal to tell the reader you're checking for truncate.

That's inconsistent with other core code, truncate_complete_page() for
example.

> Then you can remove the comment...

The comment stays, though I'm willing to improve it.

David
