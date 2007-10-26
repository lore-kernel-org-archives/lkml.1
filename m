Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbXJZDyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbXJZDyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJZDy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:54:26 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:37257 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750863AbXJZDyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:54:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eNhTkER685fOd/XQ85jLdKUezA1J3VjA+WqEBD9/b2tYg5YMbnA/xSWpplxDCNLeZlLTpzXMLCrEbMpmwKJdS5Sn7EQRmK41rxO4GFuD0w5WynymGPPwR9KE/3wki9h3Q3WbTK8AZ7jE0BtL+G2kmG5q3FLgRfYbWj9X/GbdjrE=  ;
X-YMail-OSG: _ieUawwVM1l7u4XfxDCQGAcSUVPIX8iCmh_pvwDX3KDTa6SirAAdBAcYO6XPGB2CTbQMExCdbg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: benh@kernel.crashing.org
Subject: Re: [interesting] smattering of possible memory ordering bugs
Date: Fri, 26 Oct 2007 13:47:35 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, paulus@samba.org,
       shaggy@austin.ibm.com, adaplas@gmail.com,
       "Morton, Andrew" <akpm@linux-foundation.org>, xfs-masters@oss.sgi.com
References: <200710261209.58519.nickpiggin@yahoo.com.au> <1193369717.7018.56.camel@pasglop>
In-Reply-To: <1193369717.7018.56.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261347.35545.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 13:35, Benjamin Herrenschmidt wrote:

[acks]

Thanks for those...

> > Index: linux-2.6/include/asm-powerpc/mmu_context.h
> > ===================================================================
> > --- linux-2.6.orig/include/asm-powerpc/mmu_context.h
> > +++ linux-2.6/include/asm-powerpc/mmu_context.h
> > @@ -129,7 +129,7 @@ static inline void get_mmu_context(struc
> >                 steal_context();
> >  #endif
> >         ctx = next_mmu_context;
> > -       while (test_and_set_bit(ctx, context_map)) {
> > +       while (test_and_set_bit_lock(ctx, context_map)) {
> >                 ctx = find_next_zero_bit(context_map, LAST_CONTEXT+1,
> > ctx); if (ctx > LAST_CONTEXT)
> >                         ctx = 0;
> > @@ -158,7 +158,7 @@ static inline void destroy_context(struc
> >  {
> >         preempt_disable();
> >         if (mm->context.id != NO_CONTEXT) {
> > -               clear_bit(mm->context.id, context_map);
> > +               clear_bit_unlock(mm->context.id, context_map);
> >                 mm->context.id = NO_CONTEXT;
> >  #ifdef FEW_CONTEXTS
> >                 atomic_inc(&nr_free_contexts);
>
> I don't think the previous code was wrong... it's not a locked section
> and we don't care about ordering previous stores. It's an allocation, it
> should be fine. In general, bitmap allocators should be allright.

Well if it is just allocating an arbitrary _number_ out of a bitmap
and nothing else (eg. like the pid allocator), then you don't need
barriers.


> Ignore the FEW_CONTEXTS stuff for now :-) At this point, it's UP only
> and will be replaced sooner or later.

OK. Then I agree, provided you're doing the correct synchronisation
or flushing etc. when destroying a context (which presumably you are).

I'll drop those bits then.

Thanks,
Nick
