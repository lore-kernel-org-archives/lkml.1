Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYEPJDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYEPJDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYEPJDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:03:17 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:21441 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbYEPJDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:03:15 -0400
Date: Fri, 16 May 2008 18:01:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] binfmt_elf_fdpic: Magical stack pointer index, for NEW_AUX_ENT compat.
Message-ID: <20080516090150.GA16496@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While implementing binfmt_elf_fdpic on SH it quickly became apparent
that SH was the first platform to support both binfmt_elf_fdpic and
binfmt_elf, as well as the only of the FDPIC platforms to make use of the
auxvt.

Currently binfmt_elf_fdpic uses a special version of NEW_AUX_ENT() where
the first argument is the entry displacement after csp has been adjusted,
being reset after each adjustment. As we have no ability to sort this out
through the platform's ARCH_DLINFO, this index needs to be managed
entirely in create_elf_fdpic_tables(). Presently none of the platforms
that set their own auxvt entries are able to do so through their
respective ARCH_DLINFOs when using binfmt_elf_fdpic.

In addition to this, binfmt_elf_fdpic has been looking at
DLINFO_ARCH_ITEMS for the number of architecture-specific entries in the
auxvt. This is legacy cruft, and is not defined by any platforms in-tree,
even those that make heavy use of the auxvt. AT_VECTOR_SIZE_ARCH is
always available, and contains the number that is of interest here, so we
switch to using that unconditionally as well.

As this has direct bearing on how much stack is used, platforms that have
configurable (or dynamically adjustable) NEW_AUX_ENT calls need to either
make AT_VECTOR_SIZE_ARCH more fine-grained, or leave it as a worst-case
and live with some lost stack space if those entries aren't pushed (some
platforms may also need to purposely sacrifice some space here for
alignment considerations, as noted in the code -- although not an issue
for any FDPIC-capable platform today).

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 fs/binfmt_elf_fdpic.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index ddd35d8..341a88b 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -477,6 +477,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	char __user *u_platform, *p;
 	long hwcap;
 	int loop;
+	int nr;	/* reset for each csp adjustment */
 
 	/* we're going to shovel a whole load of stuff onto the stack */
 #ifdef CONFIG_MMU
@@ -549,10 +550,7 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	/* force 16 byte _final_ alignment here for generality */
 #define DLINFO_ITEMS 13
 
-	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0);
-#ifdef DLINFO_ARCH_ITEMS
-	nitems += DLINFO_ARCH_ITEMS;
-#endif
+	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
 
 	csp = sp;
 	sp -= nitems * 2 * sizeof(unsigned long);
@@ -564,39 +562,46 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	sp -= sp & 15UL;
 
 	/* put the ELF interpreter info on the stack */
-#define NEW_AUX_ENT(nr, id, val)					\
+#define NEW_AUX_ENT(id, val)						\
 	do {								\
 		struct { unsigned long _id, _val; } __user *ent;	\
 									\
 		ent = (void __user *) csp;				\
 		__put_user((id), &ent[nr]._id);				\
 		__put_user((val), &ent[nr]._val);			\
+		nr++;							\
 	} while (0)
 
+	nr = 0;
 	csp -= 2 * sizeof(unsigned long);
-	NEW_AUX_ENT(0, AT_NULL, 0);
+	NEW_AUX_ENT(AT_NULL, 0);
 	if (k_platform) {
+		nr = 0;
 		csp -= 2 * sizeof(unsigned long);
-		NEW_AUX_ENT(0, AT_PLATFORM,
+		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t) (unsigned long) u_platform);
 	}
 
+	nr = 0;
 	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
-	NEW_AUX_ENT( 0, AT_HWCAP,	hwcap);
-	NEW_AUX_ENT( 1, AT_PAGESZ,	PAGE_SIZE);
-	NEW_AUX_ENT( 2, AT_CLKTCK,	CLOCKS_PER_SEC);
-	NEW_AUX_ENT( 3, AT_PHDR,	exec_params->ph_addr);
-	NEW_AUX_ENT( 4, AT_PHENT,	sizeof(struct elf_phdr));
-	NEW_AUX_ENT( 5, AT_PHNUM,	exec_params->hdr.e_phnum);
-	NEW_AUX_ENT( 6,	AT_BASE,	interp_params->elfhdr_addr);
-	NEW_AUX_ENT( 7, AT_FLAGS,	0);
-	NEW_AUX_ENT( 8, AT_ENTRY,	exec_params->entry_addr);
-	NEW_AUX_ENT( 9, AT_UID,		(elf_addr_t) current->uid);
-	NEW_AUX_ENT(10, AT_EUID,	(elf_addr_t) current->euid);
-	NEW_AUX_ENT(11, AT_GID,		(elf_addr_t) current->gid);
-	NEW_AUX_ENT(12, AT_EGID,	(elf_addr_t) current->egid);
+	NEW_AUX_ENT(AT_HWCAP,	hwcap);
+	NEW_AUX_ENT(AT_PAGESZ,	PAGE_SIZE);
+	NEW_AUX_ENT(AT_CLKTCK,	CLOCKS_PER_SEC);
+	NEW_AUX_ENT(AT_PHDR,	exec_params->ph_addr);
+	NEW_AUX_ENT(AT_PHENT,	sizeof(struct elf_phdr));
+	NEW_AUX_ENT(AT_PHNUM,	exec_params->hdr.e_phnum);
+	NEW_AUX_ENT(AT_BASE,	interp_params->elfhdr_addr);
+	NEW_AUX_ENT(AT_FLAGS,	0);
+	NEW_AUX_ENT(AT_ENTRY,	exec_params->entry_addr);
+	NEW_AUX_ENT(AT_UID,	(elf_addr_t) current->uid);
+	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) current->euid);
+	NEW_AUX_ENT(AT_GID,	(elf_addr_t) current->gid);
+	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) current->egid);
 
 #ifdef ARCH_DLINFO
+	nr = 0;
+	csp -= AT_VECTOR_SIZE_ARCH * 2 * sizeof(unsigned long);
+
 	/* ARCH_DLINFO must come last so platform specific code can enforce
 	 * special alignment requirements on the AUXV if necessary (eg. PPC).
 	 */
