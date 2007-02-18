Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXBRE67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXBRE67 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 23:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbXBRE67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 23:58:59 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41322 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbXBRE66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 23:58:58 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<1171664993.5644.92.camel@localhost.localdomain>
	<m1y7mxb20a.fsf@ebiederm.dsl.xmission.com>
	<1171746241.5644.124.camel@localhost.localdomain>
Date: Sat, 17 Feb 2007 21:58:16 -0700
In-Reply-To: <1171746241.5644.124.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Sun, 18 Feb 2007 08:04:00 +1100")
Message-ID: <m1lkiw9i53.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> The only time it really makes sense to me to let the irq number vary
>> arbitrary are when things are truly dynamic, like with MSI, a
>> hypervisor, or hot plug interrupt controllers.
>
> I don't understand why you would go to all that lenght to replace irq
> numbers with irq_desc * and ... keep then numbers :-)

Because I don't have something better to replace them with.

We need names for irqs, currently the kernel/user space interface
is a unsigned number.

Printing out a pointer where we currently have an integer in:
/proc/interrupts
/proc/irq/N/...
/sys/devices/pci0000:00/0000:00:0e.0/irq
is a bad practice, and if  I don't retain the number that is 
my only choice.

I similar problem exists in all of the initialization messages from
device drivers that display their irq number.

Plus I think there are also a few ioctls that return the linux
irq number.

Now it may make sense to replace my irq_nr() with irq_name(), and
return a string that can be used instead, but fixing the kernel
user space interface is a third step that is a lot more delicate
and will require more thinking.  So I would prefer to put that
off until all of the internal users are using a pointer.  Then
we can grep for irq_nr and see how many places we actually export
the irq number to user space.

The fact that the user space has been put in charge of when to
migrate an irq from cpu to another makes this double delicate.

>> Sure, and I have the same issue with a big "DESIGNED FOR ppc" in the middle,
>> or "DESIGNED FOR arch/x".   However the unfortunate truth is that the x86
>> has enough volume that frequently other architectures use some x86
>> hardware and thus get some of x86's warts.   So anything that doesn't
>> cope with the x86's warts is frequently doomed to failure.
>
> I fait to see how what I described would not apply nicely to x86 ..

The model can be made to work if you force it but it isn't really
a good fit.

I can't really use the (cpu#, vector#) tuple as hw number as it
varies at runtime, and a single interrupt can  send different (cpu#,
vector#) tuples from one interrupt message to the next without being
reprogrammed.   At least I don't have the impression that you support
multiple hardware numbers going to the same linux irq.  But this
really is the layer where I need the reverse mapping.  However I can
optimize the reverse mapping by taking advantage of the per cpu
nature.

Currently the hardware number that I use is the pin number on
the ioapic.  And to form the linux irq I just add the number
of pins of all previous ioapics together and then add my pin number.
Fairly simple.

Doing the above gives me stable names that are the same from one boot
to the next if someone doesn't change how the hardware is put
together.  It looks to me that if I adapt the ppc scheme my irq
numbers will change from one boot to the next one kernel to the next,
almost at random.  Depending on driver initialization order and
similar things.  Having names that change all of the time is confusing
and not very useful.  The fact that in the process of making my names
stable it actually happens to reflect part of the irq hardware
topology is incidental.

Giving up stable names is not something I want to do.

Eric
