Return-Path: <linux-kernel-owner+w=401wt.eu-S964996AbYEBSe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964996AbYEBSe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765446AbYEBSeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:34:18 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:19010 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762956AbYEBSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:34:17 -0400
Date: Fri, 2 May 2008 20:33:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Sam Ravnborg <sam@uranus.ravnborg.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] modpost: i2c aliases need no trailing wildcard
Message-ID: <20080502203348.3e59070e@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Not all device types need a wildcard at the end of their module
aliases. In particular, for i2c module aliases, the trailing wildcard
is not only unneeded, it could also cause the wrong driver to be
loaded.

As I2C devices have no IDs, i2c module aliases are simple, arbitrary
device names. For example:

$ /sbin/modinfo lm90
filename:       /lib/modules/2.6.25-git18/kernel/drivers/hwmon/lm90.ko
author:         Jean Delvare <khali@linux-fr.org>
description:    LM90/ADM1032 driver
license:        GPL
vermagic:       2.6.25-git18 mod_unload
depends:        hwmon
alias:          i2c:lm90*
alias:          i2c:adm1032*
alias:          i2c:lm99*
alias:          i2c:lm86*
alias:          i2c:max6657*
alias:          i2c:adt7461*
alias:          i2c:max6680*
$

This would cause trouble if one I2C chip name matches the beginning of
another I2C chip name and both chips are supported by different
drivers. For example, an i2c device named lm9042 would cause the lm90
driver to be loaded, while it doesn't support that device. This case
has yet to be seen in practice, but still, I'd like to fix it now. The
cleanest fix is to remove the trailing wildcard from i2c module aliases.

Here's a patch doing this. If nobody objects, I'll send it to Linus
through my i2c tree next week.

* * * * *

Not all device type aliases need a trailing wildcard, in particular
the i2c aliases don't. Don't add a wildcard by default in do_table(),
instead let each device type handler add it if needed.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
I have tested types acpi, dmi, eisa, i2c, ide, ieee1394, input, pci,
pcmcia, platform, pnp, scsi, serio, ssb and usb. Other types (ccw, of,
vio, parisc, sdio and virtio) are untested.

 scripts/mod/file2alias.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

--- linux-2.6.26-rc0.orig/scripts/mod/file2alias.c	2008-05-02 18:37:38.000000000 +0200
+++ linux-2.6.26-rc0/scripts/mod/file2alias.c	2008-05-02 20:23:07.000000000 +0200
@@ -51,6 +51,15 @@ do {                                    
                 sprintf(str + strlen(str), "*");                \
 } while(0)
 
+/* Always end in a wildcard, for future extension */
+static inline void add_wildcard(char *str)
+{
+	int len = strlen(str);
+
+	if (str[len - 1] != '*')
+		strcat(str + len, "*");
+}
+
 unsigned int cross_build = 0;
 /**
  * Check that sizeof(device_id type) are consistent with size of section
@@ -133,9 +142,7 @@ static void do_usb_entry(struct usb_devi
 	    id->match_flags&USB_DEVICE_ID_MATCH_INT_PROTOCOL,
 	    id->bInterfaceProtocol);
 
-	/* Always end in a wildcard, for future extension */
-	if (alias[strlen(alias)-1] != '*')
-		strcat(alias, "*");
+	add_wildcard(alias);
 	buf_printf(&mod->dev_table_buf,
 		   "MODULE_ALIAS(\"%s\");\n", alias);
 }
@@ -219,6 +226,7 @@ static int do_ieee1394_entry(const char 
 	ADD(alias, "ver", id->match_flags & IEEE1394_MATCH_VERSION,
 	    id->version);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -261,6 +269,7 @@ static int do_pci_entry(const char *file
 	ADD(alias, "bc", baseclass_mask == 0xFF, baseclass);
 	ADD(alias, "sc", subclass_mask == 0xFF, subclass);
 	ADD(alias, "i", interface_mask == 0xFF, interface);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -283,6 +292,7 @@ static int do_ccw_entry(const char *file
 	    id->dev_type);
 	ADD(alias, "dm", id->match_flags&CCW_DEVICE_ID_MATCH_DEVICE_MODEL,
 	    id->dev_model);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -290,7 +300,7 @@ static int do_ccw_entry(const char *file
 static int do_ap_entry(const char *filename,
 		       struct ap_device_id *id, char *alias)
 {
-	sprintf(alias, "ap:t%02X", id->dev_type);
+	sprintf(alias, "ap:t%02X*", id->dev_type);
 	return 1;
 }
 
@@ -309,6 +319,7 @@ static int do_serio_entry(const char *fi
 	ADD(alias, "id", id->id != SERIO_ANY, id->id);
 	ADD(alias, "ex", id->extra != SERIO_ANY, id->extra);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -316,7 +327,7 @@ static int do_serio_entry(const char *fi
 static int do_acpi_entry(const char *filename,
 			struct acpi_device_id *id, char *alias)
 {
-	sprintf(alias, "acpi*:%s:", id->id);
+	sprintf(alias, "acpi*:%s:*", id->id);
 	return 1;
 }
 
@@ -324,7 +335,7 @@ static int do_acpi_entry(const char *fil
 static int do_pnp_entry(const char *filename,
 			struct pnp_device_id *id, char *alias)
 {
-	sprintf(alias, "pnp:d%s", id->id);
+	sprintf(alias, "pnp:d%s*", id->id);
 	return 1;
 }
 
@@ -409,6 +420,7 @@ static int do_pcmcia_entry(const char *f
        ADD(alias, "pc", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID3, id->prod_id_hash[2]);
        ADD(alias, "pd", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID4, id->prod_id_hash[3]);
 
+	add_wildcard(alias);
        return 1;
 }
 
@@ -432,6 +444,7 @@ static int do_of_entry (const char *file
         if (isspace (*tmp))
             *tmp = '_';
 
+    add_wildcard(alias);
     return 1;
 }
 
@@ -448,6 +461,7 @@ static int do_vio_entry(const char *file
 		if (isspace (*tmp))
 			*tmp = '_';
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -511,6 +525,8 @@ static int do_eisa_entry(const char *fil
 {
 	if (eisa->sig[0])
 		sprintf(alias, EISA_DEVICE_MODALIAS_FMT "*", eisa->sig);
+	else
+		strcat(alias, "*");
 	return 1;
 }
 
@@ -529,6 +545,7 @@ static int do_parisc_entry(const char *f
 	ADD(alias, "rev", id->hversion_rev != PA_HVERSION_REV_ANY_ID, id->hversion_rev);
 	ADD(alias, "sv", id->sversion != PA_SVERSION_ANY_ID, id->sversion);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -544,6 +561,7 @@ static int do_sdio_entry(const char *fil
 	ADD(alias, "c", id->class != (__u8)SDIO_ANY_ID, id->class);
 	ADD(alias, "v", id->vendor != (__u16)SDIO_ANY_ID, id->vendor);
 	ADD(alias, "d", id->device != (__u16)SDIO_ANY_ID, id->device);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -559,6 +577,7 @@ static int do_ssb_entry(const char *file
 	ADD(alias, "v", id->vendor != SSB_ANY_VENDOR, id->vendor);
 	ADD(alias, "id", id->coreid != SSB_ANY_ID, id->coreid);
 	ADD(alias, "rev", id->revision != SSB_ANY_REV, id->revision);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -573,6 +592,7 @@ static int do_virtio_entry(const char *f
 	ADD(alias, "d", 1, id->device);
 	ADD(alias, "v", id->vendor != VIRTIO_DEV_ANY_ID, id->vendor);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -612,9 +632,6 @@ static void do_table(void *symval, unsig
 
 	for (i = 0; i < size; i += id_size) {
 		if (do_entry(mod->name, symval+i, alias)) {
-			/* Always end in a wildcard, for future extension */
-			if (alias[strlen(alias)-1] != '*')
-				strcat(alias, "*");
 			buf_printf(&mod->dev_table_buf,
 				   "MODULE_ALIAS(\"%s\");\n", alias);
 		}

-- 
Jean Delvare
