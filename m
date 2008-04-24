Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYDXP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYDXP5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYDXP5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:57:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262AbYDXP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:57:12 -0400
Date: Thu, 24 Apr 2008 08:55:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <4810A9E6.1080201@garzik.org>
Message-ID: <alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org>
 <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org> <480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
 <alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org> <m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org> <alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org> <4810A9E6.1080201@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 Apr 2008, Jeff Garzik wrote:
> 
> However, it does not follow that an int is what _must_ be passed around.  We
> already have design patterns like
> 
> 	cookie_pointer = ioremap(raw bus resource)
> 
> Not that I am the one pushing for that, just noting.

I do agree that we could use something more type-safe.

So a "pointer" to a structure that doesn't actually exist would be fine 
and would give us some C type checking. 

But then you'd have to have some way to "printk" the information, which is 
a very common requirement (and the printk still needs to be a number, 
because you want to match up 'dmesg' output with the '/proc/interrupts' 
file etc).

That, in turn, would effectively force a whole new function, and then 
you'd have things like

	printk(.. irq %d .., irq_number(irqcookie) ..)

which while not ugly isn't really all that clean either. And I guarantee 
that people would misuse that "irq_number(cookie)" exactly in the same 
ways they'd misuse "irq" (ie not very much).

Quite frankly, I'd much prefer a

	typedef int __bitwise irq_t;

and then we can use sparse to do this testing, without breaking any 
existing use at all (because it will still be an "int" to gcc, but sparse 
will make "irq_t" a type of its own and make sure that people pass it 
around as such and not do arithmetic ops on it etc).

> > EVERYTHING else would be architecture-specific. And that is exactly what we
> > do not want. EVER. 
> 
> Not true -- you have metadata/OOB data like MSI messages, where you are passed
> a value from the PCI hardware in the PCI message, not just an "interrupt
> asserted" condition.  Or s/value/values/ if you enable PCI MSI's multiple
> message support.

The point is, MSI *is* architecture-specific. In fact, it's even 
motherboard-specific, in that you are going to have (for the forseeable 
future) drivers that have to work with or witgout MSI even on the same 
architecture.

			Linus
