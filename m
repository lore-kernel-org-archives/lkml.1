Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbXFBV3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbXFBV3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXFBV3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:29:33 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756949AbXFBV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:29:32 -0400
Date: Sat, 2 Jun 2007 14:28:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tear <tarrqt@yahoo.com>
cc: mingo@redhat.com, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
In-Reply-To: <105227.2990.qm@web63604.mail.re1.yahoo.com>
Message-ID: <alpine.LFD.0.98.0706021400330.23741@woody.linux-foundation.org>
References: <105227.2990.qm@web63604.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jun 2007, Tear wrote:
> 
> I have tested my system with different kernel command lines
> and have ruled out all of the four possibilities. Here's a
> matrix which summarizes the situtation. My USB-enabled
> digital camera's data transfer rate is as follows:

That's not the interesting part.

There's no way the IO-APIC itself "cant' work". That's a normal Intel 
IO-APIC, it's fine. There's somethign else that causes things to not work, 
properly, and the question is why.

So the APIC choice triggers some other bug that then ACPI fixes up.

>From the dmesg between "acpi=ht" and "acpi-force", the prime candidates 
would seem to be:

   ENABLING IO-APIC IRQs
  -...TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0	 # slow
  +...TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1 # fine

and

  -uhci_hcd 0000:00:1f.2: irq 19, io base 0x0000ff80	 # slow
  +uhci_hcd 0000:00:1f.2: irq 17, io base 0x0000ff80	 # fine

(Interestingly, your *other* USB controller at 0:1f.4 gets assigned irq 18 
in both cases).

Now, I doubt it's the timer, and the UHCI irq thing sounds more likely to 
be a problem anyway, since it's USB that's slow, so it would be 
interesting to hear whether:

	acpi=force pci=routeirq

is still slow (it should enable ACPI, but then force the interrupt routing 
to use the PIRQ table anyway). 

Also, if you can figure out which USB ports are on the _other_ controller 
(the one that gets irq 18 regardless of whether ACPI is on or off), it 
would also be interesting to hear whether the camera is always fast (or 
perhaps always slow) when connected to a part that is off that 
controller..

Finally, I wonder why that particular box is marked with an "acpi=ht" 
blacklisting in the first place. Rather than add a new blacklist, it migth 
be better to remove an old (and perhaps incorrect) one.

That blacklist entry is _ancient_. It's entirely possible that it's just 
bogus: we've had so many ACPI fixes since it was added, that it's quite 
possible that the blacklist entry itself is bogus, and is the result of 
some old ACPI bug that triggered on that entry.

The Dell GX240 entry was added by commit 68e4ad79294 in the historic Linux 
archive:

    Author: Len Brown <len.brown@intel.com>
    Date:   Sat Aug 9 15:00:59 2003 -0400

    ACPI from 2.4:
    build: add ACPI_HT, delete ACPI_HT_ONLY
    boot: add acpi={force, off, ht}; delete "noht", "acpismp="
    add DMI blacklist from UnitedLinux

and since it sounds like the machine _works_ with ACPI on, my real 
preference would be to just remove the black-list entry.

In fact, I thought that patch already existed in the -mm tree?

Len - do you have any archives back from 2003 and earlier to indicate why 
the Dell GX240 was blacklisted?

In fact, googling for this shows some other users saying that removing the 
blacklist entry fixes things:

	http://forums.fedoraforum.org/showthread.php?t=107291

and there is another report ("Lil_miss_linux") claiming that moving a USB 
cardreader from one USB plug to another just "fixed" the issue they had. 
So I'm doubly interested to hear whether maybe the camera works fine in 
another USB port (which I'd guess is the one presumably connected to 
irq18).

		Linus
