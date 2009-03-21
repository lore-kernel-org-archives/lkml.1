Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZCUNPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZCUNPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 09:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZCUNOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 09:14:55 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:36889 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZCUNOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 09:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=V2IQiYiFFRqsCX+RsdO53EvkRAHHkd85id/hsEPSNnSBdX9pzvECKimNitFyezOzgT
         jlrVXW7Kl/dsaGWwFLqr7tpQfBPlJzDQAvWpYm2NRoKRkKEL3NEr1SCypztDQFhOquHQ
         DbF7/+Q9BApeTkEKOCKi4zjFxVBR8kng4XqeY=
Message-ID: <49C4E83D.1020604@vflare.org>
Date: Sat, 21 Mar 2009 18:44:37 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, cl@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] xvmalloc memory allocator
References: <ztOQA2Cz.1237575719.7896090.penberg@cs.helsinki.fi>	<49C3F1EE.90903@vflare.org>	<20090321032137.8dc113e8.akpm@linux-foundation.org>	<49C4D9C4.1030103@vflare.org> <20090321052416.6eb38759.akpm@linux-foundation.org>
In-Reply-To: <20090321052416.6eb38759.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 21 Mar 2009 17:42:52 +0530 Nitin Gupta <nitingupta910@gmail.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Sat, 21 Mar 2009 01:13:42 +0530 Nitin Gupta <ngupta@vflare.org> wrote:
>>> But what is regrettable is that xvmalloc appears to be tied to
>>> compressed-swap in some manner.  Is it not possible to split these two
>>> initiatives apart so that neither is dependent upon the other?  Or is
>>> compressed-swap hopelessly crippled without xvmalloc?
>> xvmalloc itself is completely independent of compressed-swap. Infact, its
>> loaded as separate kernel module (xvmalloc.ko)
> 
> That sounds good.
> 
>> However, this compression project is almost useless without this specialized
>> allocator.
> 
> Why?  Important information!!
> 
> See, being told all this helps us understand why xvmalloc exists.  Plus
> once we have a good description of _why_ xvmalloc is needed, perhaps we can
> come up with alternatives which are more palatable than merging a whole new
> allocator.  Such as enhancing an existing one.
> 

xvmalloc is needed by compressed swap since:
  - Its O(1)
  - It is very memory efficient
  - It can use "high memory" for allocation

* space efficiency:

  - comparison with SLUB:
http://code.google.com/p/compcache/wiki/AllocatorsComparison
shows that tlsf (allocator on which xvmalloc is based) uses ~40% less memory
than kmalloc() backed by SLUB. Christoph suggested creating multiple slabs of
different sizes for this test -- which will be a more fair comparison as kmalloc
just uses some predefined slabs. I hope to present this data soon.
Also, SLUB is limited to using "low memory" - this is blocker issue for compress
swap project (on 32-bit system with >1G RAM). xvmalloc can use high memory.

  - comparison with SLOB:
In some previous mail in this thread, I explained all the issues that exist
with SLOB that make it unacceptable for use in this project.


>>> (compcache is a terrible name, btw - it isn't a "compressed cache" at all!)
>>>
>> I have now heard this many times and my conscious is beginning to hurt now :)
>> I will change it to match name of its block device: ramzswap   sounds better?
> 
> Is there anything swap-specific about it?  It's a block device, yes?  I
> should be able to run mkfs.ext2 on it and mount the thing?
> 
No. It can handle page-aligned I/O only. Maybe its not too difficult to extend
it to handle arbitrary I/O. But as a swap device, handling just page-aligned
I/O is good enough.

>>>> Anyways, I will move it to drivers/block.
>>> This sounds like it might be a backward step.
>>
>> I'm bit confused here. Last thing I want to do is block mainline merge
>> because of such issues. Its real pain to maintain these things separately.
> 
> This is why I tell myself to never use the word "it" in an email message.
> 
> I assumed that you were referring to moving xvmalloc() down into
> drivers/block.  That would be bad, because then xvmalloc() will _never_ be
> usable by anything other than ramzblock <new name!>?
> 

I was also referring to moving xvmalloc to drivers/block. I meant that for
now maybe move it to drivers/block it that can help speed up the merge.
Maybe later if someone else find it useful too then we can work to move
it back to the real place: mm/ :)

Thanks,
Nitin

