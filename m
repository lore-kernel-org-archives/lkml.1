Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZALUui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZALUui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZALUu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:50:29 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53434 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZALUu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:50:28 -0500
Message-ID: <496BAD1C.5060201@colorfullife.com>
Date: Mon, 12 Jan 2009 21:50:36 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, dcm@acm.org,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain> <49686465.70501@s5r6.in-berlin.de> <20090110011557.9d94e111.akpm@linux-foundation.org> <496872E0.9030007@s5r6.in-berlin.de> <1231773620.6365.21.camel@gaara.bos.redhat.com> <496B9FC7.3090108@colorfullife.com> <1231792712.6365.31.camel@gaara.bos.redhat.com>
In-Reply-To: <1231792712.6365.31.camel@gaara.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> On Mon, 2009-01-12 at 20:53 +0100, Manfred Spraul wrote:
>   
>> Kristian Høgsberg wrote:
>>     
>>>   The problem
>>> isn't about returning un-zeroed-out objects to the kmem cache, the
>>> problem is returning them to the idr free list.
>>>   
>>>       
>> I think this is wrong:
>> The slab allocator assumes that the objects that are given to 
>> kmem_cache_free() are properly constructed.
>> I.e.: No additional constructor is called prior to returning the object 
>> from the next kmem_cache_alloc() call.
>>     
>
> That's fine, the ctor associated with the kmem cache is called, and in
> the case of idr, it does a memset().
>   
No.
As I said, the construtor is not called.
An object that is given to kmem_cache_free() must be properly constructed.
kmem_cache_free() just adds the obj pointer to a list, the next 
kmem_cache_alloc returns the pointer.

This is also documented in mm/slab.c:
 * The memory is organized in caches, one cache for each object type.
 * (e.g. inode_cache, dentry_cache, buffer_head, vm_area_struct)
 * Each cache consists out of many slabs (they are small (usually one
 * page long) and always contiguous), and each slab contains multiple
 * initialized objects.
 *
 * This means, that your constructor is used only for newly allocated
 * slabs and you must pass objects with the same initializations to
 * kmem_cache_free.
 *

If the idr code passes uninitialized objects to kmem_cache_free(), then 
the next kmem_cache_alloc will return a bad object.

--
    Manfred
