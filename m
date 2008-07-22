Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbYGVFkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbYGVFkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYGVFZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:43343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757186AbYGVFZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:23 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Adam Belay <ambx1@neo.rr.com>,
       Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/79] pnp: add acpi:* modalias entries
Date: Mon, 21 Jul 2008 22:19:19 -0700
Message-Id: <1216703983-21448-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Along with the non-modalias conformant "pnp:*" aliases, we add "acpi:*"
entries to PNP drivers, to allow module autoloading by ACPI PNP device
entries, which export proper modalias information, without any specific
userspace modprobe mangling.

Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 scripts/mod/file2alias.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 37d5c36..1fcaf32 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -340,11 +340,18 @@ static int do_acpi_entry(const char *filename,
 }
 
 /* looks like: "pnp:dD" */
-static int do_pnp_entry(const char *filename,
-			struct pnp_device_id *id, char *alias)
+static void do_pnp_device_entry(void *symval, unsigned long size,
+				struct module *mod)
 {
-	sprintf(alias, "pnp:d%s*", id->id);
-	return 1;
+	const unsigned long id_size = sizeof(struct pnp_device_id);
+	const struct pnp_device_id *id = symval;
+
+	device_id_check(mod->name, "pnp", size, id_size, symval);
+
+	buf_printf(&mod->dev_table_buf,
+		   "MODULE_ALIAS(\"pnp:d%s*\");\n", id->id);
+	buf_printf(&mod->dev_table_buf,
+		   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id->id);
 }
 
 /* looks like: "pnp:dD" for every device of the card */
@@ -388,9 +395,12 @@ static void do_pnp_card_entries(void *symval, unsigned long size,
 			}
 
 			/* add an individual alias for every device entry */
-			if (!dup)
+			if (!dup) {
 				buf_printf(&mod->dev_table_buf,
 					   "MODULE_ALIAS(\"pnp:d%s*\");\n", id);
+				buf_printf(&mod->dev_table_buf,
+					   "MODULE_ALIAS(\"acpi*:%s:*\");\n", id);
+			}
 		}
 	}
 }
@@ -701,9 +711,7 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 			 sizeof(struct acpi_device_id), "acpi",
 			 do_acpi_entry, mod);
 	else if (sym_is(symname, "__mod_pnp_device_table"))
-		do_table(symval, sym->st_size,
-			 sizeof(struct pnp_device_id), "pnp",
-			 do_pnp_entry, mod);
+		do_pnp_device_entry(symval, sym->st_size, mod);
 	else if (sym_is(symname, "__mod_pnp_card_device_table"))
 		do_pnp_card_entries(symval, sym->st_size, mod);
 	else if (sym_is(symname, "__mod_pcmcia_device_table"))
-- 
1.5.6.3

