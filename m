Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbXCIAK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbXCIAK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbXCIAK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:10:29 -0500
Received: from gw.goop.org ([64.81.55.164]:45324 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbXCIAK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:10:28 -0500
Message-ID: <45F0A5F0.7040900@goop.org>
Date: Thu, 08 Mar 2007 16:10:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: hardwired VMI crap
References: <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <45F07D07.5090003@goop.org> <20070308213458.GA24634@elte.hu> <45F09EAE.6090908@goop.org> <45F0A254.4020002@vmware.com>
In-Reply-To: <45F0A254.4020002@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> For APICs, we have two operations - APICRead and APICWrite.  It is
> nice and clean, and plugs in very easily to the APIC accessors
> available in Linux.
>
> Is this not clean?

Sure, that's clean, From that perspective the apic is a bunch of
registers backed by a state machine or something.  It's not particularly
clean from a high-level interface perspective because those calls don't
mean anything, but that just means pv_ops is the wrong interface for
those calls. genapic, from its name alone, sounds like it should be the
right place to hook in at that level; if it isn't, it sounds like the
right starting place.

But...

> We just don't drive the local timer interrupts through the APIC, we
> make hypercalls to schedule local timer alarms.  Which is something we
> must do for UP kernels as well, which use the PIT / PIC.  So there is
> a need for having clockevents code which doesn't program timers
> through the APIC.

Yes, but couldn't you, oh I don't know, have the virtual timer
interrupts come in on irq 97, and just register a handler for that irq
and use that ISR to drive the time stuff?  Then its logically identical
to the Xen code or any other free-standing device driver.

Making your virtual timer device share interrupts with the (emulated)
real-time device seems to be making things messy (is that right, is that
the issue?).  I don't see why UP vs SMP is an issue here at all, or why
the PIT gets involved in any way (and I don't mean that in a "I think
your design is idiotic" way, I mean that in a "I don't really understand
the problem domain, so I'm missing something in your explanations" way).

    J
