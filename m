Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYFRWk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYFRWk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYFRWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:40:15 -0400
Received: from [213.77.9.205] ([213.77.9.205]:63877 "EHLO serum.com.pl"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753517AbYFRWkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:40:13 -0400
Date: Wed, 18 Jun 2008 23:36:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080618190603.GB10431@cvg>
Message-ID: <Pine.LNX.4.55.0806182308190.7802@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
 <Pine.LNX.4.55.0806172206580.28110@cliff.in.clinika.pl> <200806172338.38318.rjw@sisk.pl>
 <200806180053.40044.rjw@sisk.pl> <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl>
 <20080618190603.GB10431@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008, Cyrill Gorcunov wrote:

> | 1. The 8259A interrupt actually escapes to the CPU somehow and is handled
> |    as an ExtINTA interrupt.  This would make the code in check_timer()  
> |    decide it has found a working configuration, while actually it has been
> |    fooled.
> 
> Maciej, that is why we get 'received illegal vector'?
> 
> 	[  129.092151] APIC error on CPU1: 00(40)

 No, but that's an interesting observation, thank you -- well spotted!  

 ExtINTA stands for an "External INTA cycle" which is passed through from
the CPU down to the system bus instead of being intercepted by the local
APIC unit as usually.  In response to the INTA cycle one of the 8259A
chips (either the master or the slave, depending on the source of the
interrupt selected for handling) supplies the vector directly to the CPU
through PCI (or whatever kind of bus links the legacy bridge with the host
bridge) and then the FSB.  Therefore the vector bypasses all the APIC
circuitry and cannot result in an APIC error interrupt.

 Instead the message quoted means an APIC input is misprogrammed
somewhere.  This error happens if an interrupt is signalled to an unmasked
APIC input which uses the Fixed or Lowest-Priority delivery mode and its
vector implies priority below the minimum permitted, that is in the range
from 0 to 15.

 We have code already in place in io_apic_{32,64}.c that can be used to
find out the offender with a piece of code like this (#if 0 has to be
deactivated for this to work and they may be bit rot bugs to be fixed):

int __init all_pic_dump(void)
{
	int v = apic_verbosity;

	apic_verbosity = APIC_DEBUG;
	print_IO_APIC();
	print_all_local_APICs();
	print_PIC();
	apic_verbosity = v;

	return 0;
}

late_initcall(all_pic_dump);

if somebody is willing to aid with debugging this problem.

  Maciej
