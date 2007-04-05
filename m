Return-Path: <linux-kernel-owner+w=401wt.eu-S1750735AbXDEMem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750735AbXDEMem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXDEMem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:34:42 -0400
Received: from khc.piap.pl ([195.187.100.11]:35007 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXDEMel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:34:41 -0400
To: <linux-kernel@vger.kernel.org>
Subject: RFC: initramfs unpack point and rules
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 05 Apr 2007 14:34:39 +0200
Message-ID: <m3ejmzdmow.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently got a BSOD bootup problem with external initramfs (it's
ARM but it seems it doesn't matter).

--------------------------------------------------------------------------

First problem: initramfs is unpacked way before console drivers
are initialized, so you aren't going to see the panic():

init/initramfs.c:static int __init populate_rootfs(void)
...
		printk(KERN_INFO "Unpacking initramfs...");
		err = unpack_to_rootfs((char *)initrd_start,
			initrd_end - initrd_start, 0);
		if (err)
			panic(err);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		printk(" done\n");
		free_initrd();

I wonder why is initramfs unpacked that early, before most drivers?
I'd expect it much later in the boot sequence, just before userspace
and initial devices (/dev/console etc) are needed. Should it be moved
there? populate_rootfs() unpacks both builtin and external initramfs.


--------------------------------------------------------------------------

Second problem:
RedBoot> exec -r 0x800000 -s 8000000 -c "console=ttyS0,115200"      

Using base address 0x00030000 and length 0x001eea08
Uncompressing Linux...............................done, booting the kernel.
[nothing then]

Obviously I didn't want to specify the exact size and expected inflate
to determine it by itself. I think a valid gzipped cpio image, followed
by some junk, should not be a problem here. Currently, unpack_to_rootfs()
does the job but returns "bad gzip magic numbers" error message - I think
I should change it to return that message only for first initramfs header
and return a success if some junk is spotted after a valid end of
compressed data.

Opinions?
-- 
Krzysztof Halasa
