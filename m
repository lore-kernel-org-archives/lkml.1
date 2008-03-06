Return-Path: <linux-kernel-owner+w=401wt.eu-S1764476AbYCFQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764476AbYCFQN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 11:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934562AbYCFQMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 11:12:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934549AbYCFQMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 11:12:52 -0500
Date: Thu, 6 Mar 2008 08:11:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
In-Reply-To: <47D014A6.9090300@rtr.ca>
Message-ID: <alpine.LFD.1.00.0803060807120.12253@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0803031207120.3611-100000@iolanthe.rowland.org> <alpine.LFD.1.00.0803030921420.17889@woody.linux-foundation.org> <47D014A6.9090300@rtr.ca>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 6 Mar 2008, Mark Lord wrote:
> 
> But also consider something like this:
> 
> 	void store_task(void)
> 	{
> 		*the_task = current;
> 	}
> 
> In this case, there is no guarantee that the assignment
> can be done atomically on all CPU types.  Some RISC archs
> (eg. MIPS R2xxx) require an (interruptible) instruction pair
> to store values to a potentially unaligned address.

You'd better not be using unaligned accesses for memory-ordering-sensitive 
things (I think x86 happens get even that right for most cases, but I 
don't think the architecture specification guarantees it, and I'm pretty 
sure that you might find problems on cache crossing writes, for example)

But quite frankly, if you have an architecture that can't do the above as 
a single write when it's a pointer, then you have a totally broken 
architecture. It's not worth supporting.

(There are data structures that are harder than native words: bytes and 
shorts can require load-modify-write cycles, and "u64" and friends can 
obviously be multiple words, so you shouldn't depend on things for those 
"complex" cases. But we *definitely* depend on atomicity for regular word 
accesses).

		Linus
