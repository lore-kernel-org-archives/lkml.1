Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbZECSLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbZECSLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZECSLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:11:41 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34589 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbZECSLl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:11:41 -0400
Date: Sun, 3 May 2009 14:07:35 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Sam Ravnborg <sam@ravnborg.org>, Jean Delvare <khali@linux-fr.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] modpost: more complete endianness fixing
In-Reply-To: <20090503204218.6c65c740.sfr@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.0905031403300.28205@vinegar-pot.mit.edu>
References: <20090503110517.6d09bca2@hyperion.delvare> <20090503103010.GA27978@uranus.ravnborg.org> <20090503204218.6c65c740.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix endianness of all the fields in the ELF header and section headers, 
not just some of them.

The missing TO_NATIVE(sechdrs[i].sh_flags) was causing many “unexpected 
non-allocatable section” warnings when cross-compiling for an architecture 
with a different endianness.

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
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
1.6.2.4

