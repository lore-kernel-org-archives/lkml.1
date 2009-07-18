Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbZGRLHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbZGRLHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbZGRLHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:07:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37625 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbZGRLHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:07:35 -0400
Date: Sat, 18 Jul 2009 13:06:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
	pci-dma-compat.h
Message-ID: <20090718110620.GC27287@elte.hu>
References: <4A5BD7B5.1010904@earthlink.net> <20090714103941B.fujita.tomonori@lab.ntt.co.jp> <20090714092354.GL19087@amd.com> <20090714.131224.205307048.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714.131224.205307048.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Tue, 14 Jul 2009 11:23:55 +0200
> 
> > On Tue, Jul 14, 2009 at 10:40:16AM +0900, FUJITA Tomonori wrote:
> >> On Mon, 13 Jul 2009 20:56:21 -0400
> >> Robert Reif <reif@earthlink.net> wrote:
> >> 
> >> > The bad address is within the kernel so it looks like
> >> > it's catching a real bug.
> >> > 
> >> > cat kallsyms | grep f0007000
> >> > f0007000 T trapbase_cpu3
> >> > 
> >> > WARNING: at lib/dma-debug.c:873 check_for_illegal_area+0xc8/0x100()
> >> > esp ffd7ba30: DMA-API: device driver maps memory from kernel text or 
> >> > rodata [addr=f0007000] [len=4096]
> >> > Modules linked in: ext3 jbd sd_mod sun_esp esp_scsi scsi_transport_spi 
> >> 
> >> Ok, I looked at check_for_illegal_area() in dma-debug.
> >> 
> >> What check_for_illegal_area() does looks bogus to me with some of I/O
> >> remapping hardware.
> > 
> > Can you be more specific about this one? 
> > check_for_illegal_area() should not depend on any hardware 
> > because all it does is checking the machine addresses to be 
> > mapped.
> 
> The check can't work properly on sparc32.
> 
> Sparc32 always maps the kernel to a fixed physical location, and 
> it therefore can execute in the identity mapping area of physical 
> memory like where all the free pages and kmalloc areas live 
> virtually.
> 
> So if we free up some pages within the kernel image (because the 
> memory is unused, for exmple that's what's happening here with the 
> extra trap table pages on Robert's machine) we have pages in the 
> free page pool that are located right inside of the kernel text, 
> data, etc.
> 
> We'll thus need a way to turn off these checks somehow.  You could 
> also augment this check by seeing if there is a backing page, and 
> if so, whether it is PageReserved or not.  That's just one idea.

Hm, note, this sparc32 behavior might break certain aspects of 
lockdep as well, see kernel/lockdep.c::static_obj(). You could get 
spurious non-printing of 'trying to register non-static key'.

I'm wondering why sparc32 frees from the middle of the kernel image. 
The way architectures generally do it is to put freeable pages into 
a separate section. That way it does not get mingled with the kernel 
core image area (which stays nicely continuous).

	Ingo
