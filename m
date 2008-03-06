Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYCFAEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYCFAEx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYCFAEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:04:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:36694 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYCFAEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:04:43 -0500
Subject: Re: [BUG] 2.6.25-rc3-mm1 kernel panic while bootup on powerpc ()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@debian.org>
In-Reply-To: <20080304103350.12d26560.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	 <47CD4AB3.3080409@linux.vnet.ibm.com> <20778.1204641656@neuling.org>
	 <20080304103350.12d26560.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 11:03:31 +1100
Message-Id: <1204761811.21545.238.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, we are - it's the semaphore rewrite which is doing this in
> start_kernel().  It's being discussed.
> 
> Enabling interrupts too early on powerpc was discovered to be fatal on
> powerpc years ago.  It looks like that remains the case.

Regarding these issues. I could make it non fatal and just WARN_ON,
provided that I have a way to differentiate legal vs. illegal calls
to local_irq_enable(). We already have that function mostly out of
line in C code due to our lazy irq disabling scheme, so the overhead of
testing some global kernel state would be minimum here.

However, I don't see anything around init/main.c:start_kernel() that I
can use. What do you reckon here we should do ? Add some kind of global
we set before calling local_irq_enable() ? Or make early_boot_irqs_on()
do that generically 

It's currently defined as an empty inline without CONFIG_TRACE_IRQFLAGS
but we could make it set a flag instead.

I'm pretty sure other archs have similar problems, especially in the
embedded world where you are booted with random junk firmwares that may
leave devices, interrupt controllers etc... in random state, and
enabling incoming IRQs before the arch code properly initializes the
main interrupt controller can be fatal. I know at least of an ARM board
I worked on a while ago that had a similar issues.

On ppc32, unfortunately, our local_irq_enable/restore are nice inlines
that whack the appropriate MSR bits directly, thus adding a test for a
global flag would add some bloat/overhead that I'd like to avoid, at
least until we decide to also do lazy disabling on those, if ever...

Cheers,
Ben.


