Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbXK1ORO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbXK1ORO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXK1OQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:16:58 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6003 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbXK1OQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:16:57 -0500
Message-ID: <474D784C.6050300@panasas.com>
Date: Wed, 28 Nov 2007 16:16:44 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2
References: <20071128034140.648383f0.akpm@linux-foundation.org>
In-Reply-To: <20071128034140.648383f0.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------010301020309060807030005"
X-OriginalArrivalTime: 28 Nov 2007 14:16:46.0208 (UTC) FILETIME=[4EE81800:01C831C9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010301020309060807030005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Wed, Nov 28 2007 at 13:41 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/
> 
> - All patches against subsystem trees were recently sent to the relevant
>   maintainers.  Many (probably most) were ignored.  I don't know why this
>   happens.
> 
> - First bug report: after ten minutes happily compiling kernels my
>   2.6.24-rc3-mm2 x86_64 box spontaneously rebooted.
> 
> - s390 won't build due to a large clash with the driver tree which I didn't
>   fix.
> 
> - the unprivileged mounts and revoke patchsets were dropped - they were
>   getting in the way of other work and were somewhat out of date.
> 
> - I won't be paying much attention to feature patches for the rest of the
>   2.6.24 development cycle.  We need to get the existing queue stabilised and
>   I left this too late in 2.6.23.
> 
>   This only affects the patches which are only in -mm: expect ongoing mayhem
>   in the various subsystem trees.
> 
> 
> 
<snip>
> Boilerplate:
> 
> 
> Changes since 2.6.24-rc3-mm1:
> 
<snip>
>  git-scsi-misc.patch
>  git-scsi-rc-fixes.patch
<snip>
> 
>  git trees
> 
<snip>
> All patches:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm2/patch-list
> 
> 
<from above url>
> bidi-support-scsi_data_buffer-broke-qla1280.patch
>   bidi-support-scsi_data_buffer-broke-qla1280
> 
> bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
>   bidi-support-scsi_data_buffer-broke-lots-of-stuff

Andrew hi.

Above 2 patches are no longer needed as they are fixed.
qla1280 - is in git-scsi-rc-fixes.patch and
ppa & imm - are in git-scsi-misc.patch

on the other hand arm-scsi is broken and its patch
is in scsi-pending. I have attached a scsi-pending-arm-convert-to-accessors.patch
for your convenience.

Thanks Boaz


--------------010301020309060807030005
Content-Type: text/plain;
 name="scsi-pending-arm-convert-to-accessors.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-pending-arm-convert-to-accessors.patch"

>From 8f21118911efce786fc1707644a4e6323521a92f Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Sun, 9 Sep 2007 21:31:21 +0300
Subject: [PATCH] [SCSI] arm: convert to accessors and !use_sg cleanup

 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/arm/acornscsi.c |   14 +++++++-------
 drivers/scsi/arm/scsi.h      |   34 +++++++++++-----------------------
 2 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index eceacf6..3bedf24 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -1790,7 +1790,7 @@ int acornscsi_starttransfer(AS_Host *host)
 	return 0;
     }
 
-    residual = host->SCpnt->request_bufflen - host->scsi.SCp.scsi_xferred;
+    residual = scsi_bufflen(host->SCpnt) - host->scsi.SCp.scsi_xferred;
 
     sbic_arm_write(host->scsi.io_port, SBIC_SYNCHTRANSFER, host->device[host->SCpnt->device->id].sync_xfer);
     sbic_arm_writenext(host->scsi.io_port, residual >> 16);
@@ -2270,7 +2270,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA IN -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_readstatusbyte(host);
@@ -2281,7 +2281,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA IN -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_sendmessage(host);
@@ -2291,7 +2291,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA IN -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_message(host);	/* -> PHASE_MSGIN, PHASE_DISCONNECT		*/
@@ -2319,7 +2319,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4b:			/* -> PHASE_STATUSIN				*/
 	case 0x8b:			/* -> PHASE_STATUSIN				*/
 	    /* DATA OUT -> STATUS */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2331,7 +2331,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4e:			/* -> PHASE_MSGOUT				*/
 	case 0x8e:			/* -> PHASE_MSGOUT				*/
 	    /* DATA OUT -> MESSAGE OUT */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
@@ -2342,7 +2342,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x4f:			/* message in					*/
 	case 0x8f:			/* message in					*/
 	    /* DATA OUT -> MESSAGE IN */
-	    host->scsi.SCp.scsi_xferred = host->SCpnt->request_bufflen -
+	    host->scsi.SCp.scsi_xferred = scsi_bufflen(host->SCpnt) -
 					  acornscsi_sbic_xfcount(host);
 	    acornscsi_dma_stop(host);
 	    acornscsi_dma_adjust(host);
diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
index bb6550e..c7415fc 100644
--- a/drivers/scsi/arm/scsi.h
+++ b/drivers/scsi/arm/scsi.h
@@ -68,46 +68,34 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
 {
 	memset(&SCpnt->SCp, 0, sizeof(struct scsi_pointer));
 
-	if (SCpnt->use_sg) {
+	if (scsi_bufflen(SCpnt)) {
 		unsigned long len = 0;
 		int buf;
 
-		SCpnt->SCp.buffer = (struct scatterlist *) SCpnt->request_buffer;
-		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
+		SCpnt->SCp.buffer = scsi_sglist(SCpnt);
+		SCpnt->SCp.buffers_residual = scsi_sg_count(SCpnt) - 1;
 		SCpnt->SCp.ptr = sg_virt(SCpnt->SCp.buffer);
 		SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
-		SCpnt->SCp.phase = SCpnt->request_bufflen;
+		SCpnt->SCp.phase = scsi_bufflen(SCpnt);
 
 #ifdef BELT_AND_BRACES
 		/*
 		 * Calculate correct buffer length.  Some commands
-		 * come in with the wrong request_bufflen.
+		 * come in with the wrong scsi_bufflen.
 		 */
 		for (buf = 0; buf <= SCpnt->SCp.buffers_residual; buf++)
 			len += SCpnt->SCp.buffer[buf].length;
 
-		if (SCpnt->request_bufflen != len)
+		if (scsi_bufflen(SCpnt) != len) {
+			WARN_ON(1);
 			printk(KERN_WARNING "scsi%d.%c: bad request buffer "
 			       "length %d, should be %ld\n", SCpnt->device->host->host_no,
-			       '0' + SCpnt->device->id, SCpnt->request_bufflen, len);
-		SCpnt->request_bufflen = len;
+			       '0' + SCpnt->device->id, scsi_bufflen(SCpnt), len);
+		}
 #endif
 	} else {
-		SCpnt->SCp.ptr = (unsigned char *)SCpnt->request_buffer;
-		SCpnt->SCp.this_residual = SCpnt->request_bufflen;
-		SCpnt->SCp.phase = SCpnt->request_bufflen;
-	}
-
-	/*
-	 * If the upper SCSI layers pass a buffer, but zero length,
-	 * we aren't interested in the buffer pointer.
-	 */
-	if (SCpnt->SCp.this_residual == 0 && SCpnt->SCp.ptr) {
-#if 0 //def BELT_AND_BRACES
-		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
-		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
-		__scsi_print_command(SCpnt->cmnd);
-#endif
 		SCpnt->SCp.ptr = NULL;
+		SCpnt->SCp.this_residual = 0;
+		SCpnt->SCp.phase = 0;
 	}
 }
-- 
1.5.3.1


--------------010301020309060807030005--
