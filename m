Return-Path: <linux-kernel-owner+w=401wt.eu-S1422987AbXDZAXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422987AbXDZAXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXDZAXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:23:45 -0400
Received: from [81.2.110.250] ([81.2.110.250]:39306 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751988AbXDZAXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:23:44 -0400
Date: Thu, 26 Apr 2007 01:24:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
Message-ID: <20070426012454.3495b5d8@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>
	<20070424202336.GC16503@elf.ucw.cz>
	<alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	<20070424212408.GD16457@elf.ucw.cz>
	<alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	<20070425072350.GA6866@ucw.cz>
	<Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	<alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	<20070425202741.GC17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	<20070425214420.GG17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	<20070425235718.66b71f01@the-village.bc.nu>
	<alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> STR does not need to "ensure that you have a consistent snapshot".

Linus I think someone's been spiking your guinness again...

> Why? Becuase there is no _room_ for inconsistency. There's nothing to be 
> "inconsistent with", since any changes to memory (by things like DMA or 
> other setup that happens while the suspend process is going on) is by 
> _definition_ consistent with the resume image (becasue there is no 
> separate image).

You bet there is. We need to know if data arrived or not, because there
is no guarantee that the data retrieved if we inadvertently re-execute a
command will be the same. The hardware state itself isn't the problem,
its the combination of hardware state and internal state which need to
match in some cases.

> off DMA and try to make the hardware be wevy wevy quiet while it's hunting 
> wabbits, it's a lot easier to just do nothing at all on "freeze", and just 
> make sure that "thaw" will re-initialze the DMA tables entirely! All 

Who cares about DMA mapping tables, those are easy to deal with, not even
that bad with an IOMMU to restore. More problematic is the users data
because if we have a device where re-executing a command is not
repeatable (eg O_DIRECT SCSI on a shared bus) then we risk being
inconsistent in our S2RAM.  If we re-run the command on resume having
allowed it to prattle on while doing S2anything then we'll get the wrong
answer.

Now there are lots of devices we don't care about as they don't have
state in the form that causes problems - network cards, TV capture etc,
but there are cases where it matters that every operation is either
finished or not started and there is no doubt about them getting done
during the S2RAM/S2DISK

S2DISK/S2RAM both need to synchronize the state of a device so it can
build a valid snapshot. That bit is a shared requirement just like you
said didn't exist. Doesn't even need to involve turning DMA off, just
getting a consistent state.

The rest can be quite different.

Mind you some laptops think S2RAM is just a transition state on the way
to disk, leave them in ACPI S2RAM and the firmware will magically turn it
into a save to disk and back to ram if the battery runs low or you leave
it idle too long.
