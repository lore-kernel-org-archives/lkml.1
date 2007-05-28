Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXE1Ijo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXE1Ijo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbXE1Igo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:44 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:4651 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbXE1Ige (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:34 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069465:sNHT23619197"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 07/20] Blackfin arch: implement a basic /proc/sram file for L1 allocation visibility
Date: Mon, 28 May 2007 16:37:42 +0800
Message-Id: <11803414782093-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

implement a basic /proc/sram file for L1 allocation visibility until we can
rewrite the entire L1 allocator (which would include a proper mechanism)

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mm/blackfin_sram.c |   87 ++++++++++++++++++++++++++++++++------
 1 files changed, 74 insertions(+), 13 deletions(-)

diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index 0241764..38d9478 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -63,6 +63,7 @@ struct l1_sram_piece {
 	void *paddr;
 	int size;
 	int flag;
+	pid_t pid;
 };
 
 static struct l1_sram_piece l1_ssram[CONFIG_L1_MAX_PIECE];
@@ -97,23 +98,22 @@ void __init l1sram_init(void)
 void __init l1_data_sram_init(void)
 {
 #if L1_DATA_A_LENGTH != 0
-	printk(KERN_INFO "Blackfin DATA_A SRAM: %d KB\n",
-	       L1_DATA_A_LENGTH >> 10);
-
 	memset(&l1_data_A_sram, 0x00, sizeof(l1_data_A_sram));
-	l1_data_A_sram[0].paddr = (void*)L1_DATA_A_START +
-		(_ebss_l1 - _sdata_l1);
+	l1_data_A_sram[0].paddr = (void*)L1_DATA_A_START + (_ebss_l1 - _sdata_l1);
 	l1_data_A_sram[0].size = L1_DATA_A_LENGTH - (_ebss_l1 - _sdata_l1);
 	l1_data_A_sram[0].flag = SRAM_SLT_FREE;
+
+	printk(KERN_INFO "Blackfin Data A SRAM: %d KB (%d KB free)\n",
+	       L1_DATA_A_LENGTH >> 10, l1_data_A_sram[0].size >> 10);
 #endif
 #if L1_DATA_B_LENGTH != 0
-	printk(KERN_INFO "Blackfin DATA_B SRAM: %d KB\n",
-	       L1_DATA_B_LENGTH >> 10);
-
 	memset(&l1_data_B_sram, 0x00, sizeof(l1_data_B_sram));
 	l1_data_B_sram[0].paddr = (void*)L1_DATA_B_START;
 	l1_data_B_sram[0].size = L1_DATA_B_LENGTH;
 	l1_data_B_sram[0].flag = SRAM_SLT_FREE;
+
+	printk(KERN_INFO "Blackfin Data B SRAM: %d KB (%d KB free)\n",
+	       L1_DATA_B_LENGTH >> 10, l1_data_B_sram[0].size >> 10);
 #endif
 
 	/* mutex initialize */
@@ -123,13 +123,13 @@ void __init l1_data_sram_init(void)
 void __init l1_inst_sram_init(void)
 {
 #if L1_CODE_LENGTH != 0
-	printk(KERN_INFO "Blackfin Instruction SRAM: %d KB\n",
-	       L1_CODE_LENGTH >> 10);
-
 	memset(&l1_inst_sram, 0x00, sizeof(l1_inst_sram));
 	l1_inst_sram[0].paddr = (void*)L1_CODE_START + (_etext_l1 - _stext_l1);
 	l1_inst_sram[0].size = L1_CODE_LENGTH - (_etext_l1 - _stext_l1);
 	l1_inst_sram[0].flag = SRAM_SLT_FREE;
+
+	printk(KERN_INFO "Blackfin Instruction SRAM: %d KB (%d KB free)\n",
+	       L1_CODE_LENGTH >> 10, l1_inst_sram[0].size >> 10);
 #endif
 
 	/* mutex initialize */
@@ -155,6 +155,7 @@ static void *_l1_sram_alloc(size_t size, struct l1_sram_piece *pfree, int count)
 		    && (pfree[i].size >= size)) {
 			addr = pfree[i].paddr;
 			pfree[i].flag = SRAM_SLT_ALLOCATED;
+			pfree[i].pid = current->pid;
 			index = i;
 			break;
 		}
@@ -166,6 +167,7 @@ static void *_l1_sram_alloc(size_t size, struct l1_sram_piece *pfree, int count)
 	if (pfree[i].size > size) {
 		for (i = 0; i < count; i++) {
 			if (pfree[i].flag == SRAM_SLT_NULL) {
+				pfree[i].pid = 0;
 				pfree[i].flag = SRAM_SLT_FREE;
 				pfree[i].paddr = addr + size;
 				pfree[i].size = pfree[index].size - size;
@@ -198,13 +200,13 @@ static void *_l1_sram_alloc_max(struct l1_sram_piece *pfree, int count,
 		return NULL;
 	*psize = best;
 
+	pfree[index].pid = current->pid;
 	pfree[index].flag = SRAM_SLT_ALLOCATED;
 	return addr;
 }
 
 /* L1 memory free function */
-static int _l1_sram_free(const void *addr,
-			 struct l1_sram_piece *pfree, int count)
+static int _l1_sram_free(const void *addr, struct l1_sram_piece *pfree, int count)
 {
 	int i, index = 0;
 
@@ -222,12 +224,14 @@ static int _l1_sram_free(const void *addr,
 	if (i >= count)
 		return -1;
 
+	pfree[index].pid = 0;
 	pfree[index].flag = SRAM_SLT_FREE;
 
 	/* link the next address slot */
 	for (i = 0; i < count; i++) {
 		if (((pfree[index].paddr + pfree[index].size) == pfree[i].paddr)
 		    && (pfree[i].flag == SRAM_SLT_FREE)) {
+			pfree[i].pid = 0;
 			pfree[i].flag = SRAM_SLT_NULL;
 			pfree[index].size += pfree[i].size;
 			pfree[index].flag = SRAM_SLT_FREE;
@@ -538,3 +542,60 @@ void *sram_alloc_with_lsl(size_t size, unsigned long flags)
 	return addr;
 }
 EXPORT_SYMBOL(sram_alloc_with_lsl);
+
+#ifdef CONFIG_PROC_FS
+/* Once we get a real allocator, we'll throw all of this away.
+ * Until then, we need some sort of visibility into the L1 alloc.
+ */
+static void _l1sram_proc_read(char *buf, int *len, const char *desc,
+                              struct l1_sram_piece *pfree, const int array_size)
+{
+	int i;
+
+	*len += sprintf(&buf[*len], "--- L1 %-14s Size  PID State\n", desc);
+	for (i = 0; i < array_size; ++i) {
+		const char *alloc_type;
+		switch (pfree[i].flag) {
+			case SRAM_SLT_NULL:      alloc_type = "NULL"; break;
+			case SRAM_SLT_FREE:      alloc_type = "FREE"; break;
+			case SRAM_SLT_ALLOCATED: alloc_type = "ALLOCATED"; break;
+			default:                 alloc_type = "????"; break;
+		}
+		*len += sprintf(&buf[*len], "%p-%p %8i %4i %s\n",
+			pfree[i].paddr, pfree[i].paddr + pfree[i].size,
+			pfree[i].size, pfree[i].pid, alloc_type);
+	}
+}
+static int l1sram_proc_read(char *buf, char **start, off_t offset, int count,
+                            int *eof, void *data)
+{
+	int len = 0;
+
+	_l1sram_proc_read(buf, &len, "Scratchpad", l1_ssram, ARRAY_SIZE(l1_ssram));
+#if L1_DATA_A_LENGTH != 0
+	_l1sram_proc_read(buf, &len, "Data A", l1_data_A_sram, ARRAY_SIZE(l1_data_A_sram));
+#endif
+#if L1_DATA_B_LENGTH != 0
+	_l1sram_proc_read(buf, &len, "Data B", l1_data_B_sram, ARRAY_SIZE(l1_data_B_sram));
+#endif
+#if L1_CODE_LENGTH != 0
+	_l1sram_proc_read(buf, &len, "Instruction", l1_inst_sram, ARRAY_SIZE(l1_inst_sram));
+#endif
+
+	return len;
+}
+
+static int __init l1sram_proc_init(void)
+{
+	struct proc_dir_entry *ptr;
+	ptr = create_proc_entry("sram", S_IFREG | S_IRUGO, NULL);
+	if (!ptr) {
+		printk(KERN_WARNING "unable to create /proc/sram\n");
+		return -1;
+	}
+	ptr->owner = THIS_MODULE;
+	ptr->read_proc = l1sram_proc_read;
+	return 0;
+}
+late_initcall(l1sram_proc_init);
+#endif
-- 
1.5.2
