Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZBDA3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZBDA3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZBDA3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:29:09 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:39375 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZBDA3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:29:08 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Adam M Belay <abelay@mit.edu>
Subject: Re: [BUG] pnpbios breaks floppy support
Date: Tue, 3 Feb 2009 17:29:01 -0700
User-Agent: KMail/1.9.10
Cc: Robert Hancock <hancockrwd@gmail.com>, Philippe De Muyter <phdm@macqel.be>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
References: <20090131212915.GA19276@frolo.macqel> <49861E88.8060809@gmail.com> <20090202014331.xt99kri8xd0k00k4@webmail.mit.edu>
In-Reply-To: <20090202014331.xt99kri8xd0k00k4@webmail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031729.02286.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 February 2009 11:43:31 pm Adam M Belay wrote:
> >>>>> 	$ cat 00:03/resources
> >>>>> 	state = active 
> >>>>> 	io 0x3f4-0x3f5
> >>>>> 	io 0x3f2-0x3f2

> >> 	$ cat 00:07/id 00:07/resources
> >> 	PNP0c02
> >> 	state = active
> >> 	io 0x80-0x80
> >> 	io 0x10-0x1f
> >> 	io 0x22-0x3f
> >> 	io 0x44-0x5f
> >> 	io 0x90-0x9f
> >> 	io 0xa2-0xbf
> >> 	io 0x3f0-0x3f1
> >> 	io 0x3f3-0x3f3

> Ok, so it appears that we have a genuine resource conflict with the
> system device (00:07).  This is because the floppy driver is requesting
> four consecutive I/O ports rather than the two ports reported by the
> PnPBIOS.

As far as I can tell, floppy.c uses only these registers:
  0x3f2 (FD_DOR)
  0x3f4 (FD_STATUS)
  0x3f5 (FD_DATA)
  0x3f7 (FD_DCR/FD_DIR)

But it requests 0x3f2-0x3f5 and 0x3f7.  That includes the unused
register at 0x3f3, hence the conflict with 00:07.

I think we should just change floppy.c to request only ports
2, 4-5, and 7, with something like the patch below.  Philippe,
can you give it a try?

> Bjorn, I think it might make sense to eventually have the PnP layer
> register resources with request_region() instead of handling it in
> device drivers.  What do you think?  In the short term we could either
> skip the floppy driver's call to request_region() when using PnP detection
> or have it use the length reported in the resource descriptor.  Still, I'm
> curious which I/O ports the driver is actually using.

In PCI, we do both: the core requests resources based on the BAR values,
and the drivers request the actual resources they need.  I think that's
important because we account for the resources used by devices without
drivers.

I would really like the PNP core to do something similar eventually.
We actually tried it a year or so ago in the -mm tree, but there are
some subtleties that I didn't fully comprehend, so we had to back it
out.  Here are some of the threads from that attempt:

  http://lkml.org/lkml/2007/10/29/412 (RFC)
  http://lkml.org/lkml/2007/11/1/214 (repost)
  http://lkml.org/lkml/2007/11/29/451 (suspend/resume problem)
  http://lkml.org/lkml/2007/12/5/227 (more suspend/resume fiddling)
  http://lkml.org/lkml/2007/12/11/200 (causes critical temp shutdown)

Bjorn


diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cf29cc4..44f711b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4399,15 +4399,20 @@ static int floppy_grab_irq_and_dma(void)
 
 	for (fdc = 0; fdc < N_FDC; fdc++) {
 		if (FDCS->address != -1) {
-			if (!request_region(FDCS->address + 2, 4, "floppy")) {
+			if (!request_region(FDCS->address + 2, 1, "floppy")) {
 				DPRINT("Floppy io-port 0x%04lx in use\n",
 				       FDCS->address + 2);
 				goto cleanup1;
 			}
+			if (!request_region(FDCS->address + 4, 2, "floppy")) {
+				DPRINT("Floppy io-port 0x%04lx in use\n",
+				       FDCS->address + 4);
+				goto cleanup2;
+			}
 			if (!request_region(FDCS->address + 7, 1, "floppy DIR")) {
 				DPRINT("Floppy io-port 0x%04lx in use\n",
 				       FDCS->address + 7);
-				goto cleanup2;
+				goto cleanup3;
 			}
 			/* address + 6 is reserved, and may be taken by IDE.
 			 * Unfortunately, Adaptec doesn't know this :-(, */
@@ -4432,13 +4437,16 @@ static int floppy_grab_irq_and_dma(void)
 	fdc = 0;
 	irqdma_allocated = 1;
 	return 0;
+cleanup3:
+	release_region(FDCS->address + 4, 2);
 cleanup2:
-	release_region(FDCS->address + 2, 4);
+	release_region(FDCS->address + 2, 1);
 cleanup1:
 	fd_free_irq();
 	fd_free_dma();
 	while (--fdc >= 0) {
-		release_region(FDCS->address + 2, 4);
+		release_region(FDCS->address + 2, 1);
+		release_region(FDCS->address + 4, 2);
 		release_region(FDCS->address + 7, 1);
 	}
 	spin_lock_irqsave(&floppy_usage_lock, flags);
