Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbYFTTAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbYFTTAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYFTS7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:59:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:55801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYFTS7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pXX/uk2AfK0VosZDhEq9aw8uXlW6vlM7dW5WiqIb7EiaoHRxthTCMk2Xb4dkd4QDF+
         hnbqb+2nFZr2suqpA74Y/QlB3nIFGouUMBQuI5nBmVAp6JfuayZUzcVH8QpL3b0YofnS
         lBtd8RU99jVZRnSrY0al3CL0zlQuHEHWjUHK8=
Date: Fri, 20 Jun 2008 22:59:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080620185927.GA11597@cvg>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <Pine.LNX.4.55.0806172206580.28110@cliff.in.clinika.pl> <200806172338.38318.rjw@sisk.pl> <200806180053.40044.rjw@sisk.pl> <Pine.LNX.4.55.0806180400070.28110@cliff.in.clinika.pl> <20080618190603.GB10431@cvg> <Pine.LNX.4.55.0806182308190.7802@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0806182308190.7802@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, Jun 18, 2008 at 11:36:16PM +0100]
| On Wed, 18 Jun 2008, Cyrill Gorcunov wrote:
| 
| > | 1. The 8259A interrupt actually escapes to the CPU somehow and is handled
| > |    as an ExtINTA interrupt.  This would make the code in check_timer()  
| > |    decide it has found a working configuration, while actually it has been
| > |    fooled.
| > 
| > Maciej, that is why we get 'received illegal vector'?
| > 
| > 	[  129.092151] APIC error on CPU1: 00(40)
| 
|  No, but that's an interesting observation, thank you -- well spotted!  
| 
|  ExtINTA stands for an "External INTA cycle" which is passed through from
| the CPU down to the system bus instead of being intercepted by the local
| APIC unit as usually.  In response to the INTA cycle one of the 8259A
| chips (either the master or the slave, depending on the source of the
| interrupt selected for handling) supplies the vector directly to the CPU
| through PCI (or whatever kind of bus links the legacy bridge with the host
| bridge) and then the FSB.  Therefore the vector bypasses all the APIC
| circuitry and cannot result in an APIC error interrupt.
| 
|  Instead the message quoted means an APIC input is misprogrammed
| somewhere.  This error happens if an interrupt is signalled to an unmasked
| APIC input which uses the Fixed or Lowest-Priority delivery mode and its
| vector implies priority below the minimum permitted, that is in the range
| from 0 to 15.
| 
|  We have code already in place in io_apic_{32,64}.c that can be used to
| find out the offender with a piece of code like this (#if 0 has to be
| deactivated for this to work and they may be bit rot bugs to be fixed):
| 
| int __init all_pic_dump(void)
| {
| 	int v = apic_verbosity;
| 
| 	apic_verbosity = APIC_DEBUG;
| 	print_IO_APIC();
| 	print_all_local_APICs();
| 	print_PIC();
| 	apic_verbosity = v;
| 
| 	return 0;
| }
| 
| late_initcall(all_pic_dump);
| 
| if somebody is willing to aid with debugging this problem.
| 
|   Maciej
| 

Thanks, Maciej,

i would really like to help... but I can't even hit this
bug on my laptop :(

		- Cyrill -
