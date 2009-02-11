Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbZBKSIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbZBKSIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 13:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZBKSIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 13:08:42 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:60297 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbZBKSIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 13:08:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ISW2ZOMzbbqwihyxpkDQ+O4VuolD7nQ7VKqFkkcLxicBAxIye8kkLAV4auX87auBjk
         LfemBE4fOq56isoo4dKxrZlcL5Ey9PZGpmuI3JYjzWl/+cikrhj4MIVmchLQMEeZQuqE
         RAWcmwRi+TkybR2mX1lbvTec7uFpHgWfPKo7g=
Date: Wed, 11 Feb 2009 20:08:32 +0200
From: Pekka Paalanen <pq@iki.fi>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stuart Bennett <stuart@freedesktop.org>,
       "Oliver McFadden" <z3ro.geek@gmail.com>,
       "david jeannot" <djeannot24@gmail.com>
Subject: Re: testing pmdval/pteval page presence bit
Message-ID: <20090211200832.016d3e59@daedalus.pq.iki.fi>
In-Reply-To: <499202F0.10108@goop.org>
References: <20090209215849.5a788261@daedalus.pq.iki.fi>
	<499202F0.10108@goop.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Oliver and David, I added you to CC, since I recall you were planning
for user space tracing in mmiotrace.)

On Tue, 10 Feb 2009 14:42:56 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Pekka Paalanen wrote:
> > Hi all,
> >
> > This question is related to mmiotrace which toggles the page presence
> > bit to trigger page faults on ioremapped regions. Page faults are used
> > to trace MMIO reads and writes of proprietary drivers.
> >
> > I understood that large pages use pmd's instead of pte's. If there is a
> > union like this:
> >
> > +	union {
> > +		pmdval_t pmdval;
> > +		pteval_t pteval;
> > +	} saved;	/* stored value prior to arming */
> >
> > and it is being assigned the proper content, as in the following:
> >
> > +static int clear_page_present(struct kmmio_fault_page *f, bool clear)
> >  {
> >  	pteval_t pteval;
> >  	pmdval_t pmdval;
> >  	unsigned int level;
> >  	pmd_t *pmd;
> > +	pte_t *pte = lookup_address(f->page, &level);
> >  
> >  	if (!pte) {
> > +		pr_err("kmmio: no pte for page 0x%08lx\n", f->page);
> >  		return -1;
> >  	}
> >  
> >  	switch (level) {
> >  	case PG_LEVEL_2M:
> >  		pmd = (pmd_t *)pte;
> > +		if (clear) {
> > +			f->saved.pmdval = pmd_val(*pmd);
> > +			pmdval = f->saved.pmdval & ~_PAGE_PRESENT;
> > +		} else
> > +			pmdval = f->saved.pmdval;
> >  		set_pmd(pmd, __pmd(pmdval));
> >  		break;
> >  
> >  	case PG_LEVEL_4K:
> > +		if (clear) {
> > +			f->saved.pteval = pte_val(*pte);
> > +			pteval = f->saved.pteval & ~_PAGE_PRESENT;
> > +		} else
> > +			pteval = f->saved.pteval;
> >  		set_pte_atomic(pte, __pte(pteval));
> >  		break;
> >
> >
> > Then regardless of was it pmdval or pteval being set, the test
> >
> > 	if (!(faultpage->saved.pteval & _PAGE_PRESENT))
> >
> > should be ok. But is it?
> > Can large page (pmd) presence be handled just like a normal page (pte)?
> >   
> 
> _PAGE_PRESENT is meaningful for both ptes and pmds; you can use 
> pmd_present() to test for it rather than open-coding it.

Okay, will look into those, but it also means I need to record which
one I am dealing with.

> But there's one other theoretical problem with this code.  In general it 
> isn't safe to just toggle the _PAGE_PRESENT bit on its own, because the 
> rest of the non-present pte could get interpreted as a swap entry.  If 
> you're guaranteed that these are kernel mappings then there's no problem 
> in practice.

This is good to know. So far these are kernel mappings, as they are all
created by ioremap*(), but there are plans to extend mmiotrace to
trace IO-mappings accessed from user space. Do you have hints for that?

OTOH, we are always dealing with PCI IO-mem-mappings, so would those ever
be not present, excluding the mmiotrace case?

Well, Stuart already found out that the kernel ioremap*()'ed pages might
not really be present, there are some fixes coming up to mmiotrace to
cope with that. The plan is to restore the state of the pte like it was
before mmiotrace cleared the _PAGE_PRESENT flag, and if the same
instruction and address faults again, fall through to the normal page
fault handling. How can/will this fail? And if it is a user page?

Oh, we are on x86/x86_64 only.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
