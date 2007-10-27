Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbXJ0KJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbXJ0KJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 06:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbXJ0KJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 06:09:14 -0400
Received: from ozlabs.org ([203.10.76.45]:49670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbXJ0KJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 06:09:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Date: Sat, 27 Oct 2007 20:09:30 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>
References: <20071024195847.GE27248@parisc-linux.org> <20071026115727.GR27248@parisc-linux.org> <20071026205714.GQ17536@waste.org>
In-Reply-To: <20071026205714.GQ17536@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710272009.31430.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2007 06:57:14 Matt Mackall wrote:
> Well I expect once you start letting people easily build strings by
> concatenation, you'll very shortly afterwards have people using them
> in loops.  And having hidden O(n^2) behavior in there is a little sad, 
> even though n will tend to be small and well-bounded. If we can do
> something simple to avoid it, we should.

Hi Matt,

        I avoid typing even a single character of optimization until it's 
justified.  This is partially a reaction against the machoptimization 
tendencies of many kernel programmers, but it's mainly a concern at the 
kernel's complexity creep.

Meanwhile, of course, I've now spent far too long analyzing this :)

Building a 1000 byte string 1 byte at a time involves 6 reallocs (SLAB) or 10 
reallocs (SLUB).  Frankly, that's good enough without an explicit alloc 
length field (better in some ways).

As to keeping an explicit length vs strlen(): those 1000 calls on my test 
machine take 1491ns per call with an explicit length vs 1496ns per call with 
strlen().  That's not worth 4 bytes, let alone a single line of code, O(n^2) 
or no.

As the nail in the coffin, callers only use ->buf, so are insulated from any 
such optimizations if we decided to do them in future.

Hope that helps,
Rusty.
PS.  I don't think we should switch this to a simple char ** tho, as 
the "struct stringbuf" gives us some type safety and reminds people not to 
simply kfree it.
