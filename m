Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYDHPxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYDHPxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYDHPxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:53:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51577 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYDHPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:53:05 -0400
Date: Tue, 8 Apr 2008 08:52:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-sparse <linux-sparse@vger.kernel.org>
Subject: Re: Using sparse to catch invalid RCU dereferences?
Message-ID: <20080408155259.GA8381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1207605856.12481.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207605856.12481.35.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 12:04:16AM +0200, Johannes Berg wrote:
> Hi,
> 
> Just a thought, I haven't tried this yet because I'm not entirely sure
> it's actually correct. I was just thinking it should be possible to
> introduce something like
> 
> 	#define __rcu	__attribute__((address_space(3)))
> 
> (for sparse only, of course) and then be able to say
> 
> 	struct myfoo *foo __rcu;
> 
> and sparse would warn on
> 
> 	struct myfoo *bar = foo;
> 
> but not on
> 
> 	struct myfoo *bar = rcu_dereference(foo);

Ah, "address_space" is a sparse-ism, no wonder I couldn't find it in
the gcc docs...

So the address_space attribute says what the pointer points to rather
than where the pointer resides, correct?

> by way of using __force inside rcu_dereference(), rcu_assign_pointer()
> etc.
> 
> Would this be feasible? Or should one actually use __bitwise/__force to
> also get the warning when assigning between two variables both marked
> __rcu?

It might be.  There are a number of places where it is legal to access
RCU-protected pointers directly, and all of these would need to be
changed.  For example, in the example above, one could do:

	foo = NULL;

I recently tried to modify rcu_assign_pointer() to issue the memory
memory barrier only when the pointer was non-NULL, but this ended badly.
Probably because I am not the greatest gcc expert around...  We ended
up having to define an rcu_assign_index() to handle the possibility of
assigning a zero-value array index, but my attempts to do type-checking
backfired, and I eventually gave it up.  Again, someone a bit more clued
in to gcc than I am could probably pull it off.

In addition, it is legal to omit rcu_dereference() and rcu_assign_pointer()
when holding the update-side lock.

So I very much like this approach in general, but it will require some
care to implement.  I would be very happy to review and comment!!!

							Thanx, Paul
