Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbYBLIoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbYBLIoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYBLIoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:44:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:45823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYBLIoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:44:06 -0500
Message-ID: <47B15C9D.6090400@suse.de>
Date: Tue, 12 Feb 2008 09:45:17 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, tglx@linutronix.de,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] [7/8] CPA: Don't flush caches on CPUs that support self-snoop
References: <200802111050.372086035@suse.de>	<200802111627.23751.ak@suse.de>	<20080211173606.GB21564@linux-os.sc.intel.com>	<200802111858.46200.ak@suse.de>	<20080211194712.GA21118@linux-os.sc.intel.com> <20080211123659.421bfaee@laptopd505.fenrus.org>
In-Reply-To: <20080211123659.421bfaee@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 11 Feb 2008 11:47:12 -0800
> "Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:
>
>   
>> On Mon, Feb 11, 2008 at 06:58:46PM +0100, Andi Kleen wrote:
>>     
>>> On Monday 11 February 2008 18:36:06 Siddha, Suresh B wrote:
>>>       
>>>> On Mon, Feb 11, 2008 at 04:27:23PM +0100, Andi Kleen wrote:
>>>>         
>>>>>>> That is exactly the situation in pageattr.c. You're saying
>>>>>>> the manual is wrong here?
>>>>>>>               
>>>>>> I'm saying that we are not following step 2 (marking the
>>>>>> pages not present) 
>>>>>>             
>>>>> Yes that's true. It's one of the design problems of the intent
>>>>> API that makes fixing this hard unfortunately.
>>>>>           
>>>> BTW, making pages not present is required only while changing the
>>>> attribute from WB to WC or WC to WB. I think this step is for
>>>> avoiding attribute aliasing for speculative accesses. For UC, we
>>>> don't have speculative accesses and such we probably don't need
>>>> it.
>>>>         
>>> Ok that would imply that my patch is ok for all current in tree
>>> users at least (none of them ever set WC currently, only UC). It
>>> might not be safe for the out of tree WC users though.
>>>
>>> So it should be ok to apply according to standard policy :)
>>>       
>> There is atleast one issue though. For an I/O device which is not
>> capable of snooping the caches, if the driver model assumes that
>> ioremap_nocache() will flush the cpu caches(before initiating DMA),
>> then the lack of cache flush in cpa() might cause some breakages.
>>     
>
> this is a totally separate issue and I agree, it needs a separate API.
> (well there is one more or less, but lets make it explicit).
>   

I doubt we have any drivers with this problem because ioremap()
for the longest time (until I added change_page_attr() to it the first time
one a few releases ago) didn't flush its caches at all and it still
doesn't flush the caches for the common case of the ioremapped area
not being part of the direct mapping (standard case on 32bit and
not uncommon on 64bit even)
>   
>>>> So WC support through PAT should take care of it.
>>>>         
>>> You mean the PAT patch should do something about it? Yes probably,
>>> but what?
>>>       
>> marking the pages not present etc..
>>     
>
> another option is to do a three-step tango; go from WB to UC, flush, then go from UC to WB.
>
> We need to deal with this for correctness anyway (since this could happen naturally) so
> might as well do things that way.
>   
Please clarify what you mean. For what correctness aspect and in
what circumstances would such a three step tango be needed?

I don't see any mention of such a requirement in the manual.

-Andi

