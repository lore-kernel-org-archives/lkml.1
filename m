Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYE0OYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYE0OYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYE0OXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:23:53 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:49704 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYE0OXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hoKTypzypu/Z0fLigvCJ41AKt7g3MDe3Ee2Al83fTXiOu7s2CIF1YvTEcwJY/Ws8Ub8zA/i/bbdUaDtH38RXaNZVV6DrsCCG4R+Y1w27SbN8Je+sV6mLB6JFfgPfs8uR840M4Oc+it5QJihMX8Pbe1f0udgkYuYboqa9tipd2wA=
Message-ID: <19f34abd0805270723u71b46527g41c42ea236c49095@mail.gmail.com>
Date: Tue, 27 May 2008 16:23:49 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Eric Sesterhenn" <snakebyte@gmx.de>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi
In-Reply-To: <20080527140031.GA3380@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526143422.GA3203@alice> <20080527140031.GA3380@alice>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Tue, May 27, 2008 at 4:00 PM, Eric Sesterhenn <snakebyte@gmx.de> wrote:
> hi,
>
> i tested a kmemcheck kernel as an attempt to debug
> this further... seems CONFIG_SECURITY is unrelated to
> this, but slub debugging only catches the
> overwrite it if i enable CONFIG_SECURITY.

Oy, whow! :-)

I actually tried to reproduce your problem yesterday to see if
kmemcheck would catch it, but I couldn't reproduce it, so I gave up
:-(

>
> with slub_debug=FZPU i get the warning at
> init_object+0x63:
>
> (gdb) l *(init_object+0x63)
> 0xc0187243 is in init_object (mm/slub.c:544).
> 539     {
> 540             u8 *p = object;
> 541
> 542             if (s->flags & __OBJECT_POISON) {
> 543                     memset(p, POISON_FREE, s->objsize - 1);
> 544                     p[s->objsize - 1] = POISON_END;
> 545             }
> 546
> 547             if (s->flags & SLAB_RED_ZONE)
> 548                     memset(p + s->objsize,
>

This is sort of expected. kmemcheck is not directly incompatible with
slub debugging, but it may produce some false positives (that we
haven't worked out yet). So I recommend that you turn slub debugging
off, like you did below.

> if i set slub_debug=- i get the kmemcheck warning at
>
> (gdb) l *(__slab_alloc+0x238)
> 0xc0187bc8 is in __slab_alloc (mm/slub.c:303).
> 298             return *(void **)(object + s->offset);
> 299     }
> 300
> 301     static inline void set_freepointer(struct kmem_cache *s, void
> *object, void *fp)
> 302     {
> 303             *(void **)(object + s->offset) = fp;
> 304     }
> 305
> 306     /* Loop over all objects in a slab */
> 307     #define for_each_object(__p, __s, __addr, __objects) \

Hm, yes. It would be nice to see the actual kmemcheck error message as
well in order to determine the cause of this.

I don't really see how that write (= fp) can cause an error, so it has
to be the s->offset dereference that is doing it. That seems extremely
unlikely and would indicate a bug in SLUB itself...

Out of curiosity, will your crash go away entirely if you compile the
kernel using SLAB?

>
> I used the kmemcheck git tree from
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-kmemcheck-4.git
>
> In case you need some of the other kmemcheck output please
> let me know.
>

It would be nice to see the whole dmesg if you can get it.

You should also make sure you have either

CONFIG_KMEMCHECK_ENABLED_BY_DEFAULT=y

set in your config or that you are booting with the kmemcheck=1
command-line option; otherwise, you'll only get the first warning
before kmemcheck auto-disables itself. Forcing it to stay on will
potentially give us more useful output.

There is actually a newer kmemcheck tree which supports
kmemcheck+SLAB, but the version you are running should be usable for
debugging your problem, so I'm not going to ask you to try that.

Thanks for trying it out, it would feel good if kmemcheck would
finally be useful for something :-) Good luck.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
