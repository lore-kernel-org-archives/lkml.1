Return-Path: <linux-kernel-owner+w=401wt.eu-S1767900AbXEDLEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767900AbXEDLEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767901AbXEDLEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:04:04 -0400
Received: from relay.gothnet.se ([82.193.160.251]:8965 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1767900AbXEDLEC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:04:02 -0400
Message-ID: <463B12F9.8060900@tungstengraphics.com>
Date: Fri, 04 May 2007 13:03:21 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Jerome Glisse <j.glisse@gmail.com>
CC: Keith Packard <keithp@keithp.com>, dri-devel@lists.sourceforge.net,
       Dave Airlie <airlied@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>	 <1178137279.53297.114.camel@vonnegut>	 <46391860.3070409@tungstengraphics.com>	 <1178251621.27028.9.camel@neko.keithp.com>	 <463AE9AE.7070806@tungstengraphics.com> <4240b9160705040149v3c97413fg54f1486f55ffbc11@mail.gmail.com>
In-Reply-To: <4240b9160705040149v3c97413fg54f1486f55ffbc11@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse wrote:
> On 5/4/07, Thomas Hellström <thomas@tungstengraphics.com> wrote:
>> Keith Packard wrote:
>> > On Thu, 2007-05-03 at 01:01 +0200, Thomas Hellström wrote:
>> >
>> >
>> >> It might be possible to find schemes that work around this. One way
>> >> could possibly be to have a buffer mapping -and validate order for
>> >> shared buffers.
>> >>
>> >
>> > If mapping never blocks on anything other than the fence, then there
>> > isn't any dead lock possibility. What this says is that ordering of
>> > rendering between clients is *not DRMs problem*. I think that's a good
>> > solution though; I want to let multiple apps work on DRM-able memory
>> > with their own CPU without contention.
>> >
>> > I don't recall if Eric layed out the proposed rules, but:
>> >
>> >  1) Map never blocks on map. Clients interested in dealing with this
>> >     are on their own.
>> >
>> >  2) Submit blocks on map. You must unmap all buffers before submitting
>> >     them. Doing the relocations in the kernel makes this all possible.
>> >
>> >  3) Map blocks on the fence from submit. We can play with pending the
>> >     flush until the app asks for the buffer back, or we can play with
>> >     figuring out when flushes are useful automatically. Doesn't matter
>> >     if the policy is in the kernel.
>> >
>> > I'm interested in making deadlock avoidence trivial and eliminating 
>> any
>> > map-map contention.
>> >
>> >
>> It's rare to have two clients access the same buffer at the same time.
>> In what situation will this occur?
>>
>> If we think of map / unmap and validation / fence  as taking a buffer
>> mutex either for the CPU or for the GPU, that's the way implementation
>> is done today. The CPU side of the mutex should IIRC be per-client
>> recursive. OTOH, the TTM implementation won't stop the CPU from
>> accessing the buffer when it is unmapped, but then you're on your own.
>> "Mutexes" need to be taken in the correct order, otherwise a deadlock
>> will occur, and GL will, as outlined in Eric's illustration, more or
>> less encourage us to take buffers in the "incorrect" order.
>>
>> In essence what you propose is to eliminate the deadlock problem by just
>> avoiding taking the buffer mutex unless we know the GPU has it. I see
>> two problems with this:
>>
>>     * It will encourage different DRI clients to simultaneously access
>>       the same buffer.
>>     * Inter-client and GPU data coherence can be guaranteed if we issue
>>       a mb() / write-combining flush with the unmap operation (which,
>>       BTW, I'm not sure is done today). Otherwise it is up to the
>>       clients, and very easy to forget.
>>
>> I'm a bit afraid we might in the future regret taking the easy way out?
>>
>> OTOH, letting DRM resolve the deadlock by unmapping and remapping shared
>> buffers in the correct order might not be the best one either. It will
>> certainly mean some CPU overhead and what if we have to do the same with
>> buffer validation? (Yes for some operations with thousands and thousands
>> of relocations, the user space validation might need to stay).
>>
>> Personally, I'm slightly biased towards having DRM resolve the deadlock,
>> but I think any solution will do as long as the implications and why we
>> choose a certain solution are totally clear.
>>
>> For item 3) above the kernel must have a way to issue a flush when
>> needed for buffer eviction.
>> The current implementation also requires the buffer to be completely
>> flushed before mapping.
>> Other than that the flushing policy is currently completely up to the
>> DRM drivers.
>>
>> /Thomas
>
> I might say stupid things as i don't think i fully understand all
> the input to this problem. Anyway here is my thought on all this:
>
> 1) First client map never block (as in Keith layout) except on
>    fence from drm side (point 3 in Keith layout)
>
But is there really a need for this except to avoid the above-mentioned 
deadlock?
As I'm not too up to date with all the possibilities the servers and GL 
clients may be using shared buffers,
I need some enlightenment :). Could we have an example, please?

> 4) We got 2 gpu queue:
>             - one with pending apps ask in which we do all stuff 
> necessary
>               to be done before submitting (locking buffer, 
> validation, ...)
>               for instance we might wait here for each buffer that are 
> still
>               mapped by some other apps in user space
>             - one run queue in which we add each apps ask that are now
>               ready to be submited to the gpu

This is getting closer and closer to a GPU scheduler, an interesting 
topic indeed.
Perhaps we should have a separate  discussion on the  needs and 
requirements for such a thing?

Regards,
/Thomas



