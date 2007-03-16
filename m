Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbXCPL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbXCPL0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXCPL0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:26:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41766 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbXCPL0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:26:48 -0400
Date: Fri, 16 Mar 2007 03:26:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/5] revoke: core code
Message-Id: <20070316032624.c6db84fc.akpm@linux-foundation.org>
In-Reply-To: <84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	<20070315173438.efadd514.akpm@linux-foundation.org>
	<84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 08:44:46 +0200 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > Why is this code using invalidate_inode_pages2()?  That function keeps on
> > breaking, has ill-defined semantics and will probably change in the future.
> >
> > Exactly what semantics are you looking for here, and why?
> 
> What the comment says "make pending reads fail." When revoking an
> inode, we need to make sure there are no pending I/O that will
> complete after revocation and thus leak information.

hm, let's define "pending".

I assume that any future callers to sys_read() will reliably do the right
thing at this stage, so we are concerned with threads which are presently
partway through a read from this inode?

If that's not accurate then please describe with some detail exactly what
semantics you're looking for here.

If it _is_ accurate then hm, tricky.  It all rather depends upon how the
relevant filesystem implements reading (and writing?).  Which is why you
made it a file_operation, fair enough.

But even for ext2 and ext3 (please keep ext4 in sync with ext3 changes,
btw), if some process is partway through a big page_cache_readahead()
operation then a concurrent invalidate_inode_pages2() call won't worry it
at all: the pagecache will be reinstantiated and do_generic_mapping_read()
will proceed to copy that pagecache out to the user after the revoke() has
returned.  I think.

I'm afraid I havent paid any attention to this revoke proposal before, I
don't understand the usecases nor the implementation details so things
which are implicitly-obvious-to-you must be explained to me.  But others
will benefit from that explanation too ;)  What, exactly, are we trying to do
with the already-opened files and the currently-in-progress syscalls?

(A concurrent direct-io read might be a problem too?)
