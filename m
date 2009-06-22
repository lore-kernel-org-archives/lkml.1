Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZFVViR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZFVViR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZFVViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:38:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:37932 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbZFVViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:38:04 -0400
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090622164604.GG29188@n2100.arm.linux.org.uk>
References: <20090622164604.GG29188@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 22 Jun 2009 22:37:52 +0100
Message-Id: <1245706672.15241.6.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 21:37:53.0865 (UTC) FILETIME=[B3250B90:01C9F381]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 17:46 +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 22, 2009 at 05:13:16PM +0100, Catalin Marinas wrote:
> > Could you or Sudeep clarify whether the driver uses DMA or PIO?
> 
> If I knew what this "eMMC" was...

The only eMMC reference I could find is the omap_hsmmc.c driver.
> 
> > In my case (ext2 over pata_platform), there is no flush_dcache_page()
> > call after the page was written with data from the CompactFlash (neither
> > the driver nor the VFS layer do this and we used hardware tracing to
> > double-check). When the page is mapped into user space,
> > update_mmu_cache() is called but the page hasn't been marked as dirty
> > and no D-cache flushing occurs. Calling flush_dcache_page() in
> > mpage_end_io_read() works around this issue.
> 
> As already covered, there's no chance of adding such a call to the
> generic kernel.  It's the responsibility of the drivers to ensure that
> data they read in hits the underlying page - in the same way that DMA
> does.

I'm not proposing to add this call. My patch is a hack to get things
working with any PIO driver. I just wanted to point to the problem I
think Sudeep encountered.

(to summarise for LKML) As it was mentioned in the past, most PIO
drivers don't do any cache flushing. In the mmci.c driver you added a
flush_dcache_call() but other block device drivers only get a pointer to
a buffer and don't have direct access to a struct page pointer. Using
virt_to_page(buffer) may help a bit but the driver would need to
reconstruct the page structures already known to code like fs/mpage.c.
There is also a bio_page() function but I'm not familiar enough with
block device drivers to suggest the best approach.

-- 
Catalin

