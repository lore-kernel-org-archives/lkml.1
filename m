Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYHDDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYHDDWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 23:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbYHDDWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 23:22:07 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39573 "EHLO
	pd3mo1so-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752913AbYHDDWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 23:22:05 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=dgOF77SLaJsav1JFRHIA:9 a=wX9nBo17Sd1pNISXESsA:7 a=ueikNKIANHvhNZWRbLb1V31136sA:4 a=UrG_RJUhHJwA:10
Message-ID: <489675DC.2080906@shaw.ca>
Date: Sun, 03 Aug 2008 21:22:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linasvepstas@gmail.com
CC: John Stoffel <john@stoffel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
References: <fa.qB5d+HsAJ6G05jNoeU8Q9GV6Dow@ifi.uio.no> <fa.fxlDAHxOnGgcBiOH/EOauE67ZPc@ifi.uio.no> <fa.1WYUmN6FHR5yW+sXoYRFN22Y8S8@ifi.uio.no> <fa.LAUkvEUlYiF69V/F8F3wigxqH9w@ifi.uio.no> <fa.mXeFXYNkfZfUYPQcGwzok0IOIfY@ifi.uio.no> <fa.KjbvCGbUr2JeQTcwA1/sFGIIMik@ifi.uio.no>
In-Reply-To: <fa.KjbvCGbUr2JeQTcwA1/sFGIIMik@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas wrote:
> What I don't like is that the corruption was utterly silent -- and disastereous:
> Originally, I had the sata disk paired to a pata disk in a RAID array, and the
> raid array was getting corrupted -- corrupted system files would get worse,
> as I tried reinstalling them. It took a while to realize that it was the sata
> disk, and it took a bit longer to realize it wasn't the disk itself, but the
> bad-ram-on-sata-channel.
> 
> So I'm wondering: can we devise a test to validate system-bus interactions
> like this? Clearly, the memtest86 test validates the RAM and the northbridge
> bus between CPU and system RAM, so that seems OK.

I wouldn't be sure about that..

> 
> I assume the sata controller is attached via pci or pci-e -- although the pci
> controller and the sata controller are on the same chip, (nVidia nForce 570
> chipset) so it may be an 'emulated' pci bus of some sort. The problem would
> seem to be some sort of bus timing issue between this particular RAM,
> and the pci bus in the chipset -- bad "eyes" on some signal line, or ground
> bounce or whatever, or maybe a rare chipset bug.

The SATA controller is part of the chipset, and I think it talks 
HyperTransport directly, it only looks like PCI or PCI Express. These 
systems have an on-die memory controller in the CPU, so the SATA 
controller has to talk HyperTransport to the CPU which then is what 
physically accesses the DIMMs.

In theory the DIMMs have no idea whether the accesses are from the CPU 
itself or from the chipset. However, it's possible that the particular 
timing or burst sizes of the transfers done by the SATA controller 
triggered a problem with marginal timing on the DIMMs and caused the 
data corruption.

> 
> So the question is: is there some sort of sata (or pci) "loopback mode",
> where we could pump data through all of the busses and controllers, up
> near to the point where it would normally go out to the serdes to the disk,
> but instead have it loop back, so that we could test the buses between
> endpoints?  I've never heard of a pci/pci-e loopback, but that doesn't mean it
> doesn't exist. I have no clue about SATA.  Is there possibly some ide or
> scsi command that can be used to loop-back? Some sort of "send bytes
> to disk, but don't actually write them to platter" command? Maybe just
> a write to some scratch ram on the disk drive itself? Even just a few bytes
> would be enough to implement a loopback test. Maybe some sort of
> "queue this block, but don't write it yet", followed by a "give me dump of
> the command queue" -- such a loopback test would have found my problem
> pretty quickly I suspect.
> 
> Ideas solicited.

I don't imagine that would be very useful in this case. The SATA link, 
PCI Express bus, HyperTransport bus all have parity or CRC error 
checking, so presumably they couldn't be likely to cause undetected 
errors. The transitions between them could cause problems, and most 
desktop machines don't have ECC memory which could catch memory timing 
problems or bad RAM (which is rather unfortunate), so those are the most 
likely places for a problem to show up.

> 
> --linas
> 
> p.s. the corruption appears to be single bits -- the rest of the word, and
> surrounding words, seem fine.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

