Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXLNLzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXLNLzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXLNLzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:55:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:39953 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763328AbXLNLzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:55:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X0GgbTt506iTTKdOoFiYErs2WST07cbpQlZ45jVejWdrwGXlpxJbXRPcEhnVU96r6sd4WPKvXjnmYq5ni2a4BxOhbaycsv8Vg6arBr4r5k0wk/dx77FReOeXSDNocIqURA0PrivEl5L+if1CY3pQACSrqWgI3kOfryIe5Wckuns=
Message-ID: <5d6222a80712140355k21a22d82scebaddff09525931@mail.gmail.com>
Date: Fri, 14 Dec 2007 09:55:41 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH 1/4] x86: clean up asm-x86/page*.h
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <476252AF.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47623AD6.6090403@goop.org> <47624D81.76E4.0078.0@novell.com>
	 <47624253.7060507@goop.org> <476252AF.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 6:53 AM, Jan Beulich <jbeulich@novell.com> wrote:
> >>> Jeremy Fitzhardinge <jeremy@goop.org> 14.12.07 09:44 >>>
>
> >Jan Beulich wrote:
> >>> --- a/arch/x86/mm/fault_64.c
> >>> +++ b/arch/x86/mm/fault_64.c
> >>> @@ -158,22 +158,22 @@ void dump_pagetable(unsigned long addres
> >>>     pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK);
> >>>     pgd += pgd_index(address);
> >>>     if (bad_address(pgd)) goto bad;
> >>> -   printk("PGD %lx ", pgd_val(*pgd));
> >>> +   printk("PGD %lx ", (unsigned long)pgd_val(*pgd));
> >>>
> >>
> >> Casts like this here and elsewhere look rather odd (in fact I think using
> >> casts should really be limited to places where you either can't do it
> >> differently or the code would become badly readable or much uglier
> >> without them). I would therefore favor simply using the right formatting
> >> specifier here.
> >
> >I would agree, but pgd_val() is defined as returning a pgdval_t, which
> >is typedefed to be unsigned long.  I'll have another look, but I don't
> >think there's an appropriate format for this.
>
> Typedef-s can be printed with the same format specifier as the underlying
> type. But u64 is (at least in plain -rc5) a typedef of 'unsigned long long', so
> the compiler validly warns about the use of 'l' there, and I would assume it's
> those compiler warnings that you want to get rid of...
>
The strategy I've been adopting in this case is to simply use unsigned
long long when we need
u64, and print it with llx for both i386 and x86_64. The problem here
is that pgd_val may be 32-bit with non-PAE configs,
IIRC. So maybe we can #define the print string, and put it inside the
ifdefs. Along the lines of printk("pgd: " PGD_STR ...)

For this particular warning, it is in a _64.c file, so the llx may be
able to help.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
