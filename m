Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbYD2UsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbYD2UsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762797AbYD2UrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:47:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43032 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762747AbYD2UrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:47:08 -0400
Date: Tue, 29 Apr 2008 22:47:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] kbuild: drop section mismatch detection for __cpu*
Message-ID: <20080429204742.GA14418@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the last months I have spent too many hours trying to figure out
the structure of the CPUHOTPLUG code and never came anywhere near
a point where I would call myself familiar with the code base.

The reson for me looking into the code was to fix a number
of section mismatch warnings - which I succeeded doing.
But during this process I do not recall I encountered a single
real bug. There were sloppy usage of the __cpuinit annotation
and stuff like this.
And I also realised that __cpuinit was used as replacement
for factoring out code only used for CPUHOTPLUG.
But again I could not fix this myself.

So I have queued up following patch that just drop
the section mismatch checks for __cpu* entirely.

I noone object I will push it to mainline soon.

	Sam

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 757294b..007db40 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -738,14 +738,14 @@ static int check_section(const char *modname, const char *sec)
 
 
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
@@ -755,12 +755,10 @@ static int check_section(const char *modname, const char *sec)
 
 #define INIT_SECTIONS      ".init.data$", ".init.text$"
 #define DEV_INIT_SECTIONS  ".devinit.data$", ".devinit.text$"
-#define CPU_INIT_SECTIONS  ".cpuinit.data$", ".cpuinit.text$"
 #define MEM_INIT_SECTIONS  ".meminit.data$", ".meminit.text$"
 
 #define EXIT_SECTIONS      ".exit.data$", ".exit.text$"
 #define DEV_EXIT_SECTIONS  ".devexit.data$", ".devexit.text$"
-#define CPU_EXIT_SECTIONS  ".cpuexit.data$", ".cpuexit.text$"
 #define MEM_EXIT_SECTIONS  ".memexit.data$", ".memexit.text$"
 
 /* init data sections */
@@ -847,15 +845,15 @@ const struct sectioncheck sectioncheck[] = {
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
@@ -1070,7 +1068,6 @@ static Elf_Sym *find_elf_symbol2(struct elf_info *elf, Elf_Addr addr,
 /*
  * Convert a section name to the function/data attribute
  * .init.text => __init
- * .cpuinit.data => __cpudata
  * .memexitconst => __memconst
  * etc.
 */
