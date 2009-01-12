Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbZALTxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbZALTxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbZALTxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:53:36 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:65126 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbZALTxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:53:35 -0500
Message-ID: <496B9FC7.3090108@colorfullife.com>
Date: Mon, 12 Jan 2009 20:53:43 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, dcm@acm.org,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain> <49686465.70501@s5r6.in-berlin.de> <20090110011557.9d94e111.akpm@linux-foundation.org> <496872E0.9030007@s5r6.in-berlin.de> <1231773620.6365.21.camel@gaara.bos.redhat.com>
In-Reply-To: <1231773620.6365.21.camel@gaara.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
>   The problem
> isn't about returning un-zeroed-out objects to the kmem cache, the
> problem is returning them to the idr free list.
>   
I think this is wrong:
The slab allocator assumes that the objects that are given to 
kmem_cache_free() are properly constructed.
I.e.: No additional constructor is called prior to returning the object 
from the next kmem_cache_alloc() call.


> Every idr use I've seen could just do the whole thing
> under a mutex and not worry about the awkward retry idea.
Unfortunately there are some users that do idr_get_new() within a spinlock.
e.g. from drivers/gpu/drm/drm_gem.c:
>         if (idr_pre_get(&file_priv->object_idr, GFP_KERNEL) == 0)
>                 return -ENOMEM;
>
>         /* do the allocation under our spinlock */
>         spin_lock(&file_priv->table_lock);
>         ret = idr_get_new_above(&file_priv->object_idr, obj, 1, handlep);
>         spin_unlock(&file_priv->table_lock);
:-(

--
    Manfred
