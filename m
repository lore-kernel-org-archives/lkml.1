Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYHGVnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYHGVnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYHGVno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:43:44 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46067 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619AbYHGVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:43:43 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Zachary Amsden <zach@vmware.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B6A5C.8030400@kernel.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
	 <489B6A5C.8030400@kernel.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 14:42:24 -0700
Message-Id: <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 14:34 -0700, H. Peter Anvin wrote:
> Zachary Amsden wrote:
> >
> > That can't be done until we know the size of the hole to relocate, which
> > isn't known until we probe in the first meg of memory to find the
> > associated ROM.  It used to be the case that other things that poked
> > around with platform specific memory and checking ROM areas lived around
> > here in setup.c, so it was a nice place to put it.  With all the
> > abstraction and combination and overifdeffing going on here, that might
> > no longer be the case.
> >
> > We could move it earlier, but then we'd need another hook to call in
> > after max_low_pfn is known.
> >
> > Or we could remove the dependency on max_low_pfn and just create a
> > liberal linear to physical mapping for lomem which spans all possible
> > low memory; then it doesn't matter so much where it is called.
> >
> 
> Okay, you lost me about halfway through that... could you perhaps
> describe the problem from the beginning, exactly what you're trying to do?

A kernel compiled with VMI enabled may run on a non-VMI platform.  If
that is the case, the fixmap should not be relocated.  If however, a VMI
ROM is found, we need to hijack up to 64-MB of linear address space from
the top of memory down.  This means moving the fixmap down by the same
amount.

Right now the code is structured in such a way that it wants to know how
much physical memory there is, so it can register a mapping table for
mapping linear addresses in the lowmem area to physical addresses.  This
causes the code to depend on max_low_pfn being initialized, which
accounts for the current placement.

But it also must be called before anything that creates the fixmap,
because the same code which registers the linear address mapping also
reserves high memory above the fixmap.

My point is 1) these could be two separate calls, or 2) the lowmem
mapping table need not depend on max_low_pfn at all, it is safe to
create an extra large mapping which covers all possible lowmem instead
of the physical ram that is actually available.

Zach

