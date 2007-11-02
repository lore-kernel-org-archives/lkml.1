Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbXKBABH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbXKBABH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 20:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXKBAAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 20:00:53 -0400
Received: from ns1.suse.de ([195.135.220.2]:53128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbXKBAAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 20:00:53 -0400
Date: Fri, 2 Nov 2007 01:00:51 +0100
From: Nick Piggin <npiggin@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071102000051.GB20144@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <472A30A9.7040203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472A30A9.7040203@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 04:01:45PM -0400, Chuck Ebbert wrote:
> On 11/01/2007 10:03 AM, Nick Piggin wrote:
> 
> [edited to show the resulting code]
> 
> > +	__asm__ __volatile__ (
> > +		LOCK_PREFIX "xaddw %w0, %1\n"
> > +		"1:\t"
> > +		"cmpb %h0, %b0\n\t"
> > +		"je 2f\n\t"
> > +		"rep ; nop\n\t"
> > +		"movb %1, %b0\n\t"
> > +		/* don't need lfence here, because loads are in-order */
> >  		"jmp 1b\n"
> > +		"2:"
> > +		:"+Q" (inc), "+m" (lock->slock)
> > +		:
> > +		:"memory", "cc");
> >  }
> 
> If you really thought you might get long queues, you could figure out
> how far back you are and use that to determine how long to wait before
> testing the lock again. That cmpb could become a subb without adding
> overhead to the fast path -- that would give you the queue length (or
> its complement anyway.)

Indeed. You can use this as a really nice input into a backoff
algorithm (eg. if you're next in line, don't back off, or at least
don't go into exponential backoff; if you've got people in front
of you, start throttling harder).

I think I'll leave that to SGI if they come up with a big x86 SSI ;)
