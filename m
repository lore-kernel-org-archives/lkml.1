Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYICFJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYICFJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 01:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYICFI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 01:08:57 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:55450 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbYICFI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 01:08:56 -0400
Date: Tue, 2 Sep 2008 22:08:48 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       dkegel@google.com, jiayingz@google.com,
       John Reiser <jreiser@BitWagon.com>
Subject: Re: [uml-devel] [PATCH 5/6] slab: Annotate slab
In-Reply-To: <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0809022036560.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net> <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Aug 2008, Pekka Enberg wrote:

> Hi Steve,
>
> On Sat, Aug 30, 2008 at 2:17 AM, Steve VanDeBogart
> <vandebo-lkml@nerdbox.net> wrote:
>> Valgrind annotations for the slab allocator:  Malloc-like and free-like
>> for cache_alloc and free.  Telling Valgrind a region is free-like clears
>> all the valid bits, so slabs with constructors need different treatment;
>> tell Valgrind about slab objects when first constructed and free them
>> when the slab is destroyed.
>
> OK, I'm biased (I'm one of the kmemcheck developers) but these hooks
> to SLAB are too ugly to live with. My preferred solution is that you
> reuse the kmemcheck annotations
> kmemcheck_slab_alloc()/kmemcheck_slab_free() we have:
>
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=30532cb3c49a2a9fed94127aab26003c52398a51

Thank you for pointing out the location of the kmemcheck code.  I looked
around briefly but didn't find the latest version.  It does seem that
kmemcheck and Valgrind annotations want to live in the same places so it
makes perfect sense to combine them where possible.  I'm not exactly sure
what you find so ugly about the Valgrind annotations, please elaborate.

>> @@ -3578,6 +3595,9 @@
>>  {
>>        struct array_cache *ac = cpu_cache_get(cachep);
>>
>> +       if (!cachep->ctor)
>> +               VALGRIND_FREELIKE_BLOCK(objp, 0);
>> +
>>        check_irq_off();
>>        objp = cache_free_debugcheck(cachep, objp,
>> __builtin_return_address(0));
>
> I'm not sure why you want to treat caches with constructor
> differently. Sure, the memory regions *are* initialized but from
> programmer's point of view you're not supposed to be touching the
> memory unless you got it from kmalloc() or kmem_cache_alloc(). Same
> goes for kfree() and kmem_cache_free() -- no touchy touchy after you
> pass a pointer to either of the functions (unless you're RCU, of
> course).

It is true that code above the allocator should not be touching free'd
slab objects.  However, it is also true that objects from slabs that
have a constructor should retain their per byte un/initialized state
through allocation and free cycles (just the semantic of slabs with
constructors AFAICT).

Ideally, we'd tell Valgrind that the bytes of a free'd slab object are
no longer accessible, but the initialized state should remain the same
until the object is made accessible again by the next allocation of
the object.  Unfortunately, the compression method for A & V bits in
Valgrind doesn't allow a region to be inaccessible and retain validness
bits.

The best we can do without spending extra space or extra cycles it to
leave the memory accessible while it is free in a slab.

--
Steve
