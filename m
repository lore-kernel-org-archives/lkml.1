Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbXGXRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbXGXRV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXGXRVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:21:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999AbXGXRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:21:17 -0400
Date: Tue, 24 Jul 2007 10:20:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory
 addresses
In-Reply-To: <1185270544.5439.252.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0707241017440.3607@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
  <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in> 
 <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org>
 <1185270544.5439.252.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jul 2007, Benjamin Herrenschmidt wrote:
> 
>  - This "volatile" will allow to pass pointers to volatile data to the
> bitops.
> 
>  - Most users of "volatile" in the kenrel (except maybe jiffies) are
> bogus
> 
>  - Thus let's remove it -as a type safety thing- to catch more of those
> stupid volatile that shouldn't be ? :-)

Quite frankly, I'd really really rather kill the "volatile" data
structures independently. Once that is done, it doesn't really matter any
more.

> Besides, as Nick pointed out, it prevents some valid optimizations.

No it doesn't. Not the ones on the functions that just do an inline asm.

The only valid optimization it might break is for "constant_test_bit()", 
which isn't even using inline asm.

And before we remove that "volatile", we'd better make damn sure that 
there isn't any driver that does

	/* Wait for the command queue to be cleared by DMA */
	while (test_bit(...))
		;

or similar.

Yes, it's annoying, but this is a scary and subtle area. And we sadly 
_have_ had code that does things like that.

		Linus
