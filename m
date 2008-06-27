Return-Path: <linux-kernel-owner+w=401wt.eu-S932481AbYF0XNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481AbYF0XNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764394AbYF0W7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:59:54 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:13647 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764687AbYF0W7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:59:15 -0400
Message-Id: <20080627225803.425364922@ldl.fc.hp.com>
References: <20080627225651.663174474@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 16:57:16 -0600
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
Subject: [patch 25/28] ISAPNP: handle independent options following dependent ones
Content-Disposition: inline; filename=isapnp-enddep-bugfix
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISAPNP spec recommends that independent options precede
dependent ones, but this is not actually required.  The current
ISAPNP code incorrectly puts such trailing independent options
at the end of the last dependent option list.

This patch fixes that bug by resetting the current option list
to the independent list when we see an "End Dependent Functions"
tag.  PNPBIOS and PNPACPI handle this the same way.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>

Index: work10/drivers/pnp/isapnp/core.c
===================================================================
--- work10.orig/drivers/pnp/isapnp/core.c	2008-06-03 15:45:02.000000000 -0600
+++ work10/drivers/pnp/isapnp/core.c	2008-06-03 15:49:38.000000000 -0600
@@ -584,14 +584,14 @@ static int __init isapnp_create_device(s
 {
 	int number = 0, skip = 0, priority, compat = 0;
 	unsigned char type, tmp[17];
-	struct pnp_option *option;
+	struct pnp_option *option, *option_independent;
 	struct pnp_dev *dev;
 	u32 eisa_id;
 	char id[8];
 
 	if ((dev = isapnp_parse_device(card, size, number++)) == NULL)
 		return 1;
-	option = pnp_register_independent_option(dev);
+	option_independent = option = pnp_register_independent_option(dev);
 	if (!option) {
 		kfree(dev);
 		return 1;
@@ -613,6 +613,7 @@ static int __init isapnp_create_device(s
 				size = 0;
 				skip = 0;
 				option = pnp_register_independent_option(dev);
+				option_independent = option;
 				if (!option) {
 					kfree(dev);
 					return 1;
@@ -662,6 +663,10 @@ static int __init isapnp_create_device(s
 		case _STAG_ENDDEP:
 			if (size != 0)
 				goto __skip;
+			if (option_independent == option)
+				dev_warn(&dev->dev, "missing "
+					 "_STAG_STARTDEP tag\n");
+			option = option_independent;
 			dev_dbg(&dev->dev, "end dependent options\n");
 			break;
 		case _STAG_IOPORT:

-- 
