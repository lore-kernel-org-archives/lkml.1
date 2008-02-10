Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYBJMtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYBJMtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 07:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYBJMst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 07:48:49 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:23638 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbYBJMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 07:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=bEZ1BSQJBNtRazo9W47o7LZij++jf/DMIlzE5C3cof8cVh1IPueOAW4ElSz8yOrdwBhNW5QtTN2BCeNCvmoFTfl3VDY5nORy4l573LPVWXiYBr0va19FClWvMP4TObX+8kMjgOSLgwC17EZuE34T7cmrXm1zZkRtAKy700jYqIU=
Message-Id: <20080210124822.076422999@gmail.com>
References: <20080210124323.068409407@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 10 Feb 2008 15:43:25 +0300
From: gorcunov@gmail.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: gorcunov@gmail.com
Subject: [patch 2/2] BINFMT: fill_elf_header cleanup - use straigth memset first
Content-Disposition: inline; filename=elf-binfmt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does simplify fill_elf_header function by setting
to zero the whole elf header first. So we fillup the fields
we really need only.

before:
   text    data     bss     dec     hex filename
  11735      80       0   11815    2e27 fs/binfmt_elf.o

after:
   text    data     bss     dec     hex filename
  11710      80       0   11790    2e0e fs/binfmt_elf.o

viola, 25 bytes of text is freed

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 binfmt_elf.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)


Index: linux-2.6.git/fs/binfmt_elf.c
===================================================================
--- linux-2.6.git.orig/fs/binfmt_elf.c	2008-02-09 12:09:28.000000000 +0300
+++ linux-2.6.git/fs/binfmt_elf.c	2008-02-10 11:15:59.000000000 +0300
@@ -1276,26 +1276,23 @@ static int writenote(struct memelfnote *
 static void fill_elf_header(struct elfhdr *elf, int segs,
 			    u16 machine, u32 flags, u8 osabi)
 {
+	memset(elf, 0, sizeof(*elf));
+
 	memcpy(elf->e_ident, ELFMAG, SELFMAG);
 	elf->e_ident[EI_CLASS] = ELF_CLASS;
 	elf->e_ident[EI_DATA] = ELF_DATA;
 	elf->e_ident[EI_VERSION] = EV_CURRENT;
 	elf->e_ident[EI_OSABI] = ELF_OSABI;
-	memset(elf->e_ident+EI_PAD, 0, EI_NIDENT-EI_PAD);
 
 	elf->e_type = ET_CORE;
 	elf->e_machine = machine;
 	elf->e_version = EV_CURRENT;
-	elf->e_entry = 0;
 	elf->e_phoff = sizeof(struct elfhdr);
-	elf->e_shoff = 0;
 	elf->e_flags = flags;
 	elf->e_ehsize = sizeof(struct elfhdr);
 	elf->e_phentsize = sizeof(struct elf_phdr);
 	elf->e_phnum = segs;
-	elf->e_shentsize = 0;
-	elf->e_shnum = 0;
-	elf->e_shstrndx = 0;
+
 	return;
 }
 

-- 
