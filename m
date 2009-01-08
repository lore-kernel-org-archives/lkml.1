Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZAHM4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZAHM4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759669AbZAHMzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:55:50 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40748 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759652AbZAHMzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:55:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/10] FLAT: Don't attempt to expand the userspace stack to
	fill the space allocated [ver #3]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: bernds_cb1@t-online.de, dhowells@redhat.com, rgetz@blackfin.uclinux.org,
       vapier.adi@gmail.com, lethal@linux-sh.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2009 12:54:27 +0000
Message-ID: <20090108125427.28454.34772.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
References: <20090108125346.28454.90871.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop the FLAT binfmt from attempting to expand the userspace stack and brk
segments to fill the space actually allocated for it.  The space allocated may
be rounded up by mmap(), and may be wasted.

However, finding out how much space we actually obtained uses the contentious
kobjsize() function which we'd like to get rid of as it doesn't necessarily
work for all slab allocators.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Mike Frysinger <vapier.adi@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
---

 fs/binfmt_flat.c |   34 +++++++++++-----------------------
 1 files changed, 11 insertions(+), 23 deletions(-)


diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 7bbd5c6..5cebf0b 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -417,8 +417,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 	unsigned long textpos = 0, datapos = 0, result;
 	unsigned long realdatastart = 0;
 	unsigned long text_len, data_len, bss_len, stack_len, flags;
-	unsigned long len, reallen, memp = 0;
-	unsigned long extra, rlim;
+	unsigned long len, memp = 0;
+	unsigned long memp_size, extra, rlim;
 	unsigned long *reloc = 0, *rp;
 	struct inode *inode;
 	int i, rev, relocs = 0;
@@ -543,17 +543,10 @@ static int load_flat_file(struct linux_binprm * bprm,
 		}
 
 		len = data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = PAGE_ALIGN(len);
 		down_write(&current->mm->mmap_sem);
 		realdatastart = do_mmap(0, 0, len,
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
-		/* Remap to use all availabe slack region space */
-		if (realdatastart && (realdatastart < (unsigned long)-4096)) {
-			reallen = kobjsize((void *)realdatastart);
-			if (reallen > len) {
-				realdatastart = do_mremap(realdatastart, len,
-					reallen, MREMAP_FIXED, realdatastart);
-			}
-		}
 		up_write(&current->mm->mmap_sem);
 
 		if (realdatastart == 0 || realdatastart >= (unsigned long)-4096) {
@@ -591,21 +584,14 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 		reloc = (unsigned long *) (datapos+(ntohl(hdr->reloc_start)-text_len));
 		memp = realdatastart;
-
+		memp_size = len;
 	} else {
 
 		len = text_len + data_len + extra + MAX_SHARED_LIBS * sizeof(unsigned long);
+		len = PAGE_ALIGN(len);
 		down_write(&current->mm->mmap_sem);
 		textpos = do_mmap(0, 0, len,
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
-		/* Remap to use all availabe slack region space */
-		if (textpos && (textpos < (unsigned long) -4096)) {
-			reallen = kobjsize((void *)textpos);
-			if (reallen > len) {
-				textpos = do_mremap(textpos, len, reallen,
-					MREMAP_FIXED, textpos);
-			}
-		}
 		up_write(&current->mm->mmap_sem);
 
 		if (!textpos  || textpos >= (unsigned long) -4096) {
@@ -622,7 +608,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 		reloc = (unsigned long *) (textpos + ntohl(hdr->reloc_start) +
 				MAX_SHARED_LIBS * sizeof(unsigned long));
 		memp = textpos;
-
+		memp_size = len;
 #ifdef CONFIG_BINFMT_ZFLAT
 		/*
 		 * load it all in and treat it like a RAM load from now on
@@ -680,10 +666,12 @@ static int load_flat_file(struct linux_binprm * bprm,
 		 * set up the brk stuff, uses any slack left in data/bss/stack
 		 * allocation.  We put the brk after the bss (between the bss
 		 * and stack) like other platforms.
+		 * Userspace code relies on the stack pointer starting out at
+		 * an address right at the end of a page.
 		 */
 		current->mm->start_brk = datapos + data_len + bss_len;
 		current->mm->brk = (current->mm->start_brk + 3) & ~3;
-		current->mm->context.end_brk = memp + kobjsize((void *) memp) - stack_len;
+		current->mm->context.end_brk = memp + memp_size - stack_len;
 	}
 
 	if (flags & FLAT_FLAG_KTRACE)
@@ -790,8 +778,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 
 	/* zero the BSS,  BRK and stack areas */
 	memset((void*)(datapos + data_len), 0, bss_len + 
-			(memp + kobjsize((void *) memp) - stack_len -	/* end brk */
-			libinfo->lib_list[id].start_brk) +		/* start brk */
+			(memp + memp_size - stack_len -		/* end brk */
+			libinfo->lib_list[id].start_brk) +	/* start brk */
 			stack_len);
 
 	return 0;

