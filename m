Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZEDJrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZEDJrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 05:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZEDJrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 05:47:32 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38254 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZEDJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 05:47:32 -0400
Date: Mon, 4 May 2009 11:49:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Anders Kaseorg <andersk@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
       Linux-MIPS <linux-mips@linux-mips.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
Message-ID: <20090504094928.GA6157@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare> <20090503103010.GA27978@uranus.ravnborg.org> <20090503124848.276b437f@hyperion.delvare> <20090503180332.GA31820@uranus.ravnborg.org> <20090503202939.GA1237@uranus.ravnborg.org> <20090504082816.GA25378@roarinelk.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504082816.GA25378@roarinelk.homelinux.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 10:28:16AM +0200, Manuel Lauss wrote:
> Hi Sam,
> 
> On Sun, May 03, 2009 at 10:29:39PM +0200, Sam Ravnborg wrote:
> > This is due to the SUSE specific section as you expected.
> > We ignore sections named ".comment" but not ".comment" sections
> > with something appended to the name.
> 
> 
> On a related note, I see tons of the following warnings cross-building for
> MIPS:
> 
> WARNING: init/mounts.o (.mdebug.abi32): unexpected non-allocatable section.
> Did you forget to use "ax"/"aw" in a .S file?                              
> Note that for example <linux/init.h> contains                              
> section definitions for use in .S files.                                   
> 
> WARNING: init/mounts.o (.pdr): unexpected non-allocatable section.
> Did you forget to use "ax"/"aw" in a .S file?                     
> Note that for example <linux/init.h> contains                     
> section definitions for use in .S files. 
> 
> 
> I added ".pdr" and ".mdebug*" to the whitelist;  the resulting kernels still
> work.  (gcc-4.3.3, binutils-2.19.1)

Hi Manuel - thanks for reporting!

Is your mips target little or big endian?
If it is a big-endian target (which I expect) then the right fix
is the patch posted by Anders.

In other words - what happens if you back out your change
and apply the appended patch.

	Sam

>From 23938116e57f8597f3cead5e1f79a51ebbbe3dd6 Mon Sep 17 00:00:00 2001
From: Anders Kaseorg <andersk@MIT.EDU>
Date: Sun, 3 May 2009 22:02:55 +0200
Subject: [PATCH 1/2] kbuild, modpost: fix unexpected non-allocatable section when cross compiling

The missing TO_NATIVE(sechdrs[i].sh_flags) was causing many
unexpected non-allocatable section warnings when cross-compiling
for an architecture with a different endianness.

Fix endianness of all the fields in the ELF header and
section headers, not just some of them so we are not
hit by this anohter time.

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Reported-by: Sean MacLennan <smaclennan@pikatech.com>
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

