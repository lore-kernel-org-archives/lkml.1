Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbZCZV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbZCZV4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZCZV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:56:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47576 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754190AbZCZV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:56:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] dmi: sanity check BIOS tables
To: linux-kernel@vger.kernel.org
Date: Thu, 26 Mar 2009 21:57:12 +0000
Message-ID: <20090326215658.18745.37412.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are various places where invalid DMI tables cause "undefined" kernel
behaviour at boot. Be more robust.

---

 drivers/firmware/dmi_scan.c |   33 +++++++++++++++++++++++++++++----
 1 files changed, 29 insertions(+), 4 deletions(-)


diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 8f0f7c4..0ad45b1 100644
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
@@ -107,6 +121,9 @@ static int __init dmi_walk_early(void (*decode)(const struct dmi_header *))
 	if (buf == NULL)
 		return -1;
 
+	/* Remember the end mark for string walking */
+	dmi_end = buf + dmi_len;
+
 	dmi_table(buf, dmi_len, dmi_num, decode);
 
 	dmi_iounmap(buf, dmi_len);
@@ -152,7 +169,7 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 	char *s;
 	int is_ff = 1, is_00 = 1, i;
 
-	if (dmi_ident[slot])
+	if (dmi_ident[slot] || d > dmi_end - 16)
 		return;
 
 	for (i = 0; i < 16 && (is_ff || is_00); i++) {
@@ -180,7 +197,7 @@ static void __init dmi_save_type(const struct dmi_header *dm, int slot, int inde
 	const u8 *d = (u8*) dm + index;
 	char *s;
 
-	if (dmi_ident[slot])
+	if (dmi_ident[slot] || d == dmi_end)
 		return;
 
 	s = dmi_alloc(4);
@@ -258,6 +275,11 @@ static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
 	struct dmi_device *dev;
 	void * data;
 
+	if (((u8 *)dm) + dm->length >= dmi_end) {
+		printk(KERN_ERR "dmi_save_ipmi_device: table overrun.\n");
+		return;
+	}
+
 	data = dmi_alloc(dm->length);
 	if (data == NULL) {
 		printk(KERN_ERR "dmi_save_ipmi_device: out of memory.\n");
@@ -283,6 +305,9 @@ static void __init dmi_save_extended_devices(const struct dmi_header *dm)
 {
 	const u8 *d = (u8*) dm + 5;
 
+	if (d >= dmi_end)
+		return;
+
 	/* Skip disabled device */
 	if ((*d & 0x80) == 0)
 		return;

