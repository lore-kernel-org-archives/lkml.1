Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbYJXXO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbYJXXO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbYJXXOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:14:08 -0400
Received: from pqueuea.post.tele.dk ([193.162.153.9]:41450 "EHLO
	pqueuea.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851AbYJXXOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:14:06 -0400
Date: Fri, 24 Oct 2008 23:37:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: [PATCH] kbuild: drop cpuinit/cpuexit checks in modpost
Message-ID: <20081024213710.GA18798@uranus.ravnborg.org>
References: <20081024142056.6a2d082a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024142056.6a2d082a@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the removal of cpuinit/cpuexit we no longer need to
do section mismatch checks on these sections.

Drop it from modpost.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

Can you add this to the queue too.

Thanks,
	Sam

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 8892161..58041e3 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -753,14 +753,14 @@ static int check_section(const char *modname, const char *sec)
 
 
 #define ALL_INIT_DATA_SECTIONS \
-	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
+	".init.data$", ".devinit.data$", ".meminit.data$"
 #define ALL_EXIT_DATA_SECTIONS \
-	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"
+	".exit.data$", ".devexit.data$", ".memexit.data$"
 
 #define ALL_INIT_TEXT_SECTIONS \
-	".init.text$", ".devinit.text$", ".cpuinit.text$", ".meminit.text$"
+	".init.text$", ".devinit.text$", ".meminit.text$"
 #define ALL_EXIT_TEXT_SECTIONS \
-	".exit.text$", ".devexit.text$", ".cpuexit.text$", ".memexit.text$"
+	".exit.text$", ".devexit.text$", ".memexit.text$"
 
 #define ALL_INIT_SECTIONS ALL_INIT_DATA_SECTIONS, ALL_INIT_TEXT_SECTIONS
 #define ALL_EXIT_SECTIONS ALL_EXIT_DATA_SECTIONS, ALL_EXIT_TEXT_SECTIONS
@@ -770,12 +770,10 @@ static int check_section(const char *modname, const char *sec)
 
 #define INIT_SECTIONS      ".init.data$", ".init.text$"
 #define DEV_INIT_SECTIONS  ".devinit.data$", ".devinit.text$"
-#define CPU_INIT_SECTIONS  ".cpuinit.data$", ".cpuinit.text$"
 #define MEM_INIT_SECTIONS  ".meminit.data$", ".meminit.text$"
 
 #define EXIT_SECTIONS      ".exit.data$", ".exit.text$"
 #define DEV_EXIT_SECTIONS  ".devexit.data$", ".devexit.text$"
-#define CPU_EXIT_SECTIONS  ".cpuexit.data$", ".cpuexit.text$"
 #define MEM_EXIT_SECTIONS  ".memexit.data$", ".memexit.text$"
 
 /* init data sections */
@@ -862,15 +860,15 @@ const struct sectioncheck sectioncheck[] = {
 	.tosec   = { ALL_EXIT_SECTIONS, NULL },
 	.mismatch = DATA_TO_EXIT,
 },
-/* Do not reference init code/data from devinit/cpuinit/meminit code/data */
+/* Do not reference init code/data from devinit/meminit code/data */
 {
-	.fromsec = { DEV_INIT_SECTIONS, CPU_INIT_SECTIONS, MEM_INIT_SECTIONS, NULL },
+	.fromsec = { DEV_INIT_SECTIONS, MEM_INIT_SECTIONS, NULL },
 	.tosec   = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_INIT,
 },
-/* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
+/* Do not reference exit code/data from devexit/memexit code/data */
 {
-	.fromsec = { DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS, NULL },
+	.fromsec = { DEV_EXIT_SECTIONS, MEM_EXIT_SECTIONS, NULL },
 	.tosec   = { EXIT_SECTIONS, NULL },
 	.mismatch = XXXEXIT_TO_EXIT,
 },
@@ -1085,7 +1083,6 @@ static Elf_Sym *find_elf_symbol2(struct elf_info *elf, Elf_Addr addr,
 /*
  * Convert a section name to the function/data attribute
  * .init.text => __init
- * .cpuinit.data => __cpudata
  * .memexitconst => __memconst
  * etc.
 */
