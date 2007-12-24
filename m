Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbXLXQ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbXLXQ7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 11:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbXLXQ7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 11:59:35 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54310 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXLXQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 11:59:34 -0500
Date: Mon, 24 Dec 2007 10:59:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Bug 9528] x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4
 suspend-to-RAM
In-reply-to: <fa.n/XQFa64Zg8snHoyB/rrKzCvAL0@ifi.uio.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, bugme-daemon@bugzilla.kernel.org
Message-id: <476FE56E.6010500@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Tr7qmPdet0rF2FSRX/94s2UEMSE@ifi.uio.no>
 <fa.n/XQFa64Zg8snHoyB/rrKzCvAL0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 23 Dec 2007, Carlos Corbacho wrote:
>> Fix suspend-to-RAM on nForce 4 (CK804) boards by increasing
>> PCIBIOS_MIN_IO.
>>
>> Fixes kernel bugzilla #9528
>>
>> Problem:
>>
>> Linus' patch (52ade9b3b97fd3bea42842a056fe0786c28d0555) to re-order
>> suspend (and fix fall out from Rafael's earlier suspend reordering work)
>> broke suspend-to-RAM on nForce 4 (CK804) boards.
>>
>> Why:
>>
>> After debugging _PTS() in the DSDT, it turns out these nVidia boards are
>> trying to write to an IO port > 0x1000 (0x142E) during suspend. Before the
>> re-ordering, we got away with this.
> 
> Very interesting.
> 
> HOWEVER.
> 
> I'd much rather figure out what the magic IO resource is that clashes. 
> 
> It's almost certainly some hidden and undocumented (or badly documented) 
> ACPI IO area that the kernel doesn't know about, because it's not a 
> regular PCI BAR resource, but some northbridge (or southbridge) magic 
> register range.
> 
> Those ranges *should* be reserved by the BIOS in the ACPI tables, but this 
> would definitely not be the first time that doesn't happen.

I'm having trouble sorting out which report is for which BIOS (and some 
of them don't have any dmesg posted), but I believe in these cases that 
memory region is indeed reported as reserved by the BIOS, and no PCI 
resources should end up allocated there. So I'm not sure why fiddling 
with PCIBIOS_MIN_IO would have any effect (other than by accident).

I wonder if this is the culprit (from Arthur Erhardt's dmesg):

pnpacpi: exceeded the max number of mem resources: 12
pnpacpi: exceeded the max number of mem resources: 12

which means we're ignoring some of the memory reservations. I wonder if 
some IO reservations are also being ignored?

Why do we have this silly hard limit of number of resources anyway? If 
we just ignore random reservations provided by the BIOS, we shouldn't be 
surprised if things break randomly. This warning at the very least 
should be much louder (i.e. "Warning: This problem may break your system")..

> 
> But the right fix would be for us to just figure out what the range is ass 
> a PCI quirk, and just know to avoid it on purpose, ratehr than just being 
> lucky and happen to avoid it because PCIBIOS_MIN_IO just happens to be 
> bigger than the particular address.
> 
> So can you:
>  - show what your /proc/ioports contains (*with* the bug triggering, ie 
>    non-working suspend, so we see what it is that actually ends up using 
>    that area)
>  - send out 'dmesg' for a boot (same deal)
>  - add "lspci -xxxvv" output to the deal too.
> 
> and also make them part of the bugzilla history (I'm cc'ing bugzilla here, 
> and added the bug number to the subject, so hopefully this thread ends up 
> being archived there too).
> 
>> There was some previous work in the PCIBIOS_MIN_IO area over two years ago
>> (71db63acff69618b3d9d3114bd061938150e146b) which bumped this to 0x4000,
>> but this was reverted (2ba84684e8cf6f980e4e95a2300f53a505eb794e) after
>> causing new and entirely different problems on another nForce board.
> 
> The problem here is classic: these magic ranges tend to be *different* on 
> different boards (because they don't tend to be fixed by hardware, they 
> are programmed regions set up by firmware), so trying to change 
> PCIBIOS_MIN_IO to avoid a problem on one board is almost certain to just 
> introduce it on another board instead.
> 
> On *your* particular board, 0x142E is used for something, but on somebody 
> elses board it might be 0x162E, and now changing PCIBIOS_MIN_IO to 0x1500 
> might make that other board hang instead.
> 
> So you seem to have debugged this very successfully, and I'm wondering if 
> you might be able to find out where that 0x142e comes from, and we could 
> fix it for *all* boards using that chipset by just figuring out what the 
> *hardware* rules (rather than the random firmware setup that will be 
> different on different boards) for that chipset actually are!

I suspect it's board specific. Looking at the DSDT for my A8N-SLI 
Deluxe, that SMIP region is defined at 0x442E (and is reported as 
reserved). This BIOS doesn't write there in the _PTS method like the 
ones in the report apparently do though.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

