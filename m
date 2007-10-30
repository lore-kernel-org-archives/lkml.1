Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbXJ3TdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbXJ3TdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbXJ3T2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:28:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758704AbXJ3T2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:28:17 -0400
Date: Tue, 30 Oct 2007 12:25:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
In-Reply-To: <20071030185639.GA9077@Krystal>
Message-ID: <alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org>
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net>
 <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal>
 <472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal>
 <alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
 <20071030185639.GA9077@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Mathieu Desnoyers wrote:
> 
> The key idea for collapsing profiling, markup and tracing was that
> marking up the code is required for both profiling and tracing. It's
> only the code that is called from that markup site that differs.

What code is actually shared? 

Regardless, an internal implementation issue is *not* a good basis for a 
user-visible interface. 

> Ok, so maybe we should keep "markup", "tracing" and "profiling"
> separately and see how things evolve.

I think so. At least conceptually - ie it might be fine to share a Kconfig 
file, but there probably shouldn't be some forced shared choice about it.

> With SMP systems becoming cheap commodity hardware, each and every
> developer increasingly face thorny race problems, both in user-space
> apps and in the kernel, which may involve hypervisor-kernel-userspace
> interaction.

Well, the thing is, most of the time, those app developers will not be
doing kernel-level markers. But they may well be doing profiling. 

Speaking as an application developer myself (git), I care deeply about 
good profiling info, and I love Oprofile. But even though I'm a kernel 
person too, I'd not want to do kprobes. It's just not relevant to me as a 
user-land developer.

(I might want to extend on strace, but if so, I'd do it generically, not 
as a "probe". For example, I'd love to see the page faults, but I think 
they really *are* "system calls", so I think it would make more sense to 
extend on the ptrace interface than to have any kprobes thing)

> > So I actually think that the current Kconfig.instrumentation should be 
> > *removed*. Rather than adding more groupings based on that 
> > fundamentally flawed premise of false commonality.
> 
> Should it come with a re-duplication of it's content into each 
> architecture, which was the case previously ? The oprofile and kprobes 
> menu entries were litteraly cut and pasted from one architecture to 
> another. Should we put its content in init/Kconfig then ?

I don't think it's a good idea to go back to making it per-architecture, 
although that extensive "depends on <list-of-archiectures-here>" might 
indicate that there certainly is room for cleanup there.

And I don't think it's wrong keeping it in kernel/Kconfig.xyz per se, I 
just think it's wrong to (a) lump the code together when it really doesn't 
necessarily need to and (b) show it to users as some kind of choice that 
is tied together (whether it then has common code or not).

On the per-architecture side, I do think it would be better to *not* have 
internal architecture knowledge in a generic file, and as such a line like

	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32

really shouldn't exist in a file like kernel/Kconfig.instrumentation.

It would be much better to do

	depends on ARCH_SUPPORTS_KPROBES

in that generic file, and then architectures that do support it would just 
have a

	bool ARCH_SUPPORTS_KPROBES
		default y

in *their* architecture files. That would seem to be much more logical, 
and is readable both for arch maintainers *and* for people who have no 
clue - and don't care - about which architecture is supposed to support 
which interface...

			Linus
