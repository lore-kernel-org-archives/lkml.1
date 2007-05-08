Return-Path: <linux-kernel-owner+w=401wt.eu-S1032485AbXEHWdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032485AbXEHWdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968440AbXEHWdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:33:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:49815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968437AbXEHWdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:33:19 -0400
Date: Wed, 9 May 2007 00:33:09 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops
Message-ID: <20070508223309.GB20174@wotan.suse.de>
References: <20070508113709.GA19294@wotan.suse.de> <10196.1178626976@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10196.1178626976@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:22:56PM +0100, David Howells wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > This patch (along with the subsequent one to optimise unlock_page) reduces
> > the overhead of lock_page/unlock_page (measured with page faults and a patch
> > to lock the page in the fault handler) by about 425 cycles on my 2-way G5.
> 
> Seems reasonable, though test_and_set_lock_bit() might be a better name.

The postfix attaches lock semantics to the test_and_set_bit operation,
so I don't think it is necessarily wrong to have this name. But it doesn't
matter too much I guess.


> > +There are two special bitops with lock barrier semantics (acquire/release,
> > +same as spinlocks).
> 
> You should update Documentation/memory-barriers.txt also.

Will do.


> >  #define TestSetPageLocked(page)		\
> >  		test_and_set_bit(PG_locked, &(page)->flags)
> > +#define TestSetPageLocked_Lock(page)		\
> > +		test_and_set_bit_lock(PG_locked, &(page)->flags)
> 
> Can we get away with just moving TestSetPageLocked() to the new function
> rather than adding another accessor?  Or how about LockPageLocked() and
> UnlockPageLocked() rather than SetPageLocked_Lock() that last looks wrong
> somehow.

The problem is that it implies some semantics that it may not have. Possibly
better is to just remove them all and use only trylock/lock/unlock_page.
