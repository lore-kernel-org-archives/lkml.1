Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYFTLwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYFTLwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYFTLwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:52:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54961 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbYFTLw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:52:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Fri, 20 Jun 2008 13:53:58 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806190225.51088.rjw@sisk.pl> <Pine.LNX.4.55.0806200024170.12929@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806200024170.12929@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201353.59083.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 of June 2008, Maciej W. Rozycki wrote:
> On Thu, 19 Jun 2008, Rafael J. Wysocki wrote:
> 
> > That helped a lot, the system seems to work normally now.
> > 
> > Here's the relevant snippet from dmesg:
> > 
> > [    0.108006] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> > [    0.108006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > [    0.108006] ...trying to set up timer (IRQ0) through the 8259A ... <3>
> > [    0.108006] ..... (found apic 0 pin 2) ...<3> failed.
> > [    0.108006] ...trying to set up timer as Virtual Wire IRQ...<3> works.
> > 
> > and the whole thing is at: http://www.sisk.pl/kernel/debug/20080618/dmesg-2.log
> 
>  Hmm, that only proved the 8259A is indeed wired to the pin #2 of the I/O 
> APIC.
> 
> > I, personally, don't have any and AMD only has SB600 documentation on its
> > web page (it's still marked as "AMD confidential" ;-)).
> 
>  Well, the IC block is most likely the same as that's not rocket science
> and once done there is no need to fiddle with that.  That written, I am
> afraid there is nothing useful about the IC in the document, except that
> it's there and consists of an I/O APIC providing 24 inputs and the usual
> pair of 8259A cores.  Thanks for the reference anyway.
> 
> > There is an interrupt controller in there, but I'm not sure if there's any
> > 8259A.  The northbridge is on the CPU, actually.
> 
>  I will praise the day someone ships an x86 machine without an 8259A core!
> 
>  As expressed in another mail I suspect there may actually be a direct
> route from the 8254 to INTIN0 in the southbridge -- this is what other
> bootstrap logs seen in the Internet suggest.  This would mean this
> particular BIOS is buggy (is it the latest version?) and provides an
> incorrect IRQ override in its ACPI tables, for example because the
> responsible block has been blindly copied from a machine using a commoner
> wiring.  This could be moderately easily fixed up with a quirk based on
> the PCI ID (after checking it again, we actually used to have a quirk for
> ATI in this area, but the way it was done suggests the issue was not
> understood well enough).
> 
>  Could you please remove the hack sent yesterday and test the patch
> provided below?  I do hope it builds, but I have no immediate means to
> check it.  Please report the output.  The intent is to test INTIN0
> directly before testing INTIN2 through the 8259A.  Thanks.

Tested, doesn't work.  The symptoms are exactly the same as with the unpatched
kernel.

This is the relevant snippet from dmesg:

[    0.108006] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.108006] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.108006] ...trying to set up timer (IRQ0) through the 8259A ... <3>
[    0.108006] ..... (found apic 0 pin 2) ...<3> works.

and the whole thing is at: http://www.sisk.pl/kernel/debug/20080620/dmesg-1.log

>  Aside of that, what I have gathered from your reports (please correct me
> if I have got it wrong) is that when the through-8259A mode is used, then
> after a while 8254 timer interrupts stop arriving.

What exactly I observe is that in this case:
1) The cooling fan is 100% on, as though the box were overheating, which seems
   to indicate some serious confusion of the platform (the mechanism turning
   the fan 100% on is supposed to be transparent to software).
2) Everything seems to slow down substantially, at least as soon as X is
   started.
3) The box cannot reboot, ie. it turns everything off as expected, but when the
   BIOS is supposed to restart the box, it just hangs solid.

> What's interesting, the "Virtual Wire IRQ" seems to work for you correctly
> (that's quite an odd setup where a local APIC input is used in the native
> mode -- please post /proc/interrupts for confirmation),

           CPU0       CPU1       
  0:        885      37234   IO-APIC-edge      timer
  1:          1        250   IO-APIC-edge      i8042
  8:          0          0   IO-APIC-edge      rtc0
 12:          4        148   IO-APIC-edge      i8042
 14:        568         52   IO-APIC-edge      ide0
 15:          0          0   IO-APIC-edge      ide1
 16:       5048       4555   IO-APIC-fasteoi   sata_sil, HDA Intel
 18:         45        110   IO-APIC-fasteoi   b43
 19:      11811      11973   IO-APIC-fasteoi   ohci_hcd:usb1, ohci_hcd:usb2, ehci_hcd:usb3
 20:          0          4   IO-APIC-fasteoi   yenta, tifm_7xx1, ohci1394
 21:      11695       1987   IO-APIC-fasteoi   acpi
 23:        883        115   IO-APIC-fasteoi   eth0
NMI:          0          0   Non-maskable interrupts
LOC:      36636        585   Local timer interrupts
RES:       7982       4590   Rescheduling interrupts
CAL:        260         75   function call interrupts
TLB:        207        146   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          1

(also available at: http://www.sisk.pl/kernel/debug/20080620/interrupts-1.txt).

> which in turn implies the master 8259A drives its INT output as we expect.
> Why would the I/O APIC input have problems then?  Hmm...

Because it's wired to something we're not aware of?

Thanks,
Rafael
