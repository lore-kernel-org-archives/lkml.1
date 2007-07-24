Return-Path: <linux-kernel-owner+w=401wt.eu-S1762062AbXGXTkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062AbXGXTkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbXGXTkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:40:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754073AbXGXTkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:40:41 -0400
Date: Tue, 24 Jul 2007 12:39:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
Message-ID: <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au>
 <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Trent Piepho wrote:
> 
> Speaking of that, why are all the asm functions in arch/i386/lib/string.c
> defined as having a memory clobber, even those which don't modify memory
> like strcmp, strchr, strlen and so on?

That's because the memory clobber will serialize the inline asm with 
anything else that reads or writes memory.

So even if we don't actually change any memory, if we cannot describe what 
we *read*, then we need to tell gcc to not re-order us wrt things that 
could *write*. And the simplest way to do that is to say that you clobber 
memory, even if you don't.

So as a more concrete example: imagine that we're doing a "strlen()" on 
some local variable. We need to tell gcc that that variable has to be 
updated in memory before it schedules the asm. The memory clobber does 
that.

(Yes, the "asm volatile" may do so too, but it's very unclear what the 
"volatile" on the asm actually does, so ..)

		Linus
