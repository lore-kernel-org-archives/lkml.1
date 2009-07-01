Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbZGAFHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbZGAFHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbZGAFHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:07:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33411 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbZGAFHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:07:10 -0400
Date: Wed, 1 Jul 2009 01:06:36 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       David Howells <dhowells@redhat.com>, Amerigo Wang <amwang@redhat.com>,
       James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090701050850.6188.59496.sendpatchset@localhost.localdomain>
In-Reply-To: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>
Subject: [Patch 2/3] elf: clean up fill_note_info()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cleanups

Introduce a helper function elf_note_info_init() to help
fill_note_info() to do initializations, also fix the potential
memory leaks.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>

---
Index: linux-2.6/fs/binfmt_elf.c
===================================================================
--- linux-2.6.orig/fs/binfmt_elf.c
+++ linux-2.6/fs/binfmt_elf.c
@@ -1714,42 +1714,54 @@ struct elf_note_info {
 	int numnote;
 };
 
-static int fill_note_info(struct elfhdr *elf, int phdrs,
-			  struct elf_note_info *info,
-			  long signr, struct pt_regs *regs)
+static int elf_note_info_init(struct elf_note_info *info)
 {
-#define	NUM_NOTES	6
-	struct list_head *t;
-
-	info->notes = NULL;
-	info->prstatus = NULL;
-	info->psinfo = NULL;
-	info->fpu = NULL;
-#ifdef ELF_CORE_COPY_XFPREGS
-	info->xfpu = NULL;
-#endif
+	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
+#define	NUM_NOTES	6
 	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
 			      GFP_KERNEL);
+#undef NUM_NOTES
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
 	if (!info->psinfo)
-		return 0;
+		goto notes_free;
 	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
 	if (!info->prstatus)
-		return 0;
+		goto psinfo_free;
 	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
 	if (!info->fpu)
-		return 0;
+		goto prstatus_free;
 #ifdef ELF_CORE_COPY_XFPREGS
 	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
 	if (!info->xfpu)
-		return 0;
+		goto fpu_free;
+#endif
+	return 1;
+#ifdef ELF_CORE_COPY_XFPREGS
+ fpu_free:
+	kfree(info->fpu);
 #endif
+ prstatus_free:
+	kfree(info->prstatus);
+ psinfo_free:
+	kfree(info->psinfo);
+ notes_free:
+	kfree(info->notes);
+	return 0;
+}
+
+static int fill_note_info(struct elfhdr *elf, int phdrs,
+			  struct elf_note_info *info,
+			  long signr, struct pt_regs *regs)
+{
+	struct list_head *t;
+
+	if (!elf_note_info_init(info))
+		return 0;
 
-	info->thread_status_size = 0;
 	if (signr) {
 		struct core_thread *ct;
 		struct elf_thread_status *ets;
@@ -1809,8 +1821,6 @@ static int fill_note_info(struct elfhdr 
 #endif
 
 	return 1;
-
-#undef NUM_NOTES
 }
 
 static size_t get_note_info_size(struct elf_note_info *info)
