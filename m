Return-Path: <linux-kernel-owner+w=401wt.eu-S1767618AbXDFNXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767618AbXDFNXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767622AbXDFNXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:23:49 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35893 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767618AbXDFNXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:23:48 -0400
Date: Fri, 6 Apr 2007 15:23:05 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Natalie Protasevich <nataliep@google.com>, Andi Kleen <ak@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       auke-jan.h.kok@intel.com
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <m1r6r0awc2.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704061503310.31796@twin.jikos.cz>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704031455200.10589@twin.jikos.cz> <46126EAA.3050000@intel.com>
 <Pine.LNX.4.64.0704031725300.28249@twin.jikos.cz> <46128C92.2020908@intel.com>
 <Pine.LNX.4.64.0704031940080.28249@twin.jikos.cz>
 <Pine.LNX.4.64.0704041748330.28249@twin.jikos.cz> <m1r6r0awc2.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Eric W. Biederman wrote:

> > And the bisection winner is
> >
> > 	i386-irq-kill-nr_irq_vectors-and-increase-nr_irqs.patch
> >
> > I don't immediately see how it could be causing it, so adding CCs which 
> > are listed in the patch.
> Weird.  I will have to look at that in a little more detail.
> Do you know if this problem happens on x86_64? What does your .config 
> look like? What does /proc/interrupts look like? What kind of hardware 
> you running this kernel on? Can anyone else reproduce this?
> The oops clearly shows something using -1 and calling that as an
> address I don't know why, but I'm guessing I have triggered a memory
> stomp somewhere.  I think this is the first time I have seen a small
> negative number causing a NULL pointer dereference.
> That patch looks innocuous enough that either:
> - I just missed changing something I should have.
> - Your configuration has an increase in NR_IRQS and that triggered
>   something.
> - The patch simply permuted things so a memory stomp now happens
>   on the e1000 data structures instead of somewhere else.
> - Something doesn't like large irq numbers.
> This work is essentially a backport from x86_64 so if your hardware
> is 64bit capable testing that should be a fairly easy test, and be
> able to rule out large irq numbers as the culprit.
> Until I get a good look at -mm I'm going to have a hard time guessing.
> But a roving memory stomp is my best guess.

Hi Eric,

after struggling with this issue for some time, I think that it's just 
some incosistent usage of NR_IRQS throughout the source probably due to 
some include hell. I really don't understand the how the mach-*/ includes 
are supposed to work.

I found out (by disassembling resulting vmlinux binaries) that in 
arch/i386/kernel/entry.S, the loop in irq_entries_start does too little 
iterations compared to NR_IRQS value as seen in for example io_apic.c

The super-stupid proof-patch below fixes the panic on my system. It's just 
to demonstrate that the i386 includes really need fixing to be consistent 
somehow.

diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
index 976438c..b20dc07 100644
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -53,6 +53,8 @@
 #include <asm/dwarf2.h>
 #include "irq_vectors.h"
 
+#define NR_IRQS 4096
+
 /*
  * We use macros for low-level operations which need to be overridden
  * for paravirtualization.  The following will never clobber any registers:

-- 
Jiri Kosina
