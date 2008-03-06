Return-Path: <linux-kernel-owner+w=401wt.eu-S933829AbYCFP6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829AbYCFP6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbYCFP6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:58:33 -0500
Received: from rtr.ca ([76.10.145.34]:4108 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYCFP6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:58:31 -0500
Message-ID: <47D014A6.9090300@rtr.ca>
Date: Thu, 06 Mar 2008 10:58:30 -0500
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
References: <Pine.LNX.4.44L0.0803031207120.3611-100000@iolanthe.rowland.org> <alpine.LFD.1.00.0803030921420.17889@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803030921420.17889@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 3 Mar 2008, Alan Stern wrote:
>> Consider a routine like the following:
>>
>> 	static task_struct *the_task;
>>
>> 	void store_task(void)
>> 	{
>> 		the_task = current;
>> 	}
>>
>> Is it possible to say whether readers examining "the_task" are 
>> guaranteed to see a coherent value?
> 
> Yes, we do depend on this.  All the RCU stuff (and in general *anything* 
> that depends on memory ordering as opposed to full locking, and we have 
> quite a lot of it) is very fundamentally dependent on the fact that things 
> like pointers get read and written atomically.
..

But also consider something like this:

 	void store_task(void)
 	{
 		*the_task = current;
 	}

In this case, there is no guarantee that the assignment
can be done atomically on all CPU types.  Some RISC archs
(eg. MIPS R2xxx) require an (interruptible) instruction pair
to store values to a potentially unaligned address.

This was a BIG issue on a different system that I once worked on.

Cheers
