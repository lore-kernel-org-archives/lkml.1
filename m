Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYLDUEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYLDUEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYLDUEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:04:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbYLDUE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:04:29 -0500
Date: Thu, 4 Dec 2008 12:03:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812041900.27514.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0812041037250.3543@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812041229.45443.elendil@planet.nl> <alpine.LFD.2.00.0812040754020.3256@nehalem.linux-foundation.org> <200812041900.27514.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo, Len, can you check the end of the email about the apparent 
very-early interrupt issue? Can we get into acpi_ec_gpe_handler() without 
interrupts being enabled some way?

Greg, Jesse, can you think about and look at the USB PCI resume ordering?

On Thu, 4 Dec 2008, Frans Pop wrote:
> 
> Well, I had a failure rate of about 1 in 5-10 resumes originally.
> See: http://bugzilla.kernel.org/show_bug.cgi?id=11545

Ok, very interesting. Thanks for the pointer.

> Then I found the 2 workarounds and *with those in place* I got almost 100% 
> reliable resumes. Now I've removed those workarounds and with either the 
> revert or your oneliner I still get 100% success.
> From my PoV that is a very definite improvement: the machine now "feels" a 
> hell of a lot more reliable for critical use.

Sure. I'd love to apply the "transparency fix" (the last patch), but my 
main worry is that while it feels really right, and it fixes things for 
you and Rafael, these kinds of changes historically _always_ end up biting 
us. Because even if it's 100% the correct thing to do, it will show up 
some problem for somebody else just because we're really unlucky, and it 
just ends up exposing some totally unrelated bug.

Exactly the same way that this whole PCI resource setting thing was 100% 
correct in the first place, but exposed some other bug.

> So I _could_ reproduce it reliably given enough suspend/resume cycles.
> But I guess this does support your suspicion that it may be a timing 
> issue: if the timing happens to be right, the resume succeeds; if it's 
> wrong I get a dead box.

Yes.

> I did try that at the beginning. That's how I ended up removing e1000e 
> before suspend. See http://bugzilla.kernel.org/show_bug.cgi?id=11545.

What is interesting is that it's apparently not reliably that e1000e thing 
that is being resumed when it fails. You have another report there that 
says that it's a match on PNP0C0A.

Of course, the way that hash works, we only have a few bits to create it, 
and sometimes you just get false positives (there's not a whole lot you 
can reliably do with about 24 bits of information ;(

So it would be interesting to get a few more debug traces of that lockup.

HOWEVER. Having now looked through your fuller dmesg output even for the 
_successful_ case, I actually find a few things that are a bit worrying.

Looking at the unpatched dmesg, since that's the most interesting one 
(since it's the one that should hopefully show behaviour that is 
potentially triggering the problem), I see two worrying things:

	pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x83f18001)
	pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
	pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x228000f0, writing 0x22803030)
	pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100107)
	pci 0000:00:1e.0: setting latency timer to 64

That "offset 0x9/0x8/0x7" are the PCI bridge window prefetchable memory, 
non-prefetchable memory, and IO bases respectively (when it says '0x9', 
it's counting in quad-words, so it's really config space offset 0x24L 
PCI_PREF_MEMORY_BASE).

Now, that really means:
 - 0x9 prefetchable window: was disabled, is now 0x80000000-0x83ffffff
 - 0x8 nonprefetch window: was disabled, is now  0xe0100000-0xe03fffff
 - 0x7 IO window: was disabled, is noe 0x3000-0x3fff

That all looks correct, BUT the IO base reprogramming actually worries me. 
It's correct only because it's a 16-bit range. For a 32-bit range (which 
is not supported on an x86 platform, since IO ports are always just 16 
bits), the ordering would be very different, and we'd have to make sure 
that we write the upper bits in a special order to avoid problems.

With the "revert fix", the sequence is essentially the same, just 
different values:

	pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
	pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
	pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x228000f0, writing 0x22803030)
	pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100107)
	pci 0000:00:1e.0: setting latency timer to 64

the difference is that we now disable the prefetchable window (since we 
never allocated it), we just disable it with a different value than the 
one the BIOS used (0x10001 _could_ be imagined to mean "bridge the range 
0x00000000-0x0000ffff, while the kernel disables the IO region by setting 
the lower range higher than the high range, which is why you see those 
fff's there).

But the "revert fix" still has the IO range restore. It's still correct in 
this case (no 32-bit IO bits set), but still has the 32-bit range worry 
for non-x86.

With the "fix transparent bridges", the sequence is different:

	pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
	pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe030e010)
	pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100007, writing 0x100107)
	pci 0000:00:1e.0: setting latency timer to 64

ie now we don't even touch the IO window, since we agree with the BIOS on 
how to disable it (ie the kernel also disables it by writing 0x00f0 to the 
low 16 bits).

Anyway, the bridge reprogramming itself all looks correct, and the only 
worry really is that I'm not sure our PCI resume code really stricly 
speaking does the right thing for 32-bit IO resources for other non-x86
architectures.

The "transparent bridge" fix results in the simplest resume sequence for 
that bridge, but the "revert" fix really makes almost no difference at 
all, and again should not matter in the _least_ from a resume standpoint!

So there is a _small_ worry there, but it's not relevant for PC platforms, 
and in no case does it look like the programming of the transparent bridge 
should matter in any way what-so-ever for the resume code.

In many ways the bigger worry is actually in the totally unrelated USB 
UHCI and EHCI drivers that resume _before_ the bridge does:

	uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
	uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
	uhci_hcd 0000:00:1d.2: setting latency timer to 64
	uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
	uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
	usb usb7: root hub lost power or was reset
	ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
	ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
	ehci_hcd 0000:00:1d.7: setting latency timer to 64
	ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10a)
	ehci_hcd 0000:00:1d.7: restoring config space at offset 0x4 (was 0x0, writing 0xe0648000)

and the worry I have here is that we actually enable the device _before_ 
we've restored the BAR information. That sounds very iffy. It sounds 
doubly iffy in the 'resume from hibernate' case, where we are going to 
have an already-set-up PCI bus and the config space values are going to 
all be live as we reprogram them.

That "restoring config space at offset 0x8" thing is where we restore 
the BAR (dword 0x8 = offset 0x20 = PCI_BASE_ADDRESS_4), and we're changing 
it from 0x1 to 0x2101, with the IO BAR enabled. In this case, the old 
value meant that the BAR started out disabled, but hibernate would have 
been different.

So I'd _much_ rather have seen the sequence have the BAR restore sequence 
be something like

	uhci_hcd 0000:00:1d.2: restoring config space at offset 0xf (was 0x300, writing 0x30b)
	uhci_hcd 0000:00:1d.2: restoring config space at offset 0x8 (was 0x1, writing 0x2101)
	uhci_hcd 0000:00:1d.2: enabling device (0000 -> 0001)
	uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
	uhci_hcd 0000:00:1d.2: setting latency timer to 64

instead. Possibly even with an explicit disable of the memory/IO/busmaster 
bits before the whole sequence.

That said, I don't think this is the cause of the problem either. For one 
thing, the USB resume happens after the e1000e resume, so since you've 
apparently seen it hang in the e1000e driver, the real problem must have 
occurred earlier. And e1000e is resumed not just before USB on your 
machine, but even before the PCI bridge is (since it's on the root bus).

For another, in your case, the BAR really was disabled, so there was 
nothing "live" going on here anyway.

The third thing that worries me is the _very_ early occurrence of

	ACPI: Waking up from system sleep state S3
	APIC error on CPU1: 00(40)
	ACPI: EC: non-query interrupt received, switching to interrupt mode

Now, that "APIC error" thing is worrisome. It's worrisome for multiple 
reasons:

 - errors are never good (0x40 means "received illegal vector", whatever 
   caused _that_)

 - more importantly, it seems to imply that interrupts are enabled on 
   CPU1, and they sure as hell shouldn't be enabled at this stage!

   Do we perhaps have a SMP resume bug where we resume the other CPU's 
   with interrupts enabled?

 - the "ACPI: EC: non-query interrupt received, switching to interrupt 
   mode" thing is from ACPI, and _also_ implies that interrupts are on. 

Why are interrupts enabled that early? I really don't like seeing 
interrupts enabled before we've even done the basic PCI resume. 

I'd really like to resume the other CPU's much later (last in the whole 
sequnce, long after we've set up devices), but the f'ing ACPI rules seem 
to be against that. And maybe some setup actually needs the CPU's alive to 
act as a bridge for IO (eg with HT or CSI).

And interrupts happening at random times could certainly cause 
"interesting" and timing-dependent resume problems. Hmm...

The problem with the whole interrupt issue is that it seems to have 
nothing what-so-ever to do with the programming of that bridge in any way, 
shape or form. The timing issues/problems it could introduce should be 
totally irrelevant to anything else.

> I'd be happy to run with unpatched kernels for a while and do some more 
> pm_traces, but only if someone is going to follow up and interpret the 
> results for me or provide suggestions for targeted additional debugging.

I don't really have any better patches to try right now. But as usual, 
from everything I can see, the actual bridge setup itself should be 
totally irrelevant to the problem you see. Which is really irritating, 
since the only patches we _do_ have that seem to matter are purely about 
that bridge resource that shouldn't matter at all!

			Linus
