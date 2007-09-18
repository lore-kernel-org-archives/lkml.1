Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbXIREXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbXIREXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbXIREXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:23:44 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:53745 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXIREXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:23:43 -0400
Message-ID: <46EF52A8.4000209@linux.vnet.ibm.com>
Date: Tue, 18 Sep 2007 09:53:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH mm] fix swapoff breakage; however...
References: <Pine.LNX.4.64.0709171947130.15413@blonde.wat.veritas.com> <46EED1A7.5080606@linux.vnet.ibm.com> <Pine.LNX.4.64.0709172038090.25512@blonde.wat.veritas.com> <46EEE81A.1010404@linux.vnet.ibm.com> <Pine.LNX.4.64.0709172312390.19506@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0709172312390.19506@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 18 Sep 2007, Balbir Singh wrote:
>> Hugh Dickins wrote:
>>> What would make sense is (what I meant when I said swap counted
>>> along with RSS) not to count pages out and back in as they are
>>> go out to swap and back in, just keep count of instantiated pages
>>>
>> I am not sure how you define instantiated pages. I suspect that
>> you mean RSS + pages swapped out (swap_pte)?
> 
> That's it.  (Whereas file pages counted out when paged out,
> then counted back in when paged back in.)
> 
>> If a swapoff is going to push a container over it's limit, then
>> we break the container and the isolation it provides.
> 
> Is it just my traditional bias, that makes me prefer you break
> your container than my swapoff?  I'm not sure.
>


:-) Please see my response below

>> Upon swapoff
>> failure, may be we could get the container to print a nice
>> little warning so that anyone else with CAP_SYS_ADMIN can fix the
>> container limit and retry swapoff.
> 
> And then they hit the next one... rather like trying to work out
> the dependencies of packages for oneself: a very tedious process.
> 

Yes, but here's the overall picture of what is happening

1. The system administrator setup a memory container to contain
   a group of applications.
2. The administrator tried to swapoff one/a group of swap files/
   devices
3. Operation 2, failed due to a container being above it's limit.
   Which implies that at some point a container went over it's
   limit and some of it's pages were swapped out

During swapoff, we try to account for pages coming back into the
container, our charging routine does try to reclaim pages,
which in turn implies -- it will use another swap device or
reclaim page cache, if both fails, we return -ENOMEM.

Given that the system administrator has setup the container and
the swap devices, I feel that he is in better control of what
to do with the system when swapoff fails.

In the future we plan to implement per container swap (a feature
desired by several people), assuming that administrators use
per container swap in the future, failing on limit sounds
like the right way to go forward.

> If the swapoff succeeds, that does mean there was actually room
> in memory (+ other swap) for everyone, even if some have gone over
> their nominal limits.  (But if the swapoff runs out of memory in
> the middle, yes, it might well have assigned the memory unfairly.)
> 

Yes, precisely my point, the administrator is the best person
to decide how to assign memory to containers. Would it help
to add a container tunable that says, it's ok to go overlimit
with this container during a swapoff.

> The appropriate answer may depend on what you do when a container
> tries to fault in one more page than its limit.  Apparently just
> fail it (no attempt to page out another page from that container).
> 

The problem with that approach is that applications will fail
in the middle of their task. They will never get a chance
to run at all, they will always get killed in the middle.
We want to be able to reclaim pages from the container and
let the application continue.

> So, if the whole system is under memory pressure, kswapd will
> be keeping the RSS of all tasks low, and they won't reach their
> limits; whereas if the system is not under memory pressure,
> tasks will easily approach their limits and so fail.
> 

Tasks failing on limit does not sound good unless we are out
of all backup memory (slow storage). We still let the application
run, although slowly.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
