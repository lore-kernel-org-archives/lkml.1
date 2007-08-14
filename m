Return-Path: <linux-kernel-owner+w=401wt.eu-S935984AbXHNWyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935984AbXHNWyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932563AbXHNWxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:53:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764789AbXHNWxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:53:33 -0400
Message-ID: <46C2325C.8040900@redhat.com>
Date: Tue, 14 Aug 2007 18:53:16 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 1/23] document preferred use of volatile with atomic_t
References: <46C03885.7000109@redhat.com> <20070813110415.GA24018@shell.boston.redhat.com> <Pine.LNX.4.64.0708141544001.401@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708141544001.401@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Mon, 13 Aug 2007, Chris Snook wrote:
> 
>> @@ -38,7 +45,7 @@
>>  
>>  Next, we have:
>>  
>> -	#define atomic_read(v)	((v)->counter)
>> +	#define atomic_read(v)	(*(volatile int *)&(v)->counter)
>>  
>>  which simply reads the current value of the counter.
> 
> volatile means that there is some vague notion of "read it now". But that 
> really does not exist. Instead we control visibility via barriers 
> (smp_wmb, smp_rmb). Would it not be best to not have volatile at all in 
> atomic operations and let the barriers do the work?

 From my reply in the other thread...

But barriers force a flush of *everything* in scope, which we generally don't 
want.  On the other hand, we pretty much always want to flush atomic_* 
operations.  One way or another, we should be restricting the volatile behavior 
to the thing that needs it.  On most architectures, this patch set just moves 
that from the declaration, where it is considered harmful, to the use, where it 
is considered an occasional necessary evil.

If you really, *really* distrust the compiler that much, you shouldn't be using 
barrier, since that uses volatile under the hood too.  You should just go ahead 
and implement the atomic operations in assembler, like Segher Boessenkool did 
for powerpc in response to my previous patchset.

	-- Chris
