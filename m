Return-Path: <linux-kernel-owner+w=401wt.eu-S965980AbXDGWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965980AbXDGWv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbXDGWv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:51:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:35379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXDGWv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:51:56 -0400
Date: Sat, 7 Apr 2007 15:51:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Optimize compound_head() by avoiding a shared page
 flag
Message-Id: <20070407155148.94da92e8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
	<20070405223657.21698.32754.sendpatchset@schroedinger.engr.sgi.com>
	<20070406222336.4dcdd663.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704071509550.31503@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Apr 2007 15:16:17 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 6 Apr 2007, Andrew Morton wrote:
> 
> > Did you investigate
> > 
> > static inline int page_tail(struct page *page)
> > {
> > 	return ((page->flags & (PG_compound|PG_tail)) == (PG_compound|PG_tail));
> > }
> 
> The usual test_bit that we are using there uses a volatile reference 
> so these wont be combined if I check them separately.
> 
> A working example of the above would be much uglier:
> 
> static inline int page_tail(struct page *page)
> {
>  	return ((page->flags & ((1L << PG_compound)|(1L << PG_tail))) == 
> ((1L << PG_compound)|(1L << PG_tail)));
> }
> 
> May be this can be cleaned up somehow.

It might generate better code to do

	unsigned long compound;

	compound = page->flags & (1 << PG_compound);
	if (PG_compound > PG_tail)
		return compound & (page->flags << (PG_compound - PG_tail));
	else
		return compound & (page->flags << (PG_tail - PG_compound));


ie: get the PG_compound flag into `compound', then bitwise-and that with
the PG_tail flag, after shifting it into PG_compound' slot.  The return
value will be zero if either bit is clear, (1<<PG_compound) if both are
set.  The `if (PG_compound > PG_tail)' will be swallowed by the compiler.

The compiler should turn it all into

	(page->flags & N) & (page->flags << M)

Which may or may not be better than (page->flags & N == N), dunno. 
Probably not - if the compiler's any good it won't save a branch, I
suspect.



Which is all a ton of fun, but this subversion of the architecture's
freedom to use volatile, memory barriers etc is a worry.  We do the same in
page_alloc.c, of course...  

