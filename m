Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbZDEVFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbZDEVFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 17:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbZDEVFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 17:05:03 -0400
Received: from www.tglx.de ([62.245.132.106]:33471 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbZDEVFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 17:05:02 -0400
Date: Sun, 5 Apr 2009 23:02:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Levon <levon@movementarian.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] x86: fix BUG: using smp_processor_id() in preemptible
 [00000000] code: oprofiled/3319
In-Reply-To: <1238962495.3301.0.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0904052301481.747@localhost.localdomain>
References: <1238958725.3522.1.camel@ht.satnam>  <alpine.LFD.2.00.0904051243310.4023@localhost.localdomain> <1238962495.3301.0.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Jaswinder Singh Rajput wrote:
> On Sun, 2009-04-05 at 12:51 -0700, Linus Torvalds wrote:
> > 
> > On Mon, 6 Apr 2009, Jaswinder Singh Rajput wrote:
> > >
> > > Fixed this bug on P4 HT machine:
> > 
> > I don't think this really is correct.
> > 
> > Anything that does that "get_stagger()" thing should already either be 
> > tied to a specific CPU (because it's going to actually touch the variables 
> > for "that CPU"), or it should likely set up the data structures for _all_ 
> > cases.

Most of the functions are called preempt off anyway. The only one
which needs care AFAICT is p4_fill_in_addresses, but the problem space
is outside of the p4 specific code. It's the call site which is
nmi_setup():

       model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
       ...
       on_each_cpu(nmi_cpu_setup, NULL, 1);

Need to have a closer look which parts of that section need to be
preempt off.

> > Just as an example, look at something like "p4_setup_ctrs()": it will use 
> > that stagger to determine what MSR to read. But if we are preemptable, the 
> > CPU we actually do the MSR read on may be a _different_ CPU than the CPU 
> > that we did the "get_stagger()" on!

And that code has nested calls to get_stagger() via pmc_setup_one_p4_counter().

That is odd as well. Why evaluate that twice ? So there are more
things to look at before we just fix^Whide some debug warning.

> > Of course, this is all ancient code, so whatever. But I really think this 
> > patch is actively bad - it just hides the issue rather than fixing 
> > anything.

And the proposed follow up patch is even worse as it just adds
mechanical band aids all over the place without analysing where the
root cause of the problem is.

Thanks,

	tglx


