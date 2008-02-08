Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbYBHSYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbYBHSYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760287AbYBHSYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:24:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:54939 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760092AbYBHSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:24:20 -0500
Date: Fri, 8 Feb 2008 19:24:14 +0100 (CET)
From: Bernhard Kaindl <bk@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stoffel <john@stoffel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 arch updates for v2.6.25
In-Reply-To: <47A8A278.4020908@zytor.com>
Message-ID: <alpine.LNX.1.00.0802081900360.321@jbgna.fhfr.qr>
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <18344.41128.159384.144803@stoffel.org> <47A8A278.4020908@zytor.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, H. Peter Anvin wrote:
> John Stoffel wrote:
> > 
> > Linus> So I'd merge a patch that puts oops information (or the whole
> > Linus> console printout) in the Intel management stuff in a
> > Linus> heartbeat. 
> >
> > How about we put in some sort of console logging tool so we can buffer
> > and log the console output better?  Currently if I have both a serial
> > and tty console defined, my GDM prompter looses the mouse until I goto
> > the XDMCP chooser and back again.  
> > I'm pretty sure it's a GDM problem, since Xdm doesn't have this issue
> > at all.  Haven't had time to chase it though.
> > 
> > In any case, having some way to log oopses better would be really
> > nice.  Not sure how we could do it reliably for suspend/resume needs
> > on laptops without dedicated management hardware like the ILOM stuff
> > on Intel/Sun boxes.  
> 
> Hm.  Dumping oops information plus perhaps even a memory dump to a USB key
> sounds like it would be highly useful - lots of storage capacity, readily
> available, and can be plugged into just about any system.
> 
> I don't know if the backdoor debugging mode in EHCI can be used for that.
> Either way, this would have to be done *very* carefully to avoid clobbering
> USB devices not intended for this purpose.

If the machine can be hooked up over FireWire to another Linux box, you can
use the OHCI1394 controller's "physical DMA" feature to get lots if info:

What you need:

- An OHCI1394-compliant (nearly all are) FireWire port in the oopsing system
- A second Linux system (with other tools also other OS) with any FireWire port
- A FireWire cable which connects the two ports (there are two kinds of plugs)
- ftp://ftp.suse.de/private/bk/firewire/tools/firescope-0.2.2.tar.bz2

What you do:

1 - You boot both systems and connect them with the FireWire cable
2 - You initialize FireWire on both systems and ensure that 'physical DMA'
    is enabled in the OHCI1394-compliant FireWire controller of the oopsing
    machine.
3 - You transfer the System.map of the debugged kernel to the second system.

    - Everything after this point does not need the cooperation of the CPU
      of the debugged system, the PCI bus needs to be working and unlocked,
      but the CPU(s) of the debugged system can otherwise do anything or
      nothing at all anymore.

4 - You trigger the oops/crash/hang, but leave the debugged machine turned on.
5 - You install firescope (URL in the list above) on the second machine and
    run it for example with:

       firescope -A System.map-of-debugged-kernel

6) you press Ctrl-D (this is just one way to do it)

What you get are the contents of the printk buffer containing the messages
which the kernel logged into the in-memory printk buffer (such as oopses)
- directly from the other machine's RAM over remote DMA (which is called
  "physical DMA" in FireWire language)

Of course you can put firescope into "auto update mode" and just watch or
log the printk buffer as it gets messages on the remote system - in real time.

--------------------------------------------------------------------------

There is new code in mainline now to debug early boot issues:

If the oops/hang/crash happens early in boot, before the normal ohci1394 kernel
driver can initialize the OHCI1394-compatible controllers on the debugged
system, such as in the ACPI initialisation or so, you can employ my early
initialisation patch for OHCI1394 controllers to get remote access early:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f212ec4b7b4d84290f12c9c0416cdea283bf5f40

It has been committed into mainline (for 2.6.25) with the x86 merge on
January 30 and it contains more documentation on debugging over FireWire.

To to ensure everybody: The code is not compiled by default, and even if
compiled, it runs __only__ when a specific boot parameter is given on boot.

However, the initialization of the ohci1394 driver allows physical DMA to
all FireWire nodes unless it is loaded with phys_dma=0. See the PS of
this mail for more regarding security.

You can also use the new code on debugging suspend/resume from disk/ram:

To debug suspend:

1 - enable the early firewire patch as documentented in the patch
2 - have the second linux system set up and connected on boot already
3 - ensure that no OHIC1394 driver is ever loaded, as suspending as
    well as the driver unload would disable the OHCI1394 controller.
4 - suspend the machine to get the oops/hang/crash.

To debug resume from disk:

Nothing add to the above. The new code gets called when the boot kernel
initializes the machine hardware on resume, so you can get access.

To debug resume from ram:

Disable the __init{,data} flags in the patch and insert a call to

	init_ohci1394_dma_on_all_controllers()

early on resume, after the registers of PCI cards are accessible.

Testing and submitting that would be the next thing on my todo list for
debugging with firewire, but someone tries it, I'd be happy to hear how
it went (or to look at the resulting patch).

My plan would be to make that a config option which can be enabled when
needed to debug resume from ram with a new flag to the boot option which
the new init_ohci1394 commit added.

The documentation in the commit also includes a link to firedump, a tool
which can to pull the the contents of all PCI-accessible memory over
FireWire at high speed. But it does not parse the e820 map yet, so it
crashes the remote system hard if it ties to read from a memory hole.
below the 4GB limit over to the second machine - with the speed of your

Best Regards,
Bernhard Kaindl

PS:

Using gdb (and even kgdb) over firewire is possible:

For very advanced users, the documentation in the commit contains a link
to a gdb stub for firewire (named fireproxy currenty) which allows gdb to
access all data which can be referenced from symbols found by gdb using
a vmlinux file which is compiled with debug information.

With it, you can get symbolic kernel stack backtraces of the remote system
by using the gdb macros which were written for kdump.

The latest version of the gdb proxy (fireproxy-0.34) can communicate
with kgdb over a generic memory-communication module (kgdbom). This
implementation is just a proof-of-concept which can only excange a very
small amount of messages over physical DMA memory back and forth, which
means that it is not yet useable for real debbugging work.

Regarding security:

On the software side: The new fw-ohci driver seems to allow physical DMA only
to devices which pretend to be FireWire disks (it is the specified way to
transfer the data) unless a disk on a remote FireWire bus is being
plugged-in. That makes it a bit harder to use physical DMA, but not
impossible. Loading no FireWire driver is also possible, but you'd have
to check that your BIOS does not enable FireWire when your machine reboots
(for boot from FireWire).

With FireWire enabled by the BIOS, a hacker could (in theory) load his
own operating system into the system RAM and boot it by changing the
code which the boot loader executes while it is running to trick the
CPU to jump directy into the bootstrapping code of the loaded OS.

Loading the ochi1394 driver with phys_dma=0 would disable physical DMA.
It could mean that some FireWire drivers like sbp2 might not work, so
if the BIOS does not enable FireWire on boot, you should be safe from
the FireWire side with that.

To be really safe from such kind of system tapping, you have to prevent
physical access to your FireWire ports (and your mainboard, to exclude
debug cards): Filling hot glue into the FireFire ports makes it harder
to use them and a padlock on the system housing gives some resistance
to physical system intrusions, but there is always a big enough bolt
cutter to open it. How much you need depends on the threat you have.
