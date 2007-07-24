Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXGXETi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXGXETi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXGXETa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 00:19:30 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:32120 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750738AbXGXET3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 00:19:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=a+Kvwr+9thuuKN79JQ6djx4yHhBczlW/FpUpU3E3IGAblmbBL1ehWYq4IfM6DZoRDQgj5sJkMIlMrVyE7peckS+chxLaNS4dIKdSBAJM2PXhjuRLaSeTb2E563KEr4s4VaTJFSHIslHgA1mHugLlDabetcjrZeZZx/upaOv6/wE=  ;
X-YMail-OSG: b00QYzwVM1mU8VSga.BWsMDzbdaqWTqhrOo26uGerQxwBsrc0cm1GnYxewhK4lF.5kRXKr3zYw--
Message-ID: <46A57DCB.7050609@yahoo.com.au>
Date: Tue, 24 Jul 2007 14:19:23 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory addresses
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in> <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 23 Jul 2007, Satyam Sharma wrote:
> 
> 
>>[4/8] i386: bitops: Kill volatile-casting of memory addresses
> 
> 
> This is wrong.
> 
> The "const volatile" is so that you can pass an arbitrary pointer. The 
> only kind of abritraty pointer is "const volatile".
> 
> In other words, the "volatile" has nothing at all to do with whether the 
> memory is volatile or not (the same way "const" has nothing to do with it: 
> it's purely a C type *safety* issue, exactly the same way "const" is a 
> type safety issue.
> 
> A "const" on a pointer doesn't mean that the thing it points to cannot 
> change. When you pass a source pointer to "strlen()", it doesn't have to 
> be constant. But "strlen()" takes a "const" pointer, because it work son 
> constant pointers *too*.
> 
> Same deal here.
> 
> Admittedly this may be mostly historic, but regardless - the "volatiles" 
> are right.
> 
> Using volatile on *data* is generally considered incorrect and bad taste, 
> but using it in situations like this potentially makes sense.
> 
> Of course, if we remove all "volatiles" in data in the kernel (with the 
> possible exception of "jiffies"), we can then remove them from function 
> declarations too, but it should be done in that order.

Well, regardless, it still forces the function to treat the pointer
target as volatile, won't it? It definitely prevents valid optimisations
that would be useful for me in mm/page_alloc.c where page flags are
being set up or torn down or checked with non-atomic bitops.

OK, not the i386 functions as much because they are all in asm anwyay,
but in general (btw. why does i386 or any architecture define their own
non-atomic bitops? If the version in asm-generic/bitops/non-atomic.h
is not good enough then surely it is a bug in gcc or that file?)

Anyway by type safety, do you mean it will stop the compiler from
warning if a pointer to a volatile is passed to the bitop? If so, then
why don't we just kill all the volatiles out of here and fix any
warnings that comeup? I doubt there would be many, and of those, some
might show up real synchronisation problems.

-- 
SUSE Labs, Novell Inc.
