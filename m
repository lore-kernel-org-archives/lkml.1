Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXKAFEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXKAFEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXKAFDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:03:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXKAFDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:03:54 -0400
Date: Thu, 01 Nov 2007 14:03:46 +0900 (JST)
Message-Id: <20071101.140346.264545041.jet@gyve.org>
To: linux-kernel@vger.kernel.org
Subject: [patch-resend] Show ioremap and vmap in /proc/meminfo
From: Masatake YAMATO <jet@gyve.org>
In-Reply-To: <20070925.003327.227852793.jet@gyve.org>
References: <20070925.003327.227852793.jet@gyve.org>
X-Mailer: Mew version 5.2 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch I posted has not got any response.
Do you think ioremap and vmap information in /proc/meminfo is not useful?
or are you just busy?

<the original message>

Hi,

For long time I've been thought the following equation is correct:

    The "MemUsage" is about "Active + Inactive + Slab + PageTables + VmallocUsed" in /proc/meminfo.

(I'm not only the person. See https://bugzilla.redhat.com/show_bug.cgi?id=243657.)

However, some VmallocUsed doesn't really consume MemUsage: ioremap
pages and vmap pages consume just virtual address spaces.

It is a bit helpful for people who want to understand kernel memory
usage to show the number of ioremap and vmap pages in /proc/meminfo.


The following patch adds entries for ioremap and vmap to /proc/meminfo.

Signed-off-by: Masatake YAMATO <jet@gyve.org>

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index b215c35..b888c59 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -19,6 +19,8 @@ static inline void proc_sys_init(void) { }
 
 struct vmalloc_info {
 	unsigned long	used;
+	unsigned long   used_as_ioremap;
+	unsigned long   used_as_vmap;
 	unsigned long	largest_chunk;
 };
 
@@ -31,6 +33,8 @@ extern void get_vmalloc_info(struct vmalloc_info *vmi);
 #define get_vmalloc_info(vmi)			\
 do {						\
 	(vmi)->used = 0;			\
+	(vmi)->used_as_ioremap = 0;		\
+	(vmi)->used_as_vmap = 0;		\
 	(vmi)->largest_chunk = 0;		\
 } while(0)
 
diff --git a/fs/proc/mmu.c b/fs/proc/mmu.c
index 25d2d9c..5297df2 100644
--- a/fs/proc/mmu.c
+++ b/fs/proc/mmu.c
@@ -38,7 +38,9 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 	unsigned long prev_end;
 
 	vmi->used = 0;
-
+	vmi->used_as_ioremap = 0;
+	vmi->used_as_vmap = 0;
+       
 	if (!vmlist) {
 		vmi->largest_chunk = VMALLOC_TOTAL;
 	}
@@ -51,6 +53,8 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 
 		for (vma = vmlist; vma; vma = vma->next) {
 			unsigned long addr = (unsigned long) vma->addr;
+			unsigned long flags;
+			unsigned long size;
 
 			/*
 			 * Some archs keep another range for modules in vmlist
@@ -59,8 +63,15 @@ void get_vmalloc_info(struct vmalloc_info *vmi)
 				continue;
 			if (addr >= VMALLOC_END)
 				break;
-
-			vmi->used += vma->size;
+ 
+			size  = vma->size;
+			flags = vma->flags;
+ 
+			vmi->used += size;
+			if (flags & VM_IOREMAP)
+			  vmi->used_as_ioremap += size;
+			if (flags & VM_MAP)
+			  vmi->used_as_vmap += size;
 
 			free_area_size = addr - prev_end;
 			if (vmi->largest_chunk < free_area_size)
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index bee251c..d784c85 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -176,6 +176,8 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 		"Committed_AS: %8lu kB\n"
 		"VmallocTotal: %8lu kB\n"
 		"VmallocUsed:  %8lu kB\n"
+		"IORemapUsed:  %8lu kB\n"
+		"VmapUsed:     %8lu kB\n"
 		"VmallocChunk: %8lu kB\n",
 		K(i.totalram),
 		K(i.freeram),
@@ -207,6 +209,8 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
 		vmi.used >> 10,
+		vmi.used_as_ioremap >> 10,
+		vmi.used_as_vmap >> 10,
 		vmi.largest_chunk >> 10
 		);
