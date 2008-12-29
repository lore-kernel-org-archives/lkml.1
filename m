Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYL2OJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYL2OJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 09:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYL2OJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 09:09:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:41140 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753840AbYL2OJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 09:09:13 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19ejNta0nJeuG69/w45JKBqHM/dm1CLNAsJIf30FF
	jHOmJPICUmYOjs
Message-ID: <4958DA08.1080008@gmx.de>
Date: Mon, 29 Dec 2008 15:09:12 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Moritz Muehlenhoff <jmm@inutil.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Helge Deller <deller@gmx.de>
Subject: [PATCH 1/2] module.c: fix module loading failure of large modules
References: <4958D99E.4010201@gmx.de>
In-Reply-To: <4958D99E.4010201@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------040105060008050603090205"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71,0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040105060008050603090205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[PATCH 1/2] module.c: fix module loading failure of large modules

When creating the final layout of a kernel module in memory, allow the
module loader to reserve some additional memory behind a given section.
This is currently only needed for the parisc port which needs to put the
stub entries there to fulfill the 17/22bit PCREL relocations with large
kernel modules like xfs.

Signed-off-by: Helge Deller <deller@gmx.de>


--------------040105060008050603090205
Content-Type: text/plain;
 name="modules.patch1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="modules.patch1"

diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
index eb10339..65fb34c 100644
--- a/include/linux/moduleloader.h
+++ b/include/linux/moduleloader.h
@@ -13,6 +13,9 @@ int module_frob_arch_sections(Elf_Ehdr *hdr,
 			      char *secstrings,
 			      struct module *mod);
 
+unsigned long module_additional_section_size(struct module *mod,
+					     unsigned int section);
+
 /* Allocator used for allocating struct module, core sections and init
    sections.  Returns NULL on failure. */
 void *module_alloc(unsigned long size);
diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..c7662da 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1579,12 +1579,16 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 }
 
 /* Update size with this section: return offset. */
-static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
+static long get_offset(struct module *mod, unsigned int *size,
+		Elf_Shdr *sechdr, unsigned int section)
 {
 	long ret;
 
 	ret = ALIGN(*size, sechdr->sh_addralign ?: 1);
 	*size = ret + sechdr->sh_size;
+#ifdef CONFIG_ARCH_WANTS_STUBS_BEHIND_SECTIONS
+	*size += module_additional_section_size(mod, section);
+#endif
 	return ret;
 }
 
@@ -1622,7 +1626,7 @@ static void layout_sections(struct module *mod,
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) == 0)
 				continue;
-			s->sh_entsize = get_offset(&mod->core_size, s);
+			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
@@ -1640,7 +1644,7 @@ static void layout_sections(struct module *mod,
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) != 0)
 				continue;
-			s->sh_entsize = (get_offset(&mod->init_size, s)
+			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}

--------------040105060008050603090205--
