Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYFREH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYFREH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 00:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYFREHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 00:07:13 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63787 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbYFREHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 00:07:11 -0400
Date: Wed, 18 Jun 2008 05:02:48 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806180053.40044.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
 <Pine.LNX.4.55.0806172206580.28110@cliff.in.clinika.pl> <200806172338.38318.rjw@sisk.pl>
 <200806180053.40044.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Rafael J. Wysocki wrote:

> Here you go.  Below is the relevant snippet from the yesterday's linux-next
> dmesg with the patches:
> "x86: I/O APIC: timer through 8259A second-chance"
> "x86: add C1E aware idle function"
> reverted and the appended debug patch applied.
> 
> [    0.108006] TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.108006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.108006] ...trying to set up timer (IRQ0) through the 8259A ... <2> failed
> [    0.108006] ...trying to set up timer as Virtual Wire IRQ...<2> works.
> 
> The entire dmesg is at: http://www.sisk.pl/kernel/debug/20080616/dmesg-4.log

 Thanks -- this is very important and useful information as it shows the
exact alternative used.

 With such a configuration the "x86: I/O APIC: timer through 8259A
second-chance" patch should not matter, because the only change it
introduces is an attempt to try the same I/O APIC pin again, but with the
IRQ0 line of the master 8259A enabled.  That's not a terribly unusual 
configuration and nothing should get confused in the system.

 Barring the unlikely possibility of the 8259A actually being wired to 
INTIN2 of the I/O APIC I can see two possible explanations:

1. The 8259A interrupt actually escapes to the CPU somehow and is handled
   as an ExtINTA interrupt.  This would make the code in check_timer()  
   decide it has found a working configuration, while actually it has been
   fooled.

2. There is a bug in this patch or an assumption it makes which results 
   in the state of some component not to be restored correctly.  
   Unfortunately I have no resources to test the 64-bit variation of the 
   code, so something may have escaped my attention.

 I'd like to find out which one is the case -- can you please reapply the
patch and send me the corresponding section of the bootstrap log?  If the
system hangs before you can retrieve the log, please just place:

while (1);

or something like that after the out: label in check_timer().

 Thanks.

  Maciej
