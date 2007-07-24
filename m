Return-Path: <linux-kernel-owner+w=401wt.eu-S1765764AbXGXHt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765764AbXGXHt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbXGXHtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:49:21 -0400
Received: from gw.goop.org ([64.81.55.164]:55742 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXGXHtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:49:20 -0400
Message-ID: <46A5AECB.3060208@goop.org>
Date: Tue, 24 Jul 2007 00:48:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in> <46A577AA.4020804@yahoo.com.au> <Pine.LNX.4.64.0707241208440.1433@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707241208440.1433@cselinux1.cse.iitk.ac.in>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Consider this (the above two functions exist only for clear_bit(),
> the atomic variant, as you already know), the _only_ memory reference
> we care about is that of the address of the passed bit-string:
>
> (1) The compiler must not optimize / elid it (i.e. we need to disallow
>     compiler optimization for that reference) -- but we've already taken
>     care of that with the __asm__ __volatile__ and the constraints on
>     the memory "addr" operand there, and,
> (2) For the i386, it also includes an implicit memory (CPU) barrier
>     already.
>
> So I /think/ it makes sense to let the compiler optimize _other_ memory
> references across the call to clear_bit(). There's a difference. I think
> we'd be safe even if we do this, because the synchronization in callers
> must be based upon the _passed bit-string_, otherwise _they_ are the
> ones who're buggy.
>
> [ However, elsewhere Jeremy Fitzhardinge mentioned the case of
>   some callers, for instance, doing a memset() on an alias of
>   the same bit-string. But again, I think that is dodgy/buggy/
>   extremely border-line usage on the caller's side itself ...
>   *unless* the caller is doing that inside a higher-level lock
>   anyway, in which case he wouldn't be needing to use the
>   locked variants either ... ]
>   

You miss my point.  If you have:

	memset(&my_bitmask, 0, sizeof(my_bitmask));
	set_bit(my_bitmask, 44);

Then unless the set_bit has a constraint argument which covers the whole
of the (multiword) bitmask, the compiler may see fit to interleave the
memset writes with the set_bit in bad ways.  In other words, plain "+m"
(*(long *)ptr) won't cut it.  You'd need "+m" (my_bitmask), I think.

    J
