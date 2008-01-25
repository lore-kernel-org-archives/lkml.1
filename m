Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYAYNu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYAYNu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbYAYNuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:50:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:64319 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbYAYNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:50:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jOXovptbVL3Fx68JcibUsDzwy6I2qTYmk+ZOTfWfgQ90UDccf3h+7IgykMV/F+cFjGdMkD06ze64Tc7iWYoG9G9l5IAGLIv4wupwhC7iILlReJ8ir2UF3xf032mG0UAocqnZJfCWWzOaxXeESeZtKE2IvldRBUArgjQwXSSl3fY=
Message-ID: <851fc09e0801250550v4e70fb37lbe95a8716ef7d6fa@mail.gmail.com>
Date: Fri, 25 Jan 2008 21:50:14 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: ioremap_nocache fix
Cc: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080125102738.GQ23708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201238561.15972.17.camel@caritas-dev.intel.com>
	 <20080125102738.GQ23708@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 6:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Huang, Ying <ying.huang@intel.com> wrote:
>
> > This patch fixes a bug of ioremap_nocache. ioremap_nocache() will call
> > __ioremap() with flags != 0 to do the real work, which will call
> > change_page_attr_addr() if phys_addr + size - 1 < (end_pfn_map <<
> > PAGE_SHIFT). But some pages between 0 ~ end_pfn_map << PAGE_SHIFT are
> > not mapped by identity map, this will make change_page_attr_addr
> > failed.
>
> very interesting! Is this in response to a bug you've triggered?
>
> i believe the scenario you outlne could trigger on 64-bit boxen, if they
> try to ioremap an area not covered by the direct ptes:

Yes. The efifb driver try to ioremap 0x40000000 on my 64-bit box and
it failed because 0x40000000 < (end_pfn_map << PAGE_SHIFT) and it is
not covered by direct ptes.

> > @@ -41,8 +41,15 @@ ioremap_change_attr(unsigned long phys_a
> >       if (phys_addr + size - 1 < (end_pfn_map << PAGE_SHIFT)) {
> >               unsigned long npages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
> >               unsigned long vaddr = (unsigned long) __va(phys_addr);
> > +             int level;
> >
> >               /*
> > +              * If there is no identity map for this address,
> > +              * change_page_attr_addr is unnecessary
> > +              */
> > +             if (!lookup_address(vaddr, &level))
> > +                     return err;
> > +             /*
>
> and we'd incorrectly fail the ioremap() with -EINVAL, and return a hard
> error to the driver - and causing broken boxes, right?

Yes.

> Thomas has unified most of ioremap*.c as well, and we'll make sure this
> fix survives the unification. The 64-bit code limped along before by
> accident, because the (pre-cleanup) 64-bit __change_page_attr() code
> incorrectly returned 0 for invalid ranges:
>
>         kpte = lookup_address(address);
>         if (!kpte) return 0;
>
> which masked the bug you fixed now. 32-bit always returned -EINVAL on
> invalid ranges.

Best Regards,
Huang Ying
