Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639Ab0AGNqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0AGNqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519Ab0AGNqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:46:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:60466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0AGNqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:46:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and add_local_return()
Date: Thu, 7 Jan 2010 14:45:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
References: <20100105220417.400092933@quilx.com> <20100105220437.940473705@quilx.com> <20100105224901.GB32584@Krystal>
In-Reply-To: <20100105224901.GB32584@Krystal>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001071445.50416.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19K/c4/bgqoN1UyIcWMoNeosQfvy9Kdc6/MSKr
 92oo/v6fUi/V/XKdwKasktJDMZC2FSbkTo5aZYHokU85J642E7
 eVWMd9B/M46S7XHDADpzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Mathieu Desnoyers wrote:
> 
> The problem I see here is that with ~5-6 operations, we will end up
> having 20*5 = 100 headers only for this. Can we combine these in a
> single header file instead ? local.h wasn't bad in this respect.

I have an old patch that I was planning to dig out for 2.6.34,
which autogenerates arch/*/include/foo.h files that only contain
"#include <asm-generic/foo.h>".

I guess this would be sufficient to avoid the overload with all
these header files.

> Also, separating all these in sub-files will make it a bit difficult to
> pinpoint errors that would arise from using a bad combination of, e.g.
> generic add with a non-protected read or set.

Yes.

> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6/include/asm-generic/add-local-generic.h	2010-01-05 15:36:02.000000000 -0600
> > @@ -0,0 +1,40 @@
> > +#ifndef __ASM_GENERIC_ADD_LOCAL_GENERIC_H
> > +#define __ASM_GENERIC_ADD_LOCAL_GENERIC_H

Why split the file between asm-generic/add-local.h and add-local-generic.h?
I don't see how any architecture could use one but not the other.

> > +#include <linux/types.h>
> > +
> > +extern unsigned long wrong_size_add_local(volatile void *ptr);
> > +
> > +/*
> > + * Generic version of __add_return_local (disables interrupts). Takes an
> > + * unsigned long parameter, supporting various types of architectures.
> > + */
> > +static inline unsigned long __add_return_local_generic(volatile void *ptr,
> > +		unsigned long value, int size)

You could probably lose the 'volatile' here, if you want to discourage
marking data as volatile in the code.

> > +{
> > +	unsigned long flags, r;
> > +
> > +	/*
> > +	 * Sanity checking, compile-time.
> > +	 */
> > +	if (size == 8 && sizeof(unsigned long) != 8)
> > +		wrong_size_add_local(ptr);

It can be BUILD_BUG_ON if you move it to the outer macro.

> > +	local_irq_save(flags);
> > +	switch (size) {
> > +	case 1: r = (*((u8 *)ptr) += value);
> > +		break;
> > +	case 2: r = (*((u16 *)ptr) += value);
> > +		break;
> > +	case 4: r = (*((u32 *)ptr) += value);
> > +		break;
> > +	case 8: r = (*((u64 *)ptr) += value);
> > +		break;

But I think here you actually need to add the volatile in order
to make these atomic assignments.

	Arnd
