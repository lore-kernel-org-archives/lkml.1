Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZA3KoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZA3KoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZA3KoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:44:08 -0500
Received: from relay.gothnet.se ([82.193.160.251]:60329 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752056AbZA3KoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:44:06 -0500
Message-ID: <4982D9AF.10005@shipmail.org>
Date: Fri, 30 Jan 2009 11:42:55 +0100
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
References: <a6f8318b0901210358w7cced8e9yab86c487b3587d75@mail.gmail.com>	<20090129172010.f25fe0ad.akpm@linux-foundation.org>	<21d7e9970901291743q4f0a9393yc5c24afb50013ff3@mail.gmail.com>	<200901291950.18724.jbarnes@virtuousgeek.org>	<20090129204403.5d9e4b38.akpm@linux-foundation.org>	<4982C4D3.4040704@shipmail.org> <20090130012134.bb4fe0bf.akpm@linux-foundation.org>
In-Reply-To: <20090130012134.bb4fe0bf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 30 Jan 2009 10:13:55 +0100 Thomas Hellstr__m <thomas@shipmail.org> wrote:
>
>   
>>>> Sounds right to me.  The offsets are just handles, not real file objects or 
>>>> backing store addresses.  We use them to take advantage of all the inode 
>>>> address mapping helpers, since they track stuff for us.
>>>>
>>>> That said, unmap_mapping_range may not be the best way to do this; basically 
>>>> we need a way to invalidate a given processes' mapping of a GTT range (which 
>>>> in turn is backed by real RAM).  If there's some other way we should be doing 
>>>> this I'm all ears.
>>>>     
>>>>         
>>> Well, we'd need to call in the big guns on this one - I've already
>>> stirred Hugh ;)
>>>
>>> unmap_mapping_range() is basically a truncate thing - it shoots down
>>> all mappings of a range of a *file*.  Across all processes in the
>>> machine which map that file.
>>>
>>> If that isn't what you want to do (and it sounds that way) then you'd
>>> want to use something which is mm_struct (or vma) centric, rather than
>>> file-centric.  zap_page_range(), methinks.
>>>
>>>   
>>>       
>> I guess I was the one starting to use this function, so some explanation:
>>
>> When the drm device is used to provide address space for buffers, 
>> user-space actually see it as a file with a distinct offset where 
>> buffers are laid out in a linear fashion, To access a certain buffer you 
>> need to lseek() to the correct offset and then read() write() or, the 
>> more common use, mmap / munmap.
>>
>> When looking through its implementation, unmap_mapping_range() seemed to 
>> do exactly the thing I wanted, namely to kill all user-space mappings of 
>> all vmas of all processes mapping a part of the device address space. 
>>     
>
> That's different from what Jesse said.  That _is_ a more appropriate
> use of unmap_mapping_range().  Although all the futzing that function
> does with truncate_count is now looking inappropriately-placed.
>
>   
Hmm, yes. I guess that was to fix a race with old do_nopage()?
Since GEM and similar managers are using  vm_insert_pfn, I guess that's 
not really needed.
>> And it saves us from storing a list of all vmas mapping the device 
>> within the drm device.
>>
>> What makes usage of unmap_mapping_range() on a device node with a well 
>> defined offset-to-data mapping different from using it on a file?
>>     
>
> umm, nothing I guess, if the driver sufficiently imitates a regular
> file.  It's unexpected (by me).  I don't think we wrote that code with
> this application in mind ;)
>
>
>   
No. It's a little odd ;), but we had a thorough discussion at that time 
(some two years ago) on LKML.

What strucks me now, though, is that if the struct address_space * 
differs between device nodes pointing to the same underlying device, we 
might be in trouble (Is that what started this thread from the first 
place?), and we might have to resort to keep track of all VMAs anyway...

/Thomas



