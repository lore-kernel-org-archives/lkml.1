Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZFVQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZFVQN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZFVQNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:13:20 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33677 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbZFVQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:13:19 -0400
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090622155659.GE29188@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
	 <20090619134446.GI24573@n2100.arm.linux.org.uk>
	 <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
	 <20090622154308.GC29188@n2100.arm.linux.org.uk>
	 <1245685846.15580.107.camel@pc1117.cambridge.arm.com>
	 <20090622155659.GE29188@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 22 Jun 2009 17:13:16 +0100
Message-Id: <1245687196.15580.122.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 16:13:17.0146 (UTC) FILETIME=[5A1D93A0:01C9F354]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 16:56 +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 22, 2009 at 04:50:46PM +0100, Catalin Marinas wrote:
> > On Mon, 2009-06-22 at 16:43 +0100, Russell King - ARM Linux wrote:
> > > On Mon, Jun 22, 2009 at 07:43:40PM +0530, Sudeep K N wrote:
> > > > Thanks for the suggestion.
> > > > With the logs it is clear that crash is in the userspace.
> > > > I am getting one of the 2 logs(below) randomly.
> > > > >From trial#2,
> > > > pgd = c60bc000
> > > > [00000000] *pgd=061ee031, *pte=00000000, *ppte=00000000
> > > > I could understand that the page tables are not proper.
> > > > I am not able understand how to proceed.
> > > > 
> > > > Trial#1:
> > > > VFS: Mounted root (ext2 filesystem).
> > > > Freeing init memory: 108K
> > > > linuxrc (1): undefined instruction: pc=40008100
> > > > Code: e08e3003 eb002842 e2801008 e58c217c (e0812103)
> > > 
> > > Your processor is misbehaving; none of the above hex codes are undefined
> > > instructions, so you shouldn't be taking an undefined instruction trap.
> > 
> > The undefined instruction aborts are possible in this situation since
> > instructions are fetched via the I-cache while the abort handler shows
> > the code via the D-cache.
> 
> However, you're missing a very important point.

Well, I get this kind of errors (with /sbin/init) every time I try ext2
on CompactFlash (with pata_platform). You could try with USB as well on
a RealView/EB+ARM11MPCore board.

> This early on, the I-cache for the non-kernel pages won't contain any
> entries except those placed there by this first binary - it's the very
> first user process which is receiving these exceptions.

The problem is not the I-cache, it is just fetched from the main memory.

> Second point is that the page concerned has only recently been mapped
> into that page.  I would be very very surprised if speculative
> instruction prefetch managed to dirty the exact right page via the
> kernel mapping to always cause the first process to fail in some way.

This has nothing to do with speculative prefetching. It's just that the
I-cache is being filled with data from main memory but the D-cache
wasn't flushed (on ARM SMP systems, the D-cache is write-allocate making
this more visible).

Could you or Sudeep clarify whether the driver uses DMA or PIO?

In my case (ext2 over pata_platform), there is no flush_dcache_page()
call after the page was written with data from the CompactFlash (neither
the driver nor the VFS layer do this and we used hardware tracing to
double-check). When the page is mapped into user space,
update_mmu_cache() is called but the page hasn't been marked as dirty
and no D-cache flushing occurs. Calling flush_dcache_page() in
mpage_end_io_read() works around this issue.

-- 
Catalin

