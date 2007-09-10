Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXIJNqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXIJNqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbXIJNqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:46:37 -0400
Received: from [81.2.110.250] ([81.2.110.250]:37656 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755462AbXIJNqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:46:36 -0400
Date: Mon, 10 Sep 2007 14:54:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: ECC and DMA to/from disk controllers
Message-ID: <20070910145415.0fe05319@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.63.0709100707210.28162@trinity.phys.uwm.edu>
References: <Pine.LNX.4.63.0709100707210.28162@trinity.phys.uwm.edu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> In thinking about this, I began to wonder about the following.  Suppose 
> that a (possibly RAID) disk controller correctly reads data from disk and 
> has correct data in the controller memory and buffers.  However when that 
> data is DMA'd into system memory some errors occur (cosmic rays, 
> electrical noise, etc).  Am I correct that these errors would NOT be 
> detected, even on a 'reliable' server with ECC memory?  In other words the 
> ECC bits would be calculated in server memory based on incorrect data from 
> the disk.

Architecture specific.

> The alternative is that disk controllers (or at least ones that are meant 
> to be reliable) DMA both the data AND the ECC byte into system memory. 
> So that if an error occurs in this transfer, then it would most likely be 
> picked up and corrected by the ECC mechanism.  But I don't think that 
> 'this is how it works'.  Could someone knowledgable please confirm or 
> contradict?

Its almost entirely device specific at every level. Some general
information and comment however

- Drives normally do error correction and shouldn't be fooled very often
by bad bits. 
- The ECC level on the drive processors and memory cache vary by vendor.
Good luck getting any information on this although maybe if you are Cern
sized they will talk

After the drive we cross the cable. For SATA this is pretty good, and
UDMA data transfer is CRC protected. For PATA the data is but not the
command block so on PATA there is a minute chance you send the CRC
protected block to the wrong place

Once its crossing the PCI bus and main memory and CPU cache its entirely
down to the system you are running what is protected and how much. Note
that a lot of systems won't report ECC errors unless you ask.

If you have hardware RAID controllers its all vendor specific including
CPU cache etc on the card etc.

The next usual mess is network transfers. The TCP checksum strength is
questionable for such workloads but the ethernet one is pretty good.
Unfortunately lots of high performance people use checksum offload which
removes much of the end to end protection and leads to problems with iffy
cards and the like. This is well studied and known to be very problematic
but in the market speed sells not correctness. 

>From the paper type II sounds like slab might be a candidate kernel side
but also CPU bugs as near OOM we will be paging hard and any L2 cache page
out/page table race from software or hardware would fit what it describes,
especially the transient nature

Type III wrong block on PATA fits with the fact the block number isn't
protected and also the limits on the cache quality of drives/drive
firmware bugs. 

For drivers/ide there are *lots* of problems with error handling so that
might be implicated (would want to do old v new ide tests on the same h/w
which would be very intriguing).

Stale data from disk cache I've seen reported, also offsets from FIFO
hardware bugs (The LOTR render farm hit the latter and had to avoid UDMA
to avoid a hardware bug)

Chunks of zero sounds like caches again, would be interesting to know
what hardware changes occurred at the point they began to pop up and what
software.

We also see chipset bugs under high contention some of which are
explained and worked around (VIA ones in the past), others we see are
clear correlations - eg between Nvidia chipsets and Silicon Image SATA
controllers.

