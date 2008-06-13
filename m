Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbYFMRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbYFMRXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYFMRXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:23:42 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:48365 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYFMRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:23:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
Date: Fri, 13 Jun 2008 11:23:16 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <200806121557.28505.bjorn.helgaas@hp.com> <48529AAC.3030008@gmail.com>
In-Reply-To: <48529AAC.3030008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131123.16890.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 10:05:00 am Jiri Slaby wrote:
> On 06/12/2008 11:57 PM, Bjorn Helgaas wrote:
> > On Thursday 12 June 2008 03:39:14 pm Jiri Slaby wrote:
> >> On 06/12/2008 11:22 PM, Bjorn Helgaas wrote:
> >>> On Thursday 12 June 2008 03:10:04 pm Jiri Slaby wrote:
> >>>> On 06/11/2008 09:03 PM, Bjorn Helgaas wrote:
> >>>>> Before you go to all the trouble of bisecting it, can you turn on
> >>>>> CONFIG_PNP_DEBUG and try the following debug patch?  I think this
> >>>>> will prevent the oops, but it's just papering over the real problem,
> >>>>> so please capture the complete dmesg log.
> >>>> ACPI: PCI interrupt for device 0000:00:02.0 disabled
> >>>> serial 00:07: disabled
> >>>> serial 00:06: disabled
> >>>> ACPI handle has no context!
> >>>> ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> >>>> ...
> >>>> serial 00:06:   no dma resource to encode!
> >>>> serial 00:06: activated
> >>>> serial 00:07:   no dma resource to encode!
> >>>> serial 00:07: activated
> >>>> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> >>> Interesting.  I wonder why a serial device would have a DMA resource.
> >>> We encode resources by following a template from _CRS, so evidently
> >>> that template had a DMA resource.  Or something deeper is wrong.
> >>>
> >>> Can you send me the rest of that dmesg log?
> >> Below.
> > 
> > Thanks, but it looks like CONFIG_PNP_DEBUG is not turned on.  Can
> > you turn that on and capture the log again, please?
> 
> Here it goes:

Thanks a lot!  Your BIOS clearly claims that at least one of your
serial ports can be configured with DMA:

  pnp 00:07:   dependent set 5 (acceptable) io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
  pnp 00:07:   dependent set 5 (acceptable) irq 3 4 5 6 7 10 11 12 flags 0x1
  pnp 00:07:   dependent set 5 (acceptable) dma 0 1 2 3 (bitmask 0xf) flags 0x0

That's wierd, but whatever, we still have to be careful to give the
BIOS back what it expects, and I think that means we have to keep
track of that disabled DMA resource in pnpacpi_allocated_resource().

Can you please replace the debug patch with the one below and send me
the results again?

Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-11 12:46:28.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-06-13 11:13:21.000000000 -0600
@@ -240,6 +240,7 @@ static acpi_status pnpacpi_allocated_res
 	struct acpi_resource_fixed_memory32 *fixed_memory32;
 	struct acpi_resource_extended_irq *extended_irq;
 	int i, flags;
+	u8 channel;
 
 	switch (res->type) {
 	case ACPI_RESOURCE_TYPE_IRQ:
@@ -259,13 +260,13 @@ static acpi_status pnpacpi_allocated_res
 
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
-		if (dma->channel_count > 0) {
-			flags = dma_flags(dma->type, dma->bus_master,
-					  dma->transfer);
-			if (dma->channels[0] == (u8) -1)
-				flags |= IORESOURCE_DISABLED;
-			pnp_add_dma_resource(dev, dma->channels[0], flags);
+		channel = dma->channels[0];
+		flags = dma_flags(dma->type, dma->bus_master, dma->transfer);
+		if (dma->channel_count == 0 || dma->channels[0] == (u8) -1) {
+			channel = -1;
+			flags = IORESOURCE_DISABLED;
 		}
+		pnp_add_dma_resource(dev, channel, flags);
 		break;
 
 	case ACPI_RESOURCE_TYPE_IO:
@@ -749,6 +750,11 @@ static void pnpacpi_encode_irq(struct pn
 	struct acpi_resource_irq *irq = &resource->data.irq;
 	int triggering, polarity, shareable;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no irq resource to encode!\n");
+		return;
+	}
+
 	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	irq->triggering = triggering;
 	irq->polarity = polarity;
@@ -771,6 +777,11 @@ static void pnpacpi_encode_ext_irq(struc
 	struct acpi_resource_extended_irq *extended_irq = &resource->data.extended_irq;
 	int triggering, polarity, shareable;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no extended irq resource to encode!\n");
+		return;
+	}
+
 	decode_irq_flags(dev, p->flags, &triggering, &polarity, &shareable);
 	extended_irq->producer_consumer = ACPI_CONSUMER;
 	extended_irq->triggering = triggering;
@@ -791,6 +802,11 @@ static void pnpacpi_encode_dma(struct pn
 {
 	struct acpi_resource_dma *dma = &resource->data.dma;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no dma resource to encode!\n");
+		return;
+	}
+
 	/* Note: pnp_assign_dma will copy pnp_dma->flags into p->flags */
 	switch (p->flags & IORESOURCE_DMA_SPEED_MASK) {
 	case IORESOURCE_DMA_TYPEA:
@@ -832,6 +848,11 @@ static void pnpacpi_encode_io(struct pnp
 {
 	struct acpi_resource_io *io = &resource->data.io;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no io resource to encode!\n");
+		return;
+	}
+
 	/* Note: pnp_assign_port will copy pnp_port->flags into p->flags */
 	io->io_decode = (p->flags & IORESOURCE_IO_16BIT_ADDR) ?
 	    ACPI_DECODE_16 : ACPI_DECODE_10;
@@ -851,6 +872,11 @@ static void pnpacpi_encode_fixed_io(stru
 {
 	struct acpi_resource_fixed_io *fixed_io = &resource->data.fixed_io;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no fixed io resource to encode!\n");
+		return;
+	}
+
 	fixed_io->address = p->start;
 	fixed_io->address_length = p->end - p->start + 1;
 
@@ -864,6 +890,11 @@ static void pnpacpi_encode_mem24(struct 
 {
 	struct acpi_resource_memory24 *memory24 = &resource->data.memory24;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no mem24 resource to encode!\n");
+		return;
+	}
+
 	/* Note: pnp_assign_mem will copy pnp_mem->flags into p->flags */
 	memory24->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
@@ -884,6 +915,11 @@ static void pnpacpi_encode_mem32(struct 
 {
 	struct acpi_resource_memory32 *memory32 = &resource->data.memory32;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no mem32 resource to encode!\n");
+		return;
+	}
+
 	memory32->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;
@@ -903,6 +939,11 @@ static void pnpacpi_encode_fixed_mem32(s
 {
 	struct acpi_resource_fixed_memory32 *fixed_memory32 = &resource->data.fixed_memory32;
 
+	if (!p) {
+		dev_err(&dev->dev, "  no fixed_mem32 resource to encode!\n");
+		return;
+	}
+
 	fixed_memory32->write_protect =
 	    (p->flags & IORESOURCE_MEM_WRITEABLE) ?
 	    ACPI_READ_WRITE_MEMORY : ACPI_READ_ONLY_MEMORY;

