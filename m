Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbYG3SO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbYG3SO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYG3SOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:14:50 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:13601 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYG3SOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:14:49 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Fwd: Re: 2.6.27-rc1 oops on boot -- cs423x? (Corrected subject)
Date: Wed, 30 Jul 2008 12:14:30 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-acpi@vger.kernel.org, Pete Clements <clem@clem.clem-digital.net>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200807300839.18425.bjorn.helgaas@hp.com> <20080730164044.GM23938@one.firstfloor.org>
In-Reply-To: <20080730164044.GM23938@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301214.30788.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 10:40:44 am Andi Kleen wrote:
> On Wed, Jul 30, 2008 at 08:39:18AM -0600, Bjorn Helgaas wrote:
> > Hi Andi,
> > 
> > Can you put the patch below in your acpi tree?  It fixes an issue
> > in 2.6.27-rc1 (URL below).  Thanks.
> 
> Does that actually fix an oops or is it just a cosmetic problem?

OK, I looked into it a little more.  Moving the "len = 0" inside the
loop "fixed" the warning, but left the more serious problem that
I had misused snprintf.  The updated patch below fixes both problems.
Thanks for keeping me honest!

Andrew, this should replace this -mm patch:
  pnp-fix-formatting-of-dbg_pnp_show_resources-output.patch



PNP: fix formatting of dbg_pnp_show_resources() output

Each resource should be printed on its own line, so start snprintf'ing
at the beginning of the buffer every time through the loop.

Also, use scnprintf() rather than snprintf() when building up the
buffer to print.  scnprintf() returns the number of characters
actually written into the buffer (not including the trailing NULL).

snprintf() returns the number of characters that *would be* written,
assuming everything would fit in the buffer.  That's nice if we want
to resize the buffer to make sure everything fits, but in this case,
I just want to keep from overflowing the buffer, and it's OK if the
output is truncated.

Using snprintf() meant that my "len" could grow to be more than the
the buffer size, which makes "sizeof(buf) - len" negative, which causes
this alarming WARN_ON:
    http://marc.info/?l=linux-kernel&m=121736480005656&w=2

More useful snprintf/scnprintf discussion:
    http://lwn.net/Articles/69419/

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/support.c |   96 +++++++++++++++++++++++++------------------------
 1 files changed, 49 insertions(+), 47 deletions(-)


diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index bbf78ef..b42df16 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -77,7 +77,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
 #ifdef DEBUG
 	char buf[128];
-	int len = 0;
+	int len;
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
@@ -89,9 +89,10 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
+		len = 0;
 
-		len += snprintf(buf + len, sizeof(buf) - len, "  %-3s ",
-				pnp_resource_type_name(res));
+		len += scnprintf(buf + len, sizeof(buf) - len, "  %-3s ",
+				 pnp_resource_type_name(res));
 
 		if (res->flags & IORESOURCE_DISABLED) {
 			dev_dbg(&dev->dev, "%sdisabled\n", buf);
@@ -101,18 +102,18 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 		switch (pnp_resource_type(res)) {
 		case IORESOURCE_IO:
 		case IORESOURCE_MEM:
-			len += snprintf(buf + len, sizeof(buf) - len,
-					"%#llx-%#llx flags %#lx",
-					(unsigned long long) res->start,
-					(unsigned long long) res->end,
-					res->flags);
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 "%#llx-%#llx flags %#lx",
+					 (unsigned long long) res->start,
+					 (unsigned long long) res->end,
+					 res->flags);
 			break;
 		case IORESOURCE_IRQ:
 		case IORESOURCE_DMA:
-			len += snprintf(buf + len, sizeof(buf) - len,
-					"%lld flags %#lx",
-					(unsigned long long) res->start,
-					res->flags);
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 "%lld flags %#lx",
+					 (unsigned long long) res->start,
+					 res->flags);
 			break;
 		}
 		dev_dbg(&dev->dev, "%s\n", buf);
@@ -144,66 +145,67 @@ void dbg_pnp_show_option(struct pnp_dev *dev, struct pnp_option *option)
 	struct pnp_dma *dma;
 
 	if (pnp_option_is_dependent(option))
-		len += snprintf(buf + len, sizeof(buf) - len,
-				"  dependent set %d (%s) ",
-				pnp_option_set(option),
-				pnp_option_priority_name(option));
+		len += scnprintf(buf + len, sizeof(buf) - len,
+				 "  dependent set %d (%s) ",
+				 pnp_option_set(option),
+				 pnp_option_priority_name(option));
 	else
-		len += snprintf(buf + len, sizeof(buf) - len, "  independent ");
+		len += scnprintf(buf + len, sizeof(buf) - len,
+				 "  independent ");
 
 	switch (option->type) {
 	case IORESOURCE_IO:
 		port = &option->u.port;
-		len += snprintf(buf + len, sizeof(buf) - len, "io  min %#llx "
-				"max %#llx align %lld size %lld flags %#x",
-				(unsigned long long) port->min,
-				(unsigned long long) port->max,
-				(unsigned long long) port->align,
-				(unsigned long long) port->size, port->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, "io  min %#llx "
+				 "max %#llx align %lld size %lld flags %#x",
+				 (unsigned long long) port->min,
+				 (unsigned long long) port->max,
+				 (unsigned long long) port->align,
+				 (unsigned long long) port->size, port->flags);
 		break;
 	case IORESOURCE_MEM:
 		mem = &option->u.mem;
-		len += snprintf(buf + len, sizeof(buf) - len, "mem min %#llx "
-				"max %#llx align %lld size %lld flags %#x",
-				(unsigned long long) mem->min,
-				(unsigned long long) mem->max,
-				(unsigned long long) mem->align,
-				(unsigned long long) mem->size, mem->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, "mem min %#llx "
+				 "max %#llx align %lld size %lld flags %#x",
+				 (unsigned long long) mem->min,
+				 (unsigned long long) mem->max,
+				 (unsigned long long) mem->align,
+				 (unsigned long long) mem->size, mem->flags);
 		break;
 	case IORESOURCE_IRQ:
 		irq = &option->u.irq;
-		len += snprintf(buf + len, sizeof(buf) - len, "irq");
+		len += scnprintf(buf + len, sizeof(buf) - len, "irq");
 		if (bitmap_empty(irq->map.bits, PNP_IRQ_NR))
-			len += snprintf(buf + len, sizeof(buf) - len,
-					" <none>");
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 " <none>");
 		else {
 			for (i = 0; i < PNP_IRQ_NR; i++)
 				if (test_bit(i, irq->map.bits))
-					len += snprintf(buf + len,
-							sizeof(buf) - len,
-							" %d", i);
+					len += scnprintf(buf + len,
+							 sizeof(buf) - len,
+							 " %d", i);
 		}
-		len += snprintf(buf + len, sizeof(buf) - len, " flags %#x",
-				irq->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, " flags %#x",
+				 irq->flags);
 		if (irq->flags & IORESOURCE_IRQ_OPTIONAL)
-			len += snprintf(buf + len, sizeof(buf) - len,
-					" (optional)");
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 " (optional)");
 		break;
 	case IORESOURCE_DMA:
 		dma = &option->u.dma;
-		len += snprintf(buf + len, sizeof(buf) - len, "dma");
+		len += scnprintf(buf + len, sizeof(buf) - len, "dma");
 		if (!dma->map)
-			len += snprintf(buf + len, sizeof(buf) - len,
-					" <none>");
+			len += scnprintf(buf + len, sizeof(buf) - len,
+					 " <none>");
 		else {
 			for (i = 0; i < 8; i++)
 				if (dma->map & (1 << i))
-					len += snprintf(buf + len,
-							sizeof(buf) - len,
-							" %d", i);
+					len += scnprintf(buf + len,
+							 sizeof(buf) - len,
+							 " %d", i);
 		}
-		len += snprintf(buf + len, sizeof(buf) - len, " (bitmask %#x) "
-				"flags %#x", dma->map, dma->flags);
+		len += scnprintf(buf + len, sizeof(buf) - len, " (bitmask %#x) "
+				 "flags %#x", dma->map, dma->flags);
 		break;
 	}
 	dev_dbg(&dev->dev, "%s\n", buf);
