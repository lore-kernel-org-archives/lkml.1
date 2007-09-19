Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXISIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXISIo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXISIoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:44:17 -0400
Received: from ppsw-4.csi.cam.ac.uk ([131.111.8.134]:43963 "EHLO
	ppsw-4.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbXISIoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:44:16 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <alpine.DEB.0.9999.0709190103560.12827@chino.kir.corp.google.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com> <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com> <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk> <alpine.DEB.0.9999.0709190103560.12827@chino.kir.corp.google.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <167F960F-0A93-4263-8AE6-1B0CEBB2C9D1@cam.ac.uk>
Cc: Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the vmalloc boundaries
Date: Wed, 19 Sep 2007 09:44:09 +0100
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Sep 2007, at 09:09, David Rientjes wrote:
> On Wed, 19 Sep 2007, Anton Altaparmakov wrote:
>>>> Index: linux-2.6/include/linux/mm.h
>>>> ===================================================================
>>>> --- linux-2.6.orig/include/linux/mm.h	2007-09-17 21:46:06.000000000
>>>> -0700
>>>> +++ linux-2.6/include/linux/mm.h	2007-09-17 23:56:54.000000000  
>>>> -0700
>>>> @@ -1158,6 +1158,14 @@ static inline unsigned long vma_pages(st
>>>> 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>>>> }
>>>>
>>>> +/* Determine if an address is within the vmalloc range */
>>>> +static inline int is_vmalloc_addr(const void *x)
>>>> +{
>>>> +	unsigned long addr = (unsigned long)x;
>>>> +
>>>> +	return addr >= VMALLOC_START && addr < VMALLOC_END;
>>>> +}
>>>
>>> This breaks on i386 because VMALLOC_END is defined in terms of  
>>> PKMAP_BASE
>>> in the CONFIG_HIGHMEM case.
>>
>> That is incorrect.  This works perfectly on i386 and on ALL  
>> architectures
>> supported by Linux.  A lot of places in the kernel already do this  
>> today
>> (mostly hand coded though, eg XFS and NTFS)...
>
> Hmm, really?
>
> After applying patches 1-3 in this series and compiling on my i386  
> with
> defconfig, I get this:
>
> In file included from include/linux/suspend.h:11,
>                  from arch/i386/kernel/asm-offsets.c:11:
> include/linux/mm.h: In function 'is_vmalloc_addr':
> include/linux/mm.h:1166: error: 'PKMAP_BASE' undeclared (first use  
> in this function)
> include/linux/mm.h:1166: error: (Each undeclared identifier is  
> reported only once
> include/linux/mm.h:1166: error: for each function it appears in.)
>
> so I don't know what you're talking about.

Just a compile failure not inherently broken!

Add:

#include <linux/highmem.h> to the top of linux/mm.h and it should  
compile just fine.

Although it may cause a problem as highmem.h also includes mm.h so a  
bit of trickery may be needed to get it to compile...

I suspect that is_vmalloc_addr() should not be in linux/mm.h at all  
and should be in linux/vmalloc.h instead and vmalloc.h should include  
linux/highmem.h.  That would be more sensible than sticking a vmalloc  
related function into linux/mm.h where it does not belong...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


