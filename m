Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZBUJXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZBUJXn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 04:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZBUJXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 04:23:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:2374 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZBUJXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 04:23:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,245,1233561600"; 
   d="scan'208";a="112979666"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 21 Feb 2009 17:24:57 +0800
Subject: RE: help! locks problem in block layer request queue?
Thread-Topic: help! locks problem in block layer request queue?
Thread-Index: AcmSlCp+XcuSNx28RwS9gPuSUpM0bwBbn7kQ
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE3130248428D8@pdsmsx503.ccr.corp.intel.com>
References: <38D9F46DFF92C54980D2F2C1E8EE313024842389@pdsmsx503.ccr.corp.intel.com>
 <20090219131305.GD29783@kernel.dk>
In-Reply-To: <20090219131305.GD29783@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1L9NlwM001253

Really awesome!  This is a big bug. I have re-write the code of processing requests from the request queue. The new code is copied from drivers/mtd/mtd_blkdevs.c and did some necessary modifies. Now it works well.  Many thanks to you :)

BTW, I noticed that MTD driver (drivers/mtd/mtd_blkdevs.c) and MMC driver (drivers/mmc/card/block.c and queue.c) also register a block device, and they create a kernel thread to process the request queue instead of process it directly. Why they do it like that? Is there any special reason for that?

Thanks a lot.

Rgds,
Yunpeng Gao 

-----Original Message-----
From: Jens Axboe [mailto:jens.axboe@oracle.com] 
Sent: 2009Äê2ÔÂ19ÈÕ 21:13
To: Gao, Yunpeng
Cc: linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: help! locks problem in block layer request queue?

On Thu, Feb 19 2009, Gao, Yunpeng wrote:
> 
> Hi all,
> 
> Sorry for the too long email. But I encountered a kernle OOP problem
> when testing my standalone NAND block driver (it's almost a normal
> block device driver) and not sure why this happen.
> 
> In my development environment, the linux 2.6.27 kernel boot with
> initrd, then 'chroot' to an MMC card. After chroot, I try to mkfs.ext3
> on NAND device. but it caused the kernel OOP message.  If I mkfs.ext3
> on NAND device before chroot, then it works well (it can mount/umount,
> copy file correctly accross system reboot).
> 
> Below is the log message (/dev/mmcblk0 is the MMC card device node,
> and /dev/nda is the NAND flash device node) and part of the driver
> code.
> 
> From the OOP message, It seems there's improper usage of locks in my
> driver code, but actually, there only one spinlock used in the driver
> (spinlock_t qlock defined in struct spectra_nand_dev). And it only
> used by registered request queue. Also, I used a semaphore
> ('spectra_sem') to prevent the low layer function from being
> re-entered. As the low layer (hardware layer) now works in PIO mode
> and it's very slowly, so maybe it holds the spinlock or semaphore for
> too long time?

You call the bvec_kmap_irq() and then call a function that does a
down(). This is illegal, as you cannot block/schedule with interrupts
disabled.

-- 
Jens Axboe

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
