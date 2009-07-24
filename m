Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZGXLOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZGXLOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 07:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbZGXLOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 07:14:10 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:36429 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588AbZGXLOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 07:14:09 -0400
Message-ID: <4A699784.9020803@vmware.com>
Date: Fri, 24 Jul 2009 13:14:12 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Use clflush() instead of wbinvd() whenever	possible
 when changing mapping
References: <1248421981-31865-1-git-send-email-thellstrom@vmware.com> <87ocra1jn6.fsf@basil.nowhere.org> <4A698B3E.4020208@vmware.com> <20090724105831.GB2045@basil.fritz.box>
In-Reply-To: <20090724105831.GB2045@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Jul 24, 2009 at 12:21:50PM +0200, Thomas Hellstrom wrote:
>   
>> Andi Kleen wrote:
>>     
>>> Thomas Hellstrom <thellstrom@vmware.com> writes:
>>>
>>>   
>>>       
>>>> The current code uses wbinvd() when the area to flush is > 4MB. Although this
>>>> may be faster than using clflush() the effect of wbinvd() on irq latencies
>>>> may be catastrophical on systems with large caches. Therefore use clflush()
>>>>     
>>>>         
>>> may be? You seem to miss some hard data here.
>>>
>>>   
>>>       
>> Admittedly.
>>     
>
> So was it motivated by a real problem?
>   

No. It was motivated by the assumption that wbinvd() is just bad:
Qoute:

WBINVD is a very nasty operation. I was talking to some CPU people 
and they really recommended to get rid of it as far as possible. 
Stopping the CPU for msecs is just wrong and there are apparently even 
some theoretical live lock situations. - It is not interruptible in 
earlier VT versions and messes up real time in the hypervisor. Some 
people were doing KVM on rt kernels and had latency spikes from that.


/Qoute
(I believe you wrote that ?)


>> However, the concept of flushing and invalidating the caches completely on 
>> systems with many
>> processors and huge caches when we intend to only flush only small piece of 
>> the cache also sounds like a big overkill.
>>     
>
> The other CPUs will not block (just flush their caches in the background or
> in parallel), so the latency shouldn't scale with the number of sockets.
> Also number of cores also shouldn't impact it because these tend
> to have shared cache hierarchies.
>
> That's just a theory, but not necessarily a worse one than yours :-)
>
>   
>> Furthermore, since the wbinvd() has been introduced as an optimization of 
>> the general clflush() case, did somebody ever check the effects on systems 
>> with many processors and huge caches?
>>     
>
> Typically systems with large caches flush faster too.
>
>   
OK. We should really test this at some point. I currently don't have the 
hardware to do so.

> -Andi
>
>   

/Thomas


