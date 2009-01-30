Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZA3JbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZA3JbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZA3JbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:31:00 -0500
Received: from relay.gothnet.se ([82.193.160.251]:12536 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751500AbZA3Ja6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:30:58 -0500
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jan 2009 04:30:57 EST
Message-ID: <4982C4D3.4040704@shipmail.org>
Date: Fri, 30 Jan 2009 10:13:55 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, kerolasa@iki.fi,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Dickins <hugh@veritas.com>, dri-devel@lists.sourceforge.net,
       kerolasa@gmail.com
Subject: Re: PROBLEM: kernel BUG at drivers/gpu/drm/drm_fops.c:146!
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com>	<20090129172010.f25fe0ad.akpm@linux-foundation.org>	<21d7e9970901291743q4f0a9393yc5c24afb50013ff3@mail.gmail.com>	<200901291950.18724.jbarnes@virtuousgeek.org> <20090129204403.5d9e4b38.akpm@linux-foundation.org>
In-Reply-To: <20090129204403.5d9e4b38.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 29 Jan 2009 19:50:17 -0800 Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
>   
>> On Thursday, January 29, 2009 5:43 pm Dave Airlie wrote:
>>     
>>> On Fri, Jan 30, 2009 at 11:20 AM, Andrew Morton
>>>       
>>>> hm, I'm a bit surprised to see the drm code using `struct
>>>> address_space' and read_mapping_page() and unmap_mapping_range() and
>>>> such.  I thought those only worked with regular files and pagecache :)
>>>>
>>>> Is it possible to briefly explain what's going on there?
>>>>
>>>> What instance of address_space_operations does ->dev_mapping actually
>>>> point at?
>>>>         
>>> Okay a bit tired and headache coming on but I'll try, maybe jbarnes
>>> can help out,
>>>
>>> We need to provide mappings to userspace that are backed by memory
>>> that can move around behind the mappings.
>>>
>>> So userspace wants a mapping for a GEM object via the AGP/GTT aperture
>>> instead of directly to the backing pages.
>>> Now as the GEM object is backed by shmem we can't use the shmem file
>>> descriptor we have to tie the mapping to without
>>> hacking up the shmem mmap functionality which seemed like a bad plan.
>>>
>>> So GEM uses the device inode to setup the mappings on. We just use a
>>> simple linear allocator to split up the device inodes address space
>>> and assign chunks to handles for different objects. The userspace app
>>> then uses the handle via mmap to get access to the VMAs. Now when GEM
>>> wants to move that object out of the GTT or to another area of the GTT
>>> we need some way to invalidate it, so we use unmap_mapping_range
>>> which destroys all the mappings for the object in all the VMA for all
>>> the processes mapping it currently
>>>
>>> GEM's read_mapping_page is distinct from this and is to do with the
>>> shmem interfaceing.
>>>
>>> Not sure if this explains it or just make it worse.
>>>       
>> Sounds right to me.  The offsets are just handles, not real file objects or 
>> backing store addresses.  We use them to take advantage of all the inode 
>> address mapping helpers, since they track stuff for us.
>>
>> That said, unmap_mapping_range may not be the best way to do this; basically 
>> we need a way to invalidate a given processes' mapping of a GTT range (which 
>> in turn is backed by real RAM).  If there's some other way we should be doing 
>> this I'm all ears.
>>     
>
> Well, we'd need to call in the big guns on this one - I've already
> stirred Hugh ;)
>
> unmap_mapping_range() is basically a truncate thing - it shoots down
> all mappings of a range of a *file*.  Across all processes in the
> machine which map that file.
>
> If that isn't what you want to do (and it sounds that way) then you'd
> want to use something which is mm_struct (or vma) centric, rather than
> file-centric.  zap_page_range(), methinks.
>
>   
I guess I was the one starting to use this function, so some explanation:

When the drm device is used to provide address space for buffers, 
user-space actually see it as a file with a distinct offset where 
buffers are laid out in a linear fashion, To access a certain buffer you 
need to lseek() to the correct offset and then read() write() or, the 
more common use, mmap / munmap.

When looking through its implementation, unmap_mapping_range() seemed to 
do exactly the thing I wanted, namely to kill all user-space mappings of 
all vmas of all processes mapping a part of the device address space. 
And it saves us from storing a list of all vmas mapping the device 
within the drm device.

What makes usage of unmap_mapping_range() on a device node with a well 
defined offset-to-data mapping different from using it on a file?

/Thomas
> ------------------------------------------------------------------------------
> This SF.net email is sponsored by:
> SourcForge Community
> SourceForge wants to tell your story.
> http://p.sf.net/sfu/sf-spreadtheword
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   



