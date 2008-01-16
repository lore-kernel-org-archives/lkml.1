Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYAPXW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYAPXW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYAPXQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:16:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44811 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756573AbYAPXQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:16:57 -0500
Date: Wed, 16 Jan 2008 15:16:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
In-Reply-To: <87odblct19.fsf@saeurebad.de>
Message-ID: <alpine.LFD.1.00.0801161454010.2806@woody.linux-foundation.org>
References: <87lk6pvii0.fsf@saeurebad.de> <alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org> <87odblct19.fsf@saeurebad.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Johannes Weiner wrote:
> 
> Okay, I understood that now.  A const qualifier just forbids modifying
> the underlying memory _through this particular pointer_, right?

Yes, exactly.

> In the case of slub's kfree(), which takes a const pointer, you pass it
> on to slab_free() which actually _DOES_ modification of the underlying
> memory when linking the object to the freelist (as far as I understood
> the code).

First off, the whole concept of "underlying memory" is all about the fact 
that pointers point not to separate objects with its own existence, but 
point to a shared resource ("memory") that can be accessed many different 
ways.

So immediately when you talk about "underlying memory", you need to 
realize that now you're not talking about "that pointer" any more, but you 
are talking about the stuff that *other* pointers can access.

And the whole (and *only*) point of a memory allocator is turning that 
amorphous notion of "infinitely aliasable underlying memory" model into 
more of a "C pointer to separate objects" model.

That *is* what a memory allocator does.

> So if I got it right and you actually modify the memory you only got a
> const pointer to

No. YOU DO NOT.

You *invalidate* the pointer. Then, the memory allocator releases that 
portion of the "infinitely aliasable underlying memory", but that means 
that THAT POINTER NO LONGER EXISTS ON A C LEVEL.

So no, you don't "modify the memory you only got a const pointer to".

What you do is that the memory allocator 

 - keeps track of the NON-const memory that it always had
 - it sees the const pointer you gave it, and uses that pointer to look up 
   ITS OWN DATA STRUCTURES.
 - it then accesses those memory locations using its own pointers.

The "const pointer" you passed to kfree() simply no longer exists. The 
object it pointed to has gone away. That particular pointer simply isn't 
valid any more.

But the memory management code, which maintains its own structures for 
what it has allocated and not allocated, can (and will) generally use the 
knowledge *it* has about its own pointers to modify its own data 
structures.

The fact that they (obviously) alias in memory is irrelevant. It has no 
meaning for the "const void *" you passed in. That pointer is not usable 
for the caller any more.

And no, this is not just a semantic argument. It's a real issue. The 
pointer you pass in to kfree() is obviously used to *find* the data 
structures that the memory allocator maintains, and there is almost 
inevitably a rather direct mapping between the passed-in pointers and the 
data structures that a memory manager maintains itself, but they really 
are different. 

So to take a kfree() a pointer, the memory manager will use the "binary 
value" of that pointer to find its own data structures, and sometimes the 
values are so closely related that it ends up being a direct cast 
(possibly with an offset), but the end result of that direct cast really 
is now the memory management internal data, not the original pointer.

A real example of this is the actual kfree() implementation in the kernel 
(let's take the one from SLAB):

	struct kmem_cache *c;
	..
	c = virt_to_cache(objp);

which then actually ends up doing a 

	struct page *page = virt_to_head_page(obj);
	return page_get_cache(page);

which literally does math on the binary representation of the pointer to 
look up the backing store values (because the memory manager by definition 
is the thing that knows how the low-level representation of pointers 
actually works).

So now the kernel has turned that user-supplied pointer into ITS OWN data 
structures, that contain the NON-CONST aliases for the data.

(It will actually use the const pointer to further get offsets into those 
things, of course, so it's several levels of indirection off that pointer)

And yes, then it will write to those non-const aliases, but that's really 
no different from the same old thing: the pointer *you* passed kmalloc() 
may be "const",  but the memory manager itself has its own data structures 
to keep track of *its* aliases to the same memory, and those are the ones 
that are actually used to re-use the memory for others (and poison it 
etc).

So the particular pointer you passed in is "const". But that never *ever* 
guarantees that there aren't other non-const pointers around to be used 
that can modify the memory. And the memory manegement definitely has all 
those aliased pointers around - it's the whole *point* of memory 
management.

			Linus
