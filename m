Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYDFTO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYDFTO2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 15:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYDFTOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 15:14:21 -0400
Received: from relay.gothnet.se ([82.193.160.251]:7213 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752292AbYDFTOU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 15:14:20 -0400
Message-ID: <47F920E4.9050808@tungstengraphics.com>
Date: Sun, 06 Apr 2008 21:13:40 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Subject: Re: [RFC] Use kernel_map_pages() to avoid illegal page aliasing.
References: <47F8DA44.3070008@tungstengraphics.com> <47F91DFD.9030508@goop.org>
In-Reply-To: <47F91DFD.9030508@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Thomas Hellström wrote:
>> Hi!
>>
>> For a long time now, the agpgart module has been creating illegal 
>> mapping aliases, since the user-space mappings of the pages in the 
>> gart are usually write-combined, whereas the kernel linear mapping of 
>> the same pages are uc for x86, and may even be wb for some 
>> architectures.
>>
>> In order to fix this, and to facilitate fast insertion and removal of 
>> pages into / from the gart I'd like to disable all default kernel 
>> mappings for those pages, which would in effect, make them behave as 
>> highmem pages from our point of view.
>>
>> As prevously discussed, the x86 set_memory_xxx() interface wasn't 
>> suitable for this, since it handles only a single mapping, and the 
>> pages may have more than one default kernel mapping.
>>
>> But it turns out that there is an interface that does exactly this. 
>> kernel_map_pages(). But it is only available  with 
>> CONFIG_DEBUG_PAGEALLOC. I'd like to make that function exported by 
>> default, but with some minor alterations as the original functions 
>> does some debug checks as well, that aren't desirable for the purpose 
>> mentioned above:
>>
>> As with highmem pages, if the driver sets up user-space mappings with 
>> non-standard caching attributes, those mappings need to be killed at 
>> suspend time, since the suspend code would otherwise create temporary 
>> incompatible mappings.
>>
>> On x86 this all would probably work fine. Does kernel_map_pages() 
>> work identically on other architectures? Specifically: Will it always 
>> work with a 4K page granularity?
>
> Well, not all architectures use 4k as their base page size, but 
> kernel_map_pages should work at the smallest supported page size.
>
> The disadvantage of this is that it will end up shattering any 
> large-page mappings the kernel has.  This is pretty much unavoidable 
> unless you can arrange to only allocate AGP pages in a physically 
> distinct area away from other kernel allocations (a mechanism to do 
> this might be generally useful, though I'm not sure what form it would 
> take - another zone perhaps?).
>
>    J
Thanks for the info. Yes, we've had to live with the splitting of large 
pages for some time. In the future we'll probably set up a pool of video 
pages into which we might perhaps try to allocate highmem pages or try 
allocations with large page sizes. In the end perhaps another zone will 
be needed.

/Thomas




