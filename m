Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXEQMqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXEQMqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXEQMqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:46:05 -0400
Received: from tornado.reub.net ([210.185.126.1]:48875 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbXEQMqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:46:04 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 08:46:03 EDT
Message-ID: <464C4CB8.8060906@reub.net>
Date: Thu, 17 May 2007 22:38:16 +1000
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: 2.6.22-rc1-mm1 - Call trace in slub_def.h
References: <20070515201914.16944e04.akpm@linux-foundation.org>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/2007 1:19 PM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/
> 
> 
> - I found some time to look into some writeback problems in
>   fs/fs-writeback.c.  The results were ugly.  There are a pile of fixes here
>   but more work (mainly testing) needs to be done.
> 
>   There's some new debug code in there which could be very expensive if
>   there are a lot of dirty inodes in the machine (quadratic behaviour).  If
>   the machine seems to be affected by this, the debugging may be disabled with
> 
> 	echo 0 > /proc/sys/fs/inode_debug
> 
> - Added an i386 early-startup development tree, as git-newsetup.patch ("H. 
>   Peter Anvin" <hpa@zytor.com>)
> 
> - Brought back git-sas.patch (Darrick J.  Wong <djwong@us.ibm.com>).  It got
>   lost quite some time ago.

I have just seen this on boot, with 2.6.22-rc2-mm1 on x86_64:

--

libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
BUG: at include/linux/slub_def.h:88 kmalloc_index()

Call Trace:
  [<ffffffff8034f3f9>] pci_dev_put+0x12/0x14
  [<ffffffff80283f30>] get_slab+0xb5/0x265
  [<ffffffff802841bc>] __kmalloc+0x13/0xa3
  [<ffffffff8021a4aa>] cache_k8_northbridges+0x80/0x116
  [<ffffffff8063fed2>] gart_iommu_init+0x16/0x594
  [<ffffffff804562ac>] genl_rcv+0x0/0x68
  [<ffffffff804548ed>] netlink_kernel_create+0x15e/0x16b
  [<ffffffff804acc52>] mutex_unlock+0x9/0xb
  [<ffffffff80639fad>] pci_iommu_init+0x9/0x12
  [<ffffffff806306af>] kernel_init+0x152/0x322
  [<ffffffff80249c7c>] trace_hardirqs_on+0xc0/0x14e
  [<ffffffff804ae03d>] trace_hardirqs_on_thunk+0x35/0x37
  [<ffffffff80249c7c>] trace_hardirqs_on+0xc0/0x14e
  [<ffffffff8020a848>] child_rip+0xa/0x12
  [<ffffffff80209f5c>] restore_args+0x0/0x30
  [<ffffffff8063055d>] kernel_init+0x0/0x322
  [<ffffffff8020a83e>] child_rip+0x0/0x12

PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
pnp: 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved

--

The full dmesg is at http://www.reub.net/files/kernel/2.6.22-rc1-mm1-dmesg and 
the config up at http://www.reub.net/files/kernel/2.6.22-rc1-mm1-config

The machine otherwise seems to run OK.

Reuben
