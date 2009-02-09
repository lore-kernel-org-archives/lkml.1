Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZBIJPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZBIJPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBIJPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:15:36 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:37593 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbZBIJPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:15:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhoFAHuBj0nCTtAn/2dsb2JhbACBbswehBoG
Date: Mon, 9 Feb 2009 10:15:27 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hancockrwd@gmail.com, abelay@mit.edu, lenb@kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] floppy: release only the ports we actually requested
Message-ID: <20090209091527.GA7049@frolo.macqel>
References: <20090205174859.18396.68512.stgit@bob.kio> <20090206085501.GA18125@frolo.macqel> <200902060920.14194.bjorn.helgaas@hp.com> <200902061057.07223.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902061057.07223.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,

On Fri, Feb 06, 2009 at 10:57:06AM -0700, Bjorn Helgaas wrote:
> On Friday 06 February 2009 09:20:13 am Bjorn Helgaas wrote:
> > On Friday 06 February 2009 01:55:01 am Philippe De Muyter wrote:
> > > Bjorn, Andrew,
> > > 
> > > --
> > > 
> > > With the last floppy patch, the floppy driver requests only the ports that
> > > it really uses, but the code contains yet places where it releases those
> > > unrequested ports.  I don't know if it is harmfull, but I think it is cleaner
> > > that the parameters of the release_region calls match the request_region ones.
> > 
> > Doh!  Boy, do I feel stupid.  I doubt this is in any git trees yet,
> > so I'll combine the two patches and send a cleaner one.
> 
> Philippe, can you give this a once-over?  I can compile it, but I don't
> have a machine with a floppy drive handy to test it.  Since you pointed
> out all the places I forgot to change, I went ahead and factored out
> the request/release stuff so they're all in one place now.

As expected, your code works (tested linked in kernel and as a module),
but I took your idea a little bit further, avoiding to keep 3 places with
the io regions list, avoiding gotos and producing a slightly smaller binary.
Of course, it is also compiled and tested both linked in kernel and in module
mode.

Is it OK for you ?

Philippe

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -558,6 +558,8 @@ static void recalibrate_floppy(void);
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
@@ -4358,6 +4358,47 @@ out_put_disk:
 
 static DEFINE_SPINLOCK(floppy_usage_lock);
 
+static struct io_region {
+	int offset;
+	int size;
+} io_regions[] = {
+	{ 2, 1 },
+	/* address + 3 is sometimes reserved by pnp bios for motherboard */
+	{ 4, 2 },
+	/* address + 6 is reserved, and may be taken by IDE.
+	 * Unfortunately, Adaptec doesn't know this :-(, */
+	{ 7, 1 },
+};
+
+static void floppy_release_allocated_regions(int fdc, struct io_region *p)
+{
+	while (p != io_regions) {
+		p--;
+		release_region(FDCS->address + p->offset, p->size);
+	}
+}
+	
+#define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
+
+static int floppy_request_regions(int fdc)
+{
+	struct io_region *p;
+
+	for (p = io_regions; p < ARRAY_END(io_regions); p++) {
+		if (!request_region(FDCS->address + p->offset, p->size, "floppy")) {
+			DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + p->offset);
+			floppy_release_allocated_regions(fdc, p);
+			return -EBUSY;
+		}
+	}
+	return 0;
+}
+
+static void floppy_release_regions(int fdc)
+{
+	floppy_release_allocated_regions(fdc, ARRAY_END(io_regions));
+}
+
 static int floppy_grab_irq_and_dma(void)
 {
 	unsigned long flags;
@@ -4399,18 +4440,8 @@ static int floppy_grab_irq_and_dma(void)
 
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
@@ -4432,15 +4463,11 @@ static int floppy_grab_irq_and_dma(void)
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
@@ -4502,8 +4529,7 @@ static void floppy_release_irq_and_dma(v
 	old_fdc = fdc;
 	for (fdc = 0; fdc < N_FDC; fdc++)
 		if (FDCS->address != -1) {
-			release_region(FDCS->address + 2, 4);
-			release_region(FDCS->address + 7, 1);
+			floppy_release_regions(fdc);
 		}
 	fdc = old_fdc;
 }
