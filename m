Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYCFKO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYCFKO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 05:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYCFKOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 05:14:18 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57562 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYCFKOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 05:14:17 -0500
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of
	the disk image
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200803062057.50181.nickpiggin@yahoo.com.au>
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
	 <200803062057.50181.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=utf-8
Organization: Bull S.A.S.
Date: Thu, 06 Mar 2008 11:16:25 +0100
Message-Id: <1204798585.4325.8.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le jeudi 06 mars 2008 à 20:57 +1100, Nick Piggin a écrit :
> On Thursday 06 March 2008 20:43, Laurent Vivier wrote:
> > This patch allows to use loop device with partitionned disk image.
> >
> > Original behavior of loop is not modified.
> >
> > A new parameter is introduced to define how many partition we want to be
> > able to manage per loop device. This parameter is "max_part".
> >
> > For instance, to manage 63 partitions / loop device, we will do:
> > # modprobe max_part=63
> > # ls -l /dev/loop?*
> > brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
> > brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
> > brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
> > brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
> > brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
> > brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
> > brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
> > brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
> >
> > And to attach a raw partitionned disk image, the original losetup is used:
> >
> > # losetup -f etch.img
> > # ls -l /dev/loop?*
> > brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
> > brw-rw---- 1 root disk 7,   1 2008-03-05 14:57 /dev/loop0p1
> > brw-rw---- 1 root disk 7,   2 2008-03-05 14:57 /dev/loop0p2
> > brw-rw---- 1 root disk 7,   5 2008-03-05 14:57 /dev/loop0p5
> > brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
> > brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
> > brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
> > brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
> > brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
> > brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
> > brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
> > # mount /dev/loop0p1 /mnt
> > # ls /mnt
> > bench  cdrom  home        lib         mnt   root     srv  usr
> > bin    dev    initrd      lost+found  opt   sbin     sys  var
> > boot   etc    initrd.img  media       proc  selinux  tmp  vmlinuz
> > # umount /mnt
> > # losetup -d /dev/loop0
> >
> > Of course, the same behavior can be done using kpartx on a loop device,
> > but modifying loop avoids to stack several layers of block device (loop +
> > device mapper), this is a very light modification (40% of modifications
> > are to manage the new parameter). Moreover all partition tables known
> > by the kernel are managed (kpartx implements only a subset).
> 
> Do you think we do something similar for drivers/block/brd.c too? I'd
> like to try to maintain parity between them where possible...

I think it is possible  (I've the same patch for NBD too), but I think
it is completely useless.

For loop, it is another story because it uses disk images that can be
created from a partition or a real device (or a virtual disk).

Regards,
Laurent
-- 
----------------- Laurent.Vivier@bull.net  ------------------
"Programmers who subconsciously view themselves as artists
 will enjoy what they do and will do it better." D. Knuth

