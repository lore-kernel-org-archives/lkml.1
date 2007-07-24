Return-Path: <linux-kernel-owner+w=401wt.eu-S1765524AbXGXIi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765524AbXGXIi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXGXIiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:38:50 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:54165 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbXGXIit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:38:49 -0400
Date: Tue, 24 Jul 2007 01:38:48 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <46A5A929.4020706@yahoo.com.au>
Message-ID: <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Nick Piggin wrote:
> Satyam Sharma wrote:
> > But for the non-atomic variants, it does make sense to remove the
> > memory clobber (and the unneeded __asm__ __volatile__ that another
> > patch did -- for the non-atomic variants, again).
>
> No. It has nothing to do with atomicity and all to do with ordering.
> For example test_bit, clear_bit, set_bit, etc are all atomic but none
> place any restrictions on ordering.
>
> __test_and_change_bit has no restriction on ordering, so as long as
> the correct operands are clobbered, a "memory" clobber to enforce a
> compiler barrier is not needed.

Speaking of that, why are all the asm functions in arch/i386/lib/string.c
defined as having a memory clobber, even those which don't modify memory
like strcmp, strchr, strlen and so on?

Why are they all volatile too?  Even those with no side effects.

It seems like any asm which writes to or _reads from_ memory that isn't one
of the operands must have a memory clobber.  And any asm with side effects
other than it's operands (and asm("mov $0, (%0)" :  :  "r"(some_pointer))
has side effects) must be volatile.

So something like strlen() needs to have a memory clobber, otherwise a
store to the string could be moved to the other side of the strlen(), but
doesn't need to be volatile, since it has no side effects.
