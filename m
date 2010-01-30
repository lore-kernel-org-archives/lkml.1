Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480Ab0A3UrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0A3UrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397Ab0A3UrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:47:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43920 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab0A3UrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:47:18 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/7] modpost: pass around const struct sectioncheck * instead of enum mismatch
Date: Sat, 30 Jan 2010 21:46:49 +0100
Message-Id: <1264884412-6173-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100130204425.GA16345@pengutronix.de>
References: <20100130204425.GA16345@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This prepares having a per-check whitelist of symbol names.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/mod/modpost.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 598d54a..3f0380b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -933,7 +933,8 @@ const struct sectioncheck sectioncheck[] = {
 }
 };
 
-static int section_mismatch(const char *fromsec, const char *tosec)
+static const struct sectioncheck *section_mismatch(
+		const char *fromsec, const char *tosec)
 {
 	int i;
 	int elems = sizeof(sectioncheck) / sizeof(struct sectioncheck);
@@ -942,10 +943,10 @@ static int section_mismatch(const char *fromsec, const char *tosec)
 	for (i = 0; i < elems; i++) {
 		if (match(fromsec, check->fromsec) &&
 		    match(tosec, check->tosec))
-			return check->mismatch;
+			return check;
 		check++;
 	}
-	return NO_MISMATCH;
+	return NULL;
 }
 
 /**
@@ -1158,7 +1159,8 @@ static int is_function(Elf_Sym *sym)
  * Try to find symbols near it so user can find it.
  * Check whitelist before warning - it may be a false positive.
  */
-static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
+static void report_sec_mismatch(const char *modname,
+				const struct sectioncheck *mismatch,
                                 const char *fromsec,
                                 unsigned long long fromaddr,
                                 const char *fromsym,
@@ -1189,7 +1191,7 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 	     modname, fromsec, fromaddr, from, fromsym, from_p, to, tosec,
 	     tosym, to_p);
 
-	switch (mismatch) {
+	switch (mismatch->mismatch) {
 	case TEXT_TO_ANY_INIT:
 		fprintf(stderr,
 		"The function %s%s() references\n"
@@ -1289,11 +1291,11 @@ static void check_section_mismatch(const char *modname, struct elf_info *elf,
                                    Elf_Rela *r, Elf_Sym *sym, const char *fromsec)
 {
 	const char *tosec;
-	enum mismatch mismatch;
+	const struct sectioncheck *mismatch;
 
 	tosec = sec_name(elf, sym->st_shndx);
 	mismatch = section_mismatch(fromsec, tosec);
-	if (mismatch != NO_MISMATCH) {
+	if (mismatch) {
 		Elf_Sym *to;
 		Elf_Sym *from;
 		const char *tosym;
-- 
1.6.6

