Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZLDVAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZLDVAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 16:00:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbZLDVAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 16:00:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:52883 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbZLDVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 16:00:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NP3qqSWIHs3HLj8XJ1KgrV0JB7wES/333uGSJQ9uV/ZMxbOmyuId+zaZJFuVXI3920
         0+x2hRa4lm9WY8KUR2LFtO/5gTLNxWxkC3/OyCieDTmaOsXdWNA2u0ifzO1qJo5HUUaB
         3OEGH2sc11Iv6tFeZz32wJoAZR1AWNTgXYo8k=
Date: Fri, 4 Dec 2009 22:00:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/2] hw-breakpoints: Perf interface support for
	breakpoint ranges
Message-ID: <20091204205959.GA13473@nowhere>
References: <1259874964-7757-1-git-send-regression-fweisbec@gmail.com> <1259896133.2076.1254.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259896133.2076.1254.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 02:08:53PM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2009-12-03 at 22:16 +0100, Frederic Weisbecker wrote:
> > Looking a the PowerPc cpu implementations of breakpoints, we have
> > for both data and instruction breakpoints:
> > 
> > - 2 Address registers (let's rather talk about a comparison operand)
> > - Control registers that define the comparison nature (equal, greater,
> >   lesser than) against the above addresses.
> > - Control registers that define how to handle the 2 address registers.
> >   The instruction address or memory access need to either match
> >    - Address 1 OR Address 2 (OR = boolean OR, not binary)
> >    - Address 1 AND Address 2 ( AND = boolean AND, not binary)
> >   And this match is subject to the comparison rules independantly
> >   defined for these two addresses by the control registers
> 
> Well.. the debug facility is different between different PowerPC CPU
> families... There's range breakpoints on some but not all, there's data
> value compare or even instruction value compare on some, etc...



Sure.
I've picked this example (Freescale G2 PPC) as it looks one the trickiest
implementations.


 
> > The most obvious practical uses of these facilities are either the
> > definition of two independant traditional breakpoints, or the
> > definition of a breakpoint that matches a range of addresses.
> > 
> > Hence we want the generic breakpoint interface to support it.
> > This patch splits up the struct perf_event_attr::bp_addr field
> > into bp_start and bp_end.
> 
> Ok, that sounds like a good idea.
> 
> > The definition of a simple breakpoint needs bp_start and bp_end to be
> > equal, ie: a simple breakpoint is a range breakpoint which start and
> > end addresses are identical.
> 
> Ok. So a 0 sized point. Makes sense.



Now that I think about it.
Why not actually use the bp_len field. It was first meant to determine
the size of the access (1, 2, 4, 8 in x86). But that could be extended
to define ranges if breakpoint ranges imply accesses of random size.

What do you think? If the PowerPc range breakpoints are always for
random size accesses (I'm not sure about it), then that would make
sense.

In this case we should drop this patch as the current interface is already
fine. We just need to turn bp_len into a u64 (u32 may not cover every cases).



> > To define a range breakpoint, you just need to set bp_start and bp_end
> > to the limits of your address range.
> 
> Inclusive ?



Yeah, that probably makes more sense as a default.

