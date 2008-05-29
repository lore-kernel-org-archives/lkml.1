Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbYE2OzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbYE2OzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbYE2Oyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:54:54 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:2826 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYE2Oyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:54:53 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch][resend] provide rtc_cmos platform device, take 2
Date: Thu, 29 May 2008 08:54:53 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stas Sergeev <stsp@aknet.ru>, ambx1@neo.rr.com, david-b@pacbell.net,
       mingo@elte.hu, tglx@linutronix.de, dbrownell@users.sourceforge.net,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <200805212334.m4LNY42M006425@imap1.linux-foundation.org> <483BEF1A.3080808@aknet.ru> <20080528163600.b4c3c12c.akpm@linux-foundation.org>
In-Reply-To: <20080528163600.b4c3c12c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805290854.54577.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008 05:36:00 pm Andrew Morton wrote:
> On Tue, 27 May 2008 15:23:06 +0400
> Stas Sergeev <stsp@aknet.ru> wrote:
> 
> > RTC doesn't work with pnpacpi=off.
> > The attached patch fixes the problem by creating the platform device for
> > the RTC when PNP is disabled. This may also help running the PNP-enabled
> > kernel on an older PCs.
> > 
> > Signed-off-by: Stas Sergeev <stsp@aknet.ru>
> > Cc: David Brownell <david-b@pacbell.net>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Cc: Adam Belay <ambx1@neo.rr.com>
> > CC: Russell King <rmk+lkml@arm.linux.org.uk>
> 
> So is everyone happy with this now?
> 
> It got lost from the changelog but IIRC this fixes a small sort-of regression
> which was added in 2.6.25(?) because Stas switched drivers.  I assume
> that the incompatibility was unintentional.
> 
> So it might be 2.6.26 material, and possibly even 2.6.25.x?

I don't really have an opinion on the RTC patch itself, but I would
like to understand why you're using "pnpacpi=off".

As far as I'm concerned, "pnpacpi=off" should only be used to work
around defects, so I'd like to fix the defect you're seeing with
parport_pc.  Is there a bug report for it?

We recently fixed some PNPACPI problems that caused parport_pc
problems, i.e.,
    http://bugzilla.kernel.org/show_bug.cgi?id=5832
    http://bugzilla.kernel.org/show_bug.cgi?id=9487

Andrew added these patches to his -mm tree, but I don't think he's
released a patchset that contains them yet.  I'll attach the patch
in case you want to try it.  Let me know what happens.

Bjorn



PNPACPI: use _CRS IRQ descriptor length for _SRS

When configuring the resources of an ACPI device, we first
evaluate _CRS to get a template of resource descriptors, then
fill in the specific resource values we want, and finally
evaluate _SRS to actually configure the device.

Some resources have optional fields, so the size of encoded
descriptors varies depending on the specific values.  For
example, IRQ descriptors can be either two or three bytes long.
The third byte contains triggering information and can be
omitted if the IRQ is edge-triggered and active high.

The BIOS often assumes that IRQ descriptors in the _SRS
buffer use the same format as those in the _CRS buffer, so
this patch enforces that constraint.

The "Start Dependent Function" descriptor also has an optional
byte, but we don't currently encode those descriptors, so I
didn't do anything for those.

I have tested this patch on a Toshiba Portege 4000.  Without
the patch, parport_pc claims the parallel port only if I use
"pnpacpi=off".  This patch makes it work with PNPACPI.

This is an extension of a patch by Tom Jaeger:
    http://bugzilla.kernel.org/show_bug.cgi?id=9487#c42

References:
    http://bugzilla.kernel.org/show_bug.cgi?id=5832 Enabling ACPI Plug and Play in kernels >2.6.9 kills Parallel support
    http://bugzilla.kernel.org/show_bug.cgi?id=9487 buggy firmware expects four-byte IRQ resource descriptor (was: Serial port disappears after Suspend on Toshiba R25)
    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1d5b285da1893b90507b081664ac27f1a8a3dc5b related ACPICA fix

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work11/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work11.orig/drivers/pnp/pnpacpi/rsparser.c	2008-05-22 13:41:52.000000000 -0600
+++ work11/drivers/pnp/pnpacpi/rsparser.c	2008-05-27 10:34:32.000000000 -0600
@@ -742,6 +742,9 @@ static acpi_status pnpacpi_type_resource
 	if (pnpacpi_supported_resource(res)) {
 		(*resource)->type = res->type;
 		(*resource)->length = sizeof(struct acpi_resource);
+		if (res->type == ACPI_RESOURCE_TYPE_IRQ)
+			(*resource)->data.irq.descriptor_length =
+					res->data.irq.descriptor_length;
 		(*resource)++;
 	}
 
@@ -800,10 +803,12 @@ static void pnpacpi_encode_irq(struct pn
 	irq->interrupt_count = 1;
 	irq->interrupts[0] = p->start;
 
-	dev_dbg(&dev->dev, "  encode irq %d %s %s %s\n", (int) p->start,
+	dev_dbg(&dev->dev, "  encode irq %d %s %s %s (%d-byte descriptor)\n",
+		(int) p->start,
 		triggering == ACPI_LEVEL_SENSITIVE ? "level" : "edge",
 		polarity == ACPI_ACTIVE_LOW ? "low" : "high",
-		irq->sharable == ACPI_SHARED ? "shared" : "exclusive");
+		irq->sharable == ACPI_SHARED ? "shared" : "exclusive",
+		irq->descriptor_length);
 }
 
 static void pnpacpi_encode_ext_irq(struct pnp_dev *dev,
