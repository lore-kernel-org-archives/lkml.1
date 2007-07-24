Return-Path: <linux-kernel-owner+w=401wt.eu-S1758368AbXGXUJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbXGXUJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759577AbXGXUJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:09:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755387AbXGXUJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:09:34 -0400
Date: Tue, 24 Jul 2007 13:08:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Trent Piepho <xyzzy@speakeasy.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <p73myxlsfl4.fsf@bingen.suse.de>
Message-ID: <alpine.LFD.0.999.0707241304560.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au> <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
 <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
 <p73myxlsfl4.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Andi Kleen wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> > 
> > (Yes, the "asm volatile" may do so too, but it's very unclear what the 
> > "volatile" on the asm actually does, so ..)
> 
> Without the volatile they get completely optimized away :/
> [tried that, cost a lot of debugging time -- empty string functions
> cause a lot of strange side effects]

Sure, that's *one* thing that "volatile" guarantees (it guarantees that 
gcc won't optimize away things where the end result isn't actually visibly 
used).

But gcc docs also talk about the other things volatile means, including 
"not significantly moved".

Is that "not significantly moved" already equivalent to "not moved past 
something that can change memory"? Probably not. Which is why it's a good 
idea to have the "memory" clobber there too, because the semantics of the 
"volatile" just aren't very well defined from a code movement standpoint 
(while a general memory clobber is *very* clear: if gcc moves the inline 
asm across another thing that uses/changes memory, that's a gcc bug, plain 
and simple (*)).

		Linus

(*) Other than pure internal gcc spills/reloads. Spilling/reloading local 
registers that haven't had their address taken obviously cannot be seen as 
memory accesses.
