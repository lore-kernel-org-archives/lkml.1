Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYFKNAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYFKNAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYFKM7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:59:52 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63008 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751111AbYFKM7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:59:51 -0400
Date: Wed, 11 Jun 2008 13:57:44 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
In-Reply-To: <86802c440806101932s1bde646at322df320d02bfdb@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0806111325060.14077@cliff.in.clinika.pl>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> 
 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl> 
 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl> 
 <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com> 
 <484E7B03.8000604@redhat.com>  <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
  <86802c440806101209q301bcef0ia859db7e587bd42e@mail.gmail.com> 
 <Pine.LNX.4.55.0806102025460.1702@cliff.in.clinika.pl> 
 <86802c440806101249i3650aa59u1090110a803c3384@mail.gmail.com> 
 <Pine.LNX.4.55.0806110122580.1702@cliff.in.clinika.pl>
 <86802c440806101932s1bde646at322df320d02bfdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Yinghai Lu wrote:

> >  Thanks for the info.  Let me understand the situation better: local APIC
> > IDs are preassigned by the firmware based on their "socket address" and
> > the socket where the lowest numbered quad would be is empty.
> > Nevertheless the firmware sets the destination ID of the ExtINTA interrupt
> > in the I/O APIC to 0 rather than the ID of the bootstrap CPU.  Is that
> > correct?
> 
> Yes
> 
> after I asked bios engineer to change the dest apic id to 4, the error
> is gone.

 Thanks for the clarification.

> >  But it would mean the Virtual Wire interrupt delivery would not work, or
> > is the I/O APIC setup redundant and the local APIC of the bootstrap CPU is
> > set up for ExtINTA delivery as well?
> 
> it doesn't need to virtual wire for timer (ExtInt), timer is hpet and
> routed to ioapic pin2.

 That's not what I asked about -- the timer does not matter here.  The 
Virtual Wire mode is a configuration, where one input of one APIC in the 
system is set up for the ExtINTA mode and acts transparently with the 
system software having no need to know about it.  Instead a pair of 
legacy 8259A chips is used to deliver interrupts, including claiming the 
INTA cycles, providing vectors and prioritising sources, as defined in the 
PC/AT architecture.

 Many pieces of software rely on the 8259A PICs, either because they 
predate the APIC or because they have no means to make use of 
multiprocessor features anyway.  They include various versions of DOS 
together with software run in that environment (as DOS programs quite 
frequently drive hardware at the low level), many versions of the 
Microsoft Windows system as well as other software.  For these a legacy 
mode, either the Virtual Wire mode, or a mode where 8259A interrupts are 
delivered directly to one processor's INT line has to be implemented as 
mandated both by the Multiprocessor Specification and the Advanced 
Configuration and Power Interface Specification.

 Coming back to my question -- how is such a mode implemented in the 
affected system?  Clearly the route through the I/O APIC is not going to 
work and moreover, the chip clutters the system with broken interrupt 
messages each time the 8259A signals an interrupt.

 Please note Linux can use the Virtual Wire mode in the APIC/SMP mode too,
if requested by specifying the "noapic" command-line option -- have you 
verified the option works correctly with the affected system?

> Just know at first BIOS engineer refused to change that to 4, because
> other os is not happy.

 Well, this is just a confirmation my attitude is correct -- such problems 
should not be papered over, because vendors will deny their existence 
then.  At least a complaint message should be printed so that users have 
an opportunity to see it and ask their hardware supplier for an 
explanation.

 In this case, a workaround for the 64-bit mode happens to be quite cheap,
but it should be extended to cover the 32-bit mode as well.  The only
solution for the 32-bit mode I have in mind would lead to a waste of
resources for many users of good hardware.  And this because of somebody's
sloppiness -- as I have written -- this better be well justified.

 Unless you have precise means to identify this system -- in that case I
think reconfiguring the bootstrap processor's local APIC ID to 0 would be
the right approach.  Have you tried it?

  Maciej
