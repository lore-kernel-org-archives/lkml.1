Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbZFKOGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbZFKOGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZFKOGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:06:34 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61056 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbZFKOGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:06:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fbXSoUCuS5/5KpeaaKIutAnBmhV+0WmkSy/TJNNHsdo73ntv5UG28Y8YoVnDU5kxW8
         1oDq/cVS51tv0Za0Yz/1ZXLKKw5yYv4ermn4q8WKwZjmdG/FG7XC7T5KHmhgqpeUqWKp
         Ha3wjqzKVwWO34Xm7llerP9Wd7UoIFUnVUzZs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0906110954030.29827@gentwo.org>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
	 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
	 <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906110954030.29827@gentwo.org>
Date: Thu, 11 Jun 2009 17:06:34 +0300
X-Google-Sender-Auth: 2127b07237ac9d2f
Message-ID: <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com>
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mingo@elte.hu, mpm@selenic.com, npiggin@suse.de,
       yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Jun 11, 2009 at 4:58 PM, Christoph
Lameter<cl@linux-foundation.org> wrote:
>> @@ -645,14 +657,10 @@ asmlinkage void __init start_kernel(void)
>>               initrd_start = 0;
>>       }
>>  #endif
>> -     vmalloc_init();
>> -     vfs_caches_init_early();
>>       cpuset_init_early();
>>       page_cgroup_init();
>> -     mem_init();
>>       enable_debug_pagealloc();
>>       cpu_hotplug_init();
>> -     kmem_cache_init();
>>       kmemtrace_init();
>>       debug_objects_mem_init();
>>       idr_init_cache();
>
> Therefore potential breakage is in cpusets, hotplug and control groups.
> Have any of these been tested with these patches? NUMA?

Yinghai has done some testing. Control groups should to be fine:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=7d63de6b4c7798a6a1c6504a65c327aaf76ef2d5

I have not tested hotplug and cpuset_init_early() does indeed needs to
be switched over to slab (it does that via fallback now).

>> diff --git a/mm/slub.c b/mm/slub.c
>> index 5e805a6..c1815a6 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2557,13 +2557,16 @@ static struct kmem_cache *create_kmalloc_cache(struct kmem_cache *s,
>>       if (gfp_flags & SLUB_DMA)
>>               flags = SLAB_CACHE_DMA;
>>
>> -     down_write(&slub_lock);
>> +     /*
>> +      * This function is called with IRQs disabled during early-boot on
>> +      * single CPU so there's no need to take slub_lock here.
>> +      */
>>       if (!kmem_cache_open(s, gfp_flags, name, size, ARCH_KMALLOC_MINALIGN,
>
> This function is also called later when kmalloc caches are
> created on demand.

Where? AFAICT, only kmem_cache_init() calls the function.

                                      Pekka
