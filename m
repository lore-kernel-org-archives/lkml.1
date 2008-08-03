Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYHCWXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYHCWXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbYHCWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:23:31 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:25522 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbYHCWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:23:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Q59AsaS+zj+kLLpxe710Nl4iazbcByAQ1ZDzf+2KfRywSMOP+WzqUlUMViU0L8j8ax
         LJ0S49/ebjM010o5nSXGQU+n63cQDZSYffCC2yCI2nfXfvS9yOoulT22/cqf6zMNuBMa
         i/QTgnM/7WMrSgSD0UNqrTw7rECzOOEg8MybM=
Message-ID: <3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
Date: Sun, 3 Aug 2008 17:23:29 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "John Stoffel" <john@stoffel.org>
Subject: Re: amd64 sata_nv (massive) memory corruption
Cc: "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18581.6873.353028.695909@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	 <200808012319.05038.alistair@devzero.co.uk>
	 <3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	 <18580.48861.657366.629904@stoffel.org>
	 <3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	 <18581.6873.353028.695909@stoffel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/2 John Stoffel <john@stoffel.org>:

>> Linas

>>> Can you post the output of dmesg after a boot,

I found the problem, and its not in dmesg

> Linas> Then, rather stupidly, I flashed the latest BIOS for the
> Linas> motherboard and now have a dead motherboard (it hangs on its
> Linas> way through BIOS, well before the bootloader.)  So I'm off to
> Linas> buy a new mobo today.
>
> Awww fuckies.  Sorry to suggest this path to you.  You might be able
> to get it back by clearing the CMOS as well.

That fixed it, but only *after* the machine cooled off overnight!
While it was warm, it was so unstable I couldn't even pilot around in BIOS
without it hanging. After cooling off, it was still unstable, but held
it together
long enough for me to ask for "factory defaults" -- and that fixed it.
(Grrr. What are these BIOS people thinking?)

I then did some more debugging, and isolated the original data corruption
problem to a bad pair of RAM sticks. But this was subtle, so let me recap:

-- The bad ram passes memtest86+
-- It's been in heavy use for some 3-4 months, for memory intensive compute,
   and memory-intensive SQL, with not the slightest hint of any stability or
   corruption problems, Uptime might have been around 3-4 months.
-- Corruption was prompt and widespread on the sata interface.

I remove the bad RAM, that the sata interface appears to be stable.
I've been doing file copies and diffs for hours without a hint of trouble.

This would seem to bring this chapter to a close.

======================================================

What I don't like is that the corruption was utterly silent -- and disastereous:
Originally, I had the sata disk paired to a pata disk in a RAID array, and the
raid array was getting corrupted -- corrupted system files would get worse,
as I tried reinstalling them. It took a while to realize that it was the sata
disk, and it took a bit longer to realize it wasn't the disk itself, but the
bad-ram-on-sata-channel.

So I'm wondering: can we devise a test to validate system-bus interactions
like this? Clearly, the memtest86 test validates the RAM and the northbridge
bus between CPU and system RAM, so that seems OK.

I assume the sata controller is attached via pci or pci-e -- although the pci
controller and the sata controller are on the same chip, (nVidia nForce 570
chipset) so it may be an 'emulated' pci bus of some sort. The problem would
seem to be some sort of bus timing issue between this particular RAM,
and the pci bus in the chipset -- bad "eyes" on some signal line, or ground
bounce or whatever, or maybe a rare chipset bug.

So the question is: is there some sort of sata (or pci) "loopback mode",
where we could pump data through all of the busses and controllers, up
near to the point where it would normally go out to the serdes to the disk,
but instead have it loop back, so that we could test the buses between
endpoints?  I've never heard of a pci/pci-e loopback, but that doesn't mean it
doesn't exist. I have no clue about SATA.  Is there possibly some ide or
scsi command that can be used to loop-back? Some sort of "send bytes
to disk, but don't actually write them to platter" command? Maybe just
a write to some scratch ram on the disk drive itself? Even just a few bytes
would be enough to implement a loopback test. Maybe some sort of
"queue this block, but don't write it yet", followed by a "give me dump of
the command queue" -- such a loopback test would have found my problem
pretty quickly I suspect.

Ideas solicited.

--linas

p.s. the corruption appears to be single bits -- the rest of the word, and
surrounding words, seem fine.
