Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYICCzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYICCzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 22:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYICCza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 22:55:30 -0400
Received: from jade.aracnet.com ([216.99.193.136]:59337 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYICCz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 22:55:29 -0400
Message-ID: <48BDFC77.4060909@BitWagon.com>
Date: Tue, 02 Sep 2008 19:54:47 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Steve VanDeBogart <vandebo-lkml@nerdbox.net>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, dkegel@google.com, jiayingz@google.com
Subject: Re: [uml-devel] [PATCH 5/6] slab: Annotate slab
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>	<alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net> <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
In-Reply-To: <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Steve VanDeBogart proposed
   [snip]
>> Index: linux-2.6.27-rc5/mm/slab.c
>> ===================================================================
>> --- linux-2.6.27-rc5.orig/mm/slab.c     2008-08-29 14:24:25.000000000 -0700
>> +++ linux-2.6.27-rc5/mm/slab.c  2008-08-29 14:24:42.000000000 -0700
   [snip]
> @@ -3466,6 +3481,8 @@
>>        objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
>>        prefetchw(objp);
>>
>> +       if (!cachep->ctor)
>> +               VALGRIND_MALLOCLIKE_BLOCK(objp, cachep->buffer_size, 0, 0);
>>        if (unlikely((flags & __GFP_ZERO) && objp))
>>                memset(objp, 0, obj_size(cachep));
>>
   [snip]
> I'm not sure why you want to treat caches with constructor
> differently. Sure, the memory regions *are* initialized but from
> programmer's point of view you're not supposed to be touching the
> memory unless you got it from kmalloc() or kmem_cache_alloc(). Same
> goes for kfree() and kmem_cache_free() -- no touchy touchy after you
> pass a pointer to either of the functions (unless you're RCU, of
> course).

Hi, I developed the predecessor to Steve's patches.  The patch treats
a cache with a constructor differently because the semantics of kmalloc
are different in that case.  If a cache has a constructor then the
object returned by kmalloc has been initialized for certain.  Namely,
the constructor initialized the object before it was kmalloc'ed the first
time, and each corresponding caller [re-]initialized the object before
calling kfree.  This is emphasized by comments in mm/slab.c:
 * This means, that your constructor is used only for newly allocated
 * slabs and you must pass objects with the same initializations to
 * kmem_cache_free.

The slab allocator has the property that the contents of a block [object]
that is returned by kmalloc are identical to the contents that were passed
to kfree (or back as result from the constructor) unless something special
happens, such as SLAB_POISON.  A block [object] which is handed back and
forth between kfree and kmalloc builds and retains history throughout the
lifetime of the cache.  This property is directly contrary to the semantics
of libc malloc.  The contents of the result of libc malloc must be considered
to be *un*initialized always.

Yes, there is at least one kmalloc+kfree slab object cache that depends on
retaining state from kfree to kmalloc.  My first attempt treated kmalloc+kfree
like libc malloc+free, but I soon learned that was not the actual semantics.

Because the slab allocator deals in objects that persist through kfree
and kmalloc, then there are only two indications that objects ever become
uninitialized: SLAB_POISON, and not having a constructor.  Obviously the
application of SLAB_POISON means that the object becomes [logically] uninit.
Not having a constructor *tends* to indicate that kmalloc() implies uninit,
by chain of reasoning based on the comment quoted above from mm/slab.c.
If the object was uninit upon first kmalloc, and if kfree is supposed to
receive objects that are "ready for kmalloc", and because a caller cannot
discern the first-ever return of an object by kmalloc, then the caller
must treat each result of kmalloc (from that particular cache) as uninit.
It would be helpful if each cache had a documenting comment such as "This
cache depends on objects whose contents persist from kfree() to kmalloc()"
or a comment such as "An object in this cache is considered to become
uninitialized when the object is passed to kfree."

With regard to Read-Copy-Update, I anticipate that RCU will require
special annotations because of the deliberate references after kfree
and before the next corresponding kmalloc.  These special annotations
will require great care, because bugs in this area have high value.

-- 
John Reiser, jreiser@BitWagon.com
