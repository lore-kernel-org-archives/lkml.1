Return-Path: <linux-kernel-owner+w=401wt.eu-S1763487AbYFDWQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763487AbYFDWQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 18:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762199AbYFDWMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 18:12:06 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33605 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762727AbYFDWL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 18:11:59 -0400
Message-Id: <20080604221129.955112741@ldl.fc.hp.com>
References: <20080604220933.168145536@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 16:09:49 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
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
Subject: [patch 16/18] PNP: remove extra 0x100 bit from option priority
Content-Disposition: inline; filename=pnp-remove-extra-priority-bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building resource options, ISAPNP and PNPBIOS set the priority
to something like "0x100 | PNP_RES_PRIORITY_ACCEPTABLE", but we 
immediately mask off the 0x100 again in pnp_build_option(), so that
bit looks superfluous.

Thanks to Rene Herman <rene.herman@gmail.com> for pointing this out.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-06-02 15:00:07.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-06-02 15:00:10.000000000 -0600
@@ -582,7 +582,7 @@ isapnp_parse_name(char *name, unsigned i
 static int __init isapnp_create_device(struct pnp_card *card,
 				       unsigned short size)
 {
-	int number = 0, skip = 0, priority = 0, compat = 0;
+	int number = 0, skip = 0, priority, compat = 0;
 	unsigned char type, tmp[17];
 	struct pnp_option *option;
 	struct pnp_dev *dev;
@@ -621,7 +621,6 @@ static int __init isapnp_create_device(s
 			} else {
 				skip = 1;
 			}
-			priority = 0;
 			compat = 0;
 			break;
 		case _STAG_COMPATDEVID:
@@ -650,10 +649,10 @@ static int __init isapnp_create_device(s
 		case _STAG_STARTDEP:
 			if (size > 1)
 				goto __skip;
-			priority = 0x100 | PNP_RES_PRIORITY_ACCEPTABLE;
+			priority = PNP_RES_PRIORITY_ACCEPTABLE;
 			if (size > 0) {
 				isapnp_peek(tmp, size);
-				priority = 0x100 | tmp[0];
+				priority = tmp[0];
 				size = 0;
 			}
 			option = pnp_register_dependent_option(dev, priority);
@@ -663,7 +662,6 @@ static int __init isapnp_create_device(s
 		case _STAG_ENDDEP:
 			if (size != 0)
 				goto __skip;
-			priority = 0;
 			dev_dbg(&dev->dev, "end dependent options\n");
 			break;
 		case _STAG_IOPORT:
Index: work10/drivers/pnp/pnpbios/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpbios/rsparser.c	2008-06-02 15:00:07.000000000 -0600
+++ work10/drivers/pnp/pnpbios/rsparser.c	2008-06-02 15:00:10.000000000 -0600
@@ -315,7 +315,7 @@ pnpbios_parse_resource_option_data(unsig
 					struct pnp_dev *dev)
 {
 	unsigned int len, tag;
-	int priority = 0;
+	int priority;
 	struct pnp_option *option, *option_independent;
 
 	if (!p)
@@ -389,9 +389,9 @@ pnpbios_parse_resource_option_data(unsig
 		case SMALL_TAG_STARTDEP:
 			if (len > 1)
 				goto len_err;
-			priority = 0x100 | PNP_RES_PRIORITY_ACCEPTABLE;
+			priority = PNP_RES_PRIORITY_ACCEPTABLE;
 			if (len > 0)
-				priority = 0x100 | p[1];
+				priority = p[1];
 			option = pnp_register_dependent_option(dev, priority);
 			if (!option)
 				return NULL;
Index: work10/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/rsparser.c	2008-06-02 15:00:07.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/rsparser.c	2008-06-02 15:00:10.000000000 -0600
@@ -545,7 +545,7 @@ struct acpipnp_parse_option_s {
 static __init acpi_status pnpacpi_option_resource(struct acpi_resource *res,
 						  void *data)
 {
-	int priority = 0;
+	int priority;
 	struct acpipnp_parse_option_s *parse_data = data;
 	struct pnp_dev *dev = parse_data->dev;
 	struct pnp_option *option = parse_data->option;

-- 
