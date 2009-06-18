Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbZFRWyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbZFRWyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZFRWym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:54:42 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:52291 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZFRWyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:54:41 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 18:54:41 EDT
Date: Thu, 18 Jun 2009 23:51:19 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
In-Reply-To: <4A3A9220.4070807@goop.org>
Message-ID: <alpine.LFD.2.00.0906182257190.17556@eddie.linux-mips.org>
References: <4A329CF8.4050502@goop.org> <alpine.LFD.2.00.0906181206190.4213@localhost.localdomain> <4A3A9220.4070807@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009, Jeremy Fitzhardinge wrote:

> Perhaps I should have expressed that a bit more clearly:  you could, if
> mad, build a machine with I/O APICs and some other mechanism for
> delivering the interrupts to CPUs.  In practice, I doubt anyone ever
> has, or ever would.

 And people have done that (not for the x86 though) -- any machine with an 
HT bus will have I/O APIC interrupts as this is how the interconnect 
carries over interrupt messages from devices.  The root HT bridge forwards 
these messages to the local APIC -- this is similar to how MSI messages 
work; in fact if the upstream HT bridge was not a root bridge, but a 
PCI-HT bridge instead, then this is how these interrupt messages would 
have to be forwarded to the root PCI bridge.

 Now with a non-x86 machine there is not necessarily a real local APIC 
component -- this is the case for example with the Broadcom BCM1250A SOC 
based around a pair of MIPS64 processor cores.  Still this chip has to 
provide some logic to map HT interrupt messages to native interrupts and 
it is there, providing means for routing messages to the correct CPUs 
based on the destination and the destination mode and for the delivery 
mode and the vector (if applicable) to select the correct native interrupt 
source.  ExtINTA and EOI cycles have to be performed by software 
explicitly though, by poking at the right MMIO addresses which are not 
associated with the HT interrupt reception logic.  Not exactly an 
x86-style local APIC, but still an analogue.

 Just for the record.  I wholeheartedly agree with Eric pretending there 
is no local APIC and fiddling with our fragile code which assumes 
otherwise is not the best thing to do.  The Broadcom platform mentioned 
does not reuse any piece of our x86 APIC code.

  Maciej
