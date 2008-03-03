Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbYCCRij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbYCCRij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759113AbYCCRaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:30:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758210AbYCCRaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:30:09 -0500
Date: Mon, 3 Mar 2008 09:26:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read
 is required
In-Reply-To: <Pine.LNX.4.44L0.0803031207120.3611-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.1.00.0803030921420.17889@woody.linux-foundation.org>
References: <Pine.LNX.4.44L0.0803031207120.3611-100000@iolanthe.rowland.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Mar 2008, Alan Stern wrote:
> 
> Consider a routine like the following:
> 
> 	static task_struct *the_task;
> 
> 	void store_task(void)
> 	{
> 		the_task = current;
> 	}
> 
> Is it possible to say whether readers examining "the_task" are 
> guaranteed to see a coherent value?

Yes, we do depend on this.  All the RCU stuff (and in general *anything* 
that depends on memory ordering as opposed to full locking, and we have 
quite a lot of it) is very fundamentally dependent on the fact that things 
like pointers get read and written atomically.

HOWEVER, it is worth pointing out that it's generally true in a 
"different" sense than the actual atomic accesses. For example, if you 
test a single bit of a word, it's still quite possible that gcc will have 
turned that "atomic" read into a single byte read, so it's not necessarily 
the case that we'll actually even read the whole word. 

(Writes are different: if you do things like bitwise updates they simply 
*will*not* be atomic, but that's simply not what we depend on anyway).

So in that sense, the atomicity guarantees are a lot weaker than the ones 
we do for IO accesses, but that's all fine. Memory isn't IO, and doesn't 
have side effects.

			Linus
