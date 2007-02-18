Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXBRT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXBRT6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbXBRT6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:58:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:60076 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbXBRT6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:58:32 -0500
Subject: Re: [RFC] killing the NR_IRQS arrays.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <m1lkiw9i53.fsf@ebiederm.dsl.xmission.com>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	 <1171664993.5644.92.camel@localhost.localdomain>
	 <m1y7mxb20a.fsf@ebiederm.dsl.xmission.com>
	 <1171746241.5644.124.camel@localhost.localdomain>
	 <m1lkiw9i53.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 06:58:03 +1100
Message-Id: <1171828684.5644.167.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Because I don't have something better to replace them with.
> 
> We need names for irqs, currently the kernel/user space interface
> is a unsigned number.

 .../...

Ok, as long as it's strictly a userspace issue, I understand.

> The model can be made to work if you force it but it isn't really
> a good fit.
>
> I can't really use the (cpu#, vector#) tuple as hw number as it
> varies at runtime, and a single interrupt can  send different (cpu#,
> vector#) tuples from one interrupt message to the next without being
> reprogrammed.   At least I don't have the impression that you support
> multiple hardware numbers going to the same linux irq.  But this
> really is the layer where I need the reverse mapping.  However I can
> optimize the reverse mapping by taking advantage of the per cpu
> nature.
> 
> Currently the hardware number that I use is the pin number on
> the ioapic.  And to form the linux irq I just add the number
> of pins of all previous ioapics together and then add my pin number.
> Fairly simple.

Ok.

> Doing the above gives me stable names that are the same from one boot
> to the next if someone doesn't change how the hardware is put
> together.  It looks to me that if I adapt the ppc scheme my irq
> numbers will change from one boot to the next one kernel to the next,
> almost at random. 

Not necessarily. The current code would though in practice, it doesn't
change much, but as I said, it would be trivial to change it so that a
domain using a linear reverse map is fully "allocated" when initialized.

Stable numbers are somewhat useful for users, thus one of the thing the
ppc code tries to do in order to get "mostly" stable numbers/names as
well is to try to use the HW number as a "starting" value when searching
for a linux irq number to assign. Only if it's not possible (the HW
number is in the reserved ISA range, too big, or the matching linux
number is already used) then it will allocate a new one.

I still think I need to add the domain and HW number to /proc/interrupts
though (or to some other sysfs file) in order to provide the mappign to
virqs to userland.

Also, if the eixsting linear and radix tree reverse maps don't fit your
needs, you can create a new one or request no reverse map from the core
at all and do everything in your arch code.

Basically, what I'm saying is that I'd like the concept of domain &
generic remappers to become generic. sparc64 and ppc use it and I'm
convinced it would be useful to other especially archs with lots of
cascaded PICs like ARM. And by doing so, we can also make it easier to
expose the HW -> virq mapping to userland in a common place with a
consistent format since it would be done by generic code.

Cheers,
Ben.


