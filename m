Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZGCAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZGCAL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbZGCALQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:11:16 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47442 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbZGCALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:11:16 -0400
Date: Fri, 3 Jul 2009 02:11:17 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
In-Reply-To: <19021.17576.808138.476600@samba.org>
Message-ID: <alpine.LSU.2.00.0907030149020.17183@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
 <19021.17576.808138.476600@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-07-03 01:37, tridge@samba.org wrote:
>
> > Yes, here is your precedent case. The DUALNAMES patch breaks the
> > operation on my Fujifilm Finepix A210 digital camera.
>
>interesting, but I think you may have been trapped by differences in
>the VFAT mounting options between the two examples.

No special options — all defaults to whatever the Linux kernel and
util-linux 2.14.1 gave me. Whereby util-linux should not make a
difference because it just passes on the mount request for there is
no special vfat helper.

Given my second report about the audio player (just sent out), I even
compared dualnames=n with =y on the same kernel — which would rule
out changed defaults between 2.6.29 and 2.6.31-rc.

/proc/mounts contains, on .31-rc:

/dev/sdc1 /mnt vfat rw,relatime,fmask=0022,dmask=0022,codepage=437
iocharset=utf8,errors=remont-ro 0 0

> > Here, dscf4159.jpg is a preexisting file created by the camera itself 
> > (and subsequently, Finepix's FAT code) as a result of taking a picture. 
> > Then I just copied that file with two different kernels in succession.
>
>ok, dscf4159.jpg may or may not be a 8.3 name depending on the
>"shortname=" mount option. As this is a digital camera, I suspect that
>it was created as an 8.3 name, although you'd have to confirm that by
>inspecting the disk image. If you made a copy of the image available
>to me somewhere (please don't email it unless it compresses to a small
>size!) then I can tell you what the camera did in this case.

http://jengelh.medozas.de/files/finepix.img.bz2
(Includes an unreadable dscf3000 entry.)

Then, I just tried everything to get an overview:

 (All with DUALNAMES=n)
 # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=lower
 # cp /mnt/dcim/100_fuji/dscf{4160,3004}.jpg
 # umount /mnt
 # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=win95
 # cp /mnt/dcim/100_fuji/dscf{4160,3005}.jpg
 # umount /mnt
 # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=winnt
 # cp /mnt/dcim/100_fuji/dscf{4160,3006}.jpg
 # umount /mnt
 # mount /dev/sdc1 /mnt -o iocharset=utf8,shortnames=mixed
 # cp /mnt/dcim/100_fuji/dscf{4160,3007}.jpg
 # umount /mnt

Result? The camera only displays 3006.

The dualnames patch's filling filenames with random illegal
chars does seems to have a really foul side-effect after all.
