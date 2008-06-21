Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYFUBu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYFUBu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 21:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYFUBup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 21:50:45 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64206 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751113AbYFUBuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 21:50:44 -0400
Date: Sat, 21 Jun 2008 02:49:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <200806201353.59083.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0806210210060.19614@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806190225.51088.rjw@sisk.pl>
 <Pine.LNX.4.55.0806200024170.12929@cliff.in.clinika.pl> <200806201353.59083.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Rafael J. Wysocki wrote:

> Tested, doesn't work.  The symptoms are exactly the same as with the unpatched
> kernel.

 Thanks.

> This is the relevant snippet from dmesg:
> 
> [    0.108006] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.108006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.108006] ...trying to set up timer (IRQ0) through the 8259A ... <3>
> [    0.108006] ..... (found apic 0 pin 2) ...<3> works.
> 
> and the whole thing is at: http://www.sisk.pl/kernel/debug/20080620/dmesg-1.log

 Hmm, it means INTIN0 is not connected to the output of the 8254.  Which
in turn means the input is either externally rewirable or internally
reconfigurable for the use with the 8254, or something else, or nothing at
all (although it seems a dumb idea not to wire the 8254 to the I/O APIC).  
It might be interesting to know whether the HPET #0 can be routed to
INTIN0 on this platform.

> What exactly I observe is that in this case:
> 1) The cooling fan is 100% on, as though the box were overheating, which seems
>    to indicate some serious confusion of the platform (the mechanism turning
>    the fan 100% on is supposed to be transparent to software).
> 2) Everything seems to slow down substantially, at least as soon as X is
>    started.
> 3) The box cannot reboot, ie. it turns everything off as expected, but when the
>    BIOS is supposed to restart the box, it just hangs solid.

 OK, as explained by Matthew and investigated by myself, it is not exactly 
a problem with the timer itself, but broken power-management 
configuration.

 This could explain the reboot thing too -- our shutdown code is meant to
revert all the APIC configuration back to the bootstrap default as yours
would not be the first BIOS that has problems with its reboot vector being
entered with the APIC infrastructure active.  But the bit that's written 
to the NVRAM may interact with the BIOS for example.

 OTOH, perhaps something has got broken on the way with the APIC code too
-- I have had a look and now we have two local APIC shutdown functions:
disable_local_APIC() and lapic_shutdown() with overlapping functionality,
plus the I/O APIC is cleared after the local APIC in at least one place,
so I would not feel terribly confident about this code.

> > What's interesting, the "Virtual Wire IRQ" seems to work for you correctly
> > (that's quite an odd setup where a local APIC input is used in the native
> > mode -- please post /proc/interrupts for confirmation),
> 
>            CPU0       CPU1       
>   0:        885      37234   IO-APIC-edge      timer
[...]
> (also available at: http://www.sisk.pl/kernel/debug/20080620/interrupts-1.txt).

 One for the other configuration, which reports "Virtual Wire IRQ", i.e.  
without my "x86: I/O APIC: timer through 8259A second-chance" patch, would
be more interesting, though perhaps less so now that the reason of the
misbehaviour is known.

> > which in turn implies the master 8259A drives its INT output as we expect.
> > Why would the I/O APIC input have problems then?  Hmm...
> 
> Because it's wired to something we're not aware of?

 Well, sure, but the question in such a case would be: "What for?"  The
output of the 8259A has had quite a standard meaning for some 30 years
now, so I would expect one would not wire it to anything else but the
interrupt input of a CPU or an APIC input without a purpose.  Or at least
a reason.

  Maciej
