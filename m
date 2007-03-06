Return-Path: <linux-kernel-owner+w=401wt.eu-S965904AbXCFRJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965904AbXCFRJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 12:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965966AbXCFRJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 12:09:48 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47768 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965904AbXCFRJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 12:09:47 -0500
Date: Tue, 6 Mar 2007 09:09:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <45ED96A6.3000704@zytor.com>
Message-ID: <Pine.LNX.4.64.0703060853050.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051621590.3998@woody.linux-foundation.org>
 <45ECD122.6020907@zytor.com> <Pine.LNX.4.64.0703051832260.4907@alien.or.mcafeemobile.com>
 <45ECD3D4.5020305@zytor.com> <Pine.LNX.4.64.0703051841380.4907@alien.or.mcafeemobile.com>
 <45ED08A9.9050501@cosmosbay.com> <45ED96A6.3000704@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, H. Peter Anvin wrote:
> 
> That's true for *any* sprintf(), though.  sprintf() converts all its arguments
> to 64 bits.

Well, it very much uses "do_div()", so that it can do a

	64 / 32 -> (div64,mod32) 

divide, which is often faster than a full 64:64 divide.

> However, this could be optimized.  I think right now sprintf() uses a generic
> divide-by-base, but a divide by 8 and 16 can of course be handled with a
> shift, and divide by 10 can be replaced with a multiplication by
> 0x1999999999999999ULL on most architectures.

Nope. You need both the result of the division *and* the remainder, and 
you can't do that with a single multiply.

Also, with modern hardware, divides are usually fairly cheap, with early 
exit logic, so that the common case of small integers is fairly cheap. 
Yeah, generating a full 64-bit number printout is still expensive, of 
course (both because you need to do many divides *and* because only the 
last few divides will be able to do any appreciable early exit logic.

Anyway, I think a full integer divide on Core 2 is something like 22 
cycles. Yes, the multiply is much fasster (at 4 cycles), but I think that 
22 cycles is actually worst-case.

Somebody who has a benchmark could try.

		Linus
