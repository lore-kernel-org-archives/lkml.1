Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYFDPyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYFDPyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYFDPxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:53:54 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64038 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754883AbYFDPxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:53:53 -0400
Date: Wed, 4 Jun 2008 16:52:39 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Stefan Assmann <sassmann@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <48467DA7.9030309@suse.de>
Message-ID: <Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de> <m1tzgauduu.fsf@frodo.ebiederm.org>
 <4846651F.4070802@suse.de> <m1ve0pqy06.fsf@frodo.ebiederm.org>
 <48467DA7.9030309@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Stefan Assmann wrote:

> You're right, that behavior is more appropriate for RT, where we see
> these boot interrupts because of the way interrupts are handled there.
> We're rewriting the patches to use a parameter like pci=ioapicreroute to
> trigger this only if the parameter is specified (for the mainstream
> kernel).

 Well, this is clear these chipsets are broken beyond imagination,
negating some 15 years of I/O APIC compatibility where masking an input in
its redirection table is expected not to have any side effects.  They
should have used a separate bit for the legacy INTx redirection.  That has
been fixed in hardware though and there is nothing we can do about it at
this stage.  Hire competent hardware designers the next time.

 However I do not feel adding a command line parameter for each of such
workarounds is the right way to do it.  We end up with an infinite number
of obscure options nobody or hardly anybody really understands.  We should
be removing them rather than adding new ones.

 What's the reasoning behind the option in this case?  As I understand 
there are two cases possible:

1. Secondary, etc. I/O APIC inputs are not masked under any circumstances.  
   No legacy INTx redirection happens, nothing to be done.

2. Secondary, etc. I/O APIC inputs are to be masked from time to time.  
   That would cause legacy INTx redirection for the affected chipsets in 
   situations where an interrupt arrives at a masked I/O APIC input.  This 
   interrupt is delivered to an input of the primary I/O APIC which cannot 
   be masked because of other devices wired to it.

   OK -- that means the interrupt is delivered anyway (and perhaps 
   discarded in the handler, but that does not matter here), so why to do
   the rerouting in the first place?  Because we could equally well keep 
   the original secondary, etc. I/O APIC input for the interrupt unmasked 
   (if an affected chipset is discovered) to the very same effect, yet 
   avoid all the hassle and unnecessary sharing.  It could be handled very 
   easily by selecting a different "interrupt controller" setup for the
   affected I/O APICs.

Either way I fail to see a reason not to this automatically -- I cannot
imagine a sane user to be able to decide whether to use the option or not
in this case.

 That's one.  Second -- I have had a look at the relevant chipset
documentation and I fail to see how INTx messages received over PCI
Express are actually converted to interrupt signals.  I gather they are
interpreted by the MCH and posted to the ICH "somehow".  What does that
"somehow" look like?  Does the MCH assert PIRQ lines of the ICH? -- but I
fail to see any available outputs in the MCH that could be used for this
purpose.  SERIRQ is obviously not used, because it is not implemented in
the MCH and PCI messages I am assuming are not used either as they are
edge-triggered and therefore preclude sharing and as such could be simply
masked out in the primary I/O APIC permanently.

 Knowing this could help understanding the problem better.

  Maciej
