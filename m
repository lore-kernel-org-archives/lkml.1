Return-Path: <linux-kernel-owner+w=401wt.eu-S1763068AbXLQVU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763068AbXLQVU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXLQVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:20:15 -0500
Received: from jade.aracnet.com ([216.99.193.136]:58925 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbXLQVUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:20:13 -0500
Message-ID: <4766E7D7.6050003@BitWagon.com>
Date: Mon, 17 Dec 2007 13:19:19 -0800
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org
Subject: Re: slab quirks in DEBUG, ctor, and initialization
References: <47669A16.3010604@BitWagon.com> <84144f020712171151j5e2a2934qc8bf2fbc9020a545@mail.gmail.com>
In-Reply-To: <84144f020712171151j5e2a2934qc8bf2fbc9020a545@mail.gmail.com>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

>>In mm/slab.c, the DEBUG variant of cache_alloc_debugcheck_after
>>might call  cachep->ctor(objp, cachep, 0);  but the non-DEBUG
>>variant does absolutely nothing.  idr_pre_get is a routine
>>which notices the difference.
> 
> 
> How does ipr_pre_get notice this?

idr_pre_get calls kmem_cache_alloc, which constructs 'struct idr_layer'
via the cachep->ctor() call from cache_alloc_debugcheck_after to
idr_cache_ctor, and not via cache_init_objs.  So if DEBUG is off,
then idr_cache_ctor does not get its chance to call memset,
which could leave the struct idr_layer potentially undefined.

>>Even when cache_alloc_debugcheck_after does invoke the ctor,
>>then it is conditional upon  cachep->flags & SLAB_POISON.  This
>>assumes that the only two states are poisoned and all-zero
>>(from .bss static, or via a cleared new page frame.)
>>So if SLAB_POISON is not specified, then a ctor which
>>does anything other than memset(,0,) is out of luck.
>>Instead: if a ctor is specified then it should be called
>>for each successful allocation.
> 
> 
> Sorry, I don't understand at all what's the problem is here. For the
> common (non-poison) case, we initialize all objects *once* whenever a
> cache is grown (see cache_grow calling cache_init_objs) which is the
> whole point of having constructors. When poisoning is enabled, we
> obviously cannot do this which is why we call the constructor for
> every allocation.

There is a comment near the beginning of mm/slab.c:
 * This means, that your constructor is used only for newly allocated
 * slabs and you must pass objects with the same initializations to
 * kmem_cache_free.
Note that the comment should be updated to account for the constructor
also being called if SLAB_POISON is specified.  A significant implication
is that calling the constructor always establishes good state, even
though the call might not be necessary, and although it might take
more time than not calling it.

In order to avoid the allocator having to call the constructor, then the
caller of kmem_cache_free must call the constructor just before freeing,
or establish the same values.  In contrast to calling the constructor
every time, the existing convention increases complexity and risk of bugs,
in exchange for faster performance when actions equivalent to the ctor
are performed in the dtor instead, or when state that is equivalent to
the ctor occurs as a natural byproduct of being done with the object.

The real gripe is that the current code makes it cumbersome for a
dynamic checking program such as valgrind(memcheck) to record correctly
the state of the object.  Is the object initialized (and which parts
of it, and were the initializations performed into allocated space),
or is it merely allocated and uninitialized?

-- 
John Reiser, jreiser@BitWagon.com
