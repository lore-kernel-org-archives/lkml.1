Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbYICPnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbYICPnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYICPmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:42:54 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:49874 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYICPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:42:54 -0400
Date: Wed, 3 Sep 2008 08:42:49 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       dkegel@google.com, jiayingz@google.com
Subject: Re: [uml-devel] [PATCH 5/6] slab: Annotate slab
In-Reply-To: <84144f020809030227jce7d3c2wab9e9c00b2fcdfe5@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.0809030833050.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net> <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net> <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com> <alpine.DEB.1.00.0809022036560.15543@abydos.NerdBox.Net>
 <84144f020809030227jce7d3c2wab9e9c00b2fcdfe5@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pekka,

On Wed, 3 Sep 2008, Pekka Enberg wrote:

> On Wed, Sep 3, 2008 at 8:08 AM, Steve VanDeBogart
> <vandebo-lkml@nerdbox.net> wrote:
>> It is true that code above the allocator should not be touching free'd
>> slab objects.  However, it is also true that objects from slabs that
>> have a constructor should retain their per byte un/initialized state
>> through allocation and free cycles (just the semantic of slabs with
>> constructors AFAICT).
>
> Sorry for being unclear, sure, object should be marked as initialized
> when they're returned from kmem_cache_alloc(). However, what I
> disagree with is *where* you're marking them as initialized. Surely
> they're not semantically initialized when the slabs are allocated
> (although technically they are).

But which bits of a slab object should be marked as initialized at
kmem_cache_alloc() time?  We can't mark all of them as initialized
because the constructor may not initialize all of them (in fact, I've
programmatically confirmed that there are constructors that don't
initialize all the bytes of an object).  The only place to get the
information of interest is to mark all bytes uninitialized and then
run the constructor on the memory region.

>
> On Wed, Sep 3, 2008 at 8:08 AM, Steve VanDeBogart
> <vandebo-lkml@nerdbox.net> wrote:
>> Ideally, we'd tell Valgrind that the bytes of a free'd slab object are
>> no longer accessible, but the initialized state should remain the same
>> until the object is made accessible again by the next allocation of
>> the object.  Unfortunately, the compression method for A & V bits in
>> Valgrind doesn't allow a region to be inaccessible and retain validness
>> bits.
>
> I don't see why you should mark them initialized all the time. Just
> mark them as uninitialized on kmem_cache_free() and again as
> initialized when they're about to be returned from kmem_cache_alloc()
> like we do in kmemcheck.

This question has the same answer as above.

--
Steve
