Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYLDIXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYLDIXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750852AbYLDIW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:22:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45786 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYLDIW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:22:58 -0500
Subject: Re: Page alloc failures under network/disk IO load
From: Peter Zijlstra <peterz@infradead.org>
To: Dan =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081203222750.391e8890@tuna>
References: <20081203222750.391e8890@tuna>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Dec 2008 09:23:03 +0100
Message-Id: <1228378983.5092.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 22:27 -0500, Dan Noé wrote:
> This is on Linux 2.6.28-rc7, on a Core 2 Duo.  The system has plenty of
> memory:
> 
>              total       used       free     shared    buffers
> cached
> Mem:          1893       1822         70          0          0

filled to the brim with data

> 1573
> -/+ buffers/cache:        249       1644
> Swap:         1906         37       1868
> 
> I am using rsync to transfer data onto this system.  The filesystem is
> XFS, and the target drive is a 1TB Western Digital on ata_piix.  The
> system files are on a RAID 1 (Linux md, also on ata_piix).
> 
> Periodically I get page allocation failures, from __netdev_alloc_skb.
> I suppose this causes the driver to drop packets and thus hurts
> performance.

There isn't much we can do about that, memory is filled and your network
card tries to allocate memory in a mode that doesn't allow freeing some.

Looking at the timestamps its not very frequent, so it doesn't hurt
performance much if anything. If you're really bothered with this, you
could quiet it by sticking in a __GFP_NOWARN in __netdev_alloc_skb() or
something..



> Below are the logs from the entire event.
> 
> Cheers,
> Dan
> 
> [112854.339298] rsync: page allocation failure. order:1, mode:0x4020
> [112854.339338] Pid: 20229, comm: rsync Not tainted 2.6.28-rc7 #3
> [112854.339365] Call Trace:
> [112854.339387]  <IRQ>  [<ffffffff802c1cfe>]
> __alloc_pages_internal+0x40e/0x530
> [112854.339433]  [<ffffffff802f14a4>] new_slab+0x274/0x350
> [112854.339461]  [<ffffffff802f2670>] __slab_alloc+0x2c0/0x440
> [112854.339498]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
> [112854.339527]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
> [112854.339555]  [<ffffffff802f3b14>]
> __kmalloc_node_track_caller+0x94/0x110
> [112854.339583]  [<ffffffff8047dea8>] ? __netdev_alloc_skb+0x38/0x60
> [112854.339610]  [<ffffffff8047dafc>] __alloc_skb+0x7c/0x160
> [112854.339637]  [<ffffffff8047dea8>] __netdev_alloc_skb+0x38/0x60
> [112854.339684]  [<ffffffffa00d975a>] rtl8169_rx_fill+0xca/0x1f0 [r8169]
> [112854.339716]  [<ffffffffa00d9ad1>] rtl8169_rx_interrupt+0x251/0x540
> [r8169]
