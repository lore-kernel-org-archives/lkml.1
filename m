Return-Path: <linux-kernel-owner+w=401wt.eu-S934972AbYCFQ1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934972AbYCFQ1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761822AbYCFQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:27:14 -0500
Received: from rtr.ca ([76.10.145.34]:2712 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473AbYCFQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:27:13 -0500
Message-ID: <47D01B5F.1060409@rtr.ca>
Date: Thu, 06 Mar 2008 11:27:11 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
References: <Pine.LNX.4.44L0.0803031207120.3611-100000@iolanthe.rowland.org> <alpine.LFD.1.00.0803030921420.17889@woody.linux-foundation.org> <47D014A6.9090300@rtr.ca> <alpine.LFD.1.00.0803060807120.12253@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803060807120.12253@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 6 Mar 2008, Mark Lord wrote:
>> But also consider something like this:
>>
>> 	void store_task(void)
>> 	{
>> 		*the_task = current;
>> 	}
>>
>> In this case, there is no guarantee that the assignment
>> can be done atomically on all CPU types.  Some RISC archs
>> (eg. MIPS R2xxx) require an (interruptible) instruction pair
>> to store values to a potentially unaligned address.
> 
> You'd better not be using unaligned accesses for memory-ordering-sensitive 
> things (I think x86 happens get even that right for most cases, but I 
> don't think the architecture specification guarantees it, and I'm pretty 
> sure that you might find problems on cache crossing writes, for example)
..

Yeah.  For the MIPS R2xxx CPU, the question was whether the compiler
could guarantee the alignment of the things the pointer could point at.
In cases where it could not, it would emit the interruptable instruction
pair instead of a single load instruction.

I don't know what gcc does on MIPS for this.  Perhaps it simply always
assumes an aligned access?  In that case, there's no issue unless some
putz actually creates/uses a pointer to an unaligned data object.

What about other architectures like ARM ?  Probably also assumes aligned,
in which case all is well.

> But quite frankly, if you have an architecture that can't do the above as 
> a single write when it's a pointer, then you have a totally broken 
> architecture. It's not worth supporting.
> 
> (There are data structures that are harder than native words: bytes and 
> shorts can require load-modify-write cycles, and "u64" and friends can 
> obviously be multiple words, so you shouldn't depend on things for those 
> "complex" cases. But we *definitely* depend on atomicity for regular word 
> accesses).
