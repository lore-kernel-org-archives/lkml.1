Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZGUK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZGUK2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZGUK2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:37053 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbZGUK2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:01 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/20] percpu: generalize first chunk allocator selection
Date: Tue, 21 Jul 2009 19:26:04 +0900
Message-Id: <1248171979-29166-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all first chunk allocators are in mm/percpu.c, it makes sense
to make generalize percpu_alloc kernel parameter.  Define PCPU_FC_*
and set pcpu_chosen_fc using early_param() in mm/percpu.c.  Arch code
can use the set value to determine which first chunk allocator to use.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/kernel-parameters.txt |   11 ++++++-----
 arch/x86/kernel/setup_percpu.c      |   24 ++++++------------------
 include/linux/percpu.h              |   12 ++++++++++++
 mm/percpu.c                         |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index faa7178..89b7568 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1915,11 +1915,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: { 0 | 1 }
 			See arch/parisc/kernel/pdc_chassis.c
 
-	percpu_alloc=	[X86] Select which percpu first chunk allocator to use.
-			Allowed values are one of "lpage", "embed" and "page".
-			See comments in arch/x86/kernel/setup_percpu.c for
-			details on each allocator.  This parameter is primarily
-			for debugging and performance comparison.
+	percpu_alloc=	Select which percpu first chunk allocator to use.
+			Currently supported values are "embed", "page" and
+			"lpage".  Archs may support subset or none of the
+			selections.  See comments in mm/percpu.c for details
+			on each allocator.  This parameter is primarily	for
+			debugging and performance comparison.
 
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 3c943b4..7f1e09b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -267,16 +267,6 @@ static ssize_t __init setup_pcpu_page(size_t static_size)
 				     pcpup_populate_pte);
 }
 
-/* for explicit first chunk allocator selection */
-static char pcpu_chosen_alloc[16] __initdata;
-
-static int __init percpu_alloc_setup(char *str)
-{
-	strncpy(pcpu_chosen_alloc, str, sizeof(pcpu_chosen_alloc) - 1);
-	return 0;
-}
-early_param("percpu_alloc", percpu_alloc_setup);
-
 static inline void setup_percpu_segment(int cpu)
 {
 #ifdef CONFIG_X86_32
@@ -307,19 +297,17 @@ void __init setup_per_cpu_areas(void)
 	 * each allocator for details.
 	 */
 	ret = -EINVAL;
-	if (strlen(pcpu_chosen_alloc)) {
-		if (strcmp(pcpu_chosen_alloc, "page")) {
-			if (!strcmp(pcpu_chosen_alloc, "lpage"))
+	if (pcpu_chosen_fc != PCPU_FC_AUTO) {
+		if (pcpu_chosen_fc != PCPU_FC_PAGE) {
+			if (pcpu_chosen_fc == PCPU_FC_LPAGE)
 				ret = setup_pcpu_lpage(static_size, true);
-			else if (!strcmp(pcpu_chosen_alloc, "embed"))
-				ret = setup_pcpu_embed(static_size, true);
 			else
-				pr_warning("PERCPU: unknown allocator %s "
-					   "specified\n", pcpu_chosen_alloc);
+				ret = setup_pcpu_embed(static_size, true);
+
 			if (ret < 0)
 				pr_warning("PERCPU: %s allocator failed (%zd), "
 					   "falling back to page\n",
-					   pcpu_chosen_alloc, ret);
+					   pcpu_fc_names[pcpu_chosen_fc], ret);
 		}
 	} else {
 		ret = setup_pcpu_lpage(static_size, false);
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index e26788e..9be05cb 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -59,6 +59,18 @@
 extern void *pcpu_base_addr;
 extern const int *pcpu_unit_map;
 
+enum pcpu_fc {
+	PCPU_FC_AUTO,
+	PCPU_FC_EMBED,
+	PCPU_FC_PAGE,
+	PCPU_FC_LPAGE,
+
+	PCPU_FC_NR,
+};
+extern const char *pcpu_fc_names[PCPU_FC_NR];
+
+extern enum pcpu_fc pcpu_chosen_fc;
+
 typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size);
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
diff --git a/mm/percpu.c b/mm/percpu.c
index 4d926d3..6617020 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1414,6 +1414,38 @@ size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 	return pcpu_unit_size;
 }
 
+const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
+	[PCPU_FC_AUTO]	= "auto",
+	[PCPU_FC_EMBED]	= "embed",
+	[PCPU_FC_PAGE]	= "page",
+	[PCPU_FC_LPAGE]	= "lpage",
+};
+
+enum pcpu_fc pcpu_chosen_fc __initdata = PCPU_FC_AUTO;
+
+static int __init percpu_alloc_setup(char *str)
+{
+	if (0)
+		/* nada */;
+#ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
+	else if (!strcmp(str, "embed"))
+		pcpu_chosen_fc = PCPU_FC_EMBED;
+#endif
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+	else if (!strcmp(str, "page"))
+		pcpu_chosen_fc = PCPU_FC_PAGE;
+#endif
+#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
+	else if (!strcmp(str, "lpage"))
+		pcpu_chosen_fc = PCPU_FC_LPAGE;
+#endif
+	else
+		pr_warning("PERCPU: unknown allocator %s specified\n", str);
+
+	return 0;
+}
+early_param("percpu_alloc", percpu_alloc_setup);
+
 static inline size_t pcpu_calc_fc_sizes(size_t static_size,
 					size_t reserved_size,
 					ssize_t *dyn_sizep)
-- 
1.6.0.2

