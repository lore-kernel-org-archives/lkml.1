Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYCVVxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYCVVxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYCVVwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:52:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:3989 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbYCVVwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:52:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lm9TVel8VCpufOYcwgqWGNa+dcYaiUGV8GYmBrEYnL32a1HNEjCyu4cNHZLs8rRXUn2R/Trf8suOYO5FX36zLGHrGWs6yBfMPBOZKa+Bg7uuTW1AuA8vDK1+A8LW8dS0v/NFtRZvkkm25ROKN7/5w2VMaIwvse906fvOowTHHQk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 22 Mar 2008 23:07:08 +0100
Message-Id: <20080322220708.17636.97707.sendpatchset@localhost.localdomain>
In-Reply-To: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
References: <20080322220623.17636.44337.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/8] ide: remove obsoleted "hdx=" kernel parameters
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove obsoleted "hdx=" kernel parameters.

* Remove no longer used stridx() and match_parm().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 Documentation/kernel-parameters.txt |    3 
 drivers/ide/ide.c                   |  139 ------------------------------------
 2 files changed, 1 insertion(+), 141 deletions(-)

Index: b/Documentation/kernel-parameters.txt
===================================================================
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -708,9 +708,6 @@ and is between 256 and 4096 characters. 
 	hd=		[EIDE] (E)IDE hard drive subsystem geometry
 			Format: <cyl>,<head>,<sect>
 
-	hd?=		[HW] (E)IDE subsystem
-	hd?lun=		See Documentation/ide/ide.txt.
-
 	highmem=nn[KMG]	[KNL,BOOT] forces the highmem zone to have an exact
 			size of <nn>. This works even on boxes that have no
 			highmem otherwise. This also works to reduce highmem
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -725,89 +725,13 @@ set_val:
 EXPORT_SYMBOL(generic_ide_ioctl);
 
 /*
- * stridx() returns the offset of c within s,
- * or -1 if c is '\0' or not found within s.
- */
-static int __init stridx (const char *s, char c)
-{
-	char *i = strchr(s, c);
-	return (i && c) ? i - s : -1;
-}
-
-/*
- * match_parm() does parsing for ide_setup():
- *
- * 1. the first char of s must be '='.
- * 2. if the remainder matches one of the supplied keywords,
- *     the index (1 based) of the keyword is negated and returned.
- * 3. if the remainder is a series of no more than max_vals numbers
- *     separated by commas, the numbers are saved in vals[] and a
- *     count of how many were saved is returned.  Base10 is assumed,
- *     and base16 is allowed when prefixed with "0x".
- * 4. otherwise, zero is returned.
- */
-static int __init match_parm (char *s, const char *keywords[], int vals[], int max_vals)
-{
-	static const char *decimal = "0123456789";
-	static const char *hex = "0123456789abcdef";
-	int i, n;
-
-	if (*s++ == '=') {
-		/*
-		 * Try matching against the supplied keywords,
-		 * and return -(index+1) if we match one
-		 */
-		if (keywords != NULL) {
-			for (i = 0; *keywords != NULL; ++i) {
-				if (!strcmp(s, *keywords++))
-					return -(i+1);
-			}
-		}
-		/*
-		 * Look for a series of no more than "max_vals"
-		 * numeric values separated by commas, in base10,
-		 * or base16 when prefixed with "0x".
-		 * Return a count of how many were found.
-		 */
-		for (n = 0; (i = stridx(decimal, *s)) >= 0;) {
-			vals[n] = i;
-			while ((i = stridx(decimal, *++s)) >= 0)
-				vals[n] = (vals[n] * 10) + i;
-			if (*s == 'x' && !vals[n]) {
-				while ((i = stridx(hex, *++s)) >= 0)
-					vals[n] = (vals[n] * 0x10) + i;
-			}
-			if (++n == max_vals)
-				break;
-			if (*s == ',' || *s == ';')
-				++s;
-		}
-		if (!*s)
-			return n;
-	}
-	return 0;	/* zero = nothing matched */
-}
-
-/*
  * ide_setup() gets called VERY EARLY during initialization,
- * to handle kernel "command line" strings beginning with "hdx=" or "ide".
+ * to handle kernel "command line" strings beginning with "ide".
  *
  * Remember to update Documentation/ide/ide.txt if you change something here.
  */
 static int __init ide_setup(char *s)
 {
-	ide_hwif_t *hwif;
-	ide_drive_t *drive;
-	unsigned int hw, unit;
-	int vals[3];
-	const char max_drive = 'a' + ((MAX_HWIFS * MAX_DRIVES) - 1);
-
-	if (strncmp(s,"hd",2) == 0 && s[2] == '=')	/* hd= is for hd.c   */
-		return 0;				/* driver and not us */
-
-	if (strncmp(s, "ide", 3) && strncmp(s, "hd", 2))
-		return 0;
-
 	printk(KERN_INFO "ide_setup: %s", s);
 	init_ide_data ();
 
@@ -845,67 +769,6 @@ static int __init ide_setup(char *s)
 	}
 #endif /* CONFIG_BLK_DEV_IDEACPI */
 
-	/*
-	 * Look for drive options:  "hdx="
-	 */
-	if (s[0] == 'h' && s[1] == 'd' && s[2] >= 'a' && s[2] <= max_drive) {
-		const char *hd_words[] = {
-			"none", "noprobe", "nowerr", "cdrom", "nodma",
-			"-6", "-7", "-8", "-9", "-10",
-			"noflush", "remap", "remap63", "scsi", NULL };
-		unit = s[2] - 'a';
-		hw   = unit / MAX_DRIVES;
-		unit = unit % MAX_DRIVES;
-		hwif = &ide_hwifs[hw];
-		drive = &hwif->drives[unit];
-		if (strncmp(s + 4, "ide-", 4) == 0) {
-			strlcpy(drive->driver_req, s + 4, sizeof(drive->driver_req));
-			goto obsolete_option;
-		}
-		switch (match_parm(&s[3], hd_words, vals, 3)) {
-			case -1: /* "none" */
-			case -2: /* "noprobe" */
-				drive->noprobe = 1;
-				goto obsolete_option;
-			case -3: /* "nowerr" */
-				drive->bad_wstat = BAD_R_STAT;
-				goto obsolete_option;
-			case -4: /* "cdrom" */
-				drive->present = 1;
-				drive->media = ide_cdrom;
-				/* an ATAPI device ignores DRDY */
-				drive->ready_stat = 0;
-				goto obsolete_option;
-			case -5: /* nodma */
-				drive->nodma = 1;
-				goto obsolete_option;
-			case -11: /* noflush */
-				drive->noflush = 1;
-				goto obsolete_option;
-			case -12: /* "remap" */
-				drive->remap_0_to_1 = 1;
-				goto obsolete_option;
-			case -13: /* "remap63" */
-				drive->sect0 = 63;
-				goto obsolete_option;
-			case -14: /* "scsi" */
-				drive->scsi = 1;
-				goto obsolete_option;
-			case 3: /* cyl,head,sect */
-				drive->media	= ide_disk;
-				drive->ready_stat = READY_STAT;
-				drive->cyl	= drive->bios_cyl  = vals[0];
-				drive->head	= drive->bios_head = vals[1];
-				drive->sect	= drive->bios_sect = vals[2];
-				drive->present	= 1;
-				drive->forced_geom = 1;
-				goto obsolete_option;
-			default:
-				goto bad_option;
-		}
-	}
-
-bad_option:
 	printk(" -- BAD OPTION\n");
 	return 1;
 obsolete_option:
