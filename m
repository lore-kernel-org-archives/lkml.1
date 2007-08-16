Return-Path: <linux-kernel-owner+w=401wt.eu-S1761084AbXHPAYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761084AbXHPAYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934943AbXHPAXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:23:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36334 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934836AbXHPAXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:23:36 -0400
Date: Thu, 16 Aug 2007 06:06:00 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Segher Boessenkool <segher@kernel.crashing.org>
cc: horms@verge.net.au, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>, rpjday@mindspring.com,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, zlynx@acm.org,
       clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
In-Reply-To: <2d2eeab6276cab2e6cc5830d36a43b98@kernel.crashing.org>
Message-ID: <alpine.LFD.0.999.0708160338520.22701@enigma.security.iitk.ac.in>
References: <46C2350A.1010807@redhat.com> <E1ILCgh-00052A-00@gondolin.me.apana.org.au>
 <20070815081841.GA16551@osiris.boeblingen.de.ibm.com> <46C30540.2070603@s5r6.in-berlin.de>
 <alpine.LFD.0.999.0708151941150.16414@enigma.security.iitk.ac.in>
 <20070815145207.GA23106@gondor.apana.org.au> <46C3253F.5090707@s5r6.in-berlin.de>
 <20070815162722.GD9645@linux.vnet.ibm.com> <d4406222873856f472b9173a14a19aa2@kernel.crashing.org>
 <20070815185724.GH9645@linux.vnet.ibm.com>
 <alpine.LFD.0.999.0708160118330.16414@enigma.security.iitk.ac.in>
 <2d2eeab6276cab2e6cc5830d36a43b98@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Aug 2007, Segher Boessenkool wrote:

> > > > What you probably mean is that the compiler has to assume any code
> > > > it cannot currently see can do anything (insofar as allowed by the
> > > > relevant standards etc.)
> > 
> > I think this was just terminology confusion here again. Isn't "any code
> > that it cannot currently see" the same as "another compilation unit",
> 
> It is not; try  gcc -combine  or the upcoming link-time optimisation
> stuff, for example.
> 
> > and wouldn't the "compilation unit" itself expand if we ask gcc to
> > compile more than one unit at once? Or is there some more specific
> > "definition" for "compilation unit" (in gcc lingo, possibly?)
> 
> "compilation unit" is a C standard term.  It typically boils down
> to "single .c file".

As you mentioned later, "single .c file with all the other files (headers
or other .c files) that it pulls in via #include" is actually "translation
unit", both in the C standard as well as gcc docs. "Compilation unit"
doesn't seem to be nearly as standard a term, though in most places it
is indeed meant to be same as "translation unit", but with the new gcc
inter-module-analysis stuff that you referred to above, I suspect one may
reasonably want to call a "compilation unit" as all that the compiler sees
at a given instant.

BTW I did some auditing (only inside include/asm-{i386,x86_64}/ and
arch/{i386,x86_64}/) and found a couple more callsites that don't use
cpu_relax():

arch/i386/kernel/crash.c:101
arch/x86_64/kernel/crash.c:97

that are:

	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
		mdelay(1);
		msecs--;
	}

where mdelay() becomes __const_udelay() which happens to be in another
translation unit (arch/i386/lib/delay.c) and hence saves this callsite
from being a bug :-)

Curiously, __const_udelay() is still marked as "inline" where it is
implemented in lib/delay.c which is weird, considering it won't ever
be inlined, would it? With the kernel presently being compiled one
translation unit at a time, I don't see how the implementation would
be visible to any callsite out there to be able to inline it.


Satyam
