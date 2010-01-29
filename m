Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646Ab0A2QNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0A2QNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481Ab0A2QNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:13:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58575 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab0A2QNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:13:32 -0500
Subject: [PATCH] Call flush_dcache_page around PIO data transfers in
	libata-aff.c
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>
Date: Fri, 29 Jan 2010 16:10:26 +0000
Message-ID: <20100129160150.22571.28609.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-36-g53e3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jan 2010 16:10:26.0828 (UTC) FILETIME=[91E3DCC0:01CAA0FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the direction of the transfer, flush_dcache_page() must be
called either before (ATA_TFLAG_WRITE) or after (!ATA_TFLAG_WRITE) the
data copying to avoid D-cache aliasing with user space or I-D cache
coherency issues (when reading data from an ATA device using PIO, the
kernel dirties the D-cache but there is no flush_dcache_page() required
on Harvard architectures).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
---

This patch allows the ARM boards to use a rootfs on CompactFlash with
the PATA platform driver.

As Anfei Zhou mentioned in a recent patch ("flush dcache before writing
into page to avoid alias"), on some architectures there may be a
performance benefit in differentiating the flush_dcache_page() calls
based on whether the kernel or the user page needs flushing.

IMHO, we should differentiate based on the direction (kernel reading
or writing from/to such page). In the ARM case with PIPT Harvard caches
(newer processors), the kernel reading from a page that may be mapped in
user space shouldn't need cache flushing. The kernel writing to such
page would require D-cache flushing because of coherency with the
I-cache. Currently on ARM, the latter happens in both cases.

Thanks.


 drivers/ata/libata-sff.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 741065c..3d3c854 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -874,6 +874,9 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 
 	DPRINTK("data %s\n", qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
 
+	if (do_write)
+		flush_dcache_page(page);
+
 	if (PageHighMem(page)) {
 		unsigned long flags;
 
@@ -893,6 +896,9 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 				       do_write);
 	}
 
+	if (!do_write)
+		flush_dcache_page(page);
+
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
 

