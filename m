Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZFWOfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZFWOfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZFWOfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:35:08 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:32931 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544AbZFWOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:35:07 -0400
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20090622164604.GG29188@n2100.arm.linux.org.uk>
References: <20090622164604.GG29188@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 23 Jun 2009 15:34:17 +0100
Message-Id: <1245767657.16488.38.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2009 14:34:18.0593 (UTC) FILETIME=[B0E00D10:01C9F40F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 17:46 +0100, Russell King - ARM Linux wrote:
> On Mon, Jun 22, 2009 at 05:13:16PM +0100, Catalin Marinas wrote:
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

The patch below appears to solve the problem with CompactFlash using
pata_platform (I cc'ed linux-ide since the patch changes their code).
The patch only handles the read case but similarly it may need to handle
the write case if D-cache aliasing between user and kernel mappings
exists.

For the USB mass storage, I haven't yet figured out the best place to
call flush_dcache_page().



Call flush_dcache_page after PIO data transfer in libata-aff.c

From: Catalin Marinas <catalin.marinas@arm.com>

When reading data from an ATA device using PIO, the kernel dirties the
D-cache but there is no flush_dcache_page() call in ata_pio_sector().
Since neither the VFS layer calls this function, a subsequent
update_mmu_cache() is not aware of the dirty page which may lead to
cache incoherency in user space.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 drivers/ata/libata-sff.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index bbbb1fa..2ae15c3 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -893,6 +893,9 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 				       do_write);
 	}
 
+	if (!do_write)
+		flush_dcache_page(page);
+
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
 

-- 
Catalin

