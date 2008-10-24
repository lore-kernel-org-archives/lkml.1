Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYJXLKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYJXLKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYJXLKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:10:24 -0400
Received: from relay.gothnet.se ([82.193.160.251]:5687 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752223AbYJXLKX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:10:23 -0400
Message-ID: <4901ABD9.10308@tungstengraphics.com>
Date: Fri, 24 Oct 2008 13:04:57 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Keith Packard <keithp@keithp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, nickpiggin@yahoo.com.au,
       airlied@linux.ie, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Peter Anvin <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org
Subject: Re: Adding kmap_atomic_prot_pfn
References: <20081022093615.GF12453@elte.hu> <1224793332.22877.8.camel@koto.keithp.com> <20081023133840.d4eef579.akpm@linux-foundation.org> <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org> <1224813015.22877.51.camel@koto.keithp.com> <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org> <1224829359.22877.86.camel@koto.keithp.com> <49017A2C.5010504@tungstengraphics.com> <20081024083830.GB6734@elte.hu> <49019307.6070207@tungstengraphics.com> <20081024093233.GA20310@elte.hu>
In-Reply-To: <20081024093233.GA20310@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Thomas Hellström <thomas@tungstengraphics.com> wrote:
>
>   
>> Ingo Molnar wrote:
>>     
>>> * Thomas Hellström <thomas@tungstengraphics.com> wrote:
>>>
>>>   
>>>       
>>>> Keith,
>>>>
>>>> What you actually are doing here is claiming copyright on code that  
>>>> other people have written, and tighten the export restrictions.   
>>>> kmap_atomic_prot_pfn() appeared long ago in drm git with identical  
>>>> code and purpose, but with different authors, and iounmap_atomic is  
>>>> identical to kunmap_atomic.
>>>>     
>>>>         
>>>   
>>>       
>>>>> +EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
>>>>>       
>>>>>           
>>> you want to use this facility in a binary-only driver?
>>>
>>> 	Ingo
>>>   
>>>       
>> At this point I have no such use for it, no.
>> The original user was a MIT style licenced driver.
>>     
>
> okay, then just to put this question to rest: i wrote the original 
> 32-bit highmem code ~10 years ago. I wrote the first version of fixmap 
> support - in fact i coined the term. I wrote the first version of the 
> atomic-kmap facility as well.
>
> All of that code is licensed under the GPLv2. So if anyone wants to make 
> any copyright claims about highmem/kmap/fixmap derivative works, 
> consider it in that light.
>   
I fully acknowledge that. The fact that others wrote almost all of the 
code is the reason why there is no  additional copyright claims in the 
file of  the original kmap_atomic_prot_pfn() implementation.

What I'm considering very bad form is someone taking other people's 
contributions, be it code or ideas,  no matter how small they are, claim 
copyright on them and restrict the original usage. That's really the 
point here. Frankly, from my own usage point of view I don't really care 
about the specific case (whether they are exported GPL or not), but with 
the current form of this patch, I'm basically no longer allowed to use 
the code currently in DRM git without Keith's permission.

> Regarding this new API variant that Keith wrote: it would be silly and 
> dangerous to export it anywhere but to in-kernel drivers. The API 
> disables preemption on 32-bit and rummages deep in the guts of the 
> kernel as well, uses up a precious resource (fixmap slots), etc. It's 
> internal and we eventually might want to deprecate forms of it and 
> concentrate on the good 64-bit performance side.
>
>   
These are all good arguments to reserve this api for in-kernel drivers.

There are other reasons why it should be available to out of tree drivers:

* The api enables a fast facility that will be extremely important by 
graphics drivers in the future, probably not only for in-kernel drivers.
Particularly as future graphics drivers will want to get fast 
write-combined kernel mappings also on highmem pages, not only io.
This latter actually suggests keeping the form kmap_atomic_prot_pfn 
instead of iomap_atomic_prot_pfn, and make it permanent, unless the same 
goals can be achieved by the VMAP work Nick Piggin is suggesting.

* The use of k[un]map_atomic() would, following your argumentation, be 
equally dangerous to export non-GPL?

Now, considering these pros and cons one might still come to the 
conclusion that for stability reasons it is best to keep this API for in 
kernel drivers. I don't really know enough about the affected kernel 
internals to be able to judge. I just think it's important that all 
facts are considered.

/Thomas





