Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbZFFWDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbZFFWDH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 18:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZFFWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 18:02:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55499 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbZFFWC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 18:02:56 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] dmi: sanity check BIOS tables
To: linux-kernel@vger.kernel.org, jeffrey.mitchell@gmail.com
Date: Sun, 07 Jun 2009 00:01:43 +0100
Message-ID: <20090606230137.17029.51286.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@etchedpixels.co.uk>

There are various places where invalid DMI tables cause "undefined" kernel
behaviour at boot. Be more robust.

Signed-off-by: Alan Cox <alan@etchedpixels.co.uk>
---

 drivers/firmware/dmi_scan.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 5f1b540..0bc0034 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -20,21 +20,32 @@ static char dmi_empty_string[] = "        ";
  */
 static int dmi_initialized;
 
+static u8 *dmi_end;
+
 static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 {
 	const u8 *bp = ((u8 *) dm) + dm->length;
 
 	if (s) {
 		s--;
-		while (s > 0 && *bp) {
+		while (s > 0) {
+			/* Catch corrupt table ends before we walk into
+			   undefined mappings */
+			if (bp >= dmi_end)
+				goto invalid;
+			if (*bp == 0)
+				break;
 			bp += strlen(bp) + 1;
 			s--;
 		}
 
 		if (*bp != 0) {
-			size_t len = strlen(bp)+1;
+			/* Use strnlen in case we have a BIOS table error */
+			size_t len = strnlen(bp, dmi_end - bp) + 1;
 			size_t cmp_len = len > 8 ? 8 : len;
 
+			if (bp == dmi_end)
+				goto invalid;
 			if (!memcmp(bp, dmi_empty_string, cmp_len))
 				return dmi_empty_string;
 			return bp;
@@ -42,6 +53,9 @@ static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
 	}
 
 	return "";
+invalid:
+	printk(KERN_ERR "dmi: table overrun - corrupt DMI tables ?\n");
+	return dmi_empty_string;
 }
 
 static char * __init dmi_string(const struct dmi_header *dm, u8 s)
@@ -109,9 +123,11 @@ static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
 	if (buf == NULL)
 		return -1;
 
+	/* Remember the end mark for string walking */
+	dmi_end = buf + dmi_len;
 	dmi_table(buf, dmi_len, dmi_num, decode, NULL);
-
 	dmi_iounmap(buf, dmi_len);
+
 	return 0;
 }
 
@@ -154,7 +170,7 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 	char *s;
 	int is_ff = 1, is_00 = 1, i;
 
-	if (dmi_ident[slot])
+	if (dmi_ident[slot] || d > dmi_end - 16)
 		return;
 
 	for (i = 0; i < 16 && (is_ff || is_00); i++) {
@@ -182,7 +198,7 @@ static void __init dmi_save_type(const struct dmi_header *dm, int slot, int inde
 	const u8 *d = (u8*) dm + index;
 	char *s;
 
-	if (dmi_ident[slot])
+	if (dmi_ident[slot] || d == dmi_end)
 		return;
 
 	s = dmi_alloc(4);
@@ -260,6 +276,11 @@ static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
 	struct dmi_device *dev;
 	void * data;
 
+	if (((u8 *)dm) + dm->length > dmi_end) {
+		printk(KERN_ERR "dmi_save_ipmi_device: table overrun.\n");
+		return;
+	}
+
 	data = dmi_alloc(dm->length);
 	if (data == NULL) {
 		printk(KERN_ERR "dmi_save_ipmi_device: out of memory.\n");
@@ -285,6 +306,9 @@ static void __init dmi_save_extended_devices(const struct dmi_header *dm)
 {
 	const u8 *d = (u8*) dm + 5;
 
+	if (d >= dmi_end)
+		return;
+
 	/* Skip disabled device */
 	if ((*d & 0x80) == 0)
 		return;

