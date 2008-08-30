Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYH3VDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYH3VDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYH3VDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:03:09 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:54444 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbYH3VDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:03:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=eylKm1wt+LsmyP2yltRU06cpEW5psc81HTCN1Vlr/W7QluZEOdKoIRBcNSNnpWWCJAR7LH493v0GzTizjn6wULJflzfXPEgh0tYFoyHlg3uBuoX8LSfAal2bWzokfOGe;
Message-ID: <48B9B588.7060709@simon.arlott.org.uk>
Date: Sat, 30 Aug 2008 22:03:04 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk>
In-Reply-To: <48B9B552.8060406@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The capacity printk'd in bytes is divided by 1000000,
whereas 1048576 would be more consistent with the rest
of the OS and disk-related utilities ('df' etc.).

This change replaces the (sz - (sz/625 - 974))/1950
calculation with a simple right shift to output with
five significant digits the capacity in KB, MB, GB, TB,
PB, or EB. Anything beyond this becomes too large...
---
 drivers/scsi/sd.c |   62 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..c47a071 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1290,6 +1290,8 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
+	unsigned long long orig_capacity, sz;
+	char *units;
 
 repeat:
 	retries = 3;
@@ -1429,30 +1431,16 @@ got_data:
 		 */
 		sector_size = 512;
 	}
-	{
-		/*
-		 * The msdos fs needs to know the hardware sector size
-		 * So I have created this table. See ll_rw_blk.c
-		 * Jacques Gelinas (Jacques@solucorp.qc.ca)
-		 */
-		int hard_sector = sector_size;
-		sector_t sz = (sdkp->capacity/2) * (hard_sector/256);
-		struct request_queue *queue = sdp->request_queue;
-		sector_t mb = sz;
-
-		blk_queue_hardsect_size(queue, hard_sector);
-		/* avoid 64-bit division on 32-bit platforms */
-		sector_div(sz, 625);
-		mb -= sz - 974;
-		sector_div(mb, 1950);
 
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%llu %d-byte hardware sectors (%llu MB)\n",
-			  (unsigned long long)sdkp->capacity,
-			  hard_sector, (unsigned long long)mb);
-	}
+	/*
+	 * The msdos fs needs to know the hardware sector size
+	 * So I have created this table. See ll_rw_blk.c
+	 * Jacques Gelinas (Jacques@solucorp.qc.ca)
+	 */
+	blk_queue_hardsect_size(sdp->request_queue, sector_size);
 
 	/* Rescale capacity to 512-byte units */
+	orig_capacity = sdkp->capacity;
 	if (sector_size == 4096)
 		sdkp->capacity <<= 3;
 	else if (sector_size == 2048)
@@ -1463,6 +1451,36 @@ got_data:
 		sdkp->capacity >>= 1;
 
 	sdkp->device->sector_size = sector_size;
+
+	/* Output device size with at most 5 digits,
+	 * this assumes sz is based on a 512-byte
+	 * sector size.
+	 */
+	sz = sdkp->capacity;
+	if (sz >= (unsigned long long)100000*((unsigned long long)2<<40)) {
+		// 100000PB
+		sz >>= 51;
+		units = "EB";
+	} else if (sz >= (unsigned long long)100000*(2<<30)) { // 100000TB
+		sz >>= 41;
+		units = "PB";
+	} else if (sz >= (unsigned long long)100000*(2<<20)) { // 100000GB
+		sz >>= 31;
+		units = "TB";
+	} else if (sz >= 100000*(2<<10)) { // 100000MB
+		sz >>= 21;
+		units = "GB";
+	} else if (sz >= 100000*2) { // 100000KB
+		sz >>= 11;
+		units = "MB";
+	} else {
+		sz >>= 1;
+		units = "KB";
+	}
+	sd_printk(KERN_NOTICE, sdkp,
+		  "%llu %d-byte hardware sectors (%llu %s)\n",
+		  (unsigned long long)orig_capacity, sector_size,
+		  (unsigned long long)sz, units);
 }
 
 /* called with buffer of length 512 */
-- 
1.5.6.5

-- 
Simon Arlott
