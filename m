Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbYFLTbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbYFLTbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYFLTbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:31:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753665AbYFLTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:31:39 -0400
Date: Thu, 12 Jun 2008 12:31:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [patch] radix-tree: fix small lockless radix-tree bug
Message-Id: <20080612123102.d8783b98.akpm@linux-foundation.org>
In-Reply-To: <200806130503.45369.nickpiggin@yahoo.com.au>
References: <200806130503.45369.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 05:03:45 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Hi guys,
> 
> Although this doesn't seem like cause for alarm (as per the analysis),
> it may still be a good 2.6.26 candidate as we should have a few more
> weeks of testing left.
> 
> It should definitely go in -mm with the lockless pagecache patch.
> 
> When shrinking a radix-tree, we do it in a lockless manner by atomically
> switching the root pointer away from the redundant node (one that only
> has a single entry in the left most slot), and switching it over to its
> lone child.
> 
> Because a lockless lookup may have got a reference to the parent and be
> in the middle of deciding what to do with it while it is being swapped
> away for its child. For this reason, we also have to keep it around and
> in a valid state for the lookup to proceed and give a valid result, for
> at least an RCU grace period. So we need to keep the child in the left
> most slot there in case that is requested by the lookup.
> 
> This is all pretty standard RCU stuff. It is worth repeating because
> in my eagerness to obey the radix tree node constructor scheme, I had
> broken this by zeroing the radix tree node before the grace period.
> 
> Fix it by clearing those fields in the RCU callback. I would normally
> want to rip out the constructor entirely, but radix tree nodes are one
> of those places where they make sense (only few cachelines will be
> touched soon after allocation).
> 
> 
> This was never actually observed in any lockless pagecache testing or
> using the test harness, but as a rare problem testing my scalable vmap
> rewrite.
> 
> Fortunately, it is not a problem anywhere lockless pagecache is used in
> mainline kernels (pagecache probe is not a guarantee, and brd does not
> have concurrent lookups and deletes).
> 
> However, it would eventually pop up for someone using lockless pagecache :P
> 

OK, I give up.  A cannot spot what you actually changed amongst all the
code motion?

