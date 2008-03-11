Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYCKMip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYCKMip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYCKMig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:38:36 -0400
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:44722 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYCKMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:38:35 -0400
Message-ID: <47D67D3A.5030208@panasas.com>
Date: Tue, 11 Mar 2008 14:38:18 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: "Ph. Marek" <philipp.marek@bmlv.gv.at>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Stacking bio support
References: <200803110352.41479.phillips@phunq.net> <200803111233.21386.philipp.marek@bmlv.gv.at> <200803110507.10858.phillips@phunq.net>
In-Reply-To: <200803110507.10858.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11 2008 at 14:07 +0200, Daniel Phillips <phillips@phunq.net> wrote:
> On Tuesday 11 March 2008 04:33, Ph. Marek wrote:
>> Win32 has IRP stacks, which do mostly the same AFAIU.
>> 	http://msdn2.microsoft.com/en-us/library/ms796144.aspx
> 
> That seems to be filling a similar need all right, though it looks
> like a fancier (read: clunkier) solution.
> 
>> How do you handle the reallocation?
>> - If you don't do it (but rely on the fact that the initial allocation is
>>   enough), you might end up with NO_MORE_IRP_STACK_LOCATIONS
>>     http://msdn2.microsoft.com/en-us/library/ms793675.aspx
>> - If you do reallocate, the allocations have to register themselves in
>>   the emergency pool (see the current thread about swapping over NFS)
> 
> Yes, I reallocate.  I do not currently register these with the
> emergency pool, good spotting.  I intend to do all such reallocations
> with GFP_MEMALLOC (out of tree deadlock-prevention allocation flag) and
> rely on (out of tree) bio throttling to prevent the memalloc reserve
> from being exhausted.  Hopefully these things will be in-tree in due
> course.
> 

I guess that is not worse then current implementation. So many slab
allocations saved, lets you have a few of your own.
>From passed experience, though, relocation is changed to a link-list
(chaining) of sorts the first time relocation starts to hit consistently.
for 1-in-100 case it can stay, any higher then that better allocate more
space and chain it to the old. It also fits better with the pools paradigm.
I would leave the reallocation for a while but make sure it is all hidden
behind the right API to be easily enhanced later on.
 
> Incidentally, the bio stack should make the bio throttling somewhat
> more elegant, a nice circular effect.
> 
>> I don't say that it's impossible ... just that some "interesting" things will 
>> await you. 
> 
> Tell me about it :-)
> 
>> That's different from the Win32 way AFAIK - there it's defined that every 
>> layer *has* to use its own stack location. (But it's been some time since I 
>> needed that, so I might be wrong.)
> 
> I think you are right.  In fact, I thought about this for a couple of
> years, always getting hung up at exactly that point.  When I stopped
> trying to see the stack as a fixed size object with preassigned frames,
> the rest fell into place.  One obvious problem with the pre-assigned
> approach: you don't always know the path ahead of time that a bio
> will take to a physical device.
>  
>> But I sure hope you succeed!
> 
> Thankyou for your useful comments.  I do need to present a solution
> complete with deadlock prevention.  I guess the bio code will end up
> simpler there too, because with the memalloc anti-deadlock approach,
> the array of bio mempools can go away.
> 
> Regards,
> 
> Daniel

Me too, I'll be watching out on your progress, It looks like the building
blocks of some very advanced possibilities. ("Pure Data")

Do you have a public git tree that we can inspect from time to time.

Cheers 
Boaz
