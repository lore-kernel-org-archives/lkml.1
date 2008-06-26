Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbYFZDL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbYFZDL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 23:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYFZDLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 23:11:18 -0400
Received: from gw.goop.org ([64.81.55.164]:54313 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbYFZDLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 23:11:17 -0400
Message-ID: <486308C9.5070709@goop.org>
Date: Wed, 25 Jun 2008 20:11:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@linux.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
References: <1214242487.11887.35.camel@koto.keithp.com>	 <4862EE4C.4060009@goop.org> <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
In-Reply-To: <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Thu, Jun 26, 2008 at 11:18 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Keith Packard wrote:
>>     
>>> The graphics memory BAR is generally fairly good sized; on Intel chips,
>>> it's between 256M and 1G (and growing). I want to write data into this
>>> region from kernel space, but it's really too big to map the whole thing
>>> into kernel address space, especially on 32-bit systems. ioremap is not
>>> a good option here -- it's way too slow.
>>>
>>> With CONFIG_HIGHMEM enabled, I can use kmap_atomic_pfn (well, actually
>>> the kmap_atomic_proc_pfn included in the DRM tree) and things work quite
>>> well -- performance is good, with barely any measurable time spent in
>>> the PTE whacking (~1%).
>>>
>>> However, with CONFIG_HIGHMEM disabled, there aren't any PTEs reserved
>>> for this kind of mapping fun. This makes me suspect that abusing
>>> kmap_atomic for this operation would not be appreciated.
>>> Should I use kmap_atomic_pfn to reach my PCI BAR like this?
>>>
>>> Would it be reasonable to supply a patch that made this work even
>>> without CONFIG_HIGHMEM?
>>>
>>>       
>> Usually people use ioremap to map device memory.  Wouldn't that work in this
>> case?
>>
>>     
>
> "but it's really too big to map the whole thing
> into kernel address space, especially on 32-bit systems. ioremap is not
> a good option here -- it's way too slow."
>
> From the original mail.
>   

Uh, yep.

> doing tlb flush for iounmap is slow as all hell if you do it a lot,
> and we can't afford to mmap the whole aperture it can 1GB.
>   

Maybe Nick's vmap reimplementation would help here.  It effectively 
allows you to map stuff into the vmalloc space, and do lazy tlb flushes 
to mitigate the cost of map/unmap.  He posted the patches week or so ago.

    J
