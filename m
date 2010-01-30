Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628Ab0A3Uri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0A3Uri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316Ab0A3Urg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:47:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43937 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab0A3Ure (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:47:34 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/7] modpost: make symbol white list a per mismatch type variable
Date: Sat, 30 Jan 2010 21:46:51 +0100
Message-Id: <1264884412-6173-6-git-send-email-u.kleine-koenig@pengutronix.de>
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

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 scripts/mod/modpost.c |   49 +++++++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index a94bd10..5dbe4db 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -817,18 +817,15 @@ static const char *data_sections[] = { DATA_SECTIONS, NULL };
 
 
 /* symbols in .data that may refer to init/exit sections */
-static const char *symbol_white_list[] =
-{
-	"*driver",
-	"*_template", /* scsi uses *_template a lot */
-	"*_timer",    /* arm uses ops structures named _timer a lot */
-	"*_sht",      /* scsi also used *_sht to some extent */
-	"*_ops",
-	"*_probe",
-	"*_probe_one",
-	"*_console",
-	NULL
-};
+#define DEFAULT_SYMBOL_WHITE_LIST					\
+	"*driver",							\
+	"*_template", /* scsi uses *_template a lot */			\
+	"*_timer",    /* arm uses ops structures named _timer a lot */	\
+	"*_sht",      /* scsi also used *_sht to some extent */		\
+	"*_ops",							\
+	"*_probe",							\
+	"*_probe_one",							\
+	"*_console"
 
 static const char *head_sections[] = { ".head.text*", NULL };
 static const char *linker_symbols[] =
@@ -850,6 +847,7 @@ struct sectioncheck {
 	const char *fromsec[20];
 	const char *tosec[20];
 	enum mismatch mismatch;
+	const char *symbol_white_list[20];
 };
 
 const struct sectioncheck sectioncheck[] = {
@@ -860,75 +858,88 @@ const struct sectioncheck sectioncheck[] = {
 	.fromsec = { TEXT_SECTIONS, NULL },
 	.tosec   = { ALL_INIT_SECTIONS, NULL },
 	.mismatch = TEXT_TO_ANY_INIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 {
 	.fromsec = { DATA_SECTIONS, NULL },
 	.tosec   = { ALL_INIT_SECTIONS, NULL },
 	.mismatch = DATA_TO_ANY_INIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 {
 	.fromsec = { TEXT_SECTIONS, NULL },
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
 	.mismatch = TEXT_TO_ANY_EXIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 {
 	.fromsec = { DATA_SECTIONS, NULL },
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
 	.mismatch = DATA_TO_ANY_EXIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not reference init code/data from devinit/cpuinit/meminit code/data */
 {
 	.fromsec = { ALL_XXXINIT_SECTIONS, NULL },
 	.tosec   = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_SOME_INIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not reference cpuinit code/data from meminit code/data */
 {
 	.fromsec = { MEM_INIT_SECTIONS, NULL },
 	.tosec   = { CPU_INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_SOME_INIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not reference meminit code/data from cpuinit code/data */
 {
 	.fromsec = { CPU_INIT_SECTIONS, NULL },
 	.tosec   = { MEM_INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_SOME_INIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
 {
 	.fromsec = { ALL_XXXEXIT_SECTIONS, NULL },
 	.tosec   = { EXIT_SECTIONS, NULL },
 	.mismatch = XXXEXIT_TO_SOME_EXIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not reference cpuexit code/data from memexit code/data */
 {
 	.fromsec = { MEM_EXIT_SECTIONS, NULL },
 	.tosec   = { CPU_EXIT_SECTIONS, NULL },
 	.mismatch = XXXEXIT_TO_SOME_EXIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not reference memexit code/data from cpuexit code/data */
 {
 	.fromsec = { CPU_EXIT_SECTIONS, NULL },
 	.tosec   = { MEM_EXIT_SECTIONS, NULL },
 	.mismatch = XXXEXIT_TO_SOME_EXIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
 	.mismatch = ANY_INIT_TO_ANY_EXIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not use init code/data from exit code */
 {
 	.fromsec = { ALL_EXIT_SECTIONS, NULL },
 	.tosec   = { ALL_INIT_SECTIONS, NULL },
 	.mismatch = ANY_EXIT_TO_ANY_INIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 },
 /* Do not export init/exit functions or data */
 {
 	.fromsec = { "__ksymtab*", NULL },
 	.tosec   = { INIT_SECTIONS, EXIT_SECTIONS, NULL },
-	.mismatch = EXPORT_TO_INIT_EXIT
+	.mismatch = EXPORT_TO_INIT_EXIT,
+	.symbol_white_list = { DEFAULT_SYMBOL_WHITE_LIST, NULL },
 }
 };
 
@@ -985,7 +996,8 @@ static const struct sectioncheck *section_mismatch(
  *   refsymname = __init_begin, _sinittext, _einittext
  *
  **/
-static int secref_whitelist(const char *fromsec, const char *fromsym,
+static int secref_whitelist(const struct sectioncheck *mismatch,
+			    const char *fromsec, const char *fromsym,
 			    const char *tosec, const char *tosym)
 {
 	/* Check for pattern 1 */
@@ -997,7 +1009,7 @@ static int secref_whitelist(const char *fromsec, const char *fromsym,
 	/* Check for pattern 2 */
 	if (match(tosec, init_exit_sections) &&
 	    match(fromsec, data_sections) &&
-	    match(fromsym, symbol_white_list))
+	    match(fromsym, mismatch->symbol_white_list))
 		return 0;
 
 	/* Check for pattern 3 */
@@ -1202,7 +1214,7 @@ static void report_sec_mismatch(const char *modname,
 		fromsym, sec2annotation(tosec), tosym);
 		break;
 	case DATA_TO_ANY_INIT: {
-		const char **s = symbol_white_list;
+		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
 		"the %s %s%s%s\n"
@@ -1223,7 +1235,7 @@ static void report_sec_mismatch(const char *modname,
 		fromsym, to, to, tosym, to_p, sec2annotation(tosec), tosym);
 		break;
 	case DATA_TO_ANY_EXIT: {
-		const char **s = symbol_white_list;
+		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
 		"the %s %s%s%s\n"
@@ -1304,7 +1316,8 @@ static void check_section_mismatch(const char *modname, struct elf_info *elf,
 		tosym = sym_name(elf, to);
 
 		/* check whitelist - we may ignore it */
-		if (secref_whitelist(fromsec, fromsym, tosec, tosym)) {
+		if (secref_whitelist(mismatch,
+					fromsec, fromsym, tosec, tosym)) {
 			report_sec_mismatch(modname, mismatch,
 			   fromsec, r->r_offset, fromsym,
 			   is_function(from), tosec, tosym,
-- 
1.6.6

