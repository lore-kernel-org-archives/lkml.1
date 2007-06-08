Return-Path: <linux-kernel-owner+w=401wt.eu-S1031927AbXFHTr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031927AbXFHTr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbXFHTrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:47:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:7156 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbXFHTrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:47:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=nSVNCrpmHOBwxE5re/OMnmGK5UJYcbrP+mSvMAZVyFQKGJnkWUv9BQ7YIWPk5PCQy+r+d3jKWdDRHmakVX4yzEroamV5LVv8uVpLIjrAzAUd/Bb5NtN7Q/YtpFR8HuGjAETkin0t2fzxiD5miQbXMrCt27XM90YS/HNTPG77+7U=
Message-ID: <4669B25A.6010404@googlemail.com>
Date: Fri, 08 Jun 2007 21:47:38 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 00/12] Slab defragmentation V3
References: <20070607215529.147027769@sgi.com>  <466999A2.8020608@googlemail.com>  <Pine.LNX.4.64.0706081110580.1464@schroedinger.engr.sgi.com> <6bffcb0e0706081156u4ad0cc9dkf6d55ebcbd79def2@mail.gmail.com> <Pine.LNX.4.64.0706081207400.2082@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0706081239340.2447@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706081239340.2447@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter pisze:
> On Fri, 8 Jun 2007, Christoph Lameter wrote:
> 
>> On Fri, 8 Jun 2007, Michal Piotrowski wrote:
>>
>>> Yes, it does. Thanks!
>> Ahhh... That leds to the discovery more sysfs problems. I need to make 
>> sure not to be holding locks while calling into sysfs. More cleanup...
> 
> Could you remove the trylock patch and see how this one fares? We may need 
> both but this should avoid taking the slub_lock around any possible alloc 
> of sysfs.
> 
> 

It's a bit tricky

cat ../sd2.patch | patch -p1
patching file mm/slub.c
Hunk #1 succeeded at 2194 (offset 15 lines).
Hunk #2 FAILED at 2653.
1 out of 2 hunks FAILED -- saving rejects to file mm/slub.c.rej
[michal@bitis-gabonica linux-work3]$ cat mm/slub.c.rej
***************
*** 2652,2677 ****
                 */
                s->objsize = max(s->objsize, (int)size);
                s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
                if (sysfs_slab_alias(s, name))
                        goto err;
-       } else {
-               s = kmalloc(kmem_size, GFP_KERNEL);
-               if (s && kmem_cache_open(s, GFP_KERNEL, name,
                                size, align, flags, ctor)) {
-                       if (sysfs_slab_add(s)) {
-                               kfree(s);
-                               goto err;
-                       }
                        list_add(&s->list, &slab_caches);
                        raise_kswapd_order(s->order);
-               } else
-                       kfree(s);
        }
        up_write(&slub_lock);
-       return s;

  err:
-       up_write(&slub_lock);
        if (flags & SLAB_PANIC)
                panic("Cannot create slabcache %s\n", name);
        else
--- 2653,2685 ----
                 */
                s->objsize = max(s->objsize, (int)size);
                s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
+               up_write(&slub_lock);
+
                if (sysfs_slab_alias(s, name))
                        goto err;
+
+               return s;
+       }
+
+       s = kmalloc(kmem_size, GFP_KERNEL);
+       if (s) {
+               if (kmem_cache_open(s, GFP_KERNEL, name,
                                size, align, flags, ctor)) {
                        list_add(&s->list, &slab_caches);
+                       up_write(&slub_lock);
                        raise_kswapd_order(s->order);
+
+                       if (sysfs_slab_add(s))
+                               goto err;
+
+                       return s;
+
+               }
+               kfree(s);
        }
        up_write(&slub_lock);

  err:
        if (flags & SLAB_PANIC)
                panic("Cannot create slabcache %s\n", name);
        else

Regards,
Michal

-- 
"Najbardziej brakowało mi twojego milczenia."
-- Andrzej Sapkowski "Coś więcej"
