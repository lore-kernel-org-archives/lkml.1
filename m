Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbXLWR4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbXLWR4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 12:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756005AbXLWR4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 12:56:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbXLWR4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 12:56:17 -0500
Date: Sun, 23 Dec 2007 09:53:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 9528] x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce
 4 suspend-to-RAM
In-Reply-To: <200712231419.40207.carlos@strangeworlds.co.uk>
Message-ID: <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Carlos Corbacho wrote:
>
> Fix suspend-to-RAM on nForce 4 (CK804) boards by increasing
> PCIBIOS_MIN_IO.
> 
> Fixes kernel bugzilla #9528
> 
> Problem:
> 
> Linus' patch (52ade9b3b97fd3bea42842a056fe0786c28d0555) to re-order
> suspend (and fix fall out from Rafael's earlier suspend reordering work)
> broke suspend-to-RAM on nForce 4 (CK804) boards.
> 
> Why:
> 
> After debugging _PTS() in the DSDT, it turns out these nVidia boards are
> trying to write to an IO port > 0x1000 (0x142E) during suspend. Before the
> re-ordering, we got away with this.

Very interesting.

HOWEVER.

I'd much rather figure out what the magic IO resource is that clashes. 

It's almost certainly some hidden and undocumented (or badly documented) 
ACPI IO area that the kernel doesn't know about, because it's not a 
regular PCI BAR resource, but some northbridge (or southbridge) magic 
register range.

Those ranges *should* be reserved by the BIOS in the ACPI tables, but this 
would definitely not be the first time that doesn't happen.

But the right fix would be for us to just figure out what the range is ass 
a PCI quirk, and just know to avoid it on purpose, ratehr than just being 
lucky and happen to avoid it because PCIBIOS_MIN_IO just happens to be 
bigger than the particular address.

So can you:
 - show what your /proc/ioports contains (*with* the bug triggering, ie 
   non-working suspend, so we see what it is that actually ends up using 
   that area)
 - send out 'dmesg' for a boot (same deal)
 - add "lspci -xxxvv" output to the deal too.

and also make them part of the bugzilla history (I'm cc'ing bugzilla here, 
and added the bug number to the subject, so hopefully this thread ends up 
being archived there too).

> There was some previous work in the PCIBIOS_MIN_IO area over two years ago
> (71db63acff69618b3d9d3114bd061938150e146b) which bumped this to 0x4000,
> but this was reverted (2ba84684e8cf6f980e4e95a2300f53a505eb794e) after
> causing new and entirely different problems on another nForce board.

The problem here is classic: these magic ranges tend to be *different* on 
different boards (because they don't tend to be fixed by hardware, they 
are programmed regions set up by firmware), so trying to change 
PCIBIOS_MIN_IO to avoid a problem on one board is almost certain to just 
introduce it on another board instead.

On *your* particular board, 0x142E is used for something, but on somebody 
elses board it might be 0x162E, and now changing PCIBIOS_MIN_IO to 0x1500 
might make that other board hang instead.

So you seem to have debugged this very successfully, and I'm wondering if 
you might be able to find out where that 0x142e comes from, and we could 
fix it for *all* boards using that chipset by just figuring out what the 
*hardware* rules (rather than the random firmware setup that will be 
different on different boards) for that chipset actually are!

For an example of what I mean, see the file "drivers/pci/quirks.c", and 
check out the quirks for various chipsets:

 - quirk_ali7101_acpi()

   Knows about the magic ALI ACPI and SMB OI regions

 - quirk_piix4_acpi(), quirk_ich6_lpc_acpi(), quirk_ich4_lpc_acpi()

   Same thing for the Intel chipsets

 - quirk_vt82c586_acpi(), quirk_vt82c686_acpi()

   VIA chipsets

etc etc.

It would be *wonderful* if somebody could figure out what the equivalent 
quirks for nVidia chipsets are! Because otherwise we'll just end up 
bouncing back and forth between different random IO allocations, and they 
are all almost guaranteed to cause the same problems, just on different 
boards!

It's sometimes possible to even just guess what the registers are, even if 
things are undocumented. In particular, that 142E range is almost 
certainly programmed into the host bridge or possibly a "LPC controller" 
or similar, and it will probably show up as the bytes "20 14" in the 
output from lspci, so we can guess which register it is that sets the 
base. That's not *always* how it works, but it's sometimes possible to 
guess (although you usually need to see a few different cases of the same 
chipset to have any kind of confirmation of the guess).

		Linus
