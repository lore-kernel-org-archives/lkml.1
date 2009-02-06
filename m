Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbZBFR5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbZBFR5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZBFR5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:57:38 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:8263 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZBFR5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:57:37 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Philippe De Muyter <phdm@macqel.be>
Subject: Re: [PATCH] floppy: release only the ports we actually requested
Date: Fri, 6 Feb 2009 10:57:06 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hancockrwd@gmail.com, abelay@mit.edu, lenb@kernel.org,
       stable@kernel.org
References: <20090205174859.18396.68512.stgit@bob.kio> <20090206085501.GA18125@frolo.macqel> <200902060920.14194.bjorn.helgaas@hp.com>
In-Reply-To: <200902060920.14194.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902061057.07223.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 February 2009 09:20:13 am Bjorn Helgaas wrote:
> On Friday 06 February 2009 01:55:01 am Philippe De Muyter wrote:
> > Bjorn, Andrew,
> > 
> > --
> > 
> > With the last floppy patch, the floppy driver requests only the ports that
> > it really uses, but the code contains yet places where it releases those
> > unrequested ports.  I don't know if it is harmfull, but I think it is cleaner
> > that the parameters of the release_region calls match the request_region ones.
> 
> Doh!  Boy, do I feel stupid.  I doubt this is in any git trees yet,
> so I'll combine the two patches and send a cleaner one.

Philippe, can you give this a once-over?  I can compile it, but I don't
have a machine with a floppy drive handy to test it.  Since you pointed
out all the places I forgot to change, I went ahead and factored out
the request/release stuff so they're all in one place now.

Bjorn


diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf29cc4..c2b3db4 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -558,6 +558,8 @@ static void process_fd_request(void);
 static void recalibrate_floppy(void);
 static void floppy_shutdown(unsigned long);
 
+static int floppy_request_regions(int);
+static void floppy_release_regions(int);
 static int floppy_grab_irq_and_dma(void);
 static void floppy_release_irq_and_dma(void);
 
@@ -4274,8 +4276,7 @@ static int __init floppy_init(void)
 		FDCS->rawcmd = 2;
 		if (user_reset_fdc(-1, FD_RESET_ALWAYS, 0)) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
-			release_region(FDCS->address + 2, 4);
-			release_region(FDCS->address + 7, 1);
+			floppy_release_regions(fdc);
 			FDCS->address = -1;
 			FDCS->version = FDC_NONE;
 			continue;
@@ -4284,8 +4285,7 @@ static int __init floppy_init(void)
 		FDCS->version = get_fdc_version();
 		if (FDCS->version == FDC_NONE) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
-			release_region(FDCS->address + 2, 4);
-			release_region(FDCS->address + 7, 1);
+			floppy_release_regions(fdc);
 			FDCS->address = -1;
 			continue;
 		}
@@ -4358,6 +4358,38 @@ out_put_disk:
 
 static DEFINE_SPINLOCK(floppy_usage_lock);
 
+static int floppy_request_regions(int fdc)
+{
+	if (!request_region(FDCS->address + 2, 1, "floppy")) {
+		DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + 2);
+		return -EBUSY;
+	}
+	if (!request_region(FDCS->address + 4, 2, "floppy")) {
+		DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + 4);
+		goto cleanup1;
+	}
+	if (!request_region(FDCS->address + 7, 1, "floppy DIR")) {
+		DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + 7);
+		goto cleanup2;
+	}
+	/* address + 6 is reserved, and may be taken by IDE.
+	 * Unfortunately, Adaptec doesn't know this :-(, */
+	return 0;
+
+cleanup2:
+	release_region(FDCS->address + 4, 2);
+cleanup1:
+	release_region(FDCS->address + 2, 1);
+	return -EBUSY;
+}
+
+static void floppy_release_regions(int fdc)
+{
+	release_region(FDCS->address + 2, 1);
+	release_region(FDCS->address + 4, 2);
+	release_region(FDCS->address + 7, 1);
+}
+
 static int floppy_grab_irq_and_dma(void)
 {
 	unsigned long flags;
@@ -4399,18 +4431,8 @@ static int floppy_grab_irq_and_dma(void)
 
 	for (fdc = 0; fdc < N_FDC; fdc++) {
 		if (FDCS->address != -1) {
-			if (!request_region(FDCS->address + 2, 4, "floppy")) {
-				DPRINT("Floppy io-port 0x%04lx in use\n",
-				       FDCS->address + 2);
-				goto cleanup1;
-			}
-			if (!request_region(FDCS->address + 7, 1, "floppy DIR")) {
-				DPRINT("Floppy io-port 0x%04lx in use\n",
-				       FDCS->address + 7);
-				goto cleanup2;
-			}
-			/* address + 6 is reserved, and may be taken by IDE.
-			 * Unfortunately, Adaptec doesn't know this :-(, */
+			if (floppy_request_regions(fdc))
+				goto cleanup;
 		}
 	}
 	for (fdc = 0; fdc < N_FDC; fdc++) {
@@ -4432,15 +4454,11 @@ static int floppy_grab_irq_and_dma(void)
 	fdc = 0;
 	irqdma_allocated = 1;
 	return 0;
-cleanup2:
-	release_region(FDCS->address + 2, 4);
-cleanup1:
+cleanup:
 	fd_free_irq();
 	fd_free_dma();
-	while (--fdc >= 0) {
-		release_region(FDCS->address + 2, 4);
-		release_region(FDCS->address + 7, 1);
-	}
+	while (--fdc >= 0)
+		floppy_release_regions(fdc);
 	spin_lock_irqsave(&floppy_usage_lock, flags);
 	usage_count--;
 	spin_unlock_irqrestore(&floppy_usage_lock, flags);
@@ -4502,8 +4520,7 @@ static void floppy_release_irq_and_dma(void)
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)
 		if (FDCS->address != -1) {
-			release_region(FDCS->address + 2, 4);
-			release_region(FDCS->address + 7, 1);
+			floppy_release_regions(fdc);
 		}
 	fdc = old_fdc;
 }
