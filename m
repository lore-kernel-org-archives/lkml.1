Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZCLJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZCLJ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZCLJ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:58:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:59613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZCLJ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:58:39 -0400
Subject: Re: [PATCH 1/2] mm: use list.h for vma list
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Daniel Lowengrub <lowdanie@gmail.com>
Cc: linux-mm@kvack.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>, Wolfram Strepp <wstrepp@gmx.de>
In-Reply-To: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com>
References: <8c5a844a0903110255q45b7cdf4u1453ce40d495ee2c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 10:58:32 +0100
Message-Id: <1236851912.5090.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 11:55 +0200, Daniel Lowengrub wrote:
> Use the linked list defined list.h for the list of vmas that's stored
> in the mm_struct structure.  Wrapper functions "vma_next" and
> "vma_prev" are also implemented.  Functions that operate on more than
> one vma are now given a list of vmas as input.
> 
> Signed-off-by: Daniel Lowengrub

While this is the approach I've taken for a patch I'm working on, a
better solution has come up if you keep the RB tree (I don't).

It is, however, even more invasive than the this one ;-)

Wolfram has been working on implementing a threaded RB-tree. This means
rb_prev() and rb_next() will be O(1) operations, so you could simply use
those to iterate the vmas.

The only draw-back is that each and every RB-tree user in the kernel
needs to be adapted because its not quite possible to maintain the
current API.

I was planning to help Wolfram do that, but I'm utterly swamped atm. :-(

What needs to be done is introduce rb_left(), rb_right() and rb_node()
helpers that for now look like:

static inline struct rb_node *rb_left(struct rb_node *n)
{
	return n->rb_left;
}

static inline struct rb_node *rb_right(struct rb_node *n)
{
	return n->rb_right;
}

static inline struct rb_node *rb_node(struct rb_node *n)
{
	return n;
}

We need these because the left and right child pointers will be
over-loaded with threading information.

After that we can flip the implementation of the RB-tree.




