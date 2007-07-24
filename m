Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbXGXV0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbXGXV0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbXGXV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:26:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56268 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXGXV0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:26:03 -0400
Subject: Re: [PATCH RFC] extent mapped page cache
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1185307985.6586.50.camel@localhost>
References: <20070710210326.GA29963@think.oraclecorp.com>
	 <20070724160032.7a7097db@think.oraclecorp.com>
	 <1185307985.6586.50.camel@localhost>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 23:25:43 +0200
Message-Id: <1185312343.5535.5.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 16:13 -0400, Trond Myklebust wrote:
> On Tue, 2007-07-24 at 16:00 -0400, Chris Mason wrote:
> > On Tue, 10 Jul 2007 17:03:26 -0400
> > Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > This patch aims to demonstrate one way to replace buffer heads with a
> > > few extent trees.  Buffer heads provide a few different features:
> > > 
> > > 1) Mapping of logical file offset to blocks on disk
> > > 2) Recording state (dirty, locked etc)
> > > 3) Providing a mechanism to access sub-page sized blocks.
> > > 
> > > This patch covers #1 and #2, I'll start on #3 a little later next
> > > week.
> > > 
> > Well, almost.  I decided to try out an rbtree instead of the radix,
> > which turned out to be much faster.  Even though individual operations
> > are slower, the rbtree was able to do many fewer ops to accomplish the
> > same thing, especially for merging extents together.  It also uses much
> > less ram.
> 
> The problem with an rbtree is that you can't use it together with RCU to
> do lockless lookups. You can probably modify it to allocate nodes
> dynamically (like the radix tree does) and thus make it RCU-compatible,
> but then you risk losing the two main benefits that you list above.

I thought on this, and I came to the conclusion that the tree rotations
used to balance binary trees are incompatible with RCU. The rotation can
hide one branch. Hence I started writing a B+tree that is RCU compatible
much like the Radix tree.

Current code here:
  http://programming.kicks-ass.net/kernel-patches/vma_lookup/btree.patch

Still needs some work, but is usable.

