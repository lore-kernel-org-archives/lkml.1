Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbXEIJS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbXEIJS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbXEIJSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:18:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34025 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754198AbXEIJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:18:49 -0400
Date: Wed, 9 May 2007 10:21:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: [PATCH] doc: volatile considered evil
Message-ID: <20070509102134.5d722386@the-village.bc.nu>
In-Reply-To: <alpine.DEB.0.99.0705081934390.20751@chino.kir.corp.google.com>
References: <516386418.20070501080839@gmail.com>
	<20070430235642.e576e917.akpm@linux-foundation.org>
	<20070508121404.17bd97a6.randy.dunlap@oracle.com>
	<a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com>
	<20070508163452.8b71f682.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081702070.28511@chino.kir.corp.google.com>
	<20070508190800.1334b968.randy.dunlap@oracle.com>
	<alpine.DEB.0.99.0705081934390.20751@chino.kir.corp.google.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's still ambiguous.  A much more explicit title that nobody could argue 
> with would be "do not use the 'volatile' keyword as a type qualifier for 
> an object."

Except when you do. The kernel uses the C volatile in various places
itself for specific good reasons (and some for historical bad ones)

Perhaps a closer summary would be

Do Not Use Volatile
-------------------

1.	volatile is not a locking mechanism

Volatile does not define sufficiently sane or strong semantics for
locking. The kernel has proper locking mechanisms which also act as
compiler fetch/store barriers and where neccessary hardware barriers for
SMP systems. The kernel knows about all the corner cases, you probably
don't.

2.	volatile is not needed for mmio space

I/O memory access are done via readb/writeb and friends. They deal with
volatility themselves so you don't have to. They may nor may not use
volatile internally to their implementation, but that is none of your
business.

3.	volatile is not atomic

Using volatile does not guarantee atomic behaviour. This often requires
special instructions or code sequences too. We have atomic_t and the
atomic_* operators for this.

4.	volatile is not a store or read barrier

Using volatile is not always sufficient to order accesses on SMP or to
ensure things execute in the order expected. Instead the kernel provides
a set of barrier operations which have clearly defined semantics on all
systems. Make use of rmb, wmb, barrier, smp_wmb etc instead

When Might You Need volatile ?
------------------------------

When you are implementing the locking primitives on a new platform. When
you are implementing the I/O and atomic prmitives on a new platform. Also
in inline gcc assembler where "volatile" is used for subtly different
purposes.

Possibly very special cases we haven't thought about yet. However if you
find one remember the need for portability and ask whether it should be
using volatile or there is a gap in the existing hardware abstraction.

