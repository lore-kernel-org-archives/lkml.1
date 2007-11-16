Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbXKPQBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbXKPQBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 11:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXKPQBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 11:01:33 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:54014 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbXKPQBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 11:01:32 -0500
Date: Fri, 16 Nov 2007 08:00:56 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Philip Mucci <mucci@cs.utk.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: perfmon2 merge news
Message-ID: <20071116160056.GF10616@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu> <20071114015210.GA20365@one.firstfloor.org> <A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu> <p737ikicjbn.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p737ikicjbn.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Fri, Nov 16, 2007 at 04:15:56PM +0100, Andi Kleen wrote:
> My impression so far is that you're not quite sure what you want,
> otherwise you would be more concrete.
> 
> > - A feature which was dropped earlier by Stefane (only to satiate
> > LKML), we consider
> > very important. Allowing one tomapping of the kernels view of the
> > PMD's, allowing
> > user-space access to full 64-bit counts, if the architecture
> > supports a user-level read instruction.
> 
> You mean returning the register number for RDPMC or equivalent
> and a way to enable it for ring 3 access? 
> 
No, he is talking about something similar to what was in perfctr.
The kernel emulates 64-bit counters in software and that is you
get back when you read the counters. If you read via RDPMC, you
get 40 bits. To reconstruct the full 64-bit value from user land
you need the upper bits. One approach is for the kernel to allow
you to remap a page that has the 64-bit (software) counters. With
that and a bit of mask/shifting you can reconstruct the full value.

> I'm considering that an essential feature too. I wasn't aware
> it was dropped.
> 
What I dropped is the cr4.pce enabled for self-monitoring sessions.

> Yes it is for everybody. I've been rather questioning if the slow
> ways (complicated syscalls) to get the counter information are really 
> needed.
> 
> > referring to the concept of eventsets. Having multiplexing is
> > important.
> 
> Why is it important? 
> 
Read my follow-up message to Dean's message.

> > - Custom sample formats would be considered not often used in our
> > community, largely
> > because the tools run on all HPC/Linux architectures. PAPI uses the
> > default sample
> > format which has been sufficient for our needs. However, the lack of
> > custom sample
> > formats preclude the dev of the specialized tools that access the
> > sampling
> > hardware as found on the IA64, PPC64, the Barcelona and the SiCortex
> > node chip.
> > pfmon exports this functionality quite well, and it does get used.
> 
> What do you mean with custom sample formats exactly?  What information
> do you want in there? And why?
> 
Perfmon2 allows you to have an in-kernel sampling buffer. The idea is
not new, Oprofile has this as well. The problem here is that if the
buffer is in the kernel the format of the samples is fixed and it
should have to. Tools may want to record samples in different formats
and as you said some may need extra information gathered in the kernel.
Some may want to aggregate samples in the kernel (Oprofile used to
do that), some may want to use a double-buffer approach to minimize
blind spots, others may simply use the counter overflow mechanism to
record something that is non-PMU related, e.g, kernel call stack.
I have built such a module and it was quite interesting to collect
the call stack when you hit a last cache level miss.

The idea behind customizable sampling format is simple: extract the
format from the perfmon core and put this into a kernel module. The
core provides a simple registration mechanism and the two communicate
via a set of callbacks.

Perfmon2 comes with a basic default format which works on all
platforms. But it is possible to develop others without having to
patch the kernel nor recompile nor reboot. At its core, each format provides
a handler routine which is called on counter overflow. The handler routine
controls what is recorded, how it is recorded, how it is exported to
userland, and wheher overflow notifications need to be sent.

Using this mechanism, for instance, we were able to connect the
Oprofile kernel code to perfmon2 on Itanium with a 100 lines of
code. The exact same approach would also work on X86 Oprofile as well.

> e.g. PEBS and so on pretty much fix the in memory sample format in hardware,
> so they only way to get a custom format would be to use a separate buffer.
> 

This is also how we support PEBS because, as you said, the format of the
samples is not under your control. if you want zero-copy PEBS support,
you have to follow the PEBS format.

I am sure other processors haev and will have hardware buffers as well.

> I can think of one reason why the kernel should add more information
> in a separate buffer (log the instruction bytes so that it can
> be disassembled and a address histogram be generated using the PEBS
> register values), but it is a relatively obscure one and definitely
> not a essential feature. Unfortunately it is also hard to implement
> completely race-free.
> 
Yes, you could do that without changing the core implementation of
perfmon2.

-- 
-Stephane
