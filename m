Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYHARao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYHARao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYHARag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:30:36 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:11915 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYHARaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:30:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=H5MNN2AUpRjfq7MFgr57GRXFqotKYVZFT33QbWxPfITkfOGkBrv+eYerv4/BXQg2Mx
         ixocb3VWMhLkKocnhB//t5TuYJ3a+B4kZfqfJmANBJx4NvZqfoTdpRG9npFeBWyNPfaf
         Tw38D/0byfcxwAqkVWlcA8KMKSjqMr1+e12tA=
Message-ID: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
Date: Fri, 1 Aug 2008 12:30:34 -0500
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: linux-kernel@vger.kernel.org
Subject: amd64 sata_nv (massive) memory corruption
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seeing strong, easily reproducible (and silent) corruption on a
sata-attached
disk drive on an amd64 board.  It might be the disk itself, but I
doubt it; googling
suggests that its somehow iommu-related but I cannot confirm this.

quickie summary:
-- disk is a brand new WDC WD5000AAKS-00YGA0 500GB disk (well, it
    was brand new a few months ago -- unusued, at any rate)
-- passes smartmon with flying colors, including many repeated short and long
   self-tests. Been passing for months.  No hint of bad sectors or other errors
   in smartctl -a display
-- no ide, sata errors in syslog -- no block device errors, no fs errors, etc.
-- No oopses anywhere to be found
-- system works flawlessly with an old PATA disk. (although I'm running it
   with dma turned off with hdparm, out of paranoia)
-- system is amd64 dual core, ASUS M2N-E mobo, 4GB RAM
   Northbridge is nVidia Corporation MCP55 Memory Controller (rev a3)
-- I tried moving the sata cable around to other ports, no effect; also tried
   reseating it on hard drive, no effect.

corruption is *easily* observed copying files with cp or dd. Also, typically
filesystem metadata is corrupted too. Creating even a small ext2 filesystem,
say 1GB, then copying 300MB of files onto it, unmounting it, and running fsk
will return many dozens of errors. Rerunning e2fsck over and over (as
e2fsck -f -y /dev/sda6) will report new errors about 1 out of every 3 times
(on small fs'es -- on big one's it will find new errors every time)

This behaviour has been observed with two different kernels:
with 2.6.23.9, compiled for 32-bit, and also 2.6.26 complied
for 64-bit.

Googling this uncovers some Dec 2006 LKML emails suggesting an
iommu problem, which I explored:
-- My default boot complains
    Your BIOS doesn't leave a aperture memory hole
    Please enable the IOMMU option in the BIOS setup
    This costs you 64 MB of RAM
-- I cannot find any option in BIOS that even vaguely hints at IOMMU-like
    function; at best, I can assign interrupts to PCI slots, but
that's it.  There's
    a bunch of IO options for olde-fashioned superio-like stuff: serial,parallel
    ports, USB stuff, etc. but that's all.
-- booting with iommu=soft does get rid of the aperature memory hole
   messsage, but does not solve the corruption problem.
-- booting with iommu=force seems to have no effect.

I'm running the powernow-k8 cpu frequency regulator. On a hunch,
I wondered if this might be the source of the problem; however,
using the "performance" regulator to keep the clock speed nailed
at maximum had no effect on the corruption bug.

Also of note:
-- problem was observed earlier, when system had 3GB RAM in it.
-- The integrated nvidia ethernet seems to work great, no errors, etc.
-- A different PCI ethernet card works great too.
-- I'm running graphics on an anceint matrox card in a PCI slot, and
    there's no hint of trouble there.
-- I'm using this system as my day-to-day desktop, and there seem to
   be no other problems. This suggests that if its some pci iommu
   wackiness, it certainly not affecting anything that isn't sata.

I really doubt the problem is the hard-drive; but I'll have to buy another
one to rule this out. Its possible that there's some problem with the
sata_nv driver, but there have been historical reports of corruption
on amd64 with other sata controllers. I can buy another sata controller
if needed, to experiment.

Other than that, any ideas for any further experiments? What can
I do to narrow the problem?

-- Linas Vepstas
