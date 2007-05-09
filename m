Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXEIWQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXEIWQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbXEIWQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:16:23 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28772 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570AbXEIWQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:16:22 -0400
Message-ID: <46424904.4000705@oracle.com>
Date: Wed, 09 May 2007 15:19:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Heikki Orsila <shdl@zakalwe.fi>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] "volatile considered harmful" document
References: <25493.1178744744@lwn.net> <20070509220548.GA10873@zakalwe.fi>
In-Reply-To: <20070509220548.GA10873@zakalwe.fi>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heikki Orsila wrote:
> Imo, the best style to relay information is by directly stating facts.
> I'm going to try to suggest some improvements on this..
> 
> On Wed, May 09, 2007 at 03:05:44PM -0600, Jonathan Corbet wrote:
>> Andrew Morton recently called out[1] use of volatile in a
>> +submitted patch, saying:
>> +
>> +	The volatiles are a worry - volatile is said to be
>> +	basically-always-wrong in-kernel, although we've never managed to
>> +	document why, and i386 cheerfully uses it in readb() and friends.
>> +
>> +In response, Randy Dunlap pulled together some email from Linus[2] on the
>> +topic and suggested that we could maybe "document why."  Here is the
>> +result.
> 
> I think previous text is unnecessary. Just tell the reasons why 
> volatile is bad and what should be used instead, no need to quote 
> people.

Ack, the doc. history isn't needed.

>> +The point that Linus often makes with regard to volatile is that
>> +its purpose is to suppress optimization, which is almost never what one
>> +really wants to do.  In the kernel, one must protect accesses to data
>> +against race conditions, which is very much a different task.  
> 
> Again, I would write this in non-personal way:
> 
> "Volatile is often used to prevent optimization, but it is not the
> behavior that is actually wanted. Access to data must be protected and 
> handled with kernel provided synchronization, mutual exclusion and 
> barriers tools. These tools make volatile useless."
> 
>> +Like volatile, the kernel primitives which make concurrent access to data
>> +safe (spinlocks, mutexes, memory barriers, etc.) are designed to prevent
>> +unwanted optimization.  If they are being used properly, there will be no
>> +need to use volatile as well.
> 
> The previous suggestion takes care of explaining that, remove this.
> 
>> If volatile is still necessary, there is
>> +almost certainly a bug in the code somewhere.  In properly-written kernel
>> +code, volatile can only serve to slow things down.
>> +
>> +Consider a typical block of kernel code:
>> +
>> +    spin_lock(&the_lock);
>> +    do_something_on(&shared_data);
>> +    do_something_else_with(&shared_data);
>> +    spin_unlock(&the_lock);
>> +
>> +If all the code follows the locking rules, the value of shared_data cannot
>> +change unexpectedly while the_lock is held.  Any other code which might
>> +want to play with that data will be waiting on the lock.
> 
> Ok
> 
>> +The spinlock
>> +primitives act as memory barriers - they are explicitly written to do so -
>> +meaning that data accesses will not be optimized across them.
> 
> "Spinlock primitives will serialise execution of code regions, and 
> memory barrier functions must be used inside spinlocks to force 
> loads and stores."
> 
>> So the
>> +compiler might think it knows what will be in some_data, but the
>> +spin_lock() call will force it to forget anything it knows.  There will be
>> +no optimization problems with accesses to that data.
> 
> I would say it directly:
> 
> "Spinlock will force an implicit memory barrier, thus preventing 
> optimizations to data access."
> 
>> +If shared_data were declared volatile, the locking would
>> +still be necessary. But the compiler would also be prevented from
>> +optimizing access to shared _within_ the critical section,
>> +when we know that nobody else can be working with it.  While the lock is
>> +held, shared_data is not volatile.
> 
> ok
> 
>>   This is why Linus says:
>> +
>> +	Also, more importantly, "volatile" is on the wrong _part_ of the
>> +	whole system. In C, it's "data" that is volatile, but that is
>> +	insane. Data isn't volatile - _accesses_ are volatile. So it may
>> +	make sense to say "make this particular _access_ be careful", but
>> +	not "make all accesses to this data use some random strategy".
> 
> Unnecessary quoting, imo. Tell the same information directly without 
> personifying the statement.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
