Return-Path: <linux-kernel-owner+w=401wt.eu-S1758229AbYDTOUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbYDTOUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 10:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYDTOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 10:20:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48154 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYDTOUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 10:20:32 -0400
Message-ID: <480B50F1.8040309@firstfloor.org>
Date: Sun, 20 Apr 2008 16:19:29 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Mark Lord <lkml@rtr.ca>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <20080420133857.GB26536@1wt.eu>
In-Reply-To: <20080420133857.GB26536@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Sun, Apr 20, 2008 at 09:27:32AM -0400, Mark Lord wrote:
>> Willy Tarreau wrote:
>>> What would really help would be to have 8k stacks with the lower page
>>> causing a fault and print a stack trace upon first access. That way,
>>> the safe setting would still report us useful information without
>>> putting users into trouble.
>> ..
>>
>> That's the best suggestion from this thread, by far!

Only if you believe that 4K stack pages are a worthy goal.
As far as I can figure out they are not. They might have been
a worthy goal on crappy 2.4 VMs, but these times are long gone.

The "saving memory on embedded" argument also does not 
quite convince me, it is unclear if that is really
a significant amount of memory on these systems and if that 
couldn't be addressed better (e.g. in running generally
less kernel threads).  I don't have numbers on this,
but then the people who made this argument didn't have any
either :) 

If anybody has concrete statistics on this
(including other kernel memory users in realistic situations)
please feel free to post them.


>> Can you produce a patch for 2.6.26 for this?
> 
> Unfortunately, I can't. I wouldn't know where to start from.

The problem with his suggestion is that the lower 4K of the stack page 
are accessed in normal operation too because it contains the thread_struct.
That could be changed, but it would be a relatively large change
because you would need to audit/change a lot of code who assumes 
thread_struct and stack are continuous

If that was changed implementing Willy's suggestion would not be that 
difficult using cpa()  at the cost of some general slowdown in 
increased TLB misses and much higher thread creation/tear down cost etc, 
Using the alternative vmalloc way has also other issues.

But still the fundamental problem is that it would likely only
hit the interesting cases in real production setups and I don't 
think the production users would be very happy to slow down
their kernels and handle strange backtraces just to act as guinea pigs 
for something dubious

-Andi

