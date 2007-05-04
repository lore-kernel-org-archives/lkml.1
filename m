Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXEDPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXEDPaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbXEDPaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:30:30 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:50499 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933115AbXEDPa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:30:29 -0400
X-Greylist: delayed 1834 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2007 11:30:29 EDT
From: Bernd Schubert <bs@q-leap.de>
To: linux-kernel@vger.kernel.org
Subject: mkfs.ext2 triggerd RAM corruption
Date: Fri, 4 May 2007 16:59:51 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705041659.51675.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm presently rather puzzled, if this is really a kernel bug, its a big bug. 

Summary: The system ramdisk (initrd) gets corrupted while running mkfs.ext2 on 
a local sata disk partition.

Reproduced on kernel versions: vanilla 2.6.16 - 2.6.20 (<2.6.16 doesn't run on 
any of the systems I can do tests with).
Please note: I could reproduce this on serveral systems, all of them use ECC 
memory and the memory of most of them the memory is monitored using EDAC. 

Details:

1.) Our systems boot from an initrd, all system services are running from the 
initrd/ramdisk.

2.) While setting up a lustre meta data storage server, lustre runs 
mkfs.ext2 -j -b 4096 -F -i 4096 -J size=400 -I 512 /dev/sda4
(Please note, I first observed this while using a lustre patched kernel, but I 
could reproduce this with vanilla kernels).


While this mkfs.ext2 command was running, suddenly running commands such as 
ps, top, ls, etc. resulted in segmentation faults.

To see whats going on, I copied the entire / (so the initrd) into a tmpfs 
root, chrooted into it, also bind mounted the main / into this chroot and 
compared several times /bin of chroot/bin and the bind-mounted /bin while the 
mkfs.ext2 command was running.

beo-05:/# diff -r /bin /oldroot/bin/
beo-05:/# diff -r /bin /oldroot/bin/
beo-05:/# diff -r /bin /oldroot/bin/
Binary files /bin/sleep and /oldroot/bin/sleep differ
beo-05:/# diff -r /bin /oldroot/bin/
Binary files /bin/bsd-csh and /oldroot/bin/bsd-csh differ
Binary files /bin/cat and /oldroot/bin/cat differ
...

Also tested different schedulers, at least happens with deadline and 
anticipatory.

The corruption does NOT happen on running the mkfs command on /dev/sda1, but 
happens with sda2, sda3 and sda3. Also doesn't happen with extended 
partitions of sda1.

Any idea whats going on?


Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
