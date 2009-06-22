Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbZFVIfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbZFVIfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbZFVIfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:35:00 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:6517 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753314AbZFVIe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:34:59 -0400
X-Greylist: delayed 954 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 04:34:59 EDT
Message-ID: <4A3F3E3A.2030202@shipmail.org>
Date: Mon, 22 Jun 2009 10:18:02 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
       dri-devel@lists.sf.net, Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm: previous pull req + 1.
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>	<4A3DABE1.50309@mit.edu>	<alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>	<alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>	<alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>	<cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>	<alpine.LFD.2.01.0906211223190.3119@localhost.localdomain> <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>> On Sun, 21 Jun 2009, Andrew Lutomirski wrote:
>>     
>>>> Anyway, here's a totally UNTESTED patch that hopefully gives a warning on
>>>> where exactly we set the invalid bits. Andy, mind trying it out? You
>>>> should get the warnign much earlier, and it should have a much more useful
>>>> back-trace.
>>>>         
>>> Your patch worked.  Photo attached.
>>>       
>> Ok.
>>
>> So it's fb_mmap() that uses an invalid page frame number when it does the 
>> "io_remap_pfn_range()" thing. 
>>
>> And the way it gets that page frame number is basically
>>
>>  - Offset (in bytes) from start of mapping:
>>
>> 	off = vma->vm_pgoff << PAGE_SHIFT;
>> 	..
>>
>>  - frame buffer start address:
>>
>>         /* frame buffer memory */
>>         start = info->fix.smem_start;
>>         len = PAGE_ALIGN((start & ~PAGE_MASK) + info->fix.smem_len);
>> 	..
>> 	off += start;
>>
>>  - do the remap:
>>
>> 	io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT, ..
>>
>> and there has been no changes to this logic in drivers/video/fbmem.c 
>> lately.
>>
>> What *has* changed is that we have a newradeon driver, and it looks like 
>> that new radeon driver is crap, and does this:
>>
>> 	info->fix.smem_start = (unsigned long)fbptr;
>>
>> which is totally screwed up. It assigns a _virtual_ address to that 
>> "smem_start" thing, even though it should be a physical one. 
>>
>> I don't know the radeon driver, so I don't know where to find the physical 
>> address.  It's also possible that there is no good single physical 
>> address, and the radeon driver should implement a "fb_mmap" function.
>>
>> Does this patch make the warning and the oops at least go away? Obviously 
>> it won't result in a working frame buffer, but that's a separate issue
>>
>> 		Linus
>>     
>
> I noticed the same bogus line myself last night, I'll get Jerome to look 
> at it since its his code, he was trying to be smart about how the 
> radeon fbdev emulation should work, but fbdev isn't smart enough to do 
> what he wants, so I've asked him to go back to the dumb pin the fbcon in 
> VRAM until we can fix fbdev to do some sort of prepare/commit type hooks 
> around blocks of reads/writes.
>
> With the safe method we end up with an 8MB pinned fbcon on 32MB in some 
> scenarios, which is still totally unacceptable from a user pov.
>
>   
There is a ttm_fbdev_mmap() function in TTM that may help in this 
situation. As with the standard ttm mmap it's using fault() which means 
it's possible to move out the backing buffer object if you first reserve 
it and then call unmap_mapping_range() on the relevant fbdev address 
space to kill existing user-space mappings.

We've experimented a little with this on the Poulsbo / Moorestown KMS 
driver (we threw out the fbcon buffer when the X server was switched in) 
but the problem turned out to be that fbdev always expects an always 
present _kernel_ mapping and it seemed a bit too hard to block accesses 
to that mapping while it was torn down and set up again to point to the 
new location.
In particular, the fbdev acceleration hooks seems to be called from 
atomic context.

It would be very helpful if we could introduce an fbdev mutex that 
protects fbdev accesses to the kernel map and to the fbdev acceleration 
functions.

/Thomas







