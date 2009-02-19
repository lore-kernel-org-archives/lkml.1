Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbZBSNPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbZBSNPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZBSNPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:15:33 -0500
Received: from brick.kernel.dk ([93.163.65.50]:18916 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZBSNPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:15:32 -0500
Date: Thu, 19 Feb 2009 14:13:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: help! locks problem in block layer request queue?
Message-ID: <20090219131305.GD29783@kernel.dk>
References: <38D9F46DFF92C54980D2F2C1E8EE313024842389@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38D9F46DFF92C54980D2F2C1E8EE313024842389@pdsmsx503.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

