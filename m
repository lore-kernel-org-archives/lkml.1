Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449Ab0AGN6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0AGN6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 08:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118Ab0AGN6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 08:58:00 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:41921 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012Ab0AGN57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 08:57:59 -0500
Date: Thu, 7 Jan 2010 08:57:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and
	add_local_return()
Message-ID: <20100107135757.GA6011@Krystal>
References: <20100105220417.400092933@quilx.com> <20100105220437.940473705@quilx.com> <20100105224901.GB32584@Krystal> <201001071445.50416.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <201001071445.50416.arnd@arndb.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:52:48 up 21 days, 22:11,  4 users,  load average: 0.77, 0.36,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann (arnd@arndb.de) wrote:
> On Tuesday 05 January 2010, Mathieu Desnoyers wrote:
> > 
> > The problem I see here is that with ~5-6 operations, we will end up
> > having 20*5 = 100 headers only for this. Can we combine these in a
> > single header file instead ? local.h wasn't bad in this respect.
> 
> I have an old patch that I was planning to dig out for 2.6.34,
> which autogenerates arch/*/include/foo.h files that only contain
> "#include <asm-generic/foo.h>".
> 
> I guess this would be sufficient to avoid the overload with all
> these header files.

Well, given we already have local.h, I am not completely sure that this
whole exercise is giving us.

[...]

> > > +#include <linux/types.h>
> > > +
> > > +extern unsigned long wrong_size_add_local(volatile void *ptr);
> > > +
> > > +/*
> > > + * Generic version of __add_return_local (disables interrupts). Takes an
> > > + * unsigned long parameter, supporting various types of architectures.
> > > + */
> > > +static inline unsigned long __add_return_local_generic(volatile void *ptr,
> > > +		unsigned long value, int size)
> 
> You could probably lose the 'volatile' here, if you want to discourage
> marking data as volatile in the code.
> 
> > > +{
> > > +	unsigned long flags, r;
> > > +
> > > +	/*
> > > +	 * Sanity checking, compile-time.
> > > +	 */
> > > +	if (size == 8 && sizeof(unsigned long) != 8)
> > > +		wrong_size_add_local(ptr);
> 
> It can be BUILD_BUG_ON if you move it to the outer macro.
> 
> > > +	local_irq_save(flags);
> > > +	switch (size) {
> > > +	case 1: r = (*((u8 *)ptr) += value);
> > > +		break;
> > > +	case 2: r = (*((u16 *)ptr) += value);
> > > +		break;
> > > +	case 4: r = (*((u32 *)ptr) += value);
> > > +		break;
> > > +	case 8: r = (*((u64 *)ptr) += value);
> > > +		break;
> 
> But I think here you actually need to add the volatile in order
> to make these atomic assignments.

Yes, you are right. If we ever try to access these variables from a
remote CPU with a load (but not with any concurrent store operation, as
this would be semantically invalid), then the volatile is important.

Mathieu

> 
> 	Arnd

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
