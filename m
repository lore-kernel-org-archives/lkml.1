Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbXH1OzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbXH1OzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXH1OzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:55:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXH1OzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:55:04 -0400
Date: Tue, 28 Aug 2007 20:38:00 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: oops at sr_block_release [Re: 2.6.23-rc3-mm1]
In-Reply-To: <46D407E9.3070603@gmail.com>
Message-ID: <alpine.LFD.0.999.0708282008430.24588@enigma.security.iitk.ac.in>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
 <46D407E9.3070603@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,


On Tue, 28 Aug 2007, Jiri Slaby wrote:

> Andrew Morton napsal(a):
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> I got this during gxine initialization of ocko.tv live stream without any cd in
> cdroms:

Yup, that's an old habit of hald-addon-storage ... doing open(2),
ioctl(2) and close(2) on the cdrom block device even when it's idle,
every 2 seconds.


> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000005c
> printing eip: f88fbe7a *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: ath5k arc4 ecb blkcipher cryptomgr crypto_algapi
> rc80211_simple mac80211 cfg80211 nls_cp437 vfat fat usb_storage tun ipv6 floppy
> parport_pc parport ohci1394 ieee1394 usbhid sr_mod ehci_hcd cdrom ff_memless
> 
> Pid: 2809, comm: hald-addon-stor Not tainted (2.6.23-rc3-mm1 #315)
> EIP: 0060:[<f88fbe7a>] EFLAGS: 00010246 CPU: 1
> EIP is at sr_block_release+0xb/0x2c [sr_mod]
> EAX: 00000000 EBX: 00000000 ECX: f88fbe6f EDX: 00000000
> ESI: c21c36c0 EDI: c289a780 EBP: c3729f18 ESP: c3729f10
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process hald-addon-stor (pid: 2809, ti=c3729000 task=c1c2be40 task.ti=c3729000)
> Stack: 00000000 c21c36c0 c3729f38 c018d7ad c21c36cc c1f9ff80 c21c3730 c21c36c0
>        c2a6ada0 dcbb3f80 c3729f40 c018d7dc c3729f4c c018e103 00000010 c3729f74
>        c016bc5f 00000000 00000000 c217fa80 c1f9ff80 c2a6ada0 dcbb3f80 c1cc6900
> Call Trace:
>  [<c0105022>] show_trace_log_lvl+0x1a/0x30
>  [<c01050dd>] show_stack_log_lvl+0xa5/0xca
>  [<c01051d2>] show_registers+0xd0/0x1c1
>  [<c01053cd>] die+0x10a/0x24d
>  [<c011afbe>] do_page_fault+0x496/0x608
>  [<c03768e2>] error_code+0x72/0x78
>  [<c018d7ad>] __blkdev_put+0x125/0x14a
>  [<c018d7dc>] blkdev_put+0xa/0xc
>  [<c018e103>] blkdev_close+0x29/0x2c
>  [<c016bc5f>] __fput+0xa6/0x161
>  [<c016bea4>] fput+0x22/0x3b
>  [<c016960b>] filp_close+0x41/0x67
>  [<c016a78c>] sys_close+0x60/0x9f
>  [<c01040ce>] syscall_call+0x7/0xb
>  =======================
> Code: 0c 81 c3 4c 01 00 00 89 5c 24 08 89 44 24 04 c7 04 24 88 cd 8f f8 e8 99 84
> 82 c7 e9 04 fe ff ff 55 89 e5 56 53 8b 80 04 01 00 00 <8b> 40 5c 8b 70 3c 8d 46
> 18 e8 cf f6 fe ff 89 c3 85 c0 75 07 89
> EIP: [<f88fbe7a>] sr_block_release+0xb/0x2c [sr_mod] SS:ESP 0068:c3729f10

blkdev_put(bdev, ...)
	__blkdev_put(bdev, ...)
		sr_block_release(bdev->bd_inode, ...)
		(sees bdev->bd_inode->i_bdev->bd_disk == NULL)

Doesn't seem like an sr_block_release() (or sr_mod) issue to me at all,
looks more like a wierd race in the block_device code ... can you send
or put up some link to your .config?

If this is reproducible (I bet it isn't, though) you could try bisecting.


Satyam
