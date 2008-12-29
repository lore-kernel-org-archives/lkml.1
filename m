Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbYL2UnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbYL2UnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYL2UnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:43:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:49295 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752092AbYL2UnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:43:13 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX19oG3lgCl1oExiqNG40G7hhs2S+RHrtmvyJGzJo7O
	xPCIFVd46zi0k+
Message-ID: <49593660.2010900@gmx.de>
Date: Mon, 29 Dec 2008 21:43:12 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: [PATCH 1/2] module.c: fix module loading failure of large modules
 (take 2)
References: <4959346E.7060600@gmx.de>
In-Reply-To: <4959346E.7060600@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] module.c: fix module loading failure of large modules (take 2)

When creating the final layout of a kernel module in memory, allow the
module loader to reserve some additional memory in front of a given section.
This is currently only needed for the parisc port which needs to put the
stub entries there to fulfill the 17/22bit PCREL relocations with large
kernel modules like xfs.

Signed-off-by: Helge Deller <deller@gmx.de>

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
diff --git a/init/Kconfig b/init/Kconfig
index f763762..5383815 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -908,6 +908,9 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
+config HAVE_MODULE_SECTION_STUBS
+	bool
+
 config KMOD
 	def_bool y
 	help
diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..4b86308 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1579,10 +1579,15 @@ static int simplify_symbols(Elf_Shdr *sechdrs,
 }
 
 /* Update size with this section: return offset. */
-static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
+static long get_offset(struct module *mod, unsigned int *size,
+		Elf_Shdr *sechdr, unsigned int section)
 {
 	long ret;
 
+#ifdef CONFIG_HAVE_MODULE_SECTION_STUBS
+	/* allocate some memory for stubs in front of each section */
+	*size += module_additional_section_size(mod, section);
+#endif
 	ret = ALIGN(*size, sechdr->sh_addralign ?: 1);
 	*size = ret + sechdr->sh_size;
 	return ret;
@@ -1622,7 +1627,7 @@ static void layout_sections(struct module *mod,
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) == 0)
 				continue;
-			s->sh_entsize = get_offset(&mod->core_size, s);
+			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
@@ -1640,7 +1645,7 @@ static void layout_sections(struct module *mod,
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) != 0)
 				continue;
-			s->sh_entsize = (get_offset(&mod->init_size, s)
+			s->sh_entsize = (get_offset(mod, &mod->init_size, s, i)
 					 | INIT_OFFSET_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
