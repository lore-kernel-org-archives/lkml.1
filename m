Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYIPXXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYIPXXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 19:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYIPXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 19:23:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYIPXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 19:23:40 -0400
Subject: [PATCH] Automatic MODULE_ALIAS() for DMI match tables.
From: David Woodhouse <dwmw2@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Julien Blache <jb@jblache.org>, Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 16 Sep 2008 16:23:26 -0700
Message-Id: <1221607406.20234.82.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes modpost handle MODULE_DEVICE_TABLE(dmi, xxxx).

I had to change the string pointers in the match table to char arrays,
and picked a size of 79 bytes almost at random -- do we need to make it
bigger than that? I was a bit concerned about the 'bloat' this
introduces into the match tables, but they should all be __initdata so
it shouldn't matter too much.

(Actually, modpost does go through the relocations and look at most of
them; it wouldn't be impossible to make it handle string pointers -- but
doesn't seem to be worth the effort, since they're __initdata).

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 2a063b6..e5084eb 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -2,29 +2,9 @@
 #define __DMI_H__
 
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
 
-enum dmi_field {
-	DMI_NONE,
-	DMI_BIOS_VENDOR,
-	DMI_BIOS_VERSION,
-	DMI_BIOS_DATE,
-	DMI_SYS_VENDOR,
-	DMI_PRODUCT_NAME,
-	DMI_PRODUCT_VERSION,
-	DMI_PRODUCT_SERIAL,
-	DMI_PRODUCT_UUID,
-	DMI_BOARD_VENDOR,
-	DMI_BOARD_NAME,
-	DMI_BOARD_VERSION,
-	DMI_BOARD_SERIAL,
-	DMI_BOARD_ASSET_TAG,
-	DMI_CHASSIS_VENDOR,
-	DMI_CHASSIS_TYPE,
-	DMI_CHASSIS_VERSION,
-	DMI_CHASSIS_SERIAL,
-	DMI_CHASSIS_ASSET_TAG,
-	DMI_STRING_MAX,
-};
+/* enum dmi_field is in mod_devicetable.h */
 
 enum dmi_device_type {
 	DMI_DEV_TYPE_ANY = 0,
@@ -48,23 +28,6 @@ struct dmi_header {
 	u16 handle;
 };
 
-/*
- *	DMI callbacks for problem boards
- */
-struct dmi_strmatch {
-	u8 slot;
-	char *substr;
-};
-
-struct dmi_system_id {
-	int (*callback)(const struct dmi_system_id *);
-	const char *ident;
-	struct dmi_strmatch matches[4];
-	void *driver_data;
-};
-
-#define DMI_MATCH(a, b)	{ a, b }
-
 struct dmi_device {
 	struct list_head list;
 	int type;
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index c4db582..3481a7d 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -388,5 +388,52 @@ struct i2c_device_id {
 			__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
+/* dmi */
+enum dmi_field {
+	DMI_NONE,
+	DMI_BIOS_VENDOR,
+	DMI_BIOS_VERSION,
+	DMI_BIOS_DATE,
+	DMI_SYS_VENDOR,
+	DMI_PRODUCT_NAME,
+	DMI_PRODUCT_VERSION,
+	DMI_PRODUCT_SERIAL,
+	DMI_PRODUCT_UUID,
+	DMI_BOARD_VENDOR,
+	DMI_BOARD_NAME,
+	DMI_BOARD_VERSION,
+	DMI_BOARD_SERIAL,
+	DMI_BOARD_ASSET_TAG,
+	DMI_CHASSIS_VENDOR,
+	DMI_CHASSIS_TYPE,
+	DMI_CHASSIS_VERSION,
+	DMI_CHASSIS_SERIAL,
+	DMI_CHASSIS_ASSET_TAG,
+	DMI_STRING_MAX,
+};
+
+struct dmi_strmatch {
+	unsigned char slot;
+	char substr[79];
+};
+
+#ifndef __KERNEL__
+struct dmi_system_id {
+	kernel_ulong_t callback;
+	kernel_ulong_t ident;
+	struct dmi_strmatch matches[4];
+	kernel_ulong_t driver_data
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
+#else
+struct dmi_system_id {
+	int (*callback)(const struct dmi_system_id *);
+	const char *ident;
+	struct dmi_strmatch matches[4];
+	void *driver_data;
+};
+#endif
+
+#define DMI_MATCH(a, b)	{ a, b }
 
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 4c9890e..ed68faf 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -629,6 +629,59 @@ static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
 	return 1;
 }
 
+static const struct dmifield {
+	const char *prefix;
+	int field;
+} dmi_fields[] = {
+	{ "bvn", DMI_BIOS_VENDOR },
+	{ "bvr", DMI_BIOS_VERSION },
+	{ "bd",  DMI_BIOS_DATE },
+	{ "svn", DMI_SYS_VENDOR },
+	{ "pn",  DMI_PRODUCT_NAME },
+	{ "pvr", DMI_PRODUCT_VERSION },
+	{ "rvn", DMI_BOARD_VENDOR },
+	{ "rn",  DMI_BOARD_NAME },
+	{ "rvr", DMI_BOARD_VERSION },
+	{ "cvn", DMI_CHASSIS_VENDOR },
+	{ "ct",  DMI_CHASSIS_TYPE },
+	{ "cvr", DMI_CHASSIS_VERSION },
+	{ NULL,  DMI_NONE }
+};
+
+static void dmi_ascii_filter(char *d, const char *s)
+{
+	/* Filter out characters we don't want to see in the modalias string */
+	for (; *s; s++)
+		if (*s > ' ' && *s < 127 && *s != ':')
+			*(d++) = *s;
+
+	*d = 0;
+}
+
+
+static int do_dmi_entry(const char *filename, struct dmi_system_id *id,
+			char *alias)
+{
+	int i, j;
+
+	sprintf(alias, "dmi*");
+
+	for (i=0; i < ARRAY_SIZE(dmi_fields); i++) {
+		for (j=0; j < 4; j++) {
+			if (id->matches[j].slot &&
+			    id->matches[j].slot == dmi_fields[i].field) {
+				sprintf(alias + strlen(alias), ":%s*", 
+					dmi_fields[i].prefix);
+				dmi_ascii_filter(alias + strlen(alias),
+						 id->matches[j].substr);
+				strcat(alias, "*");
+			}
+		}
+	}					
+
+	strcat(alias, ":");
+	return 1;
+}
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -760,6 +813,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct i2c_device_id), "i2c",
 			 do_i2c_entry, mod);
+	else if (sym_is(symname, "__mod_dmi_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct dmi_system_id), "dmi",
+			 do_dmi_entry, mod);
 	free(zeros);
 }
 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

