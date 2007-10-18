Return-Path: <linux-kernel-owner+w=401wt.eu-S933923AbXJRXpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923AbXJRXpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbXJRXo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:44:56 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:48789 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752191AbXJRXoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:44:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Message-Id:Content-Type;
  b=3epg2wUZykqGE0Jh3+T0W+FYwOkxAx+VvvHW3wjhm2iL58spvbxks2tX0+oQb1umrOMNWy1htcTieTi+brTPCOMCbyU2RORKqp8YAANBa65w3pIoDma69xhCd3BFSBr431i+THtQtxplWrCAxCXs7jvr8M9lGAp7D4SDJfdQMFg=  ;
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: + slub-avoid-atomic-operation-for-slab_unlock.patch added to -mm tree
Date: Fri, 19 Oct 2007 09:44:24 +1000
User-Agent: KMail/1.9.5
Cc: clameter@sgi.com
References: <200710182231.l9IMVaPG001850@imap1.linux-foundation.org>
In-Reply-To: <200710182231.l9IMVaPG001850@imap1.linux-foundation.org>
MIME-Version: 1.0
Message-Id: <200710190944.24187.nickpiggin@yahoo.com.au>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Y/+FHamnUQXMCMQ"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Y/+FHamnUQXMCMQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 19 October 2007 08:31, akpm@linux-foundation.org wrote:

> ------------------------------------------------------
> Subject: SLUB: avoid atomic operation for slab_unlock
> From: Christoph Lameter <clameter@sgi.com>
>
> Currently page flags are only modified in SLUB under page lock.  This means
> that we do not need an atomic operation to release the lock since there is
> nothing we can race against that is modifying page flags.  We can simply
> clear the bit without the use of an atomic operation and make sure that
> this change becomes visible after the other changes to slab metadata
> through a memory barrier.
>
> The performance of slab_free() increases 10-15% (SMP configuration doing
> a long series of remote frees).

Ah, thanks, but can we just use my earlier patch that does the
proper __bit_spin_unlock which is provided by
bit_spin_lock-use-lock-bitops.patch

This primitive should have a better chance at being correct, and
also potentially be more optimised for each architecture (it
only has to provide release consistency).

I have attached the patch here just for reference, but actually
I am submitting it properly as part of a patch series today, now
that the base bit lock patches have been sent upstream.


>  mm/slub.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff -puN mm/slub.c~slub-avoid-atomic-operation-for-slab_unlock mm/slub.c
> --- a/mm/slub.c~slub-avoid-atomic-operation-for-slab_unlock
> +++ a/mm/slub.c
> @@ -1181,9 +1181,22 @@ static __always_inline void slab_lock(st
>  	bit_spin_lock(PG_locked, &page->flags);
>  }
>
> +/*
> + * Slab unlock version that avoids having to use atomic operations
> + * (echos some of the code of bit_spin_unlock!)
> + */
>  static __always_inline void slab_unlock(struct page *page)
>  {
> -	bit_spin_unlock(PG_locked, &page->flags);
> +#ifdef CONFIG_SMP
> +	unsigned long flags;
> +
> +	flags = page->flags & ~(1 << PG_locked);
> +
> +	smp_wmb();
> +	page->flags = flags;
> +#endif
> +	preempt_enable();
> +	__release(bitlock);
>  }

This looks wrong, because it would allow the store unlocking
flags to pass a load within the critical section.

stores aren't allowed to pass loads in x86 (only vice versa),
so you might have been confused by looking at x86's spinlocks
into thinking this will work. However on powerpc and sparc, I
don't think it gives you the right types of barriers.

--Boundary-00=_Y/+FHamnUQXMCMQ
Content-Type: text/x-diff;
  charset="utf-8";
  name="slub-use-nonatomic-unlock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="slub-use-nonatomic-unlock.patch"

Slub can use the non-atomic version to unlock because other flags will not
get modified with the lock held.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1185,7 +1185,7 @@ static __always_inline void slab_lock(st
 
 static __always_inline void slab_unlock(struct page *page)
 {
-	bit_spin_unlock(PG_locked, &page->flags);
+	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
 static __always_inline int slab_trylock(struct page *page)

--Boundary-00=_Y/+FHamnUQXMCMQ--
