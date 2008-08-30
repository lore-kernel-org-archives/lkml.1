Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYH3OIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYH3OIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYH3OIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:08:47 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:57091 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYH3OIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:08:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
	b=jrTc57+itNJxL+PN6mG1qzr0Do4m1A7WHAiPih9NIg33E4f4FOhTn/29HuQz8h5MofaGwp6Z5UAwM7ndqiX9ys8AfJF/vCbkUy4fCFht+SLSyDT0b+XaLcSSuymR7EFl;
Message-ID: <48B9546B.4010004@simon.arlott.org.uk>
Date: Sat, 30 Aug 2008 15:08:43 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@HansenPartnership.com
Subject: [PATCH] scsi/sd: Fix size output in MB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The capacity printk'd in bytes is divided by 1000000,
whereas 1048576 would be more consistent with the rest
of the OS and disk-related utilities ('df' etc.).

This change replaces the (sz - (sz/625 - 974))/1950
calculation with a simple right shift by 11 bits
(/2048).

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/scsi/sd.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..e6fd6fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1441,10 +1441,8 @@ got_data:
 		sector_t mb = sz;
 
 		blk_queue_hardsect_size(queue, hard_sector);
-		/* avoid 64-bit division on 32-bit platforms */
-		sector_div(sz, 625);
-		mb -= sz - 974;
-		sector_div(mb, 1950);
+		/* Convert to megabytes (/2048) */
+		mb = sz >> 11;
 
 		sd_printk(KERN_NOTICE, sdkp,
 			  "%llu %d-byte hardware sectors (%llu MB)\n",
-- 
1.5.6.5

-- 
Simon Arlott



