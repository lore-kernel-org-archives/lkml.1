Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYDIGz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYDIGz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYDIGzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:55:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35223 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752394AbYDIGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:55:50 -0400
Message-ID: <47FC6871.2050500@sgi.com>
Date: Tue, 08 Apr 2008 23:55:45 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: bootmem allocator
References: <20080407185613.GD9211@cvg> <20080407190904.GH12292@elte.hu> <87iqytqwl7.fsf@basil.nowhere.org> <20080408080446.GA12308@elte.hu> <47FC5B7C.3020504@sgi.com> <20080409060854.GB19010@one.firstfloor.org>
In-Reply-To: <20080409060854.GB19010@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Tue, Apr 08, 2008 at 11:00:28PM -0700, Mike Travis wrote:
>> Ingo Molnar wrote:
>>> * Andi Kleen <andi@firstfloor.org> wrote:
>>>
>>>>> hm, bootmem allocator is supposed to clear memory. We have a couple 
>>>>> of places that rely on that.
>>>> I was actually considering to change that for the GB pages hugetlbfs 
>>>> patchkit, because memset for 1G is a little slow and not needed (will 
>>>> be cleared later anyways) and it might be a problem for very large 
>>>> systems with a lot of such pages at boot.
>>> changing the default behavior of bootmem alloc to be non-clearing is a 
>>> really bad idea that will only cause unrobustness. The proper approach 
>>> is to add an _opt-in_ API that does not clear memory 
>>> (bootmem_alloc_dontclear() or whatever), available to callers that know 
>>> it for sure that they dont need the clearing.
>> Yes, changing the default of bootmem_alloc is a bad idea.  I just changed
>> a bunch of static arrays to bootmem alloc's and it was pointed out early
>> that not only does bootmem_alloc clear memory, but also panics if it's not
>> available.
> 
> There are more and more bootmem calls that don't want the panic actually.
> That is why _nopanic was invented (and gets more and more variants)
> At some point the default could be even switched.
> 
> I think the right way would be to survey the callers (there are not
> that many) and then come up with a sane single API that caters to the
> majority of them by default and passes flags for the special cases.
> 
> -Andi

Hi Andi,

I really don't care(*), but there's lot's of code that expects a certain
behavior.  Either all the source calls have to be modified en masse (and you
well know that's difficult given the _zillion_ source trees), or you have to
introduce the new API transparently.  That means leaving a backdoor for old
calls:

     #define bootmem_alloc_low(...) \
	 __new_bootmem_alloc(..., FLAGS_FOR_OLD_BOOTMEM_ALLOC_LOW);

Then I think you're free to optimize away... d;-) [happy face with a baseball cap]

Cheers,
Mike

(*) As long as I don't have to debug problems as a result of the change...! ;-)
