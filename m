Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZFEXnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZFEXnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbZFEXl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:29 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45066 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbZFEXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:10 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 16/39] initconst adjustments
Date: Sat,  6 Jun 2009 01:42:34 +0200
Message-Id: <1244245377-17441-16-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

- add .init.rodata to INIT_DATA, and group all initconst flavors
  together
- move strings generated from __setup_param() into .init.rodata
- add .*init.rodata to modpost's sets of init sections
- make modpost warn about references between meminit and cpuinit
  as well as memexit and cpuexit sections (as CPU and memory
  hotplug are independently selectable features)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 include/asm-generic/vmlinux.lds.h |    5 ++-
 include/linux/init.h              |    3 +-
 scripts/mod/modpost.c             |   48 +++++++++++++++++++++++++++++-------
 3 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 89853bc..3edb114 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -336,10 +336,11 @@
 #define INIT_DATA							\
 	*(.init.data)							\
 	DEV_DISCARD(init.data)						\
-	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.data)						\
-	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.data)						\
+	*(.init.rodata)							\
+	DEV_DISCARD(init.rodata)					\
+	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)
 
 #define INIT_TEXT							\
diff --git a/include/linux/init.h b/include/linux/init.h
index 0e06c17..9f70c9f 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -225,7 +225,8 @@ struct obs_kernel_param {
  * obs_kernel_param "array" too far apart in .init.setup.
  */
 #define __setup_param(str, unique_id, fn, early)			\
-	static char __setup_str_##unique_id[] __initdata __aligned(1) = str; \
+	static const char __setup_str_##unique_id[] __initconst	\
+		__aligned(1) = str; \
 	static struct obs_kernel_param __setup_##unique_id	\
 		__used __section(.init.setup)			\
 		__attribute__((aligned((sizeof(long)))))	\
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 161b784..94e71ef 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -763,6 +763,8 @@ static void check_section(const char *modname, struct elf_info *elf,
 
 
 #define ALL_INIT_DATA_SECTIONS \
+	".init.setup$", ".init.rodata$", \
+	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$" \
 	".init.data$", ".devinit.data$", ".cpuinit.data$", ".meminit.data$"
 #define ALL_EXIT_DATA_SECTIONS \
 	".exit.data$", ".devexit.data$", ".cpuexit.data$", ".memexit.data$"
@@ -772,21 +774,23 @@ static void check_section(const char *modname, struct elf_info *elf,
 #define ALL_EXIT_TEXT_SECTIONS \
 	".exit.text$", ".devexit.text$", ".cpuexit.text$", ".memexit.text$"
 
-#define ALL_INIT_SECTIONS ALL_INIT_DATA_SECTIONS, ALL_INIT_TEXT_SECTIONS
-#define ALL_EXIT_SECTIONS ALL_EXIT_DATA_SECTIONS, ALL_EXIT_TEXT_SECTIONS
+#define ALL_INIT_SECTIONS INIT_SECTIONS, DEV_INIT_SECTIONS, \
+	CPU_INIT_SECTIONS, MEM_INIT_SECTIONS
+#define ALL_EXIT_SECTIONS EXIT_SECTIONS, DEV_EXIT_SECTIONS, \
+	CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS
 
 #define DATA_SECTIONS ".data$", ".data.rel$"
 #define TEXT_SECTIONS ".text$"
 
-#define INIT_SECTIONS      ".init.data$", ".init.text$"
-#define DEV_INIT_SECTIONS  ".devinit.data$", ".devinit.text$"
-#define CPU_INIT_SECTIONS  ".cpuinit.data$", ".cpuinit.text$"
-#define MEM_INIT_SECTIONS  ".meminit.data$", ".meminit.text$"
+#define INIT_SECTIONS      ".init.*"
+#define DEV_INIT_SECTIONS  ".devinit.*"
+#define CPU_INIT_SECTIONS  ".cpuinit.*"
+#define MEM_INIT_SECTIONS  ".meminit.*"
 
-#define EXIT_SECTIONS      ".exit.data$", ".exit.text$"
-#define DEV_EXIT_SECTIONS  ".devexit.data$", ".devexit.text$"
-#define CPU_EXIT_SECTIONS  ".cpuexit.data$", ".cpuexit.text$"
-#define MEM_EXIT_SECTIONS  ".memexit.data$", ".memexit.text$"
+#define EXIT_SECTIONS      ".exit.*"
+#define DEV_EXIT_SECTIONS  ".devexit.*"
+#define CPU_EXIT_SECTIONS  ".cpuexit.*"
+#define MEM_EXIT_SECTIONS  ".memexit.*"
 
 /* init data sections */
 static const char *init_data_sections[] = { ALL_INIT_DATA_SECTIONS, NULL };
@@ -869,12 +873,36 @@ const struct sectioncheck sectioncheck[] = {
 	.tosec   = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_INIT,
 },
+/* Do not reference cpuinit code/data from meminit code/data */
+{
+	.fromsec = { MEM_INIT_SECTIONS, NULL },
+	.tosec   = { CPU_INIT_SECTIONS, NULL },
+	.mismatch = XXXINIT_TO_INIT,
+},
+/* Do not reference meminit code/data from cpuinit code/data */
+{
+	.fromsec = { CPU_INIT_SECTIONS, NULL },
+	.tosec   = { MEM_INIT_SECTIONS, NULL },
+	.mismatch = XXXINIT_TO_INIT,
+},
 /* Do not reference exit code/data from devexit/cpuexit/memexit code/data */
 {
 	.fromsec = { DEV_EXIT_SECTIONS, CPU_EXIT_SECTIONS, MEM_EXIT_SECTIONS, NULL },
 	.tosec   = { EXIT_SECTIONS, NULL },
 	.mismatch = XXXEXIT_TO_EXIT,
 },
+/* Do not reference cpuexit code/data from memexit code/data */
+{
+	.fromsec = { MEM_EXIT_SECTIONS, NULL },
+	.tosec   = { CPU_EXIT_SECTIONS, NULL },
+	.mismatch = XXXEXIT_TO_EXIT,
+},
+/* Do not reference memexit code/data from cpuexit code/data */
+{
+	.fromsec = { CPU_EXIT_SECTIONS, NULL },
+	.tosec   = { MEM_EXIT_SECTIONS, NULL },
+	.mismatch = XXXEXIT_TO_EXIT,
+},
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
-- 
1.6.3.rc3.40.g75b44

