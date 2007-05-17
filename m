Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbXEQNic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbXEQNic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXEQNiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:38:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:49300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbXEQNiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:38:24 -0400
From: Andi Kleen <ak@suse.de>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       Jan Hubicka <jh@suse.cz>
Subject: Re: stack alignment on i386
Date: Thu, 17 May 2007 15:37:57 +0200
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0705160648320.18296@artax.karlin.mff.cuni.cz>
In-Reply-To: <Pine.LNX.4.64.0705160648320.18296@artax.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171537.57893.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 07:24, Mikulas Patocka wrote:
> >    [PATCH] x86: Drop cc-options call for all options supported in gcc
> >3.2+
> >
> >    The kernel only supports gcc 3.2+ now so it doesn't make sense
> >    anymore to explicitely check for options this compiler version
> >    already has.
> >
> >    This actually fixes a bug. The -mprefered-stack-boundary check
> >    never worked because gcc rightly complains
> >
> >      CC      arch/i386/kernel/asm-offsets.s
> >    cc1: -mpreferred-stack-boundary=2 is not between 4 and 12
>
> Hi
>
> Your patch for stack alignment on i386 is wrong. -mprefered-stack-boundary
> is log2 of the stack alignment (read gcc man page). 

Ah just using the real number would have been too easy I guess.

> On AMD64 16-byte 
> alignment is enforced because of SSE, on i386 minimal alignment is 4
> bytes.

Ok fixed now

> See the code in gcc that triggered your error:
>        i = atoi (ix86_preferred_stack_boundary_string);
>        if (i < (TARGET_64BIT ? 4 : 2) || i > 12)
>          error ("-mpreferred-stack-boundary=%d is not between %d and 12",
> i,
>                 TARGET_64BIT ? 4 : 2);
>        else
>          ix86_preferred_stack_boundary = (1 << i) * BITS_PER_UNIT;
>
> You are actually dealing with gcc bug, not Linux bug --- when gcc is
> compiled with AMD64 support it enforces 16-byte alignment even in 32-bit
> mode.

Honza? 

> Rather let it be as it was, adding -mpreferred-stack-boundary=4 doesn't
> make sense, because it is default.

Hmm, maybe that was different on older gcc versions. There must have been
some reason this option was originally added.

Linus can you please just revert  c8fdd247255a3a027cd9f66dcf93e6847d1d2f85

-Andi

