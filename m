Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbXLJJUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbXLJJUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 04:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXLJJU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 04:20:29 -0500
Received: from phunq.net ([64.81.85.152]:55567 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751182AbXLJJU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 04:20:28 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Date: Mon, 10 Dec 2007 01:20:21 -0800
User-Agent: KMail/1.9.5
Cc: davidsen@tmr.com, linux-kernel@vger.kernel.org, peterz@infradead.org
References: <200712051603.02183.phillips@phunq.net> <20071206162915.a3917d1c.akpm@linux-foundation.org> <200712062313.43383.phillips@phunq.net>
In-Reply-To: <200712062313.43383.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712100120.22657.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Unfortunately, I agreed with your suggestion too hastily.   Not only 
would it be complex to implement, It does not work.  It took me several 
days to put my finger on exactly why.  Here it is in a nutshell: 
resources may be consumed _after_ the gatekeeper runs the "go, no go" 
throttling decision.  To illustrate, throw 10,000 bios simultaneously 
at a block stack that is supposed to allow only about 1,000 in flight 
at a time.  If the block stack allocates memory somewhat late in its 
servicing scheme (for example, when it sends a network message) then it 
is possible that no actual resource consumption will have taken place 
before all 10,000 bios are allowed past the gate keeper, and deadlock 
is sure to occur sooner or later.

In general, we must throttle against the maximum requirement of inflight 
bios rather than against the measured consumption.  This achieves the 
invariant I have touted, namely that memory consumption on the block 
writeout path must be bounded.  We could therefore possibly use your 
suggestion or something resembling it to implement a debug check that 
the programmer did in fact do their bounds arithmetic  correctly, but 
it is not useful for enforcing the bound itself.

In case that coffin needs more nails in it, consider that we would not 
only need to account page allocations, but frees as well.  So what 
tells us that a page has returned to the reserve pool?  Oops, tough 
one.  The page may have been returned to a slab and thus not actually 
freed, though it remains available for satisfying new bio transactions.  
Because of such caching, your algorithm would quickly lose track of 
available resources and grind to a halt.

Never mind that keeping track of page frees is a nasty problem in 
itself.   They can occur in interrupt context, so forget the current-> 
idea.  Even keeping track of page allocations for bio transactions in 
normal context will be a mess, and that is the easy part.  I can just 
imagine the code attempting to implement this approach acreting into a 
monster that gets confusingly close to working without ever actually 
getting  there.

We do have a simple, elegant solution posted at the head of this thread, 
which is known to work.

Regards,

Daniel
