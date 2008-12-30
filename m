Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYL3Tm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYL3Tm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 14:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYL3TmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 14:42:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:51078 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752041AbYL3TmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 14:42:16 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+EI1BJ7UaEU33i0GDMOz8A86fqq4HvTJWMInrKJX
	XhUQEF+sXaAMu0
Message-ID: <495A7999.2090306@gmx.de>
Date: Tue, 30 Dec 2008 20:42:17 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>, rusty@rustcorp.com.au
CC: linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH 1/2] module.c: fix module loading failure of large modules
 (take 3)
References: <4959346E.7060600@gmx.de> <49593660.2010900@gmx.de> <20081230180724.GA15235@bombadil.infradead.org> <20081230181032.GB15235@bombadil.infradead.org> <495A65EF.5050406@gmx.de>
In-Reply-To: <495A65EF.5050406@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Deller wrote:
> Kyle McMartin wrote:
>>> Anyway, it's up to rusty.
>>>
>>> Rusty, we'd like to get this patch in, so I can merge the dependent
>>> parisc-specific patch.

Rusty,

While my initial patch (http://lkml.org/lkml/2008/12/29/274) added a
new CONFIG option and an optional callback function, this version instead
reuses the ElfHdr.sh_entsize field to tell the layout function how many
bytes to reserve.
It seems that only the IA64 module loader is affected by that change,
so the trivial patch for IA64 is below as well.
Other architectures use the sh_entsize field as well, but only for
bootloaders (x86, mips) or for special purpose loaders (powerpc cell),
but not for kernel modules. So the patch below should be pretty safe.

Personally I prefer this patch, but if you think my initial patch is
better, I'd be happy as well.


 arch/ia64/kernel/module.c |    4 +++-
 kernel/module.c           |   37 ++++++++++++++++++++-----------------
 2 files changed, 23 insertions(+), 18 deletions(-)


[PATCH 1/2] module.c: fix module loading failure of large modules (take 3)

When creating the final layout of a kernel module in memory, allow the
module loader to reserve some additional memory in front of a given section.
The amount of to-be allocated memory is returned by the architecture's
module_frob_arch_sections() function in the sechdrs.sh_entsize field.
By default this field is initialized by the module loader to zero.
Additional memory in front of code sections is currently only needed 
for the parisc port which needs to put the stub entries there to fulfill
the 17/22bit PCREL relocations with large kernel modules like xfs.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/ia64/kernel/module.c b/arch/ia64/kernel/module.c
index aaa7d90..5bd35f1 100644
--- a/arch/ia64/kernel/module.c
+++ b/arch/ia64/kernel/module.c
@@ -53,6 +53,8 @@
 
 #define MAX_LTOFF	((uint64_t) (1 << 22))	/* max. allowable linkage-table offset */
 
+#define INIT_LAYOUT_MASK (1UL << (BITS_PER_LONG-1))
+
 /* Define some relocation helper macros/types: */
 
 #define FORMAT_SHIFT	0
@@ -804,7 +806,7 @@ apply_relocate_add (Elf64_Shdr *sechdrs, const char *strtab, unsigned int symind
 
 	target_sec = sechdrs + sechdrs[relsec].sh_info;
 
-	if (target_sec->sh_entsize == ~0UL)
+	if (!(target_sec->sh_entsize & INIT_LAYOUT_MASK))
 		/*
 		 * If target section wasn't allocated, we don't need to relocate it.
 		 * Happens, e.g., for debug sections.
diff --git a/kernel/module.c b/kernel/module.c
index 1f4cc00..a09174d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -62,8 +62,9 @@
 #define ARCH_SHF_SMALL 0
 #endif
 
-/* If this is set, the section belongs in the init part of the module */
-#define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
+#define INIT_LAYOUT_MASK (1UL << (BITS_PER_LONG-1)) /* section-layout done  */
+#define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-2)) /* part of init section */
+#define INIT_STRIP_MASK  (INIT_OFFSET_MASK | INIT_LAYOUT_MASK)
 
 /* List of modules, protected by module_mutex or preempt_disable
  * (delete uses stop_machine/add uses RCU list operations). */
@@ -1583,6 +1584,8 @@ static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
 {
 	long ret;
 
+	/* architectures can request sh_entsize bytes in front of a section */
+	*size += (sechdr->sh_entsize & ~INIT_STRIP_MASK);
 	ret = ALIGN(*size, sechdr->sh_addralign ?: 1);
 	*size = ret + sechdr->sh_size;
 	return ret;
@@ -1590,8 +1593,8 @@ static long get_offset(unsigned int *size, Elf_Shdr *sechdr)
 
 /* Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
    might -- code, read-only data, read-write data, small data.  Tally
-   sizes, and place the offsets into sh_entsize fields: high bit means it
-   belongs in init. */
+   sizes, and place the offsets into sh_entsize fields: INIT_OFFSET_MASK
+   indicates that it belongs in init. */
 static void layout_sections(struct module *mod,
 			    const Elf_Ehdr *hdr,
 			    Elf_Shdr *sechdrs,
@@ -1608,9 +1611,6 @@ static void layout_sections(struct module *mod,
 	};
 	unsigned int m, i;
 
-	for (i = 0; i < hdr->e_shnum; i++)
-		sechdrs[i].sh_entsize = ~0UL;
-
 	DEBUGP("Core section allocation order:\n");
 	for (m = 0; m < ARRAY_SIZE(masks); ++m) {
 		for (i = 0; i < hdr->e_shnum; ++i) {
@@ -1618,11 +1618,12 @@ static void layout_sections(struct module *mod,
 
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
-			    || s->sh_entsize != ~0UL
+			    || (s->sh_entsize & INIT_LAYOUT_MASK)
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) == 0)
 				continue;
-			s->sh_entsize = get_offset(&mod->core_size, s);
+			s->sh_entsize = get_offset(&mod->core_size, s)
+					| INIT_LAYOUT_MASK;
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
@@ -1636,12 +1637,12 @@ static void layout_sections(struct module *mod,
 
 			if ((s->sh_flags & masks[m][0]) != masks[m][0]
 			    || (s->sh_flags & masks[m][1])
-			    || s->sh_entsize != ~0UL
+			    || (s->sh_entsize & INIT_LAYOUT_MASK)
 			    || strncmp(secstrings + s->sh_name,
 				       ".init", 5) != 0)
 				continue;
 			s->sh_entsize = (get_offset(&mod->init_size, s)
-					 | INIT_OFFSET_MASK);
+					 | INIT_OFFSET_MASK | INIT_LAYOUT_MASK);
 			DEBUGP("\t%s\n", secstrings + s->sh_name);
 		}
 		if (m == 0)
@@ -1986,7 +1987,11 @@ static noinline struct module *load_module(void __user *umod,
 
 	mod->state = MODULE_STATE_COMING;
 
-	/* Allow arches to frob section contents and sizes.  */
+	/* Allow arches to frob section contents, sh_entsize will tell the
+	 * the section layouter how much space to allocate in front of each
+	 * section */
+	for (i = 0; i < hdr->e_shnum; i++)
+		sechdrs[i].sh_entsize = 0UL;
 	err = module_frob_arch_sections(hdr, sechdrs, secstrings, mod);
 	if (err < 0)
 		goto free_mod;
@@ -2034,11 +2039,9 @@ static noinline struct module *load_module(void __user *umod,
 		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
 
-		if (sechdrs[i].sh_entsize & INIT_OFFSET_MASK)
-			dest = mod->module_init
-				+ (sechdrs[i].sh_entsize & ~INIT_OFFSET_MASK);
-		else
-			dest = mod->module_core + sechdrs[i].sh_entsize;
+		dest = ((sechdrs[i].sh_entsize & INIT_OFFSET_MASK) ?
+			 mod->module_init : mod->module_core)
+			+ (sechdrs[i].sh_entsize & ~INIT_STRIP_MASK);
 
 		if (sechdrs[i].sh_type != SHT_NOBITS)
 			memcpy(dest, (void *)sechdrs[i].sh_addr,
