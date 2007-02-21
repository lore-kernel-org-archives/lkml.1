Return-Path: <linux-kernel-owner+w=401wt.eu-S1423106AbXBUU6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423106AbXBUU6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423108AbXBUU6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:58:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45391 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423106AbXBUU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:58:11 -0500
Date: Wed, 21 Feb 2007 12:57:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-usb-devel@lists.sourceforge.net,
       Pete Zaitcev <zaitcev@redhat.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.20 kernel hang with USB drive and vfat doing ftruncate
Message-Id: <20070221125736.e5ff4206.akpm@linux-foundation.org>
In-Reply-To: <87ejoj5knu.fsf@duaron.myhome.or.jp>
References: <6EF4DB85-C7D4-445B-B9B5-0D22D5D893CD@kernel.crashing.org>
	<87vehzqwf6.fsf@duaron.myhome.or.jp>
	<48F02683-BD10-4515-BCDF-53DB8F6167AA@kernel.crashing.org>
	<87ejoj5knu.fsf@duaron.myhome.or.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007 05:18:45 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> Kumar Gala <galak@kernel.crashing.org> writes:
> 
> >>> I usually run the following twice to get the hang state:
> >>>
> >>> time ./trunc_test bar 100000000 &
> >>> time ./trunc_test baz 100000000 &
> >>>
> >>> I was wondering if anyone had any suggestions on what to poke at next
> >>> to try and figure out what is going on.
> >
> > So I realized I could use sysrq to provide some more debug  
> > information.  When the system locks up I get the following output  
> > from 't'
> >
> > [  497.499249] usb-storage   D 00000000     0   671      5            
> > 773   670 (L-TLB)
> > [  497.506930] Call Trace:
> > [  497.509372] [C3F35A60] [C00083AC] __switch_to+0x28/0x40
> > [  497.514608] [C3F35A80] [C01F4B78] schedule+0x324/0x6bc
> > [  497.519756] [C3F35AC0] [C01F5D6C] schedule_timeout+0x6c/0xd0
> > [  497.525426] [C3F35B00] [C01F5C9C] io_schedule_timeout+0x30/0x54
> > [  497.531356] [C3F35B20] [C0050DE4] congestion_wait+0x64/0x8c
> > [  497.536941] [C3F35B70] [C004A9F0] throttle_vm_writeout+0x1c/0x84
> > [  497.542958] [C3F35B90] [C004F33C] shrink_zone+0xbb0/0xfe4
> > [  497.548367] [C3F35D40] [C004F8F4] try_to_free_pages+0x184/0x2cc
> > [  497.554298] [C3F35DB0] [C0049AA8] __alloc_pages+0x110/0x2c0
> > [  497.559878] [C3F35E00] [C0060F84] cache_alloc_refill+0x394/0x694
> > [  497.565900] [C3F35E30] [C00614A0] __kmalloc+0xc4/0xcc
> > [  497.570961] [C3F35E40] [C01544D0] usb_alloc_urb+0x1c/0x5c
> > [  497.576371] [C3F35E50] [C015520C] usb_sg_init+0x1a0/0x2f8
> > [  497.581779] [C3F35EA0] [C0167318] usb_stor_bulk_transfer_sg+0x8c/ 
> > 0x138
> > [  497.588317] [C3F35ED0] [C0167960] usb_stor_Bulk_transport+0x140/0x310
> > [  497.594767] [C3F35F00] [C0167DCC] usb_stor_invoke_transport+0x2c/ 
> > 0x344
> > [  497.601303] [C3F35F50] [C0166B2C] usb_stor_transparent_scsi_command 
> > +0x10/0x20
> > [  497.608449] [C3F35F60] [C0168498] usb_stor_control_thread+0x1f8/0x290
> > [  497.614900] [C3F35FC0] [C0033E48] kthread+0xf4/0x130
> > [  497.619876] [C3F35FF0] [C001093C] kernel_thread+0x44/0x60
> > [  497.625285] sh            D 3009C7EC     0   718      1            
> 
> [...]
> 
> > and from 'm'
> >
> > [  731.834529] Show Memory
> > [  731.836968] Mem-info:
> > [  731.839234] DMA per-cpu:
> > [  731.841768] CPU    0: Hot: hi:   18, btch:   3 usd:   3   Cold:  
> > hi:    6, btch:   1 usd:   2
> > [  731.850206] Active:1510 inactive:11309 dirty:7188 writeback:3330  
> > unstable:0 free:1009 slab:1671 mapped:110 pagetables:19
> > [  731.861075] DMA free:4036kB min:4096kB low:5120kB high:6144kB  
> > active:6040kB inactive:45236kB present:65024kB pages_scanned:292  
> > all_unreclaimable? no
> > [  731.874363] lowmem_reserve[]: 0 0
> > [  731.877685] DMA: 1*4kB 0*8kB 0*16kB 0*32kB 1*64kB 1*128kB 1*256kB  
> > 1*512kB 1*1024kB 1*2048kB 0*4096kB = 4036kB
> > [  731.887669] Free swap:            0kB
> > [  731.893913] 16384 pages of RAM
> > [  731.896963] 798 reserved pages
> > [  731.900011] 10946 pages shared
> > [  731.903058] 0 pages swap cached
> >
> > It seems like usb-storage and aio are completely off in the weeds.   
> > Ideas?
> 
> It seems usb-storage should remove some kmalloc and use mempool() for
> urb...  Is someone working on this? And idea?

I think Pete said that we're supposed to be using GFP_NOIO in there.

Not that it'll help much: the VM calls throttle_vm_writeout() for GFP_NOIO
and GFP_NOFS allocations, which is a bug.  Because if the caller holds
locks which prevent filesystem or IO progress, we deadlock.

I'll fix the VM if someone else fixes USB ;)
