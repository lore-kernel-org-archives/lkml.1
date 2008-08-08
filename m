Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbYHHHQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbYHHHQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYHHHQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:16:18 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:54338 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYHHHQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:16:18 -0400
Subject: Re: [RFC][PATCH 9/7] mm: fix mm_take_all_locks() locking order
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20080807214642.GQ31535@duo.random>
References: <20080804130317.994042639@chello.nl>
	 <1218108349.8625.25.camel@twins>  <20080807214642.GQ31535@duo.random>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 09:16:15 +0200
Message-Id: <1218179775.8625.57.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 23:46 +0200, Andrea Arcangeli wrote:

> As for 8/7 you know my opinion from somebody who's way beyond the
> point: check_deadlock should be dropped 

I'll try again one more time, don't feel obliged to reply or
anything :-)

Suppose you have objects initialized from a single site:

struct my_obj *create_obj()
{
	...
	spin_lock_init(&obj->lock);
	...

	return obj;
}


So that all these object's their locks are in a single class.

Now, put these objects into two lists without fixed order.

L1: A B C D
L2: B A D C

If you were to lock-couple your way through these lists there is a
deadlock potential.

The check_noncircular stuff will not catch this due to it all being of a
single class. The only thing we have to indicate you need to pay
attention is check_deadlock.

Yes, check_deadlock is a tad too sensitive in the amount of false
positives, but without it there are gaping holes in 'proving' lock
correctness.

Currently - if you get 100% code coverage and lockdep doesn't shout,
you're good. If we were to drop check_deadlock we can't say that
anymore.


