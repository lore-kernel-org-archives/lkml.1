Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYJGP2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYJGP2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYJGP2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:28:11 -0400
Received: from gw.goop.org ([64.81.55.164]:59006 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYJGP2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:28:10 -0400
Message-ID: <48EB8008.1020700@goop.org>
Date: Tue, 07 Oct 2008 08:28:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080919)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/7] x86, cpa: make the kernel physical mapping initialization
 a two pass sequence
References: <20080923210035.413932000@linux-os.sc.intel.com> <20080923211444.369122000@linux-os.sc.intel.com> <48EA798D.1090303@goop.org> <20081007015833.GO15609@linux-os.sc.intel.com>
In-Reply-To: <20081007015833.GO15609@linux-os.sc.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> Jeremy, hi. This dependency is not documented or explicitly called anywhere
> in the mm/init_64.c code. I would have expected to see a big comment near this
> kind of code :(
>   

Indeed yes.  I've explained it in various places, including commit 
comments, but there should be a comment right there in the code.

> It is not just the NX bit that we change. For DEBUG_PAGEALLOC, we want
> use 4k pages instead of large page mappings during the identity mapping
> (as this will clean some of the cpa pool code avoiding the cpa and hence
>  the page allocations for splitting the big pages from interrupt context's).
> In this case will will split the static large page mappings.
>   

Well, that's OK.  We just need to preserve the original page permissions 
when fragmenting the large mappings.  (This isn't a case that affects 
Xen, because it will already be 4k mappings.)

>>    3. The actual implementation is pretty ugly; adding a global variable
>>       and hopping about with goto does not improve this code.
>>     
>
> This is very early init code and I can't be fancy like calling cpa()
> which need mm to be up and running.

Well, is there any urgency to set NX that early?  It might catch some 
early bugs, but there's no urgent need.

>  And also, cpa's on individual chunks
> for entire identity mapping will make the boot slow.
>   

Really?  Why?  How slow?


>> it cause real failures?  Could we revert this patch and address the
>> problem some other way?  Which app note is this, BTW?  The one I have on
>> hand, "TLBs, Paging-Structure Caches, and Their Invalidation", Apr 2007,
>> does not seem to mention this restriction.
>>     
>
> http://developer.intel.com/design/processor/applnots/317080.pdf
> Section 6 page 26
>   

Ah, OK.  I have the first version of this document which does not 
mention this.  It would be good to explicitly cite this document by name 
in the comments.

>> Xen with this code in place (touching this code is always non-trivial).
>> I haven't looked into it in depth yet, but there's a few stand out "bad
>> for Xen" pieces of code here.  (And I haven't tested 32-bit yet.)
>>
>> Quick rules for keeping Xen happy here:
>>
>>    1. Xen provides its own initial pagetable; the head_64.S one is
>>       unused when booting under Xen.
>>    2. Xen requires that any pagetable page must always be mapped RO, so
>>       we're careful to not replace an existing mapping with a new one,
>>       in case the existing mapping is a pagetable one.
>>    3. Xen never uses large pages, and the hypervisor will fail any
>>       attempt to do so.
>>     
>
> Thanks for this info. Will get back to you tomorrow.
>   

Great.  Also, do you think you'll have a chance to look at unifying the 
32 and 64 bit code (where 32 uses the 64-bit version)?


Thanks,
    J
