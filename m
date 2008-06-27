Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbYF0XFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbYF0XFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764616AbYF0W7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:10 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:1054 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764346AbYF0W67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:58:59 -0400
Message-Id: <20080627225800.926365532@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:04 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-acpi@vger.kernel.org, Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 13/28] PNP: make resource option structures private to PNP subsystem
Content-Disposition: inline; filename=pnp-make-option-structures-private
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside the PNP subsystem should need access to a
device's resource options, so this patch moves the option
structure declarations to a private header file.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work14/drivers/pnp/base.h
===================================================================
--- work14.orig/drivers/pnp/base.h	2008-06-17 14:40:28.000000000 -0600
+++ work14/drivers/pnp/base.h	2008-06-17 14:42:28.000000000 -0600
@@ -19,6 +19,54 @@ void pnp_remove_card(struct pnp_card *ca
 int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
 void pnp_remove_card_device(struct pnp_dev *dev);
 
+struct pnp_port {
+	unsigned short min;	/* min base number */
+	unsigned short max;	/* max base number */
+	unsigned char align;	/* align boundary */
+	unsigned char size;	/* size of range */
+	unsigned char flags;	/* port flags */
+	unsigned char pad;	/* pad */
+	struct pnp_port *next;	/* next port */
+};
+
+#define PNP_IRQ_NR 256
+struct pnp_irq {
+	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmask for IRQ lines */
+	unsigned char flags;	/* IRQ flags */
+	unsigned char pad;	/* pad */
+	struct pnp_irq *next;	/* next IRQ */
+};
+
+struct pnp_dma {
+	unsigned char map;	/* bitmask for DMA channels */
+	unsigned char flags;	/* DMA flags */
+	struct pnp_dma *next;	/* next port */
+};
+
+struct pnp_mem {
+	unsigned int min;	/* min base number */
+	unsigned int max;	/* max base number */
+	unsigned int align;	/* align boundary */
+	unsigned int size;	/* size of range */
+	unsigned char flags;	/* memory flags */
+	unsigned char pad;	/* pad */
+	struct pnp_mem *next;	/* next memory resource */
+};
+
+#define PNP_RES_PRIORITY_PREFERRED	0
+#define PNP_RES_PRIORITY_ACCEPTABLE	1
+#define PNP_RES_PRIORITY_FUNCTIONAL	2
+#define PNP_RES_PRIORITY_INVALID	65535
+
+struct pnp_option {
+	unsigned short priority;	/* priority */
+	struct pnp_port *port;		/* first port */
+	struct pnp_irq *irq;		/* first IRQ */
+	struct pnp_dma *dma;		/* first DMA */
+	struct pnp_mem *mem;		/* first memory resource */
+	struct pnp_option *next;	/* used to chain dependent resources */
+};
+
 struct pnp_option *pnp_build_option(int priority);
 struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
 struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
Index: work14/include/linux/pnp.h
===================================================================
--- work14.orig/include/linux/pnp.h	2008-06-17 14:41:18.000000000 -0600
+++ work14/include/linux/pnp.h	2008-06-17 14:42:28.000000000 -0600
@@ -182,54 +182,6 @@ static inline int pnp_dma_valid(struct p
 }
 
 
-struct pnp_port {
-	unsigned short min;	/* min base number */
-	unsigned short max;	/* max base number */
-	unsigned char align;	/* align boundary */
-	unsigned char size;	/* size of range */
-	unsigned char flags;	/* port flags */
-	unsigned char pad;	/* pad */
-	struct pnp_port *next;	/* next port */
-};
-
-#define PNP_IRQ_NR 256
-struct pnp_irq {
-	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmask for IRQ lines */
-	unsigned char flags;	/* IRQ flags */
-	unsigned char pad;	/* pad */
-	struct pnp_irq *next;	/* next IRQ */
-};
-
-struct pnp_dma {
-	unsigned char map;	/* bitmask for DMA channels */
-	unsigned char flags;	/* DMA flags */
-	struct pnp_dma *next;	/* next port */
-};
-
-struct pnp_mem {
-	unsigned int min;	/* min base number */
-	unsigned int max;	/* max base number */
-	unsigned int align;	/* align boundary */
-	unsigned int size;	/* size of range */
-	unsigned char flags;	/* memory flags */
-	unsigned char pad;	/* pad */
-	struct pnp_mem *next;	/* next memory resource */
-};
-
-#define PNP_RES_PRIORITY_PREFERRED	0
-#define PNP_RES_PRIORITY_ACCEPTABLE	1
-#define PNP_RES_PRIORITY_FUNCTIONAL	2
-#define PNP_RES_PRIORITY_INVALID	65535
-
-struct pnp_option {
-	unsigned short priority;	/* priority */
-	struct pnp_port *port;		/* first port */
-	struct pnp_irq *irq;		/* first IRQ */
-	struct pnp_dma *dma;		/* first DMA */
-	struct pnp_mem *mem;		/* first memory resource */
-	struct pnp_option *next;	/* used to chain dependent resources */
-};
-
 /*
  * Device Management
  */

-- 
