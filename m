Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbZLMLCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbZLMLCW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZLMLCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:02:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39099 "HELO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752361AbZLMLCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:02:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=IHK6zKME/k9jrMzpiXBsie6LSbK7VdYZ+gMAZFvQbLU2UBZ591mDh3G40mWGzT9bpr
         RBT1/ADYKNG6r52d5hPXAtpozjIUpqHX19omFYqzL6UlRyCX8WM+HuTuopvtegCHmicW
         is6I7auhnnywieCYVQSbZ++1Ebn92AWIJSPx4=
MIME-Version: 1.0
In-Reply-To: <1260474540.16132.166.camel@pasglop>
References: <8b8dd87a0912080914h3d71ea6x3052582b662d5f73@mail.gmail.com>
	 <1260342524.16132.28.camel@pasglop>
	 <8b8dd87a0912100320q7d4ec39btd450a571be291e2b@mail.gmail.com>
	 <1260474540.16132.166.camel@pasglop>
Date: Sun, 13 Dec 2009 13:02:18 +0200
Message-ID: <8b8dd87a0912130302iae9a62cj7afc2e056373a283@mail.gmail.com>
Subject: Re: Badness at arch/powerpc/mm/pgtable.c:286
From: kordex - <kordex@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Thank you it fixed the problem.

--Mikko Kortelainen

2009/12/10 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> On Thu, 2009-12-10 at 13:20 +0200, kordex - wrote:
>> arch/powerpc/mm/pgtable_32.c:362: error: too few arguments to function
>> ‘__set_pte_at’
>
> Right, you want to add an argument and set it to 0 :
>
>  -       set_pte_at(&init_mm, address, kpte, mk_pte(page, prot));
>  +       __set_pte_at(&init_mm, address, kpte, mk_pte(page, prot), 0);
>
> That should do it. Please let me know if that works.
>
> Cheers,
> Ben.
>
>> 2009/12/9 Benjamin Herrenschmidt <benh@kernel.crashing.org>:
>> > On Tue, 2009-12-08 at 19:14 +0200, kordex - wrote:
>> >> Hello,
>> >>
>> >> I turned some debuging options in order to trace rcutree problems but
>> >> after turning debugging on it began just to loop on this:
>> >>
>> >> http://xnet.fi/opt/pics/pgtable_badness.jpg
>> >> 1.5M   pgtable_badness.jpg
>> >>
>> >> I am sorry that I could not produce full dmesg.
>> >>
>> >> Kernel config: http://xnet.fi/opt/apps/lkml-2.6.32-vanilla.debug.config.txt
>> >
>> > Thanks for your report.
>> >
>> > Does that patch fixes it ?
>> >
>> > powerpc/mm: Fix a WARN_ON() with CONFIG_DEBUG_PAGEALLOC and CONFIG_DEBUG_VM
>> >
>> > Set need to call __set_pte_at() and not set_pte_at() from __change_page_attr()
>> > since the later will perform checks with CONFIG_DEBUG_VM that aren't suitable
>> > to the way we override an existing PTE. (More specifically, it doesn't let
>> > you write over a present PTE).
>> >
>> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> > ---
>> >
>> > Index: linux-work/arch/powerpc/mm/pgtable_32.c
>> > ===================================================================
>> > --- linux-work.orig/arch/powerpc/mm/pgtable_32.c        2009-12-09 18:06:14.000000000 +1100
>> > +++ linux-work/arch/powerpc/mm/pgtable_32.c     2009-12-09 18:06:16.000000000 +1100
>> > @@ -356,7 +356,7 @@ static int __change_page_attr(struct pag
>> >                return 0;
>> >        if (!get_pteptr(&init_mm, address, &kpte, &kpmd))
>> >                return -EINVAL;
>> > -       set_pte_at(&init_mm, address, kpte, mk_pte(page, prot));
>> > +       __set_pte_at(&init_mm, address, kpte, mk_pte(page, prot));
>> >        wmb();
>> >  #ifdef CONFIG_PPC_STD_MMU
>> >        flush_hash_pages(0, address, pmd_val(*kpmd), 1);
>> >
>> >
>> >
>
>
>
