Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYGGLk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYGGLk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYGGLkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:40:15 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36516 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752319AbYGGLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:40:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OLt0zNadjbVeHGOS04kusL2PDpurveXTdhMTDmxEzwisDvuMVBbJj9WluIJg1CfeklVOR6KlR9wr5gMWoiKmuTRVBx6BmQ3cbM7klden+KlC/zN8TZalzTdeSu+/jWwmVwhj94kaWPZpOq8qUhJGgHS/5W1MQHYA1h87i7hfNhE=  ;
X-YMail-OSG: DIWJDisVM1m8IBaZqPxeLZU7JDb.BgvCA7zLnVoEozmRhGF5fEPO4w4KPLwQ0Z.1UuPgPE_MaNE5jn9rZ9cQZGwUZJSIcDTAEbdWap_NW9qk3Y3WT0PBMN7RfsIrYWxxW9A-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Hugh Dickins <hugh@veritas.com>,
       "Martin Schwidefsky" <schwidefsky@googlemail.com>
Subject: Re: Lockless/Get_User_Pages_Fast causes Xorg 1.4.99.* to lock
Date: Mon, 7 Jul 2008 21:39:48 +1000
User-Agent: KMail/1.9.5
Cc: benh@kernel.crashing.org, cotte@de.ibm.com, Zan Lynx <zlynx@acm.org>,
       Ryan Hope <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <48f7fe350807032326l1d68c94l531e44c09693b989@mail.gmail.com> <200807071806.11630.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0807071134090.21480@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0807071134090.21480@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072139.48462.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 20:39, Hugh Dickins wrote:
> On Mon, 7 Jul 2008, Nick Piggin wrote:
> > I think we need a similar fix for s390 too. If so, then it really should
> > get into 2.6.26, but this late in the release, I hope an s390 maintainer
> > might be able to test and verify the fix?
>
> Wow, yes, I hadn't realized s390 is ahead of the game there: glad you're
> back to spot that.  But yes, we'd prefer maintainer to confirm and push.
>
>
> [PATCH]] s390: protect _PAGE_SPECIAL bit against mprotect
>
> Stop mprotect's pte_modify from wiping out the s390 pte_special bit, which
> caused oops thereafter when vm_normal_page thought X's abnormal was normal.
>
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> Acked-by: Hugh Dickins <hugh@veritas.com>

Thanks, I feel silly to take the authorship of this before your x86
version gets in (and will likely not be credited if it is folded
before merging)

Martin, could you please credit Hugh for the debugging? :)

Thanks,

> ---
> Index: linux-2.6/include/asm-s390/pgtable.h
> ===================================================================
> --- linux-2.6.orig/include/asm-s390/pgtable.h
> +++ linux-2.6/include/asm-s390/pgtable.h
> @@ -223,6 +223,9 @@ extern char empty_zero_page[PAGE_SIZE];
>  #define _PAGE_SPECIAL	0x004		/* SW associated with special page */
>  #define __HAVE_ARCH_PTE_SPECIAL
>
> +/* Set of bits not changed in pte_modify */
> +#define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_SPECIAL)
> +
>  /* Six different types of pages. */
>  #define _PAGE_TYPE_EMPTY	0x400
>  #define _PAGE_TYPE_NONE		0x401
> @@ -681,7 +684,7 @@ static inline void pte_clear(struct mm_s
>   */
>  static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
>  {
> -	pte_val(pte) &= PAGE_MASK;
> +	pte_val(pte) &= _PAGE_CHG_MASK;
>  	pte_val(pte) |= pgprot_val(newprot);
>  	return pte;
>  }
