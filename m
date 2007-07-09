Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbXGIFey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbXGIFey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXGIFer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:34:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:46679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXGIFeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:34:46 -0400
From: Neil Brown <neilb@suse.de>
To: Turbo Fredriksson <turbo@bayour.com>
Date: Mon, 9 Jul 2007 15:34:28 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18065.51428.849286.225118@notabene.brown>
Cc: linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: Moving MD/LVM from PPC to x86
In-Reply-To: message from Turbo Fredriksson on Sunday July 8
References: <87wsxneqs0.fsf@pumba.bayour.com>
	<20070629215416.GA12786@agk.fab.redhat.com>
	<876455erlw.fsf@pumba.bayour.com>
	<18054.9063.45466.586046@notabene.brown>
	<873azy4pq0.fsf@pumba.bayour.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday July 8, turbo@bayour.com wrote:
> Quoting Neil Brown <neilb@suse.de>:
> 
> > Version 0.90 MD superblocks (still the default) uses host-endian
> > values so you cannot move between architectures directly.  However
> > isn't too hard to make it work. 
> > Firstly, use
> >    mdadm --examine --metadata=0.swap /dev/DEVICE
> 
> ----- s n i p -----
> ppc:~# mdadm --examine --metadata=0.swap /dev/md0
> mdadm: No super block found on /dev/md0 (Expected magic a92b4efc, got 00000000)
> ppc:~# mdadm --examine --metadata=0.swap /dev/md1
> mdadm: No super block found on /dev/md1 (Expected magic a92b4efc, got 00000000)
> ppc:~# mdadm --examine --metadata=0.swap /dev/md2
> mdadm: No super block found on /dev/md2 (Expected magic a92b4efc, got 00000000)

You --examine component devices of an array, not the whole array.

> ppc:~# mdadm --examine --metadata=0.swap /dev/sda1
> mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got fc4e2ba9)

This suggests that the superblock is currently the correct byteorder
for the current host.  You use
   mdadm --examine --metadata=0.swap /dev/sda1

when you have moved a devices from one host to different host with the
opposite endian-ness (e.g. bigendian to littlendian).

> 
> > to check that you have the right devices.
> > Then
> >
> >   mdadm --assemble /dev/md0 --update=byteorder /dev/DEV0 /dev/DEV1  ....
> >
> > That should assemble the array and update the superblocks so that they
> > are in the right byteorder and will assemble easily in future.
> 
> Is this safe, changing the byteorder on all the physical devices (that are
> part of my MD's)?
> Will it still work on the PPC?

I cannot remember where you were moving 'from' or 'to', but what you
have to do is:

  1/ move the devices to the new computer.
  2/ use "mdadm --examine" to make sure they are where you expect them
      to be.  Use "--metdata=0.swap" if the byteorder is different on
      the new machine.
  3/ Once you are satisfied that things look right, use
       mdadm --assemble /dev/md0 --update=byteorder ....
    to assemble the array.  This will change the byteorder in the
    superblocks.  After you have done this, the array will assemble
    normally on the new machine, but will not if you move it back to the
    old machine. If you want to use the old machine again, you need to
    use --update=byteorder again.

Does that make it clear?

NeilBrown
