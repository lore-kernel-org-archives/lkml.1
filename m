Return-Path: <linux-kernel-owner+w=401wt.eu-S1759900AbYFLWRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbYFLWRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYFLWRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:17:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:33817 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbYFLWRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WeDJNEdBbR3YuFfzutaGgOEFXGX3Rww0XgE+ZaANcWlyAPFMIvGQZNf+9cMWpKSimV
         bgjYcS71mvoQc58zYLZtlb/Uw0lJcnyRlUExuTDPXYxAWjA/ISbdgeRld3QNOC44QlHl
         a4YjTaN6W+ULS/UD52SgEAF918tWYS5ga++3Y=
Message-ID: <1ba2fa240806121517p6ef1e117ofd940ad763195a0d@mail.gmail.com>
Date: Fri, 13 Jun 2008 01:17:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       "Rik van Riel" <riel@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <c4e36d110806121311n64890e17h67f49c32481fbb28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 <1213290335.3730.4.camel@johannes.berg>
	 <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
	 <1213292812.3730.21.camel@johannes.berg>
	 <1ba2fa240806121103m60a8ffa4ie11850fedc69d13c@mail.gmail.com>
	 <1213294547.3730.29.camel@johannes.berg>
	 <c4e36d110806121311n64890e17h67f49c32481fbb28@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:11 PM, Zdenek Kabelac
<zdenek.kabelac@gmail.com> wrote:
> 2008/6/12 Johannes Berg <johannes@sipsolutions.net>:
>>
>>> I'm not against it. You;v decided that I'm fighting you because I gave
>>> another solution.
>>
>> Ok, no, I'm not saying you shouldn't rewrite all the code to get rid of
>> it, but I think you can use a patch like mine interim as such a rewrite
>> is unlikely to go into 2.6.26, is it?
>>
>>> Frankly we probably don't need this allocation at all. maybe one skb
>>> is just enough
>>
>> That would be nice, indeed.
>>
>>> even with my never dying hope all fragments are in skb fragment list.
>>
>> :)
>>
>>> This still probably won't save pci memory allocation problem
>>
>> Yeah, true, that one needs to be done, but it could probably be done
>> only once when hw is probed rather than every time it is brought up.
>> Most likely not something you'll get to fix in 2.6.26 either though.
>
>
> Well - it's great that there will be saved few kB in allocation of
> never used pointers in iwl driver - but does this really solve the
> problem that kernel gets relatively quickly out of memory for
> allocations of this size - I guess iwl isn't the only driver
> requesting 32 sequential pages.
>
> Is it possible to track how this memory gets fragment/lost - who owns
> the block and why they are not back in the pool?
>
> btw with 8hour uptime at this moment I can see this:
>
> DMA: 26*4kB 37*8kB 72*16kB 65*32kB 3*64kB 0*128kB 0*256kB 0*512kB
> 0*1024kB 0*2048kB 1*4096kB = 7920kB
> DMA32: 203*4kB 79*8kB 26*16kB 11*32kB 6*64kB 9*128kB 3*256kB 2*512kB
> 2*1024kB 0*2048kB 0*4096kB = 7588kB
>
> so at this moment I can see quiet a lot of free DMA memory - but in my
> trace at the thread beginig after several suspend/resumes this memory
> was gone....

Currently the driver frees the memory on down and allocates it back on
up. This is done even in initial
reset for sake of flow simplicity.
I'm not sure yet why the memory is actually accumulating, whether the
bug is in the driver or memory system is not clear to me yet.  I
haven't seen this on older kernels or driver.
As I wrote I'm also polishing a patch that doesn't do this free-alloc
loop hope this will remedy somehow this problem. It has a drawback as
it will hold on memory even if devices is down.

Tomas
