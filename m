Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbXKMArM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbXKMArM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 19:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXKMAq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 19:46:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:37417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbXKMAq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 19:46:57 -0500
From: Andi Kleen <ak@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: fix taking DNA during 64bit sigreturn
Date: Tue, 13 Nov 2007 01:43:04 +0100
User-Agent: KMail/1.9.1
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org
References: <20071111192758.GA21851@linux-os.sc.intel.com> <200711122216.40663.ak@suse.de> <4738EBB6.7060605@zytor.com>
In-Reply-To: <4738EBB6.7060605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711130143.04807.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 01:11, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> The *real* fix for this is almost certainly to just get rid of the
> >> 64-bit code entirely, and use the 32-bit code as the base for one single
> >> unified setup.
> >
> > That would likely break the ABI. x86-64 ABI is completely different here
> > -- no ibcs, just pure x86 ISA.
>
> Different ABIs clearly have to be handled, 

Well all four cases are quite different.

> but I don't think that is a 
> huge deal.  The i387 code overall (not just asm/i387.h) is very
> different,

Yes because x86-64 is vastly simpler. e.g. the 64bit path 
does not touch the state itself at all. And all the state convert
code moved into the compat layer only. There were also
various other cleanups.

Also 64bit e.g. defers some of the checking to the context
switch, which also simplifies things.

> though, and I find it unlikely that a properly unified code 
> is going to be ready and working in the 2.6.24 timeframe. 

To be honest it is unclear to me how you can do better than
direct FXSAVE from/to user space on 64bit.  Sure you could
put a manual convert pass inbetween like i386, but that
would be rather pointless because it matches 1:1 and in fact would
make the code to be worse (no transparent support of future
FXSAVE extensions) . Not sure what tripped
Linus up so much either. Was it the broken white space?

> I'm exploring 
> if a partial merge with high confidence level is feasible; either way, a
> proper merge for 2.6.25 is probably the right thing.

At least on 64bit the result would be probably more complicated
and likely slower code.

If anything it might make sense to add a few more of the 64bit 
improvements to 32bit (e.g. delayed exception checking).
The direct FXSAVE path cannot be moved over because it
would break the ABI, otherwise I would have done that 
long ago.

BTW if you're looking for real fixes to do iirc some of the FPU
context switch workarounds are missing in KVM which
does mostly its own thing currently.

-Andi

