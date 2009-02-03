Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZBCPMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZBCPMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZBCPLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:11:51 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39586 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbZBCPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:11:50 -0500
Date: Tue, 3 Feb 2009 16:11:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>,
       Matthew Garrett <mjg@redhat.com>, Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] dmi: Let dmi_walk() users pass private data
Message-ID: <20090203161136.68751546@hyperion.delvare>
In-Reply-To: <20090203025937.2cfca36a.akpm@linux-foundation.org>
References: <20090201224659.6e7e84eb@hyperion.delvare>
	<20090203004210.235f162d.akpm@linux-foundation.org>
	<20090203105222.34f9f1b5@hyperion.delvare>
	<20090203025937.2cfca36a.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 02:59:37 -0800, Andrew Morton wrote:
> On Tue, 3 Feb 2009 10:52:22 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> > As for "priv" vs. "data", I wanted to use "data" everywhere, but it
> > happens that we already have a local variable named "data" in function
> > dmi_table(). I didn't want to change it, to not make the patch bigger
> > and harder to read. If you think this is such a big issue, I could
> > either rename that local variable nevertheless, or use "priv"
> > everywhere (with the open question whether we should also use "priv"
> > instead of "data" in <linux/dmi.h> or not.) Let me know what you prefer.
> 
> Could use `private_data' everywhere.   There's a lot of precedent:
> 
> y:/usr/src/25> grep private_data Tags | wc -l
> 228

Good idea, done.

From: Jean Delvare <khali@linux-fr.org>
Subject: dmi: Let dmi_walk() users pass private data

At the moment, dmi_walk() lacks flexibility, users can't pass data to
the callback function. Add a pointer for private data to make this
function more flexible.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Roland Dreier <rolandd@cisco.com>
---
 drivers/firmware/dmi_scan.c        |   18 +++++++++++-------
 drivers/hwmon/fschmd.c             |    4 ++--
 drivers/platform/x86/dell-laptop.c |    4 ++--
 drivers/watchdog/hpwdt.c           |    4 ++--
 include/linux/dmi.h                |    7 ++++---
 5 files changed, 21 insertions(+), 16 deletions(-)

--- linux-2.6.29-rc3.orig/drivers/firmware/dmi_scan.c	2009-02-03 12:10:06.000000000 +0100
+++ linux-2.6.29-rc3/drivers/firmware/dmi_scan.c	2009-02-03 16:03:52.000000000 +0100
@@ -68,7 +68,8 @@ static char * __init dmi_string(const st
  *	pointing to completely the wrong place for example
  */
 static void dmi_table(u8 *buf, int len, int num,
-		      void (*decode)(const struct dmi_header *))
+		      void (*decode)(const struct dmi_header *, void *),
+		      void *private_data)
 {
 	u8 *data = buf;
 	int i = 0;
@@ -89,7 +90,7 @@ static void dmi_table(u8 *buf, int len,
 		while ((data - buf < len - 1) && (data[0] || data[1]))
 			data++;
 		if (data - buf < len - 1)
-			decode(dm);
+			decode(dm, private_data);
 		data += 2;
 		i++;
 	}
@@ -99,7 +100,8 @@ static u32 dmi_base;
 static u16 dmi_len;
 static u16 dmi_num;
 
-static int __init dmi_walk_early(void (*decode)(const struct dmi_header *))
+static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
+		void *))
 {
 	u8 *buf;
 
@@ -107,7 +109,7 @@ static int __init dmi_walk_early(void (*
 	if (buf == NULL)
 		return -1;
 
-	dmi_table(buf, dmi_len, dmi_num, decode);
+	dmi_table(buf, dmi_len, dmi_num, decode, NULL);
 
 	dmi_iounmap(buf, dmi_len);
 	return 0;
@@ -295,7 +297,7 @@ static void __init dmi_save_extended_dev
  *	and machine entries. For 2.5 we should pull the smbus controller info
  *	out of here.
  */
-static void __init dmi_decode(const struct dmi_header *dm)
+static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
 {
 	switch(dm->type) {
 	case 0:		/* BIOS Information */
@@ -598,10 +600,12 @@ int dmi_get_year(int field)
 /**
  *	dmi_walk - Walk the DMI table and get called back for every record
  *	@decode: Callback function
+ *	@private_data: Private data to be passed to the callback function
  *
  *	Returns -1 when the DMI table can't be reached, 0 on success.
  */
-int dmi_walk(void (*decode)(const struct dmi_header *))
+int dmi_walk(void (*decode)(const struct dmi_header *, void *),
+	     void *private_data)
 {
 	u8 *buf;
 
@@ -612,7 +616,7 @@ int dmi_walk(void (*decode)(const struct
 	if (buf == NULL)
 		return -1;
 
-	dmi_table(buf, dmi_len, dmi_num, decode);
+	dmi_table(buf, dmi_len, dmi_num, decode, private_data);
 
 	iounmap(buf);
 	return 0;
--- linux-2.6.29-rc3.orig/drivers/hwmon/fschmd.c	2009-02-03 12:10:06.000000000 +0100
+++ linux-2.6.29-rc3/drivers/hwmon/fschmd.c	2009-02-03 16:02:08.000000000 +0100
@@ -856,7 +856,7 @@ static struct file_operations watchdog_f
 
 /* DMI decode routine to read voltage scaling factors from special DMI tables,
    which are available on FSC machines with an fscher or later chip. */
-static void fschmd_dmi_decode(const struct dmi_header *header)
+static void fschmd_dmi_decode(const struct dmi_header *header, void *dummy)
 {
 	int i, mult[3] = { 0 }, offset[3] = { 0 }, vref = 0, found = 0;
 
@@ -991,7 +991,7 @@ static int fschmd_probe(struct i2c_clien
 
 	/* Read the special DMI table for fscher and newer chips */
 	if ((kind == fscher || kind >= fschrc) && dmi_vref == -1) {
-		dmi_walk(fschmd_dmi_decode);
+		dmi_walk(fschmd_dmi_decode, NULL);
 		if (dmi_vref == -1) {
 			dev_warn(&client->dev,
 				"Couldn't get voltage scaling factors from "
--- linux-2.6.29-rc3.orig/drivers/platform/x86/dell-laptop.c	2009-02-03 12:10:06.000000000 +0100
+++ linux-2.6.29-rc3/drivers/platform/x86/dell-laptop.c	2009-02-03 16:02:08.000000000 +0100
@@ -103,7 +103,7 @@ static void parse_da_table(const struct
 	da_num_tokens += tokens;
 }
 
-static void find_tokens(const struct dmi_header *dm)
+static void find_tokens(const struct dmi_header *dm, void *dummy)
 {
 	switch (dm->type) {
 	case 0xd4: /* Indexed IO */
@@ -356,7 +356,7 @@ static int __init dell_init(void)
 	if (!dmi_check_system(dell_device_table))
 		return -ENODEV;
 
-	dmi_walk(find_tokens);
+	dmi_walk(find_tokens, NULL);
 
 	if (!da_tokens)  {
 		printk(KERN_INFO "dell-laptop: Unable to find dmi tokens\n");
--- linux-2.6.29-rc3.orig/drivers/watchdog/hpwdt.c	2009-02-03 12:10:06.000000000 +0100
+++ linux-2.6.29-rc3/drivers/watchdog/hpwdt.c	2009-02-03 16:02:08.000000000 +0100
@@ -382,7 +382,7 @@ asm(".text                      \n\t"
  *	This function checks whether or not a SMBIOS/DMI record is
  *	the 64bit CRU info or not
  */
-static void __devinit dmi_find_cru(const struct dmi_header *dm)
+static void __devinit dmi_find_cru(const struct dmi_header *dm, void *dummy)
 {
 	struct smbios_cru64_info *smbios_cru64_ptr;
 	unsigned long cru_physical_address;
@@ -405,7 +405,7 @@ static int __devinit detect_cru_service(
 {
 	cru_rom_addr = NULL;
 
-	dmi_walk(dmi_find_cru);
+	dmi_walk(dmi_find_cru, NULL);
 
 	/* if cru_rom_addr has been set then we found a CRU service */
 	return ((cru_rom_addr != NULL) ? 0 : -ENODEV);
--- linux-2.6.29-rc3.orig/include/linux/dmi.h	2009-02-03 12:10:06.000000000 +0100
+++ linux-2.6.29-rc3/include/linux/dmi.h	2009-02-03 16:02:29.000000000 +0100
@@ -47,7 +47,8 @@ extern int dmi_get_year(int field);
 extern int dmi_name_in_vendors(const char *str);
 extern int dmi_name_in_serial(const char *str);
 extern int dmi_available;
-extern int dmi_walk(void (*decode)(const struct dmi_header *));
+extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
+	void *private_data);
 extern bool dmi_match(enum dmi_field f, const char *str);
 
 #else
@@ -61,8 +62,8 @@ static inline int dmi_get_year(int year)
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
 static inline int dmi_name_in_serial(const char *s) { return 0; }
 #define dmi_available 0
-static inline int dmi_walk(void (*decode)(const struct dmi_header *))
-	{ return -1; }
+static inline int dmi_walk(void (*decode)(const struct dmi_header *, void *),
+	void *private_data) { return -1; }
 static inline bool dmi_match(enum dmi_field f, const char *str)
 	{ return false; }
 static inline const struct dmi_system_id *


-- 
Jean Delvare
