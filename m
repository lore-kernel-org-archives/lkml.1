Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYCaLLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYCaLLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYCaLL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:11:27 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:8298 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbYCaLL0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:11:26 -0400
Message-ID: <47F0C6C2.2000004@tungstengraphics.com>
Date: Mon, 31 Mar 2008 13:10:58 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org>
In-Reply-To: <20080331091829.GD29105@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Mar 31, 2008 at 11:06:16AM +0200, Thomas Hellström wrote:
>   
>> Andi Kleen wrote:
>>     
>>>> Also I think we need to clarify the semantics of the c_p_a 
>>>> functionality. Right now both AGP and DRM relies on c_p_a  doing an 
>>>> explicit cache flush. Otherwise the data won't appear on the device side 
>>>> of the aperture.
>>>>    
>>>>         
>>> But surely not in cpa I hope ? Or are you saying you first write data
>>> and then do cpa? If true that would be quite an abuse of CPA 
>>> I would say and you should fix it ASAP.
>>>
>>>  
>>>       
>> As AGP buffers are moved in- and out of AGP, the caching policy changes, 
>> so yes, there may be writes to cache coherent memory that needs to be 
>> flushed at some point. Since CPA has been doing that up to now, and the 
>> codepaths involved are quite time-critical, a double cache-flush is a 
>>     
>
> That doesn't make sense. You shouldn't be using CPA in any 
> time critical code path. It will always be slow. 
>
> For anything time critical you should keep a pool of uncached pages 
> once set up using CPA and reuse them.
>
> CPA really should only be used on initialization or for
> larger setup changes which are ok to go somewhat slower.
>   
Let me rehprase. Not really time-critical but it is of some importance 
that CPA is done quickly.
We're dealing with the tradeoff of reading from uncached device memory 
vs taking the pages out of
AGP, setting up a cache-coherent mapping, read and then change back. 
What we'd really would like to set up is a pool of completely unmapped 
(like highmem) pages. Then we could, to a large extent, avoid the CPA calls.

>
>
> The cache must be flushed in CPA, there is no way around it.
>
> If you write data into the buffers before you do CPA on them
> you could avoid it, but I don't think you should do that anywhere
> near time critical code, so it actually shouldn't matter.
>
> -Andi
>   
But then we wouldn't really be discussing SS either? For DRM purposes, 
the more performance we can squeeze out of CPA, the better.

/Thomas




