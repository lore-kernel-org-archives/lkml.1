Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYEDTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYEDTNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYEDTNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:13:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55951 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbYEDTND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:13:03 -0400
Date: Sun, 4 May 2008 21:13:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Timur Tabi <timur@freescale.com>, Jean Delvare <khali@linux-fr.org>,
       Jochen Friedrich <jochen@scram.de>
Subject: [GIT PULL] kbuild fixes
Message-ID: <20080504191337.GA23186@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Please pull the following kbuild fixes from:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git

Adrian Bunk (1):
      kconfig-language.txt: remove bogus hint

Jean Delvare (1):
      modpost: i2c aliases need no trailing wildcard

Sam Ravnborg (1):
      kconfig: fix MAC OS X warnings in menuconfig


	Sam


 Documentation/kbuild/kconfig-language.txt |   24 -------------------
 scripts/kconfig/lkc.h                     |    6 ++--
 scripts/kconfig/mconf.c                   |    3 +-
 scripts/mod/file2alias.c                  |   35 +++++++++++++++++++++-------
 4 files changed, 31 insertions(+), 37 deletions(-)



diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 00b950d..c412c24 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -377,27 +377,3 @@ config FOO
 
 limits FOO to module (=m) or disabled (=n).
 
-
-Build limited by a third config symbol which may be =y or =m
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-A common idiom that we see (and sometimes have problems with) is this:
-
-When option C in B (module or subsystem) uses interfaces from A (module
-or subsystem), and both A and B are tristate (could be =y or =m if they
-were independent of each other, but they aren't), then we need to limit
-C such that it cannot be built statically if A is built as a loadable
-module.  (C already depends on B, so there is no dependency issue to
-take care of here.)
-
-If A is linked statically into the kernel image, C can be built
-statically or as loadable module(s).  However, if A is built as loadable
-module(s), then C must be restricted to loadable module(s) also.  This
-can be expressed in kconfig language as:
-
-config C
-	depends on A = y || A = B
-
-or for real examples, use this command in a kernel tree:
-
-$ find . -name Kconfig\* | xargs grep -ns "depends on.*=.*||.*=" | grep -v orig
-
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index 4bc68f2..96521cb 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -11,9 +11,9 @@
 #ifndef KBUILD_NO_NLS
 # include <libintl.h>
 #else
-# define gettext(Msgid) ((const char *) (Msgid))
-# define textdomain(Domainname) ((const char *) (Domainname))
-# define bindtextdomain(Domainname, Dirname) ((const char *) (Dirname))
+static inline const char *gettext(const char *txt) { return txt; }
+static inline void textdomain(const char *domainname) {}
+static inline void bindtextdomain(const char *name, const char *dir) {}
 #endif
 
 #ifdef __cplusplus
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 734cf4f..6841e95 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -773,7 +773,7 @@ static void conf_string(struct menu *menu)
 
 	while (1) {
 		int res;
-		char *heading;
+		const char *heading;
 
 		switch (sym_get_type(menu->sym)) {
 		case S_INT:
@@ -925,3 +925,4 @@ int main(int ac, char **av)
 
 	return 0;
 }
+
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index e04c421..cea4a79 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -51,6 +51,15 @@ do {                                                            \
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
@@ -133,9 +142,7 @@ static void do_usb_entry(struct usb_device_id *id,
 	    id->match_flags&USB_DEVICE_ID_MATCH_INT_PROTOCOL,
 	    id->bInterfaceProtocol);
 
-	/* Always end in a wildcard, for future extension */
-	if (alias[strlen(alias)-1] != '*')
-		strcat(alias, "*");
+	add_wildcard(alias);
 	buf_printf(&mod->dev_table_buf,
 		   "MODULE_ALIAS(\"%s\");\n", alias);
 }
@@ -219,6 +226,7 @@ static int do_ieee1394_entry(const char *filename,
 	ADD(alias, "ver", id->match_flags & IEEE1394_MATCH_VERSION,
 	    id->version);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -261,6 +269,7 @@ static int do_pci_entry(const char *filename,
 	ADD(alias, "bc", baseclass_mask == 0xFF, baseclass);
 	ADD(alias, "sc", subclass_mask == 0xFF, subclass);
 	ADD(alias, "i", interface_mask == 0xFF, interface);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -283,6 +292,7 @@ static int do_ccw_entry(const char *filename,
 	    id->dev_type);
 	ADD(alias, "dm", id->match_flags&CCW_DEVICE_ID_MATCH_DEVICE_MODEL,
 	    id->dev_model);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -290,7 +300,7 @@ static int do_ccw_entry(const char *filename,
 static int do_ap_entry(const char *filename,
 		       struct ap_device_id *id, char *alias)
 {
-	sprintf(alias, "ap:t%02X", id->dev_type);
+	sprintf(alias, "ap:t%02X*", id->dev_type);
 	return 1;
 }
 
@@ -309,6 +319,7 @@ static int do_serio_entry(const char *filename,
 	ADD(alias, "id", id->id != SERIO_ANY, id->id);
 	ADD(alias, "ex", id->extra != SERIO_ANY, id->extra);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -316,7 +327,7 @@ static int do_serio_entry(const char *filename,
 static int do_acpi_entry(const char *filename,
 			struct acpi_device_id *id, char *alias)
 {
-	sprintf(alias, "acpi*:%s:", id->id);
+	sprintf(alias, "acpi*:%s:*", id->id);
 	return 1;
 }
 
@@ -324,7 +335,7 @@ static int do_acpi_entry(const char *filename,
 static int do_pnp_entry(const char *filename,
 			struct pnp_device_id *id, char *alias)
 {
-	sprintf(alias, "pnp:d%s", id->id);
+	sprintf(alias, "pnp:d%s*", id->id);
 	return 1;
 }
 
@@ -409,6 +420,7 @@ static int do_pcmcia_entry(const char *filename,
        ADD(alias, "pc", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID3, id->prod_id_hash[2]);
        ADD(alias, "pd", id->match_flags & PCMCIA_DEV_ID_MATCH_PROD_ID4, id->prod_id_hash[3]);
 
+	add_wildcard(alias);
        return 1;
 }
 
@@ -432,6 +444,7 @@ static int do_of_entry (const char *filename, struct of_device_id *of, char *ali
         if (isspace (*tmp))
             *tmp = '_';
 
+    add_wildcard(alias);
     return 1;
 }
 
@@ -448,6 +461,7 @@ static int do_vio_entry(const char *filename, struct vio_device_id *vio,
 		if (isspace (*tmp))
 			*tmp = '_';
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -511,6 +525,8 @@ static int do_eisa_entry(const char *filename, struct eisa_device_id *eisa,
 {
 	if (eisa->sig[0])
 		sprintf(alias, EISA_DEVICE_MODALIAS_FMT "*", eisa->sig);
+	else
+		strcat(alias, "*");
 	return 1;
 }
 
@@ -529,6 +545,7 @@ static int do_parisc_entry(const char *filename, struct parisc_device_id *id,
 	ADD(alias, "rev", id->hversion_rev != PA_HVERSION_REV_ANY_ID, id->hversion_rev);
 	ADD(alias, "sv", id->sversion != PA_SVERSION_ANY_ID, id->sversion);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -544,6 +561,7 @@ static int do_sdio_entry(const char *filename,
 	ADD(alias, "c", id->class != (__u8)SDIO_ANY_ID, id->class);
 	ADD(alias, "v", id->vendor != (__u16)SDIO_ANY_ID, id->vendor);
 	ADD(alias, "d", id->device != (__u16)SDIO_ANY_ID, id->device);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -559,6 +577,7 @@ static int do_ssb_entry(const char *filename,
 	ADD(alias, "v", id->vendor != SSB_ANY_VENDOR, id->vendor);
 	ADD(alias, "id", id->coreid != SSB_ANY_ID, id->coreid);
 	ADD(alias, "rev", id->revision != SSB_ANY_REV, id->revision);
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -573,6 +592,7 @@ static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
 	ADD(alias, "d", 1, id->device);
 	ADD(alias, "v", id->vendor != VIRTIO_DEV_ANY_ID, id->vendor);
 
+	add_wildcard(alias);
 	return 1;
 }
 
@@ -612,9 +632,6 @@ static void do_table(void *symval, unsigned long size,
 
 	for (i = 0; i < size; i += id_size) {
 		if (do_entry(mod->name, symval+i, alias)) {
-			/* Always end in a wildcard, for future extension */
-			if (alias[strlen(alias)-1] != '*')
-				strcat(alias, "*");
 			buf_printf(&mod->dev_table_buf,
 				   "MODULE_ALIAS(\"%s\");\n", alias);
 		}
