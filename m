Return-Path: <linux-kernel-owner+w=401wt.eu-S1762284AbXGUUp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284AbXGUUp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 16:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXGUUpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 16:45:14 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:39926 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXGUUpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 16:45:13 -0400
Date: Sat, 21 Jul 2007 23:44:58 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
Message-ID: <20070721204458.GG1193@rhun.ibm.com>
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070721181137.GH4152@rhun.haifa.ibm.com> <46A263FA.70501@zytor.com> <20070721201634.GF1193@rhun.ibm.com> <46A26A2E.7070305@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A26A2E.7070305@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 01:18:54PM -0700, H. Peter Anvin wrote:
> Muli Ben-Yehuda wrote:
> > 
> > So it looks like we have a purely syntactic patch that does something
> > different than the original code in one of the above places. What am I
> > missing?
> > 
> 
> +static inline void clflush(volatile void *__p)
> +{
> +	asm volatile("clflush %0" : "+m" (*(char __force *)__p));
>                                           ^
> +}

Ok, let's try again:

You're changing this (pageattr.c)

                asm volatile("clflush (%0)" :: "r" (adr + i));

into this:

		asm volatile("clflush %0" : "+m" (*(char __force*)(adr + i)));

The original one calls clflush with (adr + i), the new one with (*(adr
+ i)). Are these calls equivalent? if not, and I don't think they are,
you are changing the semantics of the code (presumably, because it
fixes a bug), and *that should be a separate patch*.

Cheers,
Muli

