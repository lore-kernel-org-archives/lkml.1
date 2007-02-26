Return-Path: <linux-kernel-owner+w=401wt.eu-S1751050AbXBZCJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbXBZCJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 21:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXBZCJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 21:09:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50022
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbXBZCJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 21:09:28 -0500
Date: Sun, 25 Feb 2007 18:09:27 -0800 (PST)
Message-Id: <20070225.180927.112620704.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: BUG in 2.6.20-rt8
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070226015230.GN5049@linux.vnet.ibm.com>
References: <20070225062747.GA13432@elte.hu>
	<20070224.223744.59470086.davem@davemloft.net>
	<20070226015230.GN5049@linux.vnet.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sun, 25 Feb 2007 17:52:30 -0800

> Why doesn't the traditional hash table of locks work here?  Use the
> cache-line address as input to the hash function, take the corresponding
> lock, do the compare-and-exchange by hand, and then release the lock.
> What am I missing here?  Address aliasing do to memory being mapped into
> multiple locations or something?  (In that case, use only the portion
> of the address within the page, right?)

It doesn't protect against pure stores.

Even ignoring that you'll also need to disable interrupts, always,
which therefore will always perform very poorly compared to an
open-coded spinlock variant.

There are zero gains to cmpxchg(), in my opinion, you dirty and
grab exclusive access to a cacheline with cmpxchg() just the
same as a spinlock, so the real cost is the same.

There is zero justification for using this primitive in generic
code.
