Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbYCZRKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbYCZRKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbYCZRIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:08:34 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21887 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbYCZRIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:08:32 -0400
Message-Id: <20080326171224.311103555@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:03 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 05/37] ISAPNP: pull pnp_add_id() out of isapnp_parse_id()
Content-Disposition: inline; filename=isapnp-restructure-parse-id
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the pnp_add_id() part from the PNPID conversion part so we
can move the initial add_id() into the pnp_dev allocation.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-21 15:31:25.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-21 15:32:15.000000000 -0600
@@ -400,11 +400,9 @@
 /*
  *  Parse EISA id.
  */
-static void isapnp_parse_id(struct pnp_dev *dev, unsigned short vendor,
-			    unsigned short device)
+static void isapnp_to_pnpid(unsigned short vendor, unsigned short device,
+			    char *id)
 {
-	char id[8];
-
 	id[0] = 'A' + ((vendor >> 2) & 0x3f) - 1;
 	id[1] = 'A' + (((vendor & 3) << 3) | ((vendor >> 13) & 7)) - 1;
 	id[2] = 'A' + ((vendor >> 8) & 0x1f) - 1;
@@ -413,8 +411,6 @@
 	id[5] = '0' + ((device >> 12) & 0x0f);
 	id[6] = '0' + ((device >> 8) & 0x0f);
 	id[7] = '\0';
-
-	pnp_add_id(dev, id);
 }
 
 /*
@@ -424,6 +420,7 @@
 						  int size, int number)
 {
 	unsigned char tmp[6];
+	char id[8];
 	struct pnp_dev *dev;
 
 	isapnp_peek(tmp, size);
@@ -431,7 +428,8 @@
 	if (!dev)
 		return NULL;
 	dev->number = number;
-	isapnp_parse_id(dev, (tmp[1] << 8) | tmp[0], (tmp[3] << 8) | tmp[2]);
+	isapnp_to_pnpid((tmp[1] << 8) | tmp[0], (tmp[3] << 8) | tmp[2], id);
+	pnp_add_id(dev, id);
 	dev->regs = tmp[4];
 	dev->card = card;
 	if (size > 5)
@@ -621,6 +619,7 @@
 	unsigned char type, tmp[17];
 	struct pnp_option *option;
 	struct pnp_dev *dev;
+	char id[8];
 
 	if ((dev = isapnp_parse_device(card, size, number++)) == NULL)
 		return 1;
@@ -660,8 +659,9 @@
 		case _STAG_COMPATDEVID:
 			if (size == 4 && compat < DEVICE_COUNT_COMPATIBLE) {
 				isapnp_peek(tmp, 4);
-				isapnp_parse_id(dev, (tmp[1] << 8) | tmp[0],
-						(tmp[3] << 8) | tmp[2]);
+				isapnp_to_pnpid((tmp[1] << 8) | tmp[0],
+						(tmp[3] << 8) | tmp[2], id);
+				pnp_add_id(dev, id);
 				compat++;
 				size = 0;
 			}

-- 
