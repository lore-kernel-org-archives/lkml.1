Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYJFSVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYJFSVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 14:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbYJFSVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 14:21:23 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:33814 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYJFSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 14:21:22 -0400
X-Greylist: delayed 1795 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 14:21:21 EDT
Date: Mon, 6 Oct 2008 18:51:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
 (Re: 2.6.27-rc8+ - first impressions)
In-Reply-To: <20081006150055.GA16930@elte.hu>
Message-ID: <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org>
References: <20081005183603.GA3263@amd.corenet.prv> <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Ingo Molnar wrote:

> i think it was caused by this stream of IO-APIC changes:
> 
>  49a66a0: x86: I/O APIC: Always report how the timer has been set up
>  17c4469: x86: I/O APIC: Include <asm/i8259.h> required by some code
>  593f4a7: x86: APIC: remove apic_write_around(); use alternatives
>  ce8b06b: x86: I/O APIC: remove an IRQ2-mask hack
>  af17478: x86: I/O APIC: Never configure IRQ2
>  c88ac1d: x86: L-APIC: Always fully configure IRQ0
>  1baea6e: x86: L-APIC: Set IRQ0 as edge-triggered
> 
> Rafael/Maciej, which of these is causing it? ce8b06b ("x86: I/O APIC: 
> remove an IRQ2-mask hack")?

 None of the above.  This:

691874f: x86: I/O APIC: timer through 8259A second-chance

This change has fixed a problem with the timer for a lot of systems and 
permitted the removal of a bunch of horrible hacks we used to have in our 
I/O-APIC/timer code, including a command-line override parameter, needed 
so that some systems would boot at all.

 This single instance of a piece of some HP gear being twisted beyond 
belief is IMO a minor annoyance and price to pay compared to the gain.  
Please note that apart from the DSDT being buggy on this machine, it has 
an incorrect IRQ 0 override in the ACPI table pointing to the pin #2 of 
the I/O APIC, which is in fact routed to the output of the master 8259A.  
Additionally the pin #0 of the I/O APIC which is indeed routed to the 
output of the 8254 does not receive any interrupts, presumably because of 
some misconfiguration during BIOS initialisation.  So in fact this machine 
suffers from three configuration problems at once of which all add up to 
the end result we can observe.

> Current theory is that this specific flavor of BIOS on HP / AMD / Turion 
> laptops (no other type is known to be affected at the moment) somehow 
> detects the IO-APIC masking patterns and uses an SMI quirk to change the 
> ACPI thermal trip point to very low settings, and thus confusing cpufreq 
> to (correctly) go into a very slow frequency.

 It is not just theory.  I did actually analyse the AML code coming from 
the broken DSDT and found the responsible snippets.  See: 
http://lkml.org/lkml/2008/6/20/442 for a reference.  No SMI is involved 
here -- this is native ACPI operation -- Linux calls these snippets 
explicitly as required by the ACPI spec for various actions.

> Activating the quirk works this around. Should we perhaps default to 
> this 'quirk' enabled by default?

 It will break many if not most of the systems out there which have the 
PIT (rather than the master 8259A) wired to the pin #2 of the I/O APIC 
and correctly reported as such with an ACPI IRQ override.

  Maciej
