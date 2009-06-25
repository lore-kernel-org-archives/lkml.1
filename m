Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbZFYJEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbZFYJEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZFYJD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:03:57 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:58694 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbZFYJD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:03:56 -0400
Message-ID: <4A433D7C.20002@shipmail.org>
Date: Thu, 25 Jun 2009 11:03:56 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Jerome Glisse <glisse@freedesktop.org>, Nick Piggin <npiggin@suse.de>,
       Jerome Glisse <jglisse@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH] radeon: preallocate memory for command stream parsing
References: <1245786367-2773-1-git-send-email-jglisse@redhat.com>	<84144f020906231252u5131ffbdk74f06f8a0f692cf9@mail.gmail.com>	<1245832141.2408.4.camel@localhost> <1245913447.2018.18.camel@penberg-laptop>
In-Reply-To: <1245913447.2018.18.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg skrev:
> Hi Jerome,
>
> On Tue, 2009-06-23 at 22:52 +0300, Pekka Enberg wrote:
>   
>>> On Tue, Jun 23, 2009 at 10:46 PM, Jerome Glisse<jglisse@redhat.com> wrote:
>>>       
>>>> Command stream parsing is the most common operation and can
>>>> happen hundred of times per second, we don't want to allocate/free
>>>> memory each time this ioctl is call. This rework the ioctl
>>>> to avoid doing so by allocating temporary memory along the
>>>> ib pool.
>>>>
>>>> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
>>>>         
>>> So how much does this help (i.e. where are the numbers)? I am bit
>>> surprised "hundred of times per second" is an issue for our slab
>>> allocators. Hmm?
>>>       
>
> On Wed, 2009-06-24 at 10:29 +0200, Jerome Glisse wrote:
>   
>> I didn't have real number but the vmap path was really slower,
>> quake3 fps goes from ~20 to ~40 on average when going from vmap
>> to preallocated. When using kmalloc i don't thing there was so
>> much performance hit. But i think the biggest hit was that in
>> previous code i asked for zeroed memory so i am pretty sure kernel
>> spend a bit of time clearing page. I reworked the code to avoid
>> needing cleared memory and so avoid memset, this is likely why
>> we get a performance boost.
>>     
>
> OK. If kmalloc() (without memset) really was too slow for your case, I'd
> be interested in looking at it in more detail. I'm not completely
> convinced the memory pool is needed here but I'm not a DRM expert so I'm
> not NAK'ing this either...
>
> 			Pekka
>
>   
Hi!
 From previous experience with other drivers kmalloc() is just fine 
performance-wise.
I've also never seen memsetting pages turn up on the profile. It would 
be interesting to see an oprofile timing of this to try and pinpoint 
what's happening.

However, in this case, I believe Jerome was forced to use vmalloc to 
guarantee that the allocation would succeed, and frequent vmallocs seem 
to be a performance killer.

One should also be careful about frame-rates. Tuning memory manager / 
command submission operation is usually a matter of how much CPU is 
consumed for a given framerate. If one compares framerates one must make 
sure that the CPU is at nearly 100% while benchmarking.

/Thomas



> ------------------------------------------------------------------------------
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   

