Return-Path: <linux-kernel-owner+w=401wt.eu-S1032354AbXEHVXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032354AbXEHVXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032346AbXEHVX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:23:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:59332 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032345AbXEHVX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:23:27 -0400
Subject: Re: [rfc] lock bitops
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <npiggin@suse.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070508150631.GC10562@parisc-linux.org>
References: <20070508113709.GA19294@wotan.suse.de>
	 <20070508150631.GC10562@parisc-linux.org>
Content-Type: text/plain
Date: Wed, 09 May 2007 07:23:15 +1000
Message-Id: <1178659395.14928.82.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 09:06 -0600, Matthew Wilcox wrote:
> On Tue, May 08, 2007 at 01:37:09PM +0200, Nick Piggin wrote:
> > --
> > Introduce test_and_set_bit_lock / clear_bit_unlock bitops with lock semantics.
> > Add non-trivial for powerpc and ia64. Convert page lock, buffer lock,
> > bit_spin_lock, tasklet locks to use the new locks.
> 
> The names are a bit clumsy.  How about naming them after the effect,
> rather than the implementation?  It struck me that really these things
> are bit mutexes -- you can sleep while holding the lock.  How about
> calling them bit_mutex_trylock() and bit_mutex_unlock()?

Hrm... spin_trylock vs. mutex_trylock ... what difference ? :-)

Note that if we're gonna generalize the usage as a mutex, we might want
to extend the unlock semantic to return the first word flag atomically
so that the caller can test for other bits without having to read
the word back (which might be a performance hit on CPUs without store
forwarding). That's already what Nick's new unlock_page() does (testing
the flag again right after unlock). At first, I though it would make
clear_bit_unlock() semantics a bit too clumsy but maybe it's worth it.

Ben.


