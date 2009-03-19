Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZCSBCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZCSBCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZCSBCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:02:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39627
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbZCSBCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:02:40 -0400
Date: Wed, 18 Mar 2009 18:02:27 -0700 (PDT)
Message-Id: <20090318.180227.256169134.davem@davemloft.net>
To: vernux@us.ibm.com
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <49C16C5D.5090306@us.ibm.com>
References: <49C16349.9030503@us.ibm.com>
	<20090318.143844.173112261.davem@davemloft.net>
	<49C16C5D.5090306@us.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vernon Mauery <vernux@us.ibm.com>
Date: Wed, 18 Mar 2009 14:49:17 -0700

> Yes, the double context switches surely hurt the temporal and
> spatial locality of the vanilla codepath, but it also induces a
> longer penalty for blocking on a lock -- instead of a nanoseconds
> or a few microseconds, the task gets delayed for tens of
> microseconds.  So really, the -rt kernel has more to fix than
> the vanilla kernel in this case, but any improvement in the lock
> contention in the vanilla case would be magnified and would cause
> dramatic improvements in the -rt kernel.

Contention on a shared resource is not implicitly bad.

And with upstream spinlocks the cost is relatively low for a case like
this where a thread of control goes in and only holds the lock for
long enough to unlink a packet from the list and immediately the lock
is released.

The cost should be, cache line move from cpu-to-cpu, atomic lock,
linked list unlink, a store, and a memory barrier.  And that's
all it is upstream.

If the -rt kernel makes this 10 times more expensive, I really don't
see why that is an upstream concern at the current point in time.

That's the tradeoff, common situations where locks are held by
multiple threads with contention, but only for mere cycles, are
seemingly a lot more expensive in the -rt kernel.

I mean, for example, why doesn't the -rt kernel just spin for a little
while like a normal spinlock would instead of always entering that
expensive contended code path?  It would be a huge win here, but I
have yet to see discussion of changes in that area of the -rt kernel
to combat these effects.  Is it the networking that always has to
change for the sake of -rt? :-)
