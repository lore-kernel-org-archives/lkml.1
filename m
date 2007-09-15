Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbXIOWQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbXIOWQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 18:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbXIOWQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 18:16:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbXIOWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 18:16:06 -0400
Date: Sat, 15 Sep 2007 15:15:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: crashme fault
In-Reply-To: <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
 <alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
 <20070915183412.GA14501@one.firstfloor.org> <46EC2702.3090000@oracle.com>
 <alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Sep 2007, Linus Torvalds wrote:
> 
> Here's a really *stupid* patch (and untested too, btw) to see if it gets 
> easier to debug when you don't oops, just print the register state 
> instead.

Side note - while thinking about this, I'm wondering whether maybe that 
"stupid" patch might not actually be the right thing to do.

The fact is, the "user access" bit in the error code is in many ways a 
totally *different* issue than the "user_mode(regs)" test. We may end up 
having a system page fault for some action that was initiated by user 
space: eg taking a page fault on a segment load. And it may well be marked 
as a "system access" in the error code, even though the instruction that 
triggered it was all user mode, and even though we could just terminate 
the program rather than oops.

That said, since the kernel isn't paging itself out, user mode generally 
should not be able to generate those kinds of system access page faults. 
Our segment tables should all be in core, and so I would still in 
*practice* always expect the register state and the error code to match in 
the "usermode'ness".

So regardless of whether we want to trust "user_mode(regs)" more than 
"error_code & PF_USER", it would definitely be very interesting if you can 
give a good "this is where it started happening".

			Linus
