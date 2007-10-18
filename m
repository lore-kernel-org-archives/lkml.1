Return-Path: <linux-kernel-owner+w=401wt.eu-S934079AbXJRXti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079AbXJRXti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 19:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759396AbXJRXtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 19:49:31 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:47851 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758923AbXJRXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 19:49:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=EIKyv9q9+VBSclMgui31/qzrbTBRPcIiZ5re5OOT0q9/gT4frKpvxIHTwbYeSoA2yaVtmKymvOfpVNJ99xjIETU8759bAFa2/fP01aTk4g5vOM0Y6CDUI/XpvDjEv1yygDkrwxMkpDUVAchq9yI25uPPYA4diPUOOzPBWiIdC8o=  ;
X-YMail-OSG: nuy.SxUVM1kYMFkIL0L56.4nib_UJzuMvb9KLk2ZdYnivF5_CYLcXP_tuMwLTlES3BZfoaodvw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SLUB: Avoid atomic operation for slab_unlock
Date: Fri, 19 Oct 2007 09:49:00 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-mm@kvack.org
References: <Pine.LNX.4.64.0710181514310.3584@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710181514310.3584@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tD/FHL3nvu84Zrs"
Message-Id: <200710190949.01019.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_tD/FHL3nvu84Zrs
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[sorry, I read and replied to my inbox before mailing lists...
please ignore the last mail on this patch, and reply to this
one which is properly threaded]

On Friday 19 October 2007 08:15, Christoph Lameter wrote:
> Currently page flags are only modified in SLUB under page lock. This means
> that we do not need an atomic operation to release the lock since there
> is nothing we can race against that is modifying page flags. We can simply
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
>       bit_spin_lock(PG_locked, &page->flags);
>  }
>
> +/*
> + * Slab unlock version that avoids having to use atomic operations
> + * (echos some of the code of bit_spin_unlock!)
> + */
>  static __always_inline void slab_unlock(struct page *page)
>  {
> -     bit_spin_unlock(PG_locked, &page->flags);
> +#ifdef CONFIG_SMP
> +     unsigned long flags;
> +
> +     flags = page->flags & ~(1 << PG_locked);
> +
> +     smp_wmb();
> +     page->flags = flags;
> +#endif
> +     preempt_enable();
> +     __release(bitlock);
>  }

This looks wrong, because it would allow the store unlocking
flags to pass a load within the critical section.

stores aren't allowed to pass loads in x86 (only vice versa),
so you might have been confused by looking at x86's spinlocks
into thinking this will work. However on powerpc and sparc, I
don't think it gives you the right types of barriers.


--Boundary-00=_tD/FHL3nvu84Zrs
Content-Type: text/x-diff;
  charset="iso-8859-1";
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

--Boundary-00=_tD/FHL3nvu84Zrs--
