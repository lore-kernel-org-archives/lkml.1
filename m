Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZEDL6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZEDL6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZEDL6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:58:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58192 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZEDL6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:58:11 -0400
Date: Mon, 4 May 2009 13:59:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Sean MacLennan <smaclennan@pikatech.com>, Anders Kaseorg <andersk@mit.edu>,
       Jean Delvare <khali@linux-fr.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>, Wolfgang Denk <wd@denx.de>
Subject: [PATCH 1/3] kbuild, modpost: fix unexpected non-allocatable section when cross compiling
Message-ID: <20090504115955.GA7239@uranus.ravnborg.org>
References: <20090504115704.GA7134@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504115704.GA7134@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7d875a02864a35532543897195dfea2235815df8 Mon Sep 17 00:00:00 2001
From: Anders Kaseorg <andersk@MIT.EDU>
Date: Sun, 3 May 2009 22:02:55 +0200
Subject: [PATCH 1/3] kbuild, modpost: fix unexpected non-allocatable section when cross compiling

The missing TO_NATIVE(sechdrs[i].sh_flags) was causing many
unexpected non-allocatable section warnings when cross-compiling
for an architecture with a different endianness.

Fix endianness of all the fields in the ELF header and
section headers, not just some of them so we are not
hit by this anohter time.

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Reported-by: Sean MacLennan <smaclennan@pikatech.com>
Tested-by: Sean MacLennan <smaclennan@pikatech.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/mod/modpost.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 936b6f8..a5c17db 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -384,11 +384,19 @@ static int parse_elf(struct elf_info *info, const char *filename)
 		return 0;
 	}
 	/* Fix endianness in ELF header */
-	hdr->e_shoff    = TO_NATIVE(hdr->e_shoff);
-	hdr->e_shstrndx = TO_NATIVE(hdr->e_shstrndx);
-	hdr->e_shnum    = TO_NATIVE(hdr->e_shnum);
-	hdr->e_machine  = TO_NATIVE(hdr->e_machine);
-	hdr->e_type     = TO_NATIVE(hdr->e_type);
+	hdr->e_type      = TO_NATIVE(hdr->e_type);
+	hdr->e_machine   = TO_NATIVE(hdr->e_machine);
+	hdr->e_version   = TO_NATIVE(hdr->e_version);
+	hdr->e_entry     = TO_NATIVE(hdr->e_entry);
+	hdr->e_phoff     = TO_NATIVE(hdr->e_phoff);
+	hdr->e_shoff     = TO_NATIVE(hdr->e_shoff);
+	hdr->e_flags     = TO_NATIVE(hdr->e_flags);
+	hdr->e_ehsize    = TO_NATIVE(hdr->e_ehsize);
+	hdr->e_phentsize = TO_NATIVE(hdr->e_phentsize);
+	hdr->e_phnum     = TO_NATIVE(hdr->e_phnum);
+	hdr->e_shentsize = TO_NATIVE(hdr->e_shentsize);
+	hdr->e_shnum     = TO_NATIVE(hdr->e_shnum);
+	hdr->e_shstrndx  = TO_NATIVE(hdr->e_shstrndx);
 	sechdrs = (void *)hdr + hdr->e_shoff;
 	info->sechdrs = sechdrs;
 
@@ -402,13 +410,16 @@ static int parse_elf(struct elf_info *info, const char *filename)
 
 	/* Fix endianness in section headers */
 	for (i = 0; i < hdr->e_shnum; i++) {
-		sechdrs[i].sh_type   = TO_NATIVE(sechdrs[i].sh_type);
-		sechdrs[i].sh_offset = TO_NATIVE(sechdrs[i].sh_offset);
-		sechdrs[i].sh_size   = TO_NATIVE(sechdrs[i].sh_size);
-		sechdrs[i].sh_link   = TO_NATIVE(sechdrs[i].sh_link);
-		sechdrs[i].sh_name   = TO_NATIVE(sechdrs[i].sh_name);
-		sechdrs[i].sh_info   = TO_NATIVE(sechdrs[i].sh_info);
-		sechdrs[i].sh_addr   = TO_NATIVE(sechdrs[i].sh_addr);
+		sechdrs[i].sh_name      = TO_NATIVE(sechdrs[i].sh_name);
+		sechdrs[i].sh_type      = TO_NATIVE(sechdrs[i].sh_type);
+		sechdrs[i].sh_flags     = TO_NATIVE(sechdrs[i].sh_flags);
+		sechdrs[i].sh_addr      = TO_NATIVE(sechdrs[i].sh_addr);
+		sechdrs[i].sh_offset    = TO_NATIVE(sechdrs[i].sh_offset);
+		sechdrs[i].sh_size      = TO_NATIVE(sechdrs[i].sh_size);
+		sechdrs[i].sh_link      = TO_NATIVE(sechdrs[i].sh_link);
+		sechdrs[i].sh_info      = TO_NATIVE(sechdrs[i].sh_info);
+		sechdrs[i].sh_addralign = TO_NATIVE(sechdrs[i].sh_addralign);
+		sechdrs[i].sh_entsize   = TO_NATIVE(sechdrs[i].sh_entsize);
 	}
 	/* Find symbol table. */
 	for (i = 1; i < hdr->e_shnum; i++) {
-- 
1.6.3.rc3.40.g75b44

