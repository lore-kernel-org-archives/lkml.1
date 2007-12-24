Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXLXVBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXLXVBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 16:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbXLXVBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 16:01:06 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:58574 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386AbXLXVBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 16:01:05 -0500
Subject: [PATCH] PNP: add all PNP card device id's as individual aliases
From: Kay Sievers <kay.sievers@novell.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 21:58:47 +0100
Message-Id: <1198529927.11716.4.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: PNP: add all PNP card device id's as individual aliases

The current PNP combined card + devices module aliase can
never ever match anything, because all these values are never
available all at the same time to match a module.

Instead of adding the useless combined alias, we add the device
id's all as individual aliases. Device id's are exported by the PNP
bus, and can now properly used to request the loading of a
matching module.

The module snd-sbawe currently exports aliases, who can never
match any device:
  alias: pnp:cCTLXXXXdCTL0045dCTL0022*
  alias: pnp:cCTLXXXXdCTL0044dCTL0023*
  alias: pnp:cCTLXXXXdCTL0042dCTL0022*
  alias: pnp:cCTLXXXXdCTL0041dCTL0021*
  alias: pnp:cCTLXXXXdCTL0031dCTL0021*
  alias: pnp:cCTL00eddCTL0041dCTL0070*
  alias: pnp:cCTL00e9dCTL0045dCTL0022*
  alias: pnp:cCTL00e4dCTL0045dCTL0022*
  alias: pnp:cCTL00c7dCTL0045dCTL0022*
  alias: pnp:cCTL00c5dCTL0045dCTL0022*
  alias: pnp:cCTL00c3dCTL0045dCTL0022*
  alias: pnp:cCTL00c1dCTL0042dCTL0022*
  alias: pnp:cCTL00b2dCTL0044dCTL0023*
  alias: pnp:cCTL009edCTL0044dCTL0023*
  alias: pnp:cCTL009ddCTL0042dCTL0022*
  alias: pnp:cCTL009fdCTL0041dCTL0021*
  alias: pnp:cCTL009cdCTL0041dCTL0021*
  alias: pnp:cCTL009adCTL0041dCTL0021*
  alias: pnp:cCTL0054dCTL0031dCTL0021*
  alias: pnp:cCTL0048dCTL0031dCTL0021*
  alias: pnp:cCTL0047dCTL0031dCTL0021*
  alias: pnp:cCTL0046dCTL0031dCTL0021*
  alias: pnp:cCTL0045dCTL0031dCTL0021*
  alias: pnp:cCTL0044dCTL0031dCTL0021*
  alias: pnp:cCTL0043dCTL0031dCTL0021*
  alias: pnp:cCTL0042dCTL0031dCTL0021*
  alias: pnp:cCTL0039dCTL0031dCTL0021*
  alias: pnp:cCTL0035dCTL0031dCTL0021*

With this patch it exports only the device id's, as matchable
aliases:
  alias: pnp:dCTL0070*
  alias: pnp:dCTL0045*
  alias: pnp:dCTL0023*
  alias: pnp:dCTL0044*
  alias: pnp:dCTL0022*
  alias: pnp:dCTL0042*
  alias: pnp:dCTL0041*
  alias: pnp:dCTL0021*
  alias: pnp:dCTL0031*

Now, the exported value of the PNP bus can be used to autoload
a matching module:
  $ modprobe --first-time -n -v pnp:dCTL0045
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/core/snd-rawmidi.ko
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/drivers/mpu401/snd-mpu401-uart.ko
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/core/snd-hwdep.ko
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/isa/sb/snd-sb-common.ko
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/isa/sb/snd-sb16-csp.ko
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/isa/sb/snd-sb16-dsp.ko
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/drivers/opl3/snd-opl3-lib.ko
  insmod /lib/modules/2.6.24-rc6-g5b825ed2-dirty/kernel/sound/isa/sb/snd-sbawe.ko

  $ grep CTL0045 /sys/bus/pnp/devices/*/id
  /sys/bus/pnp/devices/01:01.00/id:CTL0045

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 file2alias.c |   57 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index d802b5a..1882889 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -324,19 +324,52 @@ static int do_pnp_entry(const char *filename,
 	return 1;
 }
 
-/* looks like: "pnp:cCdD..." */
-static int do_pnp_card_entry(const char *filename,
-			struct pnp_card_device_id *id, char *alias)
+/* looks like: "pnp:dD" for every device of the card */
+static void do_pnp_card_entries(void *symval, unsigned long size,
+				struct module *mod)
 {
-	int i;
+	const unsigned long id_size = sizeof(struct pnp_card_device_id);
+	const unsigned int count = (size / id_size)-1;
+	const struct pnp_card_device_id *cards = symval;
+	unsigned int i;
 
-	sprintf(alias, "pnp:c%s", id->id);
-	for (i = 0; i < PNP_MAX_DEVICES; i++) {
-		if (! *id->devs[i].id)
-			break;
-		sprintf(alias + strlen(alias), "d%s", id->devs[i].id);
+	device_id_check(mod->name, "pnp", size, id_size, symval);
+
+	for (i = 0; i < count; i++) {
+		unsigned int j;
+		const struct pnp_card_device_id *card = &cards[i];
+
+		for (j = 0; j < PNP_MAX_DEVICES; j++) {
+			const char *id = (char *)card->devs[j].id;
+			int i2, j2;
+			int dup = 0;
+
+			if (!id[0])
+				break;
+
+			/* find duplicate, already added value */
+			for (i2 = 0; i2 < i && !dup; i2++) {
+				const struct pnp_card_device_id *card2 = &cards[i2];
+
+				for (j2 = 0; j2 < PNP_MAX_DEVICES; j2++) {
+					const char *id2 = (char *)card2->devs[j2].id;
+
+					if (!id2[0])
+						break;
+
+					if (!strcmp(id, id2)) {
+						dup = 1;
+						break;
+					}
+				}
+			}
+
+			/* add an individual alias for every device entry */
+			if (!dup)
+				buf_printf(&mod->dev_table_buf,
+					   "MODULE_ALIAS(\"pnp:d%s*\");\n", id);
+		}
 	}
-	return 1;
 }
 
 /* Looks like: pcmcia:mNcNfNfnNpfnNvaNvbNvcNvdN. */
@@ -630,9 +663,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 			 sizeof(struct pnp_device_id), "pnp",
 			 do_pnp_entry, mod);
 	else if (sym_is(symname, "__mod_pnp_card_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct pnp_card_device_id), "pnp_card",
-			 do_pnp_card_entry, mod);
+		do_pnp_card_entries(symval, sym->st_size, mod);
 	else if (sym_is(symname, "__mod_pcmcia_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct pcmcia_device_id), "pcmcia",
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c


