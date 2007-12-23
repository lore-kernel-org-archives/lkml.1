Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXLWUnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXLWUnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 15:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXLWUnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 15:43:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:20445 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbXLWUnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 15:43:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ehmbFOj56dI9rSPyN4FnMOdSlnxLN3t53CvlolbKuYn7avyZbDKaYU9Us51nuLm/9IrEvFwuNnHc5/S5ASWtypm7G36+kM45j7UXGpnoO3G53vB0grt6I5FeWJUV3G3WFlNPVJrL+xdd/mbYb/HctMIIGqn6w0RMeiW3ACfSAZA=
Message-ID: <86802c440712231243oc9cbd4ft73810d7f77590d9f@mail.gmail.com>
Date: Sun, 23 Dec 2007 12:43:01 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [Bug 9528] x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Cc: "Carlos Corbacho" <carlos@strangeworlds.co.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Greg KH" <gregkh@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Len Brown" <lenb@kernel.org>, bugme-daemon@bugzilla.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200712231419.40207.carlos@strangeworlds.co.uk>
	 <alpine.LFD.0.9999.0712230933570.21557@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 23, 2007 9:53 AM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Sun, 23 Dec 2007, Carlos Corbacho wrote:
> >
> > Fix suspend-to-RAM on nForce 4 (CK804) boards by increasing
> > PCIBIOS_MIN_IO.
> >
> > Fixes kernel bugzilla #9528
> >
> > Problem:
> >
> > Linus' patch (52ade9b3b97fd3bea42842a056fe0786c28d0555) to re-order
> > suspend (and fix fall out from Rafael's earlier suspend reordering work)
> > broke suspend-to-RAM on nForce 4 (CK804) boards.
> >
> > Why:
> >
> > After debugging _PTS() in the DSDT, it turns out these nVidia boards are
> > trying to write to an IO port > 0x1000 (0x142E) during suspend. Before the
> > re-ordering, we got away with this.
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
it looks like BIOS doesn't assign io port in bus 0. ( for PMU? or some 00:01.1)
and kernel try to assign value to it according to PCIBIOS_MIN_IO.

sometime some systems could have several HT chains.
bus: [00,08] on node 0 link 1
bus: 00 index 0 io port: [5000, dfff]
bus: 00 index 1 io port: [e000, efff]
bus: 00 index 2 io port: [0, fff]
bus: 00 index 3 mmio: [de000000, dfffffff]
bus: 00 index 4 mmio: [e0000000, e7ffffff]
bus: 00 index 5 mmio: [a0000, bffff]
bus: 00 index 6 mmio: [f0000000, ffffffff]
bus: [80,86] on node 1 link 2
bus: 80 index 0 io port: [1000, 4fff]
bus: 80 index 1 io port: [f000, ffff]
bus: 80 index 2 mmio: [c0000000, ddffffff]
bus: 80 index 3 mmio: [e8000000, efffffff]

current all the buses will use ioport_resource

@@ -1158,6 +1162,8 @@ struct pci_bus * pci_create_bus(struct d
        b->resource[0] = &ioport_resource;
        b->resource[1] = &iomem_resource;

kernel could try to allocate resource from [0x1000, 0x4fff] for the
device in first HT chain...
..
I met one case: when some cards insert, i can not use mcp55 on die nic.
then i make one patch that could read KB northbridge pci conf space to
make different peer root bus has right io/iomem resource range.
pci_assign_resource could get right value for the devices that is not
assigned io value by BIOS.

YH
