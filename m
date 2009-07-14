Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbZGNUMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbZGNUMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 16:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbZGNUMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 16:12:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52055
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755526AbZGNUMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 16:12:20 -0400
Date: Tue, 14 Jul 2009 13:12:24 -0700 (PDT)
Message-Id: <20090714.131224.205307048.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
 pci-dma-compat.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090714092354.GL19087@amd.com>
References: <4A5BD7B5.1010904@earthlink.net>
	<20090714103941B.fujita.tomonori@lab.ntt.co.jp>
	<20090714092354.GL19087@amd.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 14 Jul 2009 11:23:55 +0200

> On Tue, Jul 14, 2009 at 10:40:16AM +0900, FUJITA Tomonori wrote:
>> On Mon, 13 Jul 2009 20:56:21 -0400
>> Robert Reif <reif@earthlink.net> wrote:
>> 
>> > The bad address is within the kernel so it looks like
>> > it's catching a real bug.
>> > 
>> > cat kallsyms | grep f0007000
>> > f0007000 T trapbase_cpu3
>> > 
>> > WARNING: at lib/dma-debug.c:873 check_for_illegal_area+0xc8/0x100()
>> > esp ffd7ba30: DMA-API: device driver maps memory from kernel text or 
>> > rodata [addr=f0007000] [len=4096]
>> > Modules linked in: ext3 jbd sd_mod sun_esp esp_scsi scsi_transport_spi 
>> 
>> Ok, I looked at check_for_illegal_area() in dma-debug.
>> 
>> What check_for_illegal_area() does looks bogus to me with some of I/O
>> remapping hardware.
> 
> Can you be more specific about this one? check_for_illegal_area() should
> not depend on any hardware because all it does is checking the machine
> addresses to be mapped.

The check can't work properly on sparc32.

Sparc32 always maps the kernel to a fixed physical location, and it
therefore can execute in the identity mapping area of physical memory
like where all the free pages and kmalloc areas live virtually.

So if we free up some pages within the kernel image (because the
memory is unused, for exmple that's what's happening here with the
extra trap table pages on Robert's machine) we have pages in the free
page pool that are located right inside of the kernel text, data, etc.

We'll thus need a way to turn off these checks somehow.  You could
also augment this check by seeing if there is a backing page, and if
so, whether it is PageReserved or not.  That's just one idea.
