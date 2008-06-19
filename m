Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbYFSDgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbYFSDgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 23:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYFSDgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:36:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43610 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbYFSDf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:35:59 -0400
Date: Thu, 19 Jun 2008 09:15:23 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>,
       <greg@kroah.com>, <varunc@linux.vnet.ibm.com>,
       <jbarnes@virtuousgeek.org>
Subject: Re: Strange problem with e1000 driver - ping packet loss
Message-ID: <20080619034523.GB3548@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20080618125215.GC3988@linux.vnet.ibm.com> <36D9DB17C6DE9E40B059440DB8D95F52056F2AC0@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F52056F2AC0@orsmsx418.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 12:18:30PM -0700, Brandeburg, Jesse wrote:
> > # cat /proc/interrupts
> >  10:       2296    XT-PIC-XT        ata_piix, eth0, eth1
> 
> whats wrong with your system that you can't use acpi and/or apic? It
> would probably orthoginally solve the problem by unsharing your
> interrupt.

Nothing wrong with acpi/apic. It just wasnt helping solve the problem.
I booted with noapic to check if it helps resolve, but found 
it didnt.  

> > IRQ10 is thus being shared by both the hard disk and eth0/eth1.
> 
> bad for performance but should really work okay.

Is there a way we can force unsharing of the IRQ (between harddisk and
eth1) in software?

> > Here's the strange observation I made:
> > 
> > When I initiate some disk activity (ex: dd if=/dev/zero
> > ...
> 
> > This meant that e1000 NIC is having trouble interrupting the OS.
> 
> you're correct here, there appears to be some problem on your system
> either with interrupt delivery

Note that other interrupts (timer, hard disk) are fine. Even eth1 interrupt 
"works", just that it comes lazily (once in few seconds - when I am pumping 
potentially hundreds of ping packets to it every second). 

	# watch "grep 10: /proc/interrupts"

shows the interrupt count associated with eth1 increment at the rate of
1-2 every 2-3 seconds (<1 interrupt per second). 

Is there some interrupt-related statistics that we can obtain from e1000
card which shows how many times e1000 NIC tried "interrupting" the system?

> or with the driver masking off interrupts and leaving them disabled.

Hmm ..shouldnt that affect ata disk functionality too? hard disk I/O
works fine when ping performance is bad.

> > Before I could jump up and say this is a hardware issue, I was told
> > that Windows works just fine on the server (and as well as 2.4 kernel,
> > which I couldnt verify) :(
> 
> well it might be a bios issue,

Again, if it was a bios issue, the question i am faced with is "how is
Windows working fine on it?".

> but would likely be solved by using boot
> option acpi=force and/or lapci (see kernel-parameters.txt

I had tried these other boot options in vain: noapic, acpi=off, acpi=noirq, pci=noacpi
If you recommend any other boot option, we'd be glad to try it out.

> > Some more observations:
> > 
> > 1. I tried setting e1000 parameters (RxIntDelay=0, RxAbsIntDelay=0,
> >    TxIntDelay=0, TxAbsIntDelay=0, InterruptThrottleRate=0). None of
> >    them helped.
> 
> these won't help you get an interrupt delivered or re-enabled

ok.

> > 2. When ping performance was poor, readprofile showed that system
> >    is mostly idle. This confirms that OS is not getting very
> >    frequenty interrupts from eth1 and hence idling.
> 
> expected, thanks for checking.
> 
> > 3. When ping performance was poor, ethtool -S eth1 showed that
> >    rx_bytes was incrementing at a good pace, showing that the
> >    NIC was receiving ping responses back, but not handing them over
> >    to OS for further processing
> 
> also expected for an interrupt problem.
>  
> > 4. e1000 chipset is 82546GB
> > 
> > 5. e1000e driver didnt work at all (it doesnt recognize the cards).
> 
> expected, this is a PCI-X adapter.
>  
> 
> > Any advice on how to fix this problem?
> 
> try the boot options first, then if that doesn't work for you, download
> ethregs from e1000.sourceforge.net download area and compile/run it and
> send me the output in private email.

sure ..i will send you them after sometime.

> if you have a spare moment, you can try the e1000-8.X driver from
> sourceforge and let me know if it works okay, that would imply we just
> need to patch the in-kernel driver to fix an already known issue.

ok, we will test that out as well.

Thanks for all your inputs!

-- 
Regards,
vatsa
