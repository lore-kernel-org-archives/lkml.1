Return-Path: <linux-kernel-owner+w=401wt.eu-S1752409AbYA1QFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbYA1QFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYA1QEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:04:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:35407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbYA1QEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:04:51 -0500
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc	-
	working version - Addon patch 2
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <479DEE10.6060203@keyaccess.nl>
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>
	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Mon, 28 Jan 2008 17:04:49 +0100
Message-Id: <1201536289.20940.425.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-28 at 16:00 +0100, Rene Herman wrote:
> On 28-01-08 15:21, Thomas Renninger wrote:
> 
> > I think I know what is going on.
> > While pnpbios and pnpacpi theoretically do not have limits, isapnp has
> > spec restrictions (AFAIK, I have not read this up, but taken over from
> > previous implementation...).
> > Therefore in isapnp I wanted to stay with:
> > #define PNP_MAX_PORT            8
> > #define PNP_MAX_MEM             4
> > #define PNP_MAX_IRQ             2
> > #define PNP_MAX_DMA             2
> > but I have forgotten to malloc one portion for each at init time, or
> > even better one portion as soon as one is needed.
> 
> Yup.
> 
> > As said, isapnp is more or less untested, thanks a lot for trying out.
> > I will send an updated version soon.
> 
> I"m not sure of the flow of things by the way but if it makes better/nicer 
> code to just pretend that ISAPnP is also unlimited then I'd say to simply do 
> so. ISAPnP is getting obsolete anyway, not anything to optimise for...

Also go the dynamic way in isapnp layer

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pnp/isapnp/core.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6.23/drivers/pnp/isapnp/core.c
===================================================================
--- linux-2.6.23.orig/drivers/pnp/isapnp/core.c
+++ linux-2.6.23/drivers/pnp/isapnp/core.c
@@ -953,7 +953,7 @@ static int isapnp_read_resources(struct 
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 	if (dev->active) {
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
+		for (tmp = 0; pnp_port_ok(dev, tmp); tmp++) {
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
@@ -961,8 +961,10 @@ static int isapnp_read_resources(struct 
 			new_res.flags = IORESOURCE_IO;
 			if (pnp_assign_resource(res, &new_res))
 				pnp_err("Bug in %s", __FUNCTION__);
+			if (tmp > PNP_MAX_PORT)
+				pnp_warn("ISA exceeds spec max port");
 		}
-		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
+		for (tmp = 0; pnp_mem_ok(dev, tmp); tmp++) {
 			ret =
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
@@ -971,8 +973,10 @@ static int isapnp_read_resources(struct 
 			new_res.flags = IORESOURCE_MEM;
 			if (pnp_assign_resource(res, &new_res))
 				pnp_err("Bug in %s", __FUNCTION__);
+			if (tmp > PNP_MAX_MEM)
+				pnp_warn("ISA exceeds spec max mem");
 		}
-		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
+		for (tmp = 0; pnp_irq_ok(dev, tmp); tmp++) {
 			ret =
 			    (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >>
 			     8);
@@ -982,8 +986,11 @@ static int isapnp_read_resources(struct 
 			new_res.flags = IORESOURCE_IRQ;
 			if (pnp_assign_resource(res, &new_res))
 				pnp_err("Bug in %s", __FUNCTION__);
+			if (tmp > PNP_MAX_IRQ)
+				pnp_warn("ISA exceeds spec max irq");
+
 		}
-		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
+		for (tmp = 0; pnp_dma_ok(dev, tmp); tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
@@ -992,6 +999,8 @@ static int isapnp_read_resources(struct 
 			new_res.flags = IORESOURCE_DMA;
 			if (pnp_assign_resource(res, &new_res))
 				pnp_err("Bug in %s", __FUNCTION__);
+			if (tmp > PNP_MAX_DMA)
+				pnp_warn("ISA exceeds spec max dma");
 		}
 	}
 	return 0;
@@ -1017,14 +1026,14 @@ static int isapnp_set_resources(struct p
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0;
-	     tmp < PNP_MAX_PORT
+	     pnp_port_ok(dev, tmp)
 	     && (res->port_resource[tmp].
 		 flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO;
 	     tmp++)
 		isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 				  res->port_resource[tmp].start);
 	for (tmp = 0;
-	     tmp < PNP_MAX_IRQ
+	     pnp_irq_ok(dev, tmp)
 	     && (res->irq_resource[tmp].
 		 flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ;
 	     tmp++) {
@@ -1034,14 +1043,14 @@ static int isapnp_set_resources(struct p
 		isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 	}
 	for (tmp = 0;
-	     tmp < PNP_MAX_DMA
+	     pnp_dma_ok(dev, tmp)
 	     && (res->dma_resource[tmp].
 		 flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA;
 	     tmp++)
 		isapnp_write_byte(ISAPNP_CFG_DMA + tmp,
 				  res->dma_resource[tmp].start);
 	for (tmp = 0;
-	     tmp < PNP_MAX_MEM
+	     pnp_mem_ok(dev, tmp)
 	     && (res->mem_resource[tmp].
 		 flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM;
 	     tmp++)


