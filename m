Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZLAC61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZLAC61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 21:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZLAC6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 21:58:24 -0500
Received: from ozlabs.org ([203.10.76.45]:33136 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbZLAC6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 21:58:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] ppc64: re-enable kexec to allow module loads with CONFIG_MODVERSIONS and CONFIG_RELOCATABLE turned on
Date: Tue, 1 Dec 2009 13:28:26 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
References: <20091119195216.GC11414@hmsreliant.think-freely.org> <20091130181600.GA11583@hmsreliant.think-freely.org>
In-Reply-To: <20091130181600.GA11583@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912011328.27043.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009 04:46:00 am Neil Horman wrote:
> Paul, Ben, given that Rusty hasn't come back with any opinion on this patch, do you
> feel comfortable merging it via the ppc tree?  Currently the earlyinit routine
> is only compiled in and used for your arch, so I think its fairly benign.

Sorry, I *did* track down the archives for linuxppc-dev, then find your post,
then read your patch.  But I didn't actually reply.

Other than minor issues, there's one significant one: you shouldn't be trying
to change rodata.  It might work on PPC today, but it's poor form at least.

How's this?  Untested on ppc.

Other changes:
1) I also changed reloc_start to an array; this is a good idea for any
   linker-defined symbols so the compiler can't make assumptions about size.
2) local.h?  How about module.h?
3) I don't think the extra ". = 0" is necessary.
4) ARCH_USES_RELOC_ENTRIES isn't clear enough for me; I prefer
   ARCH_RELOCATE_KCRCTAB.

module: handle ppc64 relocating kcrctabs when CONFIG_RELOCATABLE=y

http://lists.ozlabs.org/pipermail/linuxppc-dev/2009-November/077972.html

Inspired-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -87,5 +87,10 @@ struct exception_table_entry;
 void sort_ex_table(struct exception_table_entry *start,
 		   struct exception_table_entry *finish);
 
+#ifdef CONFIG_MODVERSIONS
+#define ARCH_RELOCATES_KCRCTAB
+
+extern const unsigned long reloc_start[];
+#endif
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_MODULE_H */
diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -38,6 +38,9 @@ jiffies = jiffies_64 + 4;
 #endif
 SECTIONS
 {
+	. = 0;
+	reloc_start = .;
+
 	. = KERNELBASE;
 
 /*
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1030,11 +1030,23 @@ static int try_to_force_load(struct modu
 }
 
 #ifdef CONFIG_MODVERSIONS
+/* If the arch applies (non-zero) relocations to kernel kcrctab, unapply it. */
+static unsigned long maybe_relocated(unsigned long crc,
+				     const struct module *crc_owner)
+{
+#ifdef ARCH_RELOCATES_KCRCTAB
+	if (crc_owner == NULL)
+		return crc - (unsigned long)reloc_start;
+#endif
+	return crc;
+}
+
 static int check_version(Elf_Shdr *sechdrs,
 			 unsigned int versindex,
 			 const char *symname,
 			 struct module *mod, 
-			 const unsigned long *crc)
+			 const unsigned long *crc,
+			 const struct module *crc_owner)
 {
 	unsigned int i, num_versions;
 	struct modversion_info *versions;
@@ -1055,10 +1067,10 @@ static int check_version(Elf_Shdr *sechd
 		if (strcmp(versions[i].name, symname) != 0)
 			continue;
 
-		if (versions[i].crc == *crc)
+		if (versions[i].crc == maybe_relocated(*crc, crc_owner))
 			return 1;
 		DEBUGP("Found checksum %lX vs module %lX\n",
-		       *crc, versions[i].crc);
+		       maybe_relocated(*crc, crc_owner), versions[i].crc);
 		goto bad_version;
 	}
 
@@ -1081,7 +1093,8 @@ static inline int check_modstruct_versio
 	if (!find_symbol(MODULE_SYMBOL_PREFIX "module_layout", NULL,
 			 &crc, true, false))
 		BUG();
-	return check_version(sechdrs, versindex, "module_layout", mod, crc);
+	return check_version(sechdrs, versindex, "module_layout", mod, crc,
+			     NULL);
 }
 
 /* First part is kernel version, which we ignore if module has crcs. */
@@ -1099,7 +1112,8 @@ static inline int check_version(Elf_Shdr
 				unsigned int versindex,
 				const char *symname,
 				struct module *mod, 
-				const unsigned long *crc)
+				const unsigned long *crc,
+				const struct module *crc_owner)
 {
 	return 1;
 }
@@ -1134,8 +1148,8 @@ static const struct kernel_symbol *resol
 	/* use_module can fail due to OOM,
 	   or module initialization or unloading */
 	if (sym) {
-		if (!check_version(sechdrs, versindex, name, mod, crc) ||
-		    !use_module(mod, owner))
+		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
+		    || !use_module(mod, owner))
 			sym = NULL;
 	}
 	return sym;

