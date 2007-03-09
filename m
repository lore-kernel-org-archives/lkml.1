Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXCIAg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXCIAg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXCIAg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:36:56 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45915 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbXCIAgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:36:55 -0500
Date: Thu, 8 Mar 2007 16:29:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Zachary Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: hardwired VMI crap
In-Reply-To: <45F0A5F0.7040900@goop.org>
Message-ID: <Pine.LNX.4.64.0703081616250.10832@woody.linux-foundation.org>
References: <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain>
 <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain>
 <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu>
 <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain>
 <45F0761C.6060107@vmware.com> <45F07D07.5090003@goop.org> <20070308213458.GA24634@elte.hu>
 <45F09EAE.6090908@goop.org> <45F0A254.4020002@vmware.com> <45F0A5F0.7040900@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ I don't really want to be involved too much in this particular 
  discussion, but I'll pipe up quickly anyway.. ]

On Thu, 8 Mar 2007, Jeremy Fitzhardinge wrote:

> Zachary Amsden wrote:
> > For APICs, we have two operations - APICRead and APICWrite.  It is
> > nice and clean, and plugs in very easily to the APIC accessors
> > available in Linux.
> >
> > Is this not clean?
> 
> Sure, that's clean, From that perspective the apic is a bunch of
> registers backed by a state machine or something.

I think you could do much worse than just decide to pick the IO-APIC/lapic 
as your "virtual interrupt controller model". So I do *not* think that 
APICRead/APICWrite are in any way horrible interfaces for a virtual 
interrupt controller. In many ways, you then have a tested and known 
interface to work with.

Of course, there are bound to be better interfaces that map more naturally 
to what people actually want to *do* ("[un]mask interrupt pin X", 
"acknowledge interrupt pin X" etc), but quite often the cost of an 
interface is *designing* it, so I don't think it's wrong per se to just 
avoid that cost entirely, and just say "we make our interface look like a 
known hardware interface". And then IOAPIC/lapic is the obvious choice.

So Ingo, I think you've been a bit unfair. I agree that it would be 
ugly to also try to emulate timers with that "fake local apic" setup, but 
even that ugliness is probably not horrid, especially if you want to have 
some kind of stable interface for an ABI.

Of course the whole "stable ABI" is fairly moot. The kernel clearly won't 
use the ABI, but a source-level API - and part of that is *exactly* that 
an ABI is by design always very inflexible and has to be backwards 
compatible. Make the API more high-level, and then the VMI "paravirt_ops" 
stuff can translate that higher-level API into its own low-level ABI any 
way it wants to.

I do agree that for timers, the lapic model is probably ugly enough that 
an ABI might be better off with somethign cleaner than just seeing timers 
too as part of the interrupt controller, but I doubt it really is  that 
big a deal. And I really think Ingo has made a bigger deal out of this 
than necessary, although clearly CONFIG_NO_HZ will require that the 
paravirt_ops will work on that level and will be able to translate it to 
whatever VMI interfaces there are.

		Linus
