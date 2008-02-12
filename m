Return-Path: <linux-kernel-owner+w=401wt.eu-S1762251AbYBLNef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762251AbYBLNef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbYBLNe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:34:27 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:40346 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbYBLNe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:34:26 -0500
Date: Tue, 12 Feb 2008 14:34:23 +0100
From: "Edgar E. Iglesias" <edgar.iglesias@axis.com>
To: ysato@users.sourceforge.jp, linux-kernel@vger.kernel.org
Cc: mikael.starvik@axis.com
Subject: [PATCH] Use ELF_CORE_EFLAGS for kcore ELF header flags.
Message-ID: <20080212133423.GD16389@edgar.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ELF_CORE_EFLAGS is already used by the binfmt_elf coredumper to set correct 
arch specific ELF header flags on coredumps. Use it for kcore aswell.
This corrects kcore files for the CRIS arch and I beleive it corrects 
ordinary coredumps for the H8/300.

Signed-off-by: Edgar E. Iglesias <edgar@axis.com>

---

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index e78c81f..c2370c7 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -23,6 +23,10 @@
 
 #define CORE_STR "CORE"
 
+#ifndef ELF_CORE_EFLAGS
+#define ELF_CORE_EFLAGS	0
+#endif
+
 static int open_kcore(struct inode * inode, struct file * filp)
 {
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
@@ -164,11 +168,7 @@ static void elf_kcore_store_hdr(char *bufp, int nphdr, int dataoff)
 	elf->e_entry	= 0;
 	elf->e_phoff	= sizeof(struct elfhdr);
 	elf->e_shoff	= 0;
-#if defined(CONFIG_H8300)
-	elf->e_flags	= ELF_FLAGS;
-#else
-	elf->e_flags	= 0;
-#endif
+	elf->e_flags	= ELF_CORE_EFLAGS;
 	elf->e_ehsize	= sizeof(struct elfhdr);
 	elf->e_phentsize= sizeof(struct elf_phdr);
 	elf->e_phnum	= nphdr;
diff --git a/include/asm-h8300/elf.h b/include/asm-h8300/elf.h
index 26bfc7e..806f20b 100644
--- a/include/asm-h8300/elf.h
+++ b/include/asm-h8300/elf.h
@@ -32,6 +32,8 @@ typedef unsigned long elf_fpregset_t;
 #define ELF_FLAGS       0x820000
 #endif
 
+#define ELF_CORE_EFLAGS ELF_FLAGS
+
 #define ELF_PLAT_INIT(_r)	_r->er1 = 0
 
 #define USE_ELF_CORE_DUMP
